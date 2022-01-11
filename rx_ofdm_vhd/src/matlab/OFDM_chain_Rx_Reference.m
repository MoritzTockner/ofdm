
%% settings
clearvars;
%load('Tx_setup.mat');
%HIL=true;

tracking=true;
quantize_on=true;
equalize=true;
nr_symbols=30;  %total number of transmitted symbols (sync+equalize+data)
nr_equalize=8;  %number of equalizer symbols 
NumberOfSubcarrier = 128;
NumberOfGuardChips = 32;
osr=8; %oversampling rate of AD9361 Rx Data
AntennaSampleRate=2e6;
pause_key=false;

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

if quantize_on
   rx_out=round(rx_out*2048)/2048; 
end

%% Upsample before Rx Synchronization
osr_rx=4;
cicinterp=dsp.CICInterpolator(osr_rx,1,2);
allRx_osr=cicinterp(rx_out)/(osr_rx);
allRx=allRx_osr;

if quantize_on
   allRx=round(allRx*2048)/2048; 
end

%% Rx Synch
disp('Start coarse timing synch');
step_width=1;
fine_res=osr*osr_rx;

if quantize_on
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
window_len=32*fine_res
win_min=zeros(length(P)-window_len+1,1);
for k=1:length(win_min)
  win_min(k)=min(M(k:k+window_len-1));
end


peak_idx=find((win_min>0.9));
start_idx=find(diff(win_min(peak_idx))<0);
start_idx=peak_idx(start_idx(1))+floor(32*fine_res/2)

RxAntennaChips=allRx(start_idx:start_idx+nr_symbols*160*osr*osr_rx-1);

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

%%estimation of CFO
angle_Pstart=mean(angle(P(start_idx-10*fine_res:start_idx+10*fine_res)));
CFO_est=angle_Pstart/pi/(NumberOfSubcarrier/AntennaSampleRate); %[Hz]
disp(['Estimated carrier frequncy offset : ' num2str(CFO_est) 'Hz']);



%% cancel estimated CFO

  t_vec=[0:length(RxAntennaChips)-1]'./(fine_res*AntennaSampleRate);
  if quantize_on
    CFO_bb_cancel=round(exp(1i*2*pi*CFO_est*t_vec)*pow2(8))/pow2(8);
    RxAntennaChips=round(RxAntennaChips.*CFO_bb_cancel*pow2(11))/pow2(11);
  else
    CFO_bb_cancel=exp(1i*2*pi*CFO_est*t_vec);
    RxAntennaChips=RxAntennaChips.*CFO_bb_cancel;      
  end
    

%% RX Part
for k=1:nr_symbols  
%% OFDM_Rx
    %RxChips=RxAntennaChips(osr*osr_rx*NumberOfGuardChips+1:osr*osr_rx:osr*osr_rx*(NumberOfGuardChips+NumberOfSubcarrier)); %extract symbol
   
    RxChips = RxAntennaChips(1:osr*osr_rx:1+osr*osr_rx*(NumberOfSubcarrier-1)); %extract symbol

    if quantize_on 
        oldpath = addpath('../../syn/fft_ii_0_example_design/Matlab_model/');
        N_fft = NumberOfSubcarrier;
        RxChips = RxChips*pow2(11);  % change format from s1.11 to s12.0
        RxChips = RxChips.';         % change to row vector for fft model
        [RxModSymbolsVDHLBase, RxModSymbolsVDHLExponent] = fft_ii_0_example_design_model(RxChips, N_fft, 0); 
        RxModSymbolsVDHLBase = RxModSymbolsVDHLBase(digit_reverse(0:(N_fft-1), log2(N_fft)) + 1); % undo bit reverse from FFT VHDL model
        RxModSymbolsVDHLBase = RxModSymbolsVDHLBase.';
        RxModSymbolsVHDL = RxModSymbolsVDHLBase/pow2(11);
        path(oldpath);
   
        RxModSymbols=round(RxModSymbolsVHDL/sqrt(128)*pow2(11))/pow2(11);
%       RxModSymbols=round(RxModSymbols/sqrt(128)*pow2(11))/pow2(11);      
    else
        RxModSymbols = fft(RxChips);
        RxModSymbols=RxModSymbols/sqrt(128);
    end
    %% Modulation Demapper 
    if (k>1 && k<=nr_equalize+1 && equalize)
      corr_idx=0;
      %do channel estimation
      if k==2  %first run of channel estimation (reset Hk_inv)
        disp('Start channel estimation');
        Hk=zeros(NumberOfSubcarrier,1);
      end

      Hk=Hk+RxModSymbols;
      if k==nr_equalize+1
        Hk=Hk./nr_equalize;
        if quantize_on
            Hk_inv=round(1./(Hk./TxSymbol_equal)*pow2(11))/pow2(11);
        else
            Hk_inv=1./(Hk./TxSymbol_equal);
        end
        disp('Finished channel estimation');
        figure(21)
        clf;
        plot(abs(Hk),'m*');
        title('Averaged abs(Hk)');
        ylabel('abs(Hk)');
        xlabel('subcarrier');
        disp('')
        if pause_key
            pause;
            disp('Press key to continue')
        end    
      end
      
    else
        if (equalize==false && k==2)||(equalize && k==nr_equalize+2)
          disp('Start regular receive + timing tracking');
          if pause_key
                disp('Press key to continue')
                pause;
          end          
        end
        
        %correct RxModSymbols
        if quantize_on
          RxModSymbols=round(RxModSymbols.*Hk_inv*pow2(11))/pow2(11);
        else
          RxModSymbols=RxModSymbols.*Hk_inv;
        end    
        RxModSymbVec=[RxModSymbVec;RxModSymbols];
        
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

