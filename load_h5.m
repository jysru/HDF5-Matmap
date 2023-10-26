function load_h5(h5fNamePathCell, varargin)
% load_h5.m : Reads .h5 datasets and attributes and returns them into
%       the base workspace
%
%
% Inputs:
%   * h5fNamePathCell : either a string with the file name, or a cell from
%           which a fullfile string will be created. If it does not end with the
%           '.h5' extension, this will be automatically added.
%
%   * varargin : optional argument case-insensitive string, either 'datasets'
%           'attributes' or 'cellarrays', followed by a cell containing the strings of the
%           datasets or attributes names to load into the base workspace
%
%
% Example:
%   filename = 'h5test.h5'; % Contains datasets 'a' and 'b', and attributes 'c' and 'd'
%   
%   % Load every dataset and attribute into the base workspace
%   simple_h5fread(filename)
%   % Load no attribute, but all datasets into the base workspace
%   simple_h5fread(filename,'attributes',{})
%   % Load no attribute, but only the a dataset into the base workspace
%   simple_h5fread(filename,'attributes',{},'datasets',{'a'})
%   % Dont load anything
%   simple_h5fread(filename,'attributes',{},'datasets',{})
%



    %% Check the number of input arguments and assign optinal arguments flags
    narginchk(1,5);
    flag_specDsets = 0;
    flag_specAttrs = 0;
    
    while ~isempty(varargin)
        switch lower(varargin{1})
            case 'datasets'
                flag_specDsets = 1;
                specDsetsStr = varargin{2};
            case 'attributes'
                flag_specAttrs = 1;
                specAttrsStr = varargin{2};
            otherwise
                error(['Unsupported optional argument: ' varargin{1}]);
        end
        varargin(1:2) = [];
    end


    %% Build file reading pathname using fullfile
    if iscell(h5fNamePathCell) % Else, the string is simply used
        tmpNamePath = [];
        for i=1:length(h5fNamePathCell)
            tmpNamePath = fullfile(tmpNamePath,h5fNamePathCell{i});
        end
        h5fNamePathCell = tmpNamePath;
    end
    
    % If the fullfile does not contain the '.h5' extension, add it
    if ~strcmp(h5fNamePathCell(end-2:end),'.h5')
        h5fNamePathCell = [h5fNamePathCell '.h5'];
    end
    
    
    %% Get the info structure about the h5file
    info = h5info(h5fNamePathCell);
    
    
    %% Load datasets as variables into the base workspace
    if flag_specDsets % Load specific datasets
        h5fDsetsStr = cell(length(info.Datasets),1);
        for i=1:length(info.Datasets)
            h5fDsetsStr{i} = info.Datasets(i).Name;
        end
        
        for i=1:length(specDsetsStr)
            if any(strcmp(h5fDsetsStr,specDsetsStr{i}))
                varval = h5read(h5fNamePathCell,['/' specDsetsStr{i}]);
                assignin('base',specDsetsStr{i},varval);
            else
                warning(['Could not find dataset /' specDsetsStr{i} '. This dataset will not be loaded.']);
            end
        end
        
    else % Load all datasets
        for i=1:length(info.Datasets)
            dset = info.Datasets(i).Name;
            varval = h5read(h5fNamePathCell,['/' dset]);
            assignin('base',dset,varval);
        end
    end
    
    
    %% Load attributes as variables into the base workspace
    if flag_specAttrs % Load specific attributes
        h5fAttrsStr = cell(length(info.Attributes),1);
        for i=1:length(info.Attributes)
            h5fAttrsStr{i} = info.Attributes(i).Name;
        end
        
        for i=1:length(specAttrsStr)
            if any(strcmp(h5fAttrsStr,specAttrsStr{i}))
                varval = h5readatt(h5fNamePathCell,'/',specAttrsStr{i});
                assignin('base',specAttrsStr{i},varval);
            else
                warning(['Could not find attribute ' specDsetsStr{i} '. This attribute will not be loaded.']);
            end
        end
        
    else % Load all attributes
        for i=1:length(info.Attributes)
            attr = info.Attributes(i).Name;
            varval = h5readatt(h5fNamePathCell,'/',attr);
            assignin('base',attr,varval);
        end
    end
    
end




