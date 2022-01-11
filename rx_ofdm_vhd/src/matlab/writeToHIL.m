function data_scaled = writeToHIL(data, filename, filepath)
    
    if nargin < 3
        filepath = './';
    end

    %% write files for HIL
    scale = max(max(abs(real(data))),max(abs(imag(data))));

    % Write to .mat file
    data_scaled = data/scale*0.5;
    save([filepath, filename, '.mat'],'data_scaled');

    % Write to .txt file
    data_i = round(real(data)/scale*pow2(10));
    data_q = round(imag(data)/scale*pow2(10));
    data_scaled = [data_i data_q];
    fileID = fopen([filepath, filename, '.txt'], 'w');
    for idx = 1:length(data_i)
        fprintf(fileID, '%i %i\n', data_scaled(idx,1), data_scaled(idx,2));
    end
    fclose(fileID);


end