function fillBactrackLinks(bactrackcsvpath,numRegsperFrame,CONST)

    %init matrix
    numFrames = size(numRegsperFrame,1);
    linkFrames = numFrames-1; %last frame has no forward links

    bactracklink = readtable(bactrackcsvpath);

    numLinksPerFrame = zeros(linkFrames,1);
    framesource = bactracklink.frame_source+1;
    labelsource = bactracklink.label_source;

    %find 1-1 and 1-2 links from bactrack
    for jj = 1:linkFrames
        numLinksPerFrame(jj) = sum(framesource==jj);
    end

    missingLinksPerFrame = zeros(linkFrames,1);
    %find 1-0 missing links
    for framenum = 1:linkFrames

        framec = framesource==framenum; %indices for frame from csv
        labelc = labelsource(framec); %source labels for that frame

        full = 1:numRegsperFrame(framenum);
        sample = labelc;

        idx = ismember(full,sample);
        missingregs = full(~idx);
        
        missingLinksPerFrame(framenum) = size(missingregs,2);
    end

    indtotLinks = missingLinksPerFrame+ numLinksPerFrame;
    totLinks = sum(indtotLinks);
    fillLinks = zeros(totLinks,8);

    % totRegs = sum(numRegsperFrame);
    % totRegsLinks = sum(numRegsperFrame(1:end-1));%last frame has no forward links 
    % fillLinks = zeros(totRegsLinks,8);

    %first col Var#
    fillLinks(:,1) = [1:totLinks]';

    startinds = cumsum(indtotLinks)+1;
    startinds = [1; startinds];
    endinds = cumsum(indtotLinks);

    %second col frame_source
    % indFrame = cumsum(numRegsperFrame)+1;
    % indFrame = [1; indFrame];

    for framenum = 1:linkFrames
        startInd = startinds(framenum);
        endInd = endinds(framenum);
        fillLinks(startInd:endInd,2) = framenum;
    end

    %cols 3-6

    % framesource = bactracklink.frame_source+1; % matlab indexing at 1
    % labelsource = bactracklink.label_source;

    % frametarget = bactracklink.frame_target+1;  %redundant w framesource
    labeltarget = bactracklink.label_target;
    areasource = bactracklink.area_source;
    areatarget = bactracklink.area_target;

    % populate with bactrack links
    for framenum = 1:linkFrames
        % datac{frame+1,1} = frame; %frame+1 bc datac has some text at the top
        
        framec = framesource==framenum; %indices for frame from csv
        labelc = labelsource(framec); %source labels for that frame
        labelf = labeltarget(framec); %target labels for that frame
        areac = areasource(framec);
        areaf = areatarget(framec);

        tmpinfo = [labelc labelf areac areaf];
        sorttmp = sortrows(tmpinfo);

        startInd = startinds(framenum);
        endInd = startInd + size(labelc,1)-1; %only bactrack links

        fillLinks(startInd:endInd,3:6) = sorttmp;

    end

    % startinds = cumsum(numRegsperFrame)+1;
    % startinds = [1; startinds];
    % endinds = cumsum(numRegsperFrame);

    % calculate dA error

    DA_MIN = CONST.trackOpti.DA_MIN;
    DA_MAX =  CONST.trackOpti.DA_MAX;

    AreaChange = (fillLinks(:,6)-fillLinks(:,5))./fillLinks(:,6);
    fillLinks(:,8) = AreaChange;

    %error3 for DA>max; else error2 (DA<min and no forward link)
    error3 = AreaChange > DA_MAX;
    error2 = AreaChange < DA_MIN;
    noflinks = isnan(AreaChange);

    fillLinks(error3,7) = 3; 
    fillLinks(error2,7) = 2;
    fillLinks(noflinks,7) = 2;

    % find missing links and fill in; error 
    for framenum = 1:linkFrames

        framec = framesource==framenum; %indices for frame from csv
        labelc = labelsource(framec); %source labels for that frame

        % startInd = indFrame(framenum);
        % endInd = startInd + size(labelc,1)-1;

        full = 1:numRegsperFrame(framenum);
        sample = labelc;
        % sample = fillLinks(startInd:endInd,3);

        idx = ismember(full,sample);
        missingregs = full(~idx);

        fillLinks(startinds(framenum)+size(labelc,1):endinds(framenum),3) = missingregs;
        fillLinks(startinds(framenum)+size(labelc,1):endinds(framenum),4) = NaN;

        %error already handled by DA calc
        % fillLinks(simplestart(framenum)+size(labelc,1):simpleend(framenum),7) = 1;


    end

    filledmatPath = [fileparts(bactrackcsvpath) filesep 'superseggerlinksFill.mat'];
    save(filledmatPath,"fillLinks") %save as mat

    labels = ["Var1";"frame_source";"label_source";"label_target";"area_source";"area_target";"error";"DA"];
    temps = array2table(fillLinks,"VariableNames",labels);
    filledcsvPath = [fileparts(bactrackcsvpath) filesep 'superseggerlinksFill.csv'];
    if exist(filledcsvPath,'file')>0
        disp('Bactrack to Supersegger filled links file already generated.')
    else
        writetable(temps,filledcsvPath)
    end
    % fillTable
 
end

