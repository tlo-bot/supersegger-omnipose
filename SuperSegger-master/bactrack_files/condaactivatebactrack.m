%add bactrack environment to path; equivalent to conda activate bactrack

function [initPath,condaStatus] = condaactivatebactrack()
    %% get path ~\Users\username\
    
    [~,currentPath] = system('cd');
    currentPath = [currentPath '\'];
    [uPath,uInd] = regexp(path, 'Users\\\w*\\','match');
    
    drivePath = currentPath(1:uInd-1);
    
    basePath = fullfile(drivePath, uPath);
    basePath = basePath{1};
    
    
    %% try to find ana/miniconda folder
    
    miniInstalled = [];
    anaInstalled = [];
    %assumes install location is ~\Users\username\miniconda3
    miniInstalled = isfolder(fullfile(basePath, 'miniconda3'));
    anaInstalled = isfolder(fullfile(basePath, 'anaconda3'));
    %isfolder() is case insensitive, I think
    
    %% find path to bactrack folder
    
    btPath = [];
    %can set btPath manually as a string in line above if not found
    %ex. btPath = 'C:\Users\Name\Documents\miniconda3\envs\bactrack\';
    if isempty(miniInstalled) && isempty(anaInstalled) && isempty(btPath)
        warning(['Miniconda/Anaconda path not found. \n ' ...
            'Check installation or set manually in condaactivatebactrack.m'], ...
            'verbose')
		condaStatus = 0;
    elseif miniInstalled
        btPath = fullfile(basePath,'miniconda3', 'envs', 'bactrack');
		condaStatus = 1;
    elseif anaInstalled
        btPath = fullfile(basePath,'anaconda3', 'envs', 'bactrack');
		condaStatus = 1;
    end
    
    if ~isempty(btPath)
        setenv('PATH', [btPath ';' getenv('PATH')]);
        %add to top of path to not use other potential pythons in path
    end
    
    %% add bactrack to MATLAB environment/system path
    %adapted from Julian Hapke's MATLAB Answers code
    initPath = getenv('PATH');
    if ~isempty(btPath)
        splitPath = strsplit(initPath,';');
        addConda = {
            btPath
            fullfile(btPath, 'Library', 'mingw-w64', 'bin')
            fullfile(btPath, 'Library', 'usr', 'bin')
            fullfile(btPath, 'Library', 'bin')
            fullfile(btPath, 'Scripts')
            fullfile(btPath, 'bin')
            };
    
        newPath = [addConda(:); splitPath(:)];
        newPath = unique(newPath, 'stable');
        newPath = strjoin(newPath,';');
        setenv('PATH', newPath);
    end

end


