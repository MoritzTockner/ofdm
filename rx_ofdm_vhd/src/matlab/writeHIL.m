function [data_scaled, scale] = writeHIL(data, filename, filepath)
    
    if nargin < 3
        filepath = './';
    end

    data_prec = 11;

    %% write files for HIL
    scale = max(max(abs(real(data))),max(abs(imag(data))));

    % Write to .mat file
    data_scaled = data/scale*0.5;
    save([filepath, filename, '.mat'],'data_scaled');

    % Write to .txt file
    data_scaled = round(data./scale.*pow2(data_prec));
    fileID = fopen([filepath, filename, '.txt'], 'w');
    for idx = 1:length(data_scaled)
        fprintf(fileID, '%i %i\n', real(data_scaled(idx)), imag(data_scaled(idx)));
    end
    fclose(fileID);


end