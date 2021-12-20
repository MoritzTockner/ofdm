%    function [y] = fft_model(x,nps,inverse)             
%                                                                                             
%   Calculates the complex fixed-point FFT/IFFT for variable transform
%   sizes (stored in vector nps) of the complex input vector x.
%
%   Uses the fixed point model of the Variable Streaming architecture.
%                                                                                             
%   Inputs:   x          : Input complex vector. x will be split into blocks
%                          of various sizes as specified by nps. The size of this
%                          vector must greater than or equal to the sum of the
%                          values in nps.
%                          appended to the input sequence appropriately.                      
%             nps        : A vector of transform Lengths to be applied on a block-by-block basis.                
%             inverse    : A vector specifying the FFT direction on a block-by-block basis.   
%                          0 => FFT                                                           
%                          1 => IFFT
%                                                                                             
%   Outputs   y          : The transform-domain complex vector output                         
%                                                     
%                                                                                             
%   Copyright Altera
%                                                                                                  
%   This file is automatically generated. DO NOT EDIT.
%                                                                                       
function [y] = fft_ii_0_example_design_model(x,nps,inverse)         
% addpath(strcat(getenv('QUARTUS_ROOTDIR'),'/../ip/altera/dsp/altera_fft_ii/src/matlab/lib/'));
% Parameterization Space. 
N=128;
DATA_PREC=12;
TWIDDLE_PREC=12;
% Input is in natural order                                                           
INPUT_ORDER=1;  
OUTPUT_ORDER=1;
% Output is in natural order                                                           
% Fixed point data data_rep
REPRESENTATION=0;
% DSP multiplier architecture
SVOPT=2;
% Data width at the input to each stage                                                                                     
PRUNE=[2,3,2,0];
y=[];           
i=1;
%for each block in the vector N, perform the transform
for i=1:length(nps)                                                                      
    rin = real(x(1:nps(i)));                                                          
    iin = imag(x(1:nps(i)));                                                                       
    [roc,ioc] = SVSfftmodel(rin,iin,DATA_PREC,TWIDDLE_PREC,N,nps(i),inverse(i), INPUT_ORDER, OUTPUT_ORDER,REPRESENTATION,SVOPT,PRUNE);      
    y = [y, roc+j*ioc]   ;
    %remove block from input vector
    x=x(nps(i)+1:end);  
end                                                                                           


