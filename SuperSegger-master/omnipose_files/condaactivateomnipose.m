%add omnipose environment to path; equivalent to conda activate omnipose

function [initPath,condaStatus] = condaactivateomnipose()
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
    
    %% find path to omnipose folder
    
    omniPath = [];
    %can set omniPath manually as a string in line above if not found
    %ex. omniPath = 'C:\Users\Name\Documents\miniconda3\envs\omnipose\';
    if isempty(miniInstalled) && isempty(anaInstalled) && isempty(omniPath)
        warning(['Miniconda/Anaconda path not found. \n ' ...
            'Check installation or set manually in condaactivateomnipose.m'], ...
            'verbose')
		condaStatus = 0;
    elseif miniInstalled
        omniPath = fullfile(basePath,'miniconda3', 'envs', 'omnipose');
		condaStatus = 1;
    elseif anaInstalled
        omniPath = fullfile(basePath,'anaconda3', 'envs', 'omnipose');
		condaStatus = 1;
    end
    
    if ~isempty(omniPath)
        setenv('PATH', [omniPath ';' getenv('PATH')]);
        %add to top of path to not use other potential pythons in path
    end
    
    %% add omnipose to MATLAB environment/system path
    %adapted from Julian Hapke's MATLAB Answers code
    initPath = getenv('PATH');
    if ~isempty(omniPath)
        splitPath = strsplit(initPath,';');
        addConda = {
            omniPath
            fullfile(omniPath, 'Library', 'mingw-w64', 'bin')
            fullfile(omniPath, 'Library', 'usr', 'bin')
            fullfile(omniPath, 'Library', 'bin')
            fullfile(omniPath, 'Scripts')
            fullfile(omniPath, 'bin')
            };
    
        newPath = [addConda(:); splitPath(:)];
        newPath = unique(newPath, 'stable');
        newPath = strjoin(newPath,';');
        setenv('PATH', newPath);
    end

end


