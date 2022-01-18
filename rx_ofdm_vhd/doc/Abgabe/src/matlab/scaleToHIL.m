function [data_scaled, scale] = scaleToHIL(data, data_precision)
%SCALETOHIL 

    if nargin < 2
        data_precision = 11;
    end

    scale = max(max(abs(real(data))), max(abs(imag(data)))); % normalize to [-1, 1]
    data_scaled = round(data./scale.*pow2(data_precision));  % change format from s1.11 to s12.0
end

