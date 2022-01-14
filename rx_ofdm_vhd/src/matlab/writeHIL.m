function writeHIL(data, filename, filepath)
    
    if nargin < 3
        filepath = './';
    end

    %% write files for HIL

    % Write to .txt file
    fileID = fopen([filepath, filename, '.txt'], 'a');
    for idx = 1:length(data)
        fprintf(fileID, '%i %i\n', real(data(idx)), imag(data(idx)));
    end
    fclose(fileID);


end