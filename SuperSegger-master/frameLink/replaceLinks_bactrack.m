function [datac, datar, errormat] = replaceLinks_bactrack(bactrackcsvpath)

    % bactracklink = readtable('/home/tlo/Documents/Data/bactrack_test2/xy0/bactrackfiles/superseggerlinksdev.csv');
    bactracklink = readtable(bactrackcsvpath);
    
    framesource = bactracklink.frame_source+1; % matlab indexing at 1
    labelsource = bactracklink.label_source;
    % frametarget = bactracklink.frame_target+1;  %redundant w framesource
    labeltarget = bactracklink.label_target;
    
    numframes = max(framesource);
    
    datac = cell(numframes+1,5); %initialize
    [datac{1,:}] = deal('frame','data_c_map_f','data_c_map_r','data_c_revmap_f','data_c_revmap_r');
    
    for frame = 1:numframes
        datac{frame+1,1} = frame; %frame+1 bc datac has some text at the top
        framec = framesource==frame; %indices for frame from csv
        labelc = labelsource(framec); %source labels for that frame
        labelf = labeltarget(framec); %target labels for that frame
        
        if frame~=numframes %not the last frame
            hasdupe = checkduplicate(labelc);
            if hasdupe %at least one division
                % [a,b,c] = unique(labelc);
                % counts = accumarray(c,1);
                % vc = [a counts]; %unique labels and number of times they occur
                % divideind = vc(:,2)==2; %repeated index in label source
                % numdiv = sum(divideind); %num dividing in frame
        
                a = unique(labelc);
        
                %populate c_f 
                
                numregsC = length(a);
                cf_temp = cell(1,numregsC);
        
                for regC = 1:numregsC
                    % regCdivides = numel(find(c==regC))>1;
                    % if regCdivides
                        indC = labelc==regC;
                        cf_temp{regC} = labelf(indC)';
                    % else
                        % cf_temp{regC} = labelf(indC);
                    % end
        
                    
                end
        
                datac{frame+1,2} = cf_temp;
        
                % populate c_revmap_f
        
                numregsF = length(labelf);
                crevf_temp = cell(1,numregsF);
        
                for regF = 1:numregsF
                    crevf_temp{regF} = labelc(regF);
                end
        
                datac{frame+1,4} = crevf_temp;
        
        
                % for dividing, find the two target labels
                % divlabels = labelf(divideind);
                % nondivlabels = labelf(~divideind );
                % 
                % for ii = 1:length(divlabels)
                %     mapind = c==divlabels(ii);
                %     divf = labelf(mapind);
                % 
                % end
        
            else
                % no division, so populate with one target label
        
                %populate c_f 
        
                numregsC = length(labelc);
        
                for regC = 1:numregsC
                        indC = labelc==regC;
                        cf_temp{regC} = labelf(indC)';
                end
        
                datac{frame+1,2} = cf_temp;
        
                % populate c_revmap_f
        
                numregsF = length(labelf);
                crevf_temp = cell(1,numregsF);
        
                for regF = 1:numregsF
                    crevf_temp{regF} = labelc(regF);
                end
        
                datac{frame+1,4} = crevf_temp;
        
            end
    
        else
            %last frame
    
            %populate c_f with nans
            numregslastframe = size(datac{end-1,2},2); %size framelast map_r
            datac{frame+1,2} = cell(1,numregslastframe);

            % populate c_revmap_f with nans
    
        end
    
    
        %populate c_r
        if frame==1
    
            %empty cells for first frame
            
            numregsfirstframe = size(datac{2,2},2); %size frame1 map_f 
            datac{frame+1,3} = cell(1,numregsfirstframe);

        else
            datac{frame+1,3} = datac{frame,4}; %pull from prev frame revmap_f
    
        end
    
    
        %populate c_revmap_r
    
        if frame==1
            
            %empty cell for first frame
        else
            datac{frame+1,5} = datac{frame,2}; %pull from prev frame c_map_f
        end
    
    end
    
    %datar
    
    datar = cell(numframes+1,5); %initialize
    [datar{1,:}] = deal('frame','data_r_map_f','data_r_map_r','data_r_revmap_f','data_r_revmap_r');

    [datar{2:end,1}] = datac{2:end,1}; 
    [datar{2:end,2}] = datac{2:end,2}; 
    [datar{2:end,3}] = datac{2:end,3};
    [datar{2:end,4}] = datac{2:end,4};
    [datar{2:end,5}] = datac{2:end,5};

    %error

    errormat = cell(numframes+1,3); %initialize
    [errormat{1,:}] = deal('frame','error_f','error_r');

    for frame = 1:numframes
        numregsC = size(datac{2,frame+1},2); %numregs given by size c_f
        errormat{frame+1,1} = frame; %frame

        %fill error with zeros unless further changed
        errormat{frame+1,2} = zeros(numregsC); %error_f
        errormat{frame+1,3} = zeros(numregsC); %error_r
    end

end





function hasdupe = checkduplicate(arr)
    lenarr = length(arr);
    unarr = length(unique(arr));

    if lenarr==unarr
        hasdupe = 0;
    else
        hasdupe = 1;
    end

end