
%% settings
clearvars; close all;
%load('Tx_setup.mat');
%HIL=true;

% switches
tracking = true;
quantize = true;
equalize = true;
write_file_fft_in = false;
read_file_fft_in = false;
write_file_fft_out = false;
fft_model = 'vhdl';  % 'ideal', 'matlab', 'vhdl'
equalizer_model = 'vhdl'; % 'ideal', 'matlab', 'vhdl'
compare_vhdl_matlab_ideal = false;
UseVhdlData = false;

filepath_data = '../../sim/';
if write_file_fft_in && exist([filepath_data, 'fft_in.txt'], 'file')
    delete([filepath_data, 'fft_in.txt']);
end
if write_file_fft_out && exist([filepath_data, 'fft_out_matlab.txt'], 'file')
    delete([filepath_data, 'fft_out_matlab.txt']);
end

nr_symbols=30;  %total number of transmitted symbols (sync+equalize+data)
nr_equalize=8;  %number of equalizer symbols 
NumberOfSubcarrier = 128;
NumberOfGuardChips = 32;
osr=8; %oversampling rate of AD9361 Rx Data
AntennaSampleRate=2e6;
pause_key=false;

% Equalizer bitwidths
Hk_Bits = 11;
multBits = 7;
divBits = 5;

figure(1); %Constellation Diagram
clf;
hold on;
xlabel('I');
ylabel('Q');
title('Constellation Diagram')
grid on;

figure(2); %Rx |H(f)|
clf;
hold on;
xlabel('subcarrier');
ylabel('|H(f)|');
grid on;

figure(3); %Rx |arg(H(f))|
clf;
hold on;
xlabel('subcarrier');
ylabel('arg(H(f)) [rad]');
grid on;

figure(7); %tracking phase
clf;
grid on;
hold on;
title('tracking phase');
xlabel('FFT bin');
ylabel('phase error');


Hk_inv=ones(NumberOfSubcarrier,1); %for first coarse timing synch run
corr_idx=0;
phase_diff_vec=[];  
phase_offset_vec=[];
delta_idx_vec=[];
phase_offset=0;
allRxBits=[];

load TxSymbol_equal.mat;

% convert the TxSymbol_equal into two representation bits
% "00" -> 1. Quadrant
% "01" -> 2. Quadrant
% "10" -> 3. Quadrant
% "11" -> 4. Quadrant

TxSymbol_equal_bit = zeros(length(TxSymbol_equal), 1);

for sym = 1:length(TxSymbol_equal)
    if imag(TxSymbol_equal(sym)) >= 0
        if real(TxSymbol_equal(sym)) >= 0
            TxSymbol_equal_bit(sym) = 1;
        else
            TxSymbol_equal_bit(sym) = 2;
        end
    else
        if real(TxSymbol_equal(sym)) >= 0
            TxSymbol_equal_bit(sym) = 4;
        else
            TxSymbol_equal_bit(sym) = 3;
        end
    end
end

load('tx_data_rx_air.mat');
rx_out=cf_ad9361_lpc_voltage2+1i*cf_ad9361_lpc_voltage3;
figure(4)
clf;
plot(real(rx_out),'r');
hold on;
plot(imag(rx_out),'g');
title('RX data samples');
xlabel('samples');
ylabel('scaled data');
legend('real','imag');

RxModSymbVec=[];
p=1/sqrt(2);
ModulationSymbols=[p + 1i*p; p - 1i*p; -p + 1i*p; -p - 1i*p];

if quantize
   rx_out=round(rx_out*2048)/2048; 
end

%% Upsample before Rx Synchronization
osr_rx=4;
cicinterp=dsp.CICInterpolator(osr_rx,1,2);
allRx_osr=cicinterp(rx_out)/(osr_rx);
allRx=allRx_osr;

if quantize
   allRx=round(allRx*2048)/2048; 
end

%% Rx Synch
disp('Start coarse timing synch');
step_width=1;
fine_res=osr*osr_rx;

if quantize
   allRx_sync=round(allRx*128)/128;
else
   allRx_sync=allRx; 
end

P=zeros(length(allRx)-160*osr*osr_rx,1);
R=zeros(length(allRx)-160*osr*osr_rx,1);
M=zeros(length(allRx)-160*osr*osr_rx,1);

%%correlate CPs
for k=1:length(P)
    P(k)=sum((allRx_sync(k:step_width:k+(63*fine_res)).*conj(allRx_sync(64*fine_res+k:step_width:k+(127*fine_res)))));
    R(k)=sum(abs(allRx_sync(64*fine_res+k:step_width:k+(127*fine_res))).^2);
    M(k)=(abs(P(k))^2)/R(k)^2;
end

figure(5)
clf;
subplot(221)
plot(abs(P))
xlabel('sample on osr*Tchip rate')
ylabel('P')
subplot(222)
xlabel('sample on osr*Tchip rate')
ylabel('angle of P')
plot(angle(P))
subplot(223)
plot(R)
xlabel('sample on osr*Tchip rate')
ylabel('R')
subplot(224)
plot(M)
xlabel('sample on osr*Tchip rate')
ylabel('M')

%Find start of Synch Symbol
%windwo method
window_len = NumberOfGuardChips*fine_res;
win_min=zeros(length(P)-window_len+1,1);
for k=1:length(win_min)
  win_min(k)=min(M(k:k+window_len-1));
end


peak_idx = find((win_min > 0.9));
start_idx = find(diff(win_min(peak_idx)) < 0, 1);
start_idx = peak_idx(start_idx) + NumberOfGuardChips*fine_res/2;

RxAntennaChips = allRx(start_idx:start_idx+nr_symbols*(NumberOfGuardChips + NumberOfSubcarrier)*fine_res-1);

figure(5) 
subplot(224)
hold on;

plot(win_min,'g');
plot(start_idx,M(start_idx),'r*')
subplot(222)
hold on;
plot(start_idx,angle(P(start_idx)),'r*')
for k=1:floor(length(P)/fine_res/160)
  plot(mod(start_idx+k*fine_res*160,length(P)),angle(P(start_idx)),'go');
end    
grid on

%% estimation of CFO
angle_Pstart = mean(angle(P(start_idx-10*fine_res:start_idx+10*fine_res)));
CFO_est = angle_Pstart/pi/(NumberOfSubcarrier/AntennaSampleRate); %[Hz]
disp(['Estimated carrier frequncy offset : ' num2str(CFO_est) 'Hz']);



%% cancel estimated CFO

t_vec=[0:length(RxAntennaChips)-1]'./(fine_res*AntennaSampleRate);
if quantize
    CFO_bb_cancel = round(exp(1i*2*pi*CFO_est*t_vec)*pow2(8))/pow2(8);
    RxAntennaChips = round(RxAntennaChips.*CFO_bb_cancel*pow2(11))/pow2(11);
else
    CFO_bb_cancel = exp(1i*2*pi*CFO_est*t_vec);
    RxAntennaChips = RxAntennaChips.*CFO_bb_cancel;      
end
    
RxModSymbolsVhdlVec = readHIL('fft_out', '../../sim/');

MaxRxModSymbolsReal = 0;
MaxRxModSymbolsImag = 0;

%% RX Part
for k=1:nr_symbols  
%% OFDM_Rx
    % extract symbol
    RxChips = RxAntennaChips(1:fine_res:fine_res*(NumberOfGuardChips + NumberOfSubcarrier)); 
    if write_file_fft_in
        RxChipsHIL = round(RxChips.*pow2(11));  % change format from s1.11 to s12.0
        writeHIL(RxChipsHIL, 'fft_in', filepath_data);
    end
    if read_file_fft_in
        RxChips = readHIL('fft_in', filepath_data);
        
        % convert from s12.0 to s1.11
        RxChips = RxChips./pow2(11);
    end

    % cut CP at the end
    RxChips = RxChips(1:NumberOfSubcarrier);

    if quantize

        % Matlab model fft
        RxChipsMatlab = RxChips.';         % change to row vector for fft model        

        % change format from s1.11 to s12.0
        RxChipsMatlab = round(RxChipsMatlab.*pow2(11));

        oldpath = addpath('../../syn/fft_ii_0_example_design/Matlab_model/');
        [RxModSymbolsBase, RxModSymbolsExponent] = fft_ii_0_example_design_model(RxChipsMatlab, NumberOfSubcarrier, 0); 
        path(oldpath);

        % Ignore exponent to prevent overflow. This is only allowed if
        % the exponents don't change from one channel estimation to
        % the next.
        RxModSymbolsMatlab = RxModSymbolsBase;  

        if write_file_fft_out
            writeHIL(RxModSymbolsMatlab, 'fft_out_matlab', filepath_data);
        end

        % change format from s12.0 to s1.11
        RxModSymbolsMatlab = RxModSymbolsMatlab./pow2(11);
        RxModSymbolsMatlab = RxModSymbolsMatlab.';

        % Ideal fft
        RxModSymbolsIdeal = fft(RxChips);

        % VHDL model fft
        % convert from s12.0 to s1.11
        RxModSymbolsVhdl = RxModSymbolsVhdlVec((k-1)*NumberOfSubcarrier+1:k*NumberOfSubcarrier)./pow2(11);

        switch fft_model
            case 'ideal'
                RxModSymbols = RxModSymbolsIdeal;
            case 'matlab'
                RxModSymbols = RxModSymbolsMatlab;
            case 'vhdl'
                RxModSymbols = RxModSymbolsVhdl;
            otherwise
                error('Some fft model must be selected.');
        end

        % RxModSymbols = RxModSymbols.*pow2(2);
        MaxRxModSymbolsReal = max(max(real(RxModSymbols)), MaxRxModSymbolsReal);
        MaxRxModSymbolsImag = max(max(imag(RxModSymbols)), MaxRxModSymbolsImag);

        if compare_vhdl_matlab_ideal
            RxModSymbolsIdeal = RxModSymbolsIdeal.*pow2(RxModSymbolsExponent(1));
            
            figure(8);
            subplot(211);
            plot(abs(RxModSymbolsIdeal), 'x-', 'DisplayName', 'abs(RxModSymbolsIdeal)');
            hold on; grid on;
            plot(abs(RxModSymbolsMatlab), 'x-', 'DisplayName', 'abs(RxModSymbolsMatlab)');
            plot(abs(RxModSymbolsVhdl), 'x-', 'DisplayName', 'abs(RxModSymbolsVhdl)');
            legend();
            title('|RxModSymbols|');
            hold off;

            subplot(212);
            plot(angle(RxModSymbolsIdeal), 'x-', 'DisplayName', 'angle(RxModSymbolsIdeal)');
            hold on; grid on;
            plot(angle(RxModSymbolsMatlab), 'x-', 'DisplayName', 'angle(RxModSymbolsMatlab)');
            plot(angle(RxModSymbolsVhdl), 'x-', 'DisplayName', 'angle(RxModSymbolsVhdl)');
            legend();
            title('angle(RxModSymbols)');
            hold off;

            RmseRxModSymbols = rms(RxModSymbolsIdeal - RxModSymbolsMatlab);
            RmseRxModSymbolsVhdl = rms(RxModSymbolsIdeal - RxModSymbolsVhdl);
            fprintf('RMSE of MATLAB model = %f\n', RmseRxModSymbols);
            fprintf('RMSE of VHDL model = %f\n', RmseRxModSymbolsVhdl);
        end
    else
        RxModSymbols = fft(RxChips);
        RxModSymbols = RxModSymbols/sqrt(NumberOfSubcarrier);
    end

    if (k>1 && k<=nr_equalize+1 && equalize)
        %% Channel Estimation
        corr_idx=0;
        
        if k==2  %first run of channel estimation (reset Hk_inv)
            disp('Start channel estimation');
            Hk=zeros(NumberOfSubcarrier,1);
        end

        Hk=Hk+RxModSymbols;
        assert(all(abs(Hk)./pow2(Hk_Bits) < 1));

        if k==nr_equalize+1
            if quantize
                switch equalizer_model
                    case {'ideal', 'matlab'}
                        Hk=floor((Hk./nr_equalize).*pow2(Hk_Bits))./pow2(Hk_Bits);
                        Hk_inv=round(1./(Hk./TxSymbol_equal)*pow2(Hk_Bits))/pow2(Hk_Bits);
    
                    case 'vhdl'
                        Hk=floor((Hk./nr_equalize).*pow2(Hk_Bits))./pow2(Hk_Bits);
    
                        % TODO in HW mit 2 Bits welche den Quadranten repräsentieren ->
                        % (a+ib) / (x+iy) -> konjugiert komplex erweitern
                        % (a+ib) * (x-iy) / (x²+y²) -->
    
                        % (a*x + b*y)     (b*x - a*y)
                        % ___________ + i*___________
                        % (x*x + y*y)     (x*x + y*y)
    
                        % x = real (Hk) | a = real(TxSymbol_equal)
                        % y = imag (Hk) | b = imag(TxSymbol_equal)
    
                        for CurrSym = 1:NumberOfSubcarrier
    
                            if TxSymbol_equal_bit(CurrSym) == 1
                                a = floor((1/sqrt(2))*pow2(6))/pow2(6);
                                b = floor((1/sqrt(2))*pow2(6))/pow2(6);
                            elseif TxSymbol_equal_bit(CurrSym) == 2
                                a = -floor((1/sqrt(2))*pow2(6))/pow2(6);
                                b = floor((1/sqrt(2))*pow2(6))/pow2(6);
                            elseif TxSymbol_equal_bit(CurrSym) == 3
                                a = -floor((1/sqrt(2))*pow2(6))/pow2(6);
                                b = -floor((1/sqrt(2))*pow2(6))/pow2(6);
                            elseif TxSymbol_equal_bit(CurrSym) == 4
                                a = floor((1/sqrt(2))*pow2(6))/pow2(6);
                                b = -floor((1/sqrt(2))*pow2(6))/pow2(6);
                            end
                            assert(abs(a/pow2(6)) < 1)
                            assert(abs(b/pow2(6)) < 1)
    
                            % Hk Hk_Bits - Bit
                            x = floor((real(Hk(CurrSym)))*pow2(multBits))/pow2(multBits);
                            y = floor((imag(Hk(CurrSym)))*pow2(multBits))/pow2(multBits);
                            assert(abs(x/pow2(multBits)) < 1)
                            assert(abs(y/pow2(multBits)) < 1)
    
                            ax = floor((a * x)*pow2(multBits))/pow2(multBits);
                            by = floor((b * y)*pow2(multBits))/pow2(multBits);
                            bx = floor((b * x)*pow2(multBits))/pow2(multBits);
                            ay = floor((a * y)*pow2(multBits))/pow2(multBits);
                            assert(abs(ax/pow2(multBits)) < 1)
                            assert(abs(by/pow2(multBits)) < 1)
                            assert(abs(bx/pow2(multBits)) < 1)
                            assert(abs(ay/pow2(multBits)) < 1)
    
                            xx = floor((x * x)*pow2(multBits))/pow2(multBits);
                            yy = floor((y * y)*pow2(multBits))/pow2(multBits);
                            assert(abs(xx/pow2(multBits)) < 1)
                            assert(abs(yy/pow2(multBits)) < 1)
    
                            xx_yy = floor((xx + yy)*pow2(multBits))/pow2(multBits);
                            assert(abs(xx_yy/pow2(multBits)) < 1)
    
                            ax_by = floor((ax + by)*pow2(multBits))/pow2(multBits);
                            bx_ay = floor((bx - ay)*pow2(multBits))/pow2(multBits);
                            assert(abs(ax_by/pow2(multBits)) < 1)
                            assert(abs(bx_ay/pow2(multBits)) < 1)
    
                            Hk_real = floor((ax_by / xx_yy)*pow2(divBits))/pow2(divBits);
                            Hk_imag = floor((bx_ay / xx_yy)*pow2(divBits))/pow2(divBits);
                            assert(abs(Hk_real/pow2(divBits)) < 1)
                            assert(abs(Hk_imag/pow2(divBits)) < 1)
    
                            Hk_inv(CurrSym) = Hk_real + 1i*Hk_imag;
                        end
                end
            else
                Hk=Hk./nr_equalize;
                Hk_inv=1./(Hk./TxSymbol_equal);
            end

        end

        disp('Finished channel estimation');
        figure(21)
        clf;
        plot(abs(Hk),'m*');
        title('Averaged abs(Hk)');
        ylabel('abs(Hk)');
        xlabel('subcarrier');
        disp('')
      
    else
            %% Start regular receive + timing tracking
        
            % Equalizer
            switch equalizer_model
                case {'matlab', 'vhdl'}
                    RxModSymbols=floor((RxModSymbols.*Hk_inv).*pow2(Hk_Bits))./pow2(Hk_Bits);
                case 'ideal'
                    RxModSymbols=RxModSymbols.*Hk_inv;
        end    
            RxModSymbVec = [RxModSymbVec; RxModSymbols];
        
            %% Modulation Demapper
        if k>1 %dont_store bits in first sync symbol
          RxSymbols=zeros(length(RxModSymbols),2);
          for j=1:length(RxSymbols(:,1))
           if real(RxModSymbols(j))>=0 
              RxSymbols(j,2)=0;
           else
              RxSymbols(j,2)=1;
           end   
           if imag(RxModSymbols(j))>=0 
              RxSymbols(j,1)=0;
           else
              RxSymbols(j,1)=1;
           end   
          end
          RxBits=zeros(2*length(RxSymbols),1);
          for j=1:length(RxSymbols(:,1))
            RxBits(j*2-1)=RxSymbols(j,1); 
            RxBits(j*2)=RxSymbols(j,2);
          end    
          allRxBits=[allRxBits; RxBits]; 
        end  
    end  
    
        % Plot Constellation Diagram
        figure(1)
        hold on;
        if k==1 %sync symbol
          plot(real(RxModSymbols),imag(RxModSymbols),'md');
        elseif k==nr_symbols
          plot(real(RxModSymbols),imag(RxModSymbols),'bo');
        elseif (equalize==false && k==2)||(equalize && k==nr_equalize+2)  
          plot(real(RxModSymbols),imag(RxModSymbols),'ro');        
        else
          plot(real(RxModSymbols),imag(RxModSymbols),'g+');
        end
        plot(real(ModulationSymbols),imag(ModulationSymbols),'r+');
        axis([-2 2 -2 2]);
    
        figure(2)
        
        if k==1
          plot(abs(RxModSymbols),'gd');
        elseif k==nr_symbols
          plot(abs(RxModSymbols),'bo');
        elseif (equalize==false && k==2)||(equalize && k==nr_equalize+2)  
          plot(abs(RxModSymbols),'ro');
        else  
          plot(abs(RxModSymbols),'g+');
        end
        
        figure(3);
        hold on;
        if k==1
          plot(angle(RxModSymbols),'gd');
        elseif k==nr_symbols
          plot(angle(RxModSymbols),'bo');
 
        elseif (equalize==false && k==2)||(equalize && k==nr_equalize+2)  
          plot(angle(RxModSymbols),'ro');
        else
          plot(angle(RxModSymbols),'g+');
        end
        
        if k==1
            disp('Finished coarse timing synch');
            disp('')
            if pause_key
                disp('Press key to continue')
                pause;
            end                
        end
       
        %timing tracking
        if (k>=nr_equalize+2 && tracking)
            %check for phase error in Rx signal
            track_phase=mod(unwrap(angle(RxModSymbols)),pi/2);
            figure(7);
            plot(track_phase,'g+');
            %check coarse phase error
            
            if abs(mean(diff(track_phase(2:16))))>(0.01) 
              phase_diff=mean(diff(track_phase(2:10)));  %simple method
              delta_idx=1; %4
            else
              phase_diff=mean(diff(track_phase(2:64)));  %works better for noise signals and small error
              delta_idx=1;  %1
            end
            phase_diff_vec=[phase_diff_vec phase_diff]; %for debug only
            
                       
            phase_offset=mean(track_phase(2:end))-pi/4;
            phase_offset_vec=[phase_offset_vec phase_offset];
            
            if phase_diff<0
              corr_idx=1*delta_idx;
            else
              corr_idx=-1*delta_idx;  
            end 
            
            delta_idx_vec=[delta_idx_vec corr_idx];
        end
        %disp('Tracking')
        %pause;        
   
    %corr_idx=0;
    RxAntennaChips=RxAntennaChips(osr*osr_rx*(NumberOfGuardChips+NumberOfSubcarrier)+1+corr_idx:end); %cut last symbol + tracking correction  
      
    phase_offset_cancel=exp(-1i*phase_offset);
    %phase_offset_cancel=exp(-1i*phase_offset*2e6/160*t_vec);
    RxAntennaChips=RxAntennaChips*phase_offset_cancel;

    %% Power and SNR calculation
end %k loop
disp('Finished regular receive + timing tracking');
 
%return

%% Reporting
load('tx_bits.mat')
allTxBits=allTxBits(257:256+length(allRxBits)); %skip in Tx Bits first sync Symbol
bit_diff=allTxBits(1:length(allRxBits))-allRxBits;  
err=find(bit_diff~=0);
sum_err=length(err);

disp(['Total Number of Errors:' num2str(sum_err)]);
disp(['Total Number of Bits:' num2str(length(bit_diff))]);

%EVM calc
nr_symb=length(RxModSymbVec)/128;
N=length(RxModSymbVec(1:128*nr_symb));
EV=RxModSymbVec(1:N)-(p*sign(real(RxModSymbVec(1:N)))+1i*p*sign(imag(RxModSymbVec(1:N))));
EVM=sqrt(1/N)*sum(abs(EV));
disp(['EVM:' num2str(EVM) '%' ]);

