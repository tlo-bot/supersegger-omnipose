function saveosmasks(dirname_seg)
% saves out OmniSegger masks which may be edited
% after the linking stage
%
% dirname_seg: seg directory in xy directory

%% make new dir for masks in xy dir
dirname_mask = [fileparts(dirname_seg) filesep 'masksOS'];    
if ~exist(dirname_mask, 'dir')
    mkdir(dirname_mask);
else
    disp('masksOS directory already exists');
end

%% read in the err files and save
    
% dirname_seg = '/home/tlo/Documents/Data/HUcrop/HUcrop_newsegomni/xy0/seg';
[numErrFiles, errFileNames] = countErrFiles(dirname_seg);
    
for ee = 1:numErrFiles
    filename_tmp = errFileNames{ee};
    err_tmp = load([dirname_seg filesep filename_tmp]);
    mask_tmp = err_tmp.regs.regs_label;
    
    % Convert mask_tmp to the minimum uint type
    if max(mask_tmp(:)) <= intmax('uint8')
        mask_uint = uint8(mask_tmp);
    elseif max(mask_tmp(:)) <= intmax('uint16')
        mask_uint = uint16(mask_tmp);
    else
        mask_uint = uint32(mask_tmp);
    end

    % Define the output filename
    imgname = filename_tmp(1:end-8);
    output_filename = fullfile(dirname_mask, [imgname, '_os_masks.png']);

    % Save the mask as a PNG file
    imwrite(mask_uint, output_filename);
end
    
disp('Done saving OmniSegger masks');

end



function [numErrFiles, errFileNames] = countErrFiles(dirname_seg)
    % List all files in the directory
    files = dir(dirname_seg);
    
    % Filter files that contain 'err' in their name
    errFiles = arrayfun(@(x) contains(x.name, 'err'), files);
    
    % Get the filenames that contain 'err'
    errFileNames = {files(errFiles).name};
    
    % Count the number of files containing 'err'
    numErrFiles = sum(errFiles);
end