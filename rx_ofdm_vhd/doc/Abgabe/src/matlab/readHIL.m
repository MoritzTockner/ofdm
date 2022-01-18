function data = readHIL(filename, filepath)
    
    if nargin < 2
        filepath = './';
    end

    %% read files from HIL .txt file
    data_i = [];
    data_q = [];

    filepath_full = [filepath, filename, '.txt'];
    fileID = fopen(filepath_full, 'r');

    assert(fileID ~= -1, sprintf('Invalid filename/path: %s\n', filepath_full));

    line = fgets(fileID);
    while line ~= -1
        data = sscanf(line, '%d %d');
        data_i = [data_i; data(1)];
        data_q = [data_q; data(2)];

        line = fgets(fileID);
    end
    fclose(fileID);

    data = data_i + 1j*data_q;

end