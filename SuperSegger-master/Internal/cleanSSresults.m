function cleanSSresults(basedir)
% resets supersegger folder by moving raw imgs to top directory
% and deletes supersegger files and directories
%
% basedir: directory to reset

%% copy the raw ims to top directory
    

    rawim_dir = [basedir filesep 'raw_im'];
    
    files = dir([rawim_dir filesep '*.tif']);
    filenames = {files.name};
    
    numfiles = length(files);
    
    for imnum = 1:numfiles
        copyfile([rawim_dir filesep filenames{imnum}],basedir);
    end
    
%% delete supersegger generated files and directories
    
    %raw_im
    rmdir(rawim_dir,'s');
    %xy
    rmdir([basedir filesep 'xy*'],'s');
    %viewer
    if exist([basedir filesep 'superSeggerViewer'],'dir')
        rmdir([basedir filesep 'superSeggerViewer'],'s');
        delete([basedir filesep '.superSeggerViewer.mat']);
    end
    
    delete([basedir filesep 'CONST.mat']);

end

