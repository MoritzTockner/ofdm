function data = readHIL(filename, scale, filepath)
    
    if nargin < 3
        filepath = './';
    end

    %% read files from HIL .txt file
    data_i = [];
    data_q = [];

    fileID = fopen([filepath, filename, '.txt'], 'r');
    line = fgets(fileID);
    while line ~= -1
        data = sscanf(line, '%d %d');
        data_i = [data_i; data(1)];
        data_q = [data_q; data(2)];

        line = fgets(fileID);
    end
    fclose(fileID);

    data_scaled = data_i + 1j*data_q;
    data = data_scaled.*scale;

end