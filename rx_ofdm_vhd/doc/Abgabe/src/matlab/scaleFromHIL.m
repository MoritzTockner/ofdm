function data = scaleFromHIL(data_scaled, scale, data_precision)

    if nargin < 2
        data_precision = 11;
    end

    data = data_scaled.*scale./pow2(data_precision);

end