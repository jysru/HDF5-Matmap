function save_h5(fileNamePathCell,varStrCell)
% save_h5.m : Save workspace variables into a .h5 file
%       Only simple variables can be saved into h5 files so far (no struct or cell)
%
%
% Inputs:
%   * fileNamePathCell : either a string with the file name, or a cell from
%           which a fullfile string will be created. If it does not end with the
%           '.h5' extension, this will be automatically added.
%
%   * varStrCell : a cell containing all the variable names (as strings) to
%           be saved into the .h5 file. Variables will be loaded into the
%           function and saved as attributes in the h5f root if they are
%           not numeric, or if they are numeric but their size is 1.
%           Otherwise, the variables will be saved in a dataset with their name
%
% 
% Example:
%   filename = 'h5test.h5';
%   a = linspace(10,20,100);
%   b = rand(10);
%   c = 1;
%   d = 'test';
% 
%   simple_h5fsave(filename,{'a','b','z','c','d'});
%   % Variables {'a','b','z','c','d'} will be saved into 'h5test.h5'
%   % 'a' and 'b' will be saved into '/a' and '/b' datasets
%   % 'z' will be discarded, showing a warning
%   % 'c' and 'd' will be saved as attributes in the root of the .h5 file
%
%   simple_h5fsave({'myfolder',filename},{'a','b','z','c','d'});
%   % Same, but the variables will now be saved into 'myfolder/h5test.h5'
%



    %% Build file saving pathname using fullfile
    if iscell(fileNamePathCell) % Else, the string is simply used
        tmpNamePath = [];
        for i=1:length(fileNamePathCell)
            tmpNamePath = fullfile(tmpNamePath,fileNamePathCell{i});
        end
        fileNamePathCell = tmpNamePath;
    end
    
    % If the fullfile does not contain the '.h5' extension, add it
    if ~strcmp(fileNamePathCell(end-2:end),'.h5')
        fileNamePathCell = [fileNamePathCell '.h5'];
    end
        
         

    %% Save each variable from varStrCell into datasets
    dsets = varStrCell; % Just varStrCell with '/' prefix to match h5f datasets syntax
    for i=1:length(varStrCell)
        if varStrCell{i}(1) ~= '/'
            dsets{i} = ['/' dsets{i}];
        end
    end
    
    
    for i=1:length(dsets)
        % Try to get the variable from the base workspace
        try
            var = evalin('base',[varStrCell{i} ';']); % Get the variable from the base workspace
        catch
            % If the variable couldn't be found, continue to the next iteration
            warning(['Could not find variable ' varStrCell{i} '. This variable will not be saved.']);
            continue
        end
        
        % Save the variable as a dataset if numeric and with size > 1, or as an attribute otherwise
        if isnumeric(var) % If not numeric, or numeric with size 1, save as an attribute
            sz = size(var);
            
            if prod(sz) == 1
                h5writeatt(fileNamePathCell,'/',varStrCell{i},var);
            else % Otherwise, save as a dataset
                h5create(fileNamePathCell, dsets{i}, sz)
                h5write(fileNamePathCell, dsets{i}, var)
            end
        else
            h5writeatt(fileNamePathCell,'/',varStrCell{i},var);
        end
    end
    
end

