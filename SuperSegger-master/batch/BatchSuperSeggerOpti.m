function BatchSuperSeggerOpti(dirname_,skip,clean_flag,res,startEnd,showWarnings)
% BatchSuperSeggerOpti : runs everything from start to finish,
% including alignment, building the directory structure,
%single image segmentation, error resolution, cell linking,
% fluorescence analysis, and cell files.
%
% Processes a raw data set by
% (1) Aligning and cropping time series
% (2) Organizing files into directories
%        xy points are put in their own dir's
%        phase, fluor files put in their own dir's
%        makes seg and cell directories
% (3) Segmenting the frames into cell regions
% (4) Linking the regions between time steps
% (5) finding loci and calculating fluor statistics
% (6) Putting complete cells into the cell dir.
%
% INPUT :
% dirname_ : dir containing raw tif files
% skip     : The segmentation is performed every skip files
%          : this skip is very useful for high frequency timelapse where
%          : cells would switch back and forth between one and two
%          : segments leading to errors that are difficult to resolve.
%          : This segments every skip files, then copies the segments into
%          : the intermediate frames.
% clean_flag : Set this to be true to start from scratch and reseg all the
%            : files regardless of whether any seg files exist. If this
%            : flag is false, use existing segments, if they exist and
%            : new segs if they don't yet exist.
% res       : is a string that is passed to loadConstants(Mine).m to load
%           : the right constants for processing.
% showWarnings : Set to 0 to mute warnings
% startEnd : array of two values to indicate where to start and where to
% stop the program. 1, alignment, 2, segmentation, 3, stripping, 4 linking,
% 5, cell marker, 6 : fluor, 7 : foci, 8, cellA structrues, 9, clist, 10 cell files.
%
% Copyright (C) 2016 Wiggins Lab
% Written by Paul Wiggins & Stella Stylianidou.
% University of Washington, 2016
% This file is part of SuperSegger.

% SuperSegger is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% SuperSegger is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with SuperSegger.  If not, see <http://www.gnu.org/licenses/>.

% Init

intCheckForInstallLib

if (nargin < 1) || isempty( dirname_ ) || strcmp(dirname_ ,'.')
    dirname_ = pwd;
end
dirname_ = fixDir(dirname_);

if nargin < 2 || isempty( skip )
    skip = 1; % default : don't skip frames
end

if nargin < 3 || isempty( clean_flag )
    clean_flag = 0; % default : don't resegment frames if segmented.
end

if nargin < 4 || isempty( res )
    res = [];
end


if ~exist( 'startEnd', 'var' ) || isempty( startEnd )
    startEnd = [1 20];
end

if ~exist( 'showWarnings', 'var' ) || isempty( showWarnings )
    showWarnings = 1;
end


if ~checkToolboxes
    return;
end

%if you pass a res value, write over CONST values. If it isn't passed,
% use existing values, if they exist. If not, load the default values.
if isstruct(res)
    CONST = res;
else
    disp (['BatchSuperSeggerOpti : Loading constants file ', res]);
    if exist('loadConstantsMine','file');
        CONST = loadConstantsMine(res);
    else
        CONST = loadConstants(res,0);
    end
end


if clean_flag && showWarnings
    disp ('Clean flag is set to true. Do you want to continue, Y/N [Y]:')
    try
        answer=input('','s');
        if lower(answer) ~='y'
            disp ('Exiting BatchSuperSegger. Reset clean flag and rerun');
            return
        end
    catch
        % can not use input  - in eval mode
    end
end

if startEnd(1) >1
    CONST.align.ALIGN_FLAG = 0;
end

% align frames
if exist( dirname_, 'dir' )
    if exist( [dirname_,filesep,'raw_im'] ,'dir') && ...
            (numel(dir ([dirname_,filesep,'raw_im',filesep,'*.tif*'])) || ...
            exist([dirname_,filesep,'raw_im',filesep,'cropbox.mat'],'file'))
        disp('BatchSuperSeggerOpti : images already aligned');
        if exist([dirname_,filesep,'raw_im',filesep,'cropbox.mat'],'file')
            tmp = load( [dirname_,filesep,'raw_im',filesep,'cropbox.mat'] );
            crop_box_array = tmp.crop_box_array;
        else
            crop_box_array = cell(1,10000);
        end
    elseif numel(dir ([dirname_,filesep,'*.tif*']))
        % check naming convention
        if ~isRightNameFormat(dirname_)
            disp('Images in incorrect naming format. Using convertImageNames to convert names.')
            convertImageNames(dirname_)
        end
        
        mkdir( [dirname_,filesep,'raw_im'] );
        if CONST.align.ALIGN_FLAG
            crop_box_array = trackOptiAlignPad( dirname_,...
                CONST.parallel.parallel_pool_num, CONST);
            movefile( [dirname_,filesep,'*.tif*'], [dirname_,filesep,'raw_im'] ) % moves images to raw_im
            movefile( [dirname_,'align',filesep,'*.tif*'], [dirname_,filesep]); % moves aligned back to main folder
            rmdir( [dirname_,'align'] ); % removes _align directory
        else
            copyfile( [dirname_,filesep,'*.tif'], [dirname_,filesep,'raw_im'] ) % moves images to raw_im
            crop_box_array = cell(1,10000);
        end
    else
        error('No images found');
    end
    
else
    error(['BatchSuperSeggerOpti : Can''t find directory ''',dirname_,'''. Exiting.'] );
end


% setups the dir structure for analysis.
trackOptiPD(dirname_, CONST);
save( [dirname_,'CONST.mat'],'-STRUCT', 'CONST' ); % Saves CONST set you used.
save( [dirname_,'raw_im',filesep,'cropbox.mat'], 'crop_box_array' );

% Loop through xy directories
% Reset n values in case directories have already been made.
% setup nxy values
contents = dir([dirname_,'xy*']);

if isempty(contents)
    disp('BSSO: No xy directories were found.');
else
    num_dir_tmp = numel(contents);
    nxy = [];
    num_xy = 0;
    
    for i = 1:num_dir_tmp
        if (contents(i).isdir) && (numel(contents(i).name) > 2)
            num_xy = num_xy+1;
            nxy = [nxy, str2num(contents(i).name(3:end))];
            dirname_list{i} = [dirname_,contents(i).name,filesep];
        end
    end
    
    % set values for nc (array of channels (phase and fluorescent))
    contents = dir([dirname_list{1},'fluor*']);
    num_dir_tmp = numel(contents);
    nc = 1;
    num_c = 1;
    
    for i = 1:num_dir_tmp
        if (contents(i).isdir) && (numel(contents(i).name) > numel('fluor'))
            num_c = num_c+1;
            nc = [nc, str2num(contents(i).name(numel('fluor')+1:end))+1];
        end
    end
    
    
    % Set up parallel loop for each xy point if more than one xy position
    % exists. If not more than one xy, we will parallelize inner loops
    if (num_xy>1) && (CONST.parallel.parallel_pool_num>0)
        workers = CONST.parallel.parallel_pool_num;
        CONST.parallel.parallel_pool_num = 0;
    else
        workers=0;
    end
    
    if workers || ~CONST.parallel.show_status
        h = [];
    else
        h = waitbar( 0, ['Data segmentation xy: 0/',num2str(num_xy)] );
        cleanup = onCleanup( @()( delete( h ) ) );
    end
    
%     parfor(j = 1:num_xy,workers)
    for j = 1:num_xy
        
        dirname_xy = dirname_list{j};
        intProcessXY( dirname_xy, skip, nc, num_c, clean_flag, ...
            CONST, startEnd, crop_box_array{j})
        
        if workers || ~CONST.parallel.show_status
            disp( ['BatchSuperSeggerOpti: No status bar. xy ',num2str(j), ...
                ' of ', num2str(num_xy),'.']);
        else
            if isvalid(h)
                waitbar( j/num_xy,h,...
                    ['Data segmentation xy: ',num2str(j),...
                    '/',num2str(num_xy)]);
            end
        end
    end
    
    if workers % shutting down parallel pool
        poolobj = gcp('nocreate');
        delete(poolobj);
    end
    
    
    if ~workers
        close(h);
    end
    
end

% done!
end

function intProcessXY( dirname_xy, skip, nc, num_c, clean_flag, ...
    CONST, startEnd, crop_box)
% intProcessXY : the details of running the code in parallel.
% Essentially for parallel processing to work, you have to hand each
% processor all the information it needs to process the images.

% Initialization
file_filter = '*.tif*';
verbose = CONST.parallel.verbose;

% get header to show xy position
tmp1 = strfind( dirname_xy, 'xy');
tmp2 = strfind( dirname_xy,[filesep]);

if ~isempty(tmp1) && ~isempty(tmp2)
    header = [dirname_xy(tmp1(end):(tmp2(end)-1)),': '];
else
    header = [dirname_xy];
end

% reset nz values
contents=dir([dirname_xy,'phase',filesep,file_filter]);
num_im = numel(contents);

nz = []; % array of numbers of z frames
nt = []; % array of frame numbers

for i = 1:num_im;
    nameInfo = ReadFileName( contents(i).name );
    nt = [nt, nameInfo.npos(1,1)];
    nz = [nz, nameInfo.npos(4,1)];
end

nt = sort(unique(nt));
nz = sort(unique(nz));

num_t = numel(nt);
num_z = numel(nz);

if  isempty(nz) || nz(1)==-1 % no z frames
    nz = 1;
end


disp([header 'BatchSuperSeggerOpti : Segmenting Cells']);

if (CONST.parallel.parallel_pool_num>0)
    workers = CONST.parallel.parallel_pool_num; % number of workers
else
    workers=0;
end

if ~CONST.parallel.show_status
    h = [];
else
    h = waitbar( 0, ['BatchSuperSeggerOpti : Frame 0/',num2str(num_t)] );
    cleanup = onCleanup( @()( delete( h ) ) );
end

stamp_name = [dirname_xy,'seg',filesep,'.doSegFull'];

if clean_flag
    cleanSuperSegger (dirname_xy, startEnd, skip)
end

%[~] = input('Images aligned. Get masks of aligned images from cellpose ("cp_masks" folder) and put into xy# folder please. \n Press Enter when ready to continue.');
%call cellpose here and have it save the masks in the xy folder  
%[~] = input('Are you ready??? \n Press Enter to go to the Dark Side.');

cpinstalled = contains(pwd,['envs' filesep 'cellpose']);
if ~exist([dirname_xy 'cp_masks'],'dir') && ~exist([dirname_xy 'masks'],'dir')  %if folder doesn't exist
    cpstr = genCellposeCommand(dirname_xy); %get cellpose command
    %check if cellpose is installed
    if cpinstalled %if cellpose installed and in right matlab path  
        disp('Generating cellpose masks.');
        system(cpstr); %call python to run cellpose
    else %cellpose not installed or in wrong path
%         reply = input('Do you have cellpose installed? (y/n)','s');
%         if isempty(reply)
%             reply = 'n';
%         end
%         if (reply=='y' || reply=='Y') %cellpose installed but path wrong
%             disp('<strong>Check that your MATLAB path is in C:\Users\Name\miniconda3\envs\cellpose</strong>')
%             [~] = input('Are you ready??? \n Press Enter to go to the Dark Side.');   
%             disp('Generating cellpose masks.');
%             genCellposeMasks(dirname_xy);
%         elseif reply=='n' %cellpose not installed
%             %[~] = input('Images aligned. Get masks of aligned images from cellpose ("masks" folder) and put into xy# folder please. \n Press Enter when ready to continue.');
%             [~] = input('Images aligned. Please run cellpose on xy\phase folder to generate masks. \n Press Enter when ready to continue.');
%         end
        clipboard('copy',cpstr);
        disp(['<strong>Cellpose not found on MATLAB path. Please run cellpose on ..\xy\phase\ folder in Terminal to generate masks.</strong>']);
        disp(['<strong>Cellpose command copied to clipboard:</strong>']);
        disp(cpstr);
        [~] = input(['<strong>Press Enter when ready to continue.</strong>']);
    end
else %folder exists
    if exist([dirname_xy 'cp_masks'],'dir')
        cpmasksdir = dir([dirname_xy 'cp_masks']); %get contents of folder
    elseif exist([dirname_xy 'masks'],'dir')
        cpmasksdir = dir([dirname_xy 'masks']);
    end
    dirnotempty = max(~startsWith({cpmasksdir.name},'.')); %return 1 if file exists that's not a . hidden file
    if dirnotempty==0 % no masks inside; folder is empty
        cpstr = genCellposeCommand(dirname_xy); %get cellpose command
        if cpinstalled
            disp('Generating cellpose masks.');
            system(cpstr);
        else
%             reply = input('Do you have cellpose installed? (y/n)','s');
%             if isempty(reply)
%                 reply = 'n';
%             end
%             if (reply=='y' || reply=='Y') %cellpose installed but path wrong
%                 disp('<strong>Check that your MATLAB path is in C:\Users\Name\miniconda3\envs\cellpose</strong>')
%                 [~] = input('Are you ready??? \n Press Enter to go to the Dark Side.');   
%                 disp('Generating cellpose masks.');
%                 genCellposeMasks(dirname_xy);
%             else %cellpose not installed
%             %[~] = input('Images aligned. Get masks of aligned images from cellpose ("masks" folder) and put into xy# folder please. \n Press Enter when ready to continue.');
%             [~] = input('Images aligned. Please run cellpose on xy\phase folder to generate masks. \n Press Enter when ready to continue.');
%             end
            clipboard('copy',cpstr);
            disp(['<strong>Cellpose not found on MATLAB path. Please run cellpose on ..\xy\phase\ folder in Terminal to generate masks.</strong>']);
            disp(['<strong>Cellpose command copied to clipboard:</strong>']);
            disp(cpstr);
            [~] = input(['<strong>Press Enter when ready to continue.</strong>']);
        end
    elseif dirnotempty==1 %folder and masks exist
    disp('Cellpose masks already generated.');
    end
end

disp('Continuing segmentation.'); 

% does the segmentations for all the frames in parallel
% Edit: not sure why this was at 2... 3 is segmentation 
if startEnd(1) <= 3 && startEnd(2) >=3 && ~exist( stamp_name, 'file' )
%     parfor(i=1:num_t,workers) % through all frames
    for i = 1:num_t
        
        if isempty( crop_box )
            crop_box_tmp = [];
        else
            crop_box_tmp = crop_box(i,:);
        end
        
        doSeg(i, nameInfo, nc, nz, nt, num_z, num_c, dirname_xy, ...
            skip, CONST, [header,'t',num2str(i),': '], crop_box_tmp);
        
        if ~CONST.parallel.show_status
            if verbose
                disp( [header, 'BatchSuperSeggerOpti : Segment. Frame ',num2str(i), ...
                    ' of ', num2str(num_t),'.']);
            end
        else
            waitbar( i/num_t, h,...
                ['Data segmentation t: ',num2str(i),'/',num2str(num_t)]);
        end
    end
    time_stamp = clock; %#ok saved below
    save( stamp_name, 'time_stamp'); % saves that xydir was full segmented
end
if CONST.parallel.show_status
    if isvalid(h)
        close(h);
    end
end

% trackOpti has all the rest of things : Linking, Cell files, Fluorescence calculation etc
if startEnd(2) >2
    trackOpti(dirname_xy,skip,CONST, header, startEnd);
end
end

function cpstr = genCellposeCommand(dirname_xy)
    diralign = [dirname_xy 'phase' filesep];
    %get the path to model here
    %model should be only file w/ cpmodellocate.m in trainedmodel folder
    modeldirpath = extractBefore(which('cpmodellocate'),'cpmodellocate');
    modeldir = dir(modeldirpath);
    cpmodel = modeldir(~endsWith({modeldir.name},'.m')); %ignore the cpmodellocate file
    cpmodel = cpmodel(~startsWith({cpmodel.name},'.')); %ignore the hidden . files
    %cpmodel = dir([modeldir '*cell*']); %assumes modelname includes 'cell'
    %cpstr = ['python -m cellpose --dir ' diralign ' --pretrained_model ' [modeldirpath cpmodel.name] ' --flow_threshold 0 --save_png --no_npy']; %mouseland
    %kevin's version should output masks folder in xy dir
    %cpstr = ['python -m cellpose --dir ' diralign ' --pretrained_model ' [modeldirpath cpmodel.name] ' --save_png --save_above']; %kevin's cellpose
    if isempty(modeldirpath) || isempty(cpmodel)
        disp('>><strong>Caution!</strong> Training model not properly found on path. Please manually input path of file after --pretrained_model option into Terminal.');
        disp('Training model located in folder: ~\SuperSegger-master\cellpose_files\trainedmodel\')
    end 
    %cpstr = ['python -m cellpose --dir ' diralign  ' --pretrained_model ' [modeldirpath cpmodel.name] '  --save_png --dir_above --in_folders --nclasses 4 --omni --cluster --mask_threshold 1'];
    cpstr = ['python -m cellpose --dir ' diralign  ' --pretrained_model bact_omni --save_png --dir_above --in_folders --nclasses 4 --omni --cluster --mask_threshold 1'];
    %system(cpstr); %call python to run cellpose

    %movefile([diralign '**.png'], [dirname_xy 'cp_masks' filesep]) %move the masks from the phase to the cp_masks folder %mouseland
end
