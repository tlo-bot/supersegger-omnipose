function fillBactrackLinks(bactrackcsvpath,numRegsperFrame,CONST)

    %init matrix
    totRegs = sum(numRegsperFrame);
    totRegsLinks = sum(numRegsperFrame(1:end-1));%last frame has no forward links 
    fillLinks = zeros(totRegsLinks,8);

    %first col Var#
    fillLinks(:,1) = [1:totRegsLinks]';

    bactracklink = readtable(bactrackcsvpath);

    %second col frame_source
    indFrame = cumsum(numRegsperFrame)+1;
    indFrame = [1; indFrame];
    numFrames = size(numRegsperFrame,1);
    linkFrames = numFrames-1; %last frame has no forward links

    
    for framenum = 1:linkFrames
        startInd = indFrame(framenum);
        endInd = indFrame(framenum+1)-1;
        fillLinks(startInd:endInd,2) = framenum;
    end

    %cols 3-6

    framesource = bactracklink.frame_source+1; % matlab indexing at 1
    labelsource = bactracklink.label_source;
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

        startInd = indFrame(framenum);
        endInd = startInd + size(labelc,1)-1;

        fillLinks(startInd:endInd,3:6) = sorttmp;

    end

    simplestart = cumsum(numRegsperFrame)+1;
    simplestart = [1; simplestart];
    simpleend = cumsum(numRegsperFrame);

    % calculate dA error

    DA_MIN = CONST.trackOpti.DA_MIN;
    DA_MAX =  CONST.trackOpti.DA_MAX;

    AreaChange = (fillLinks(:,6)-fillLinks(:,5))./fillLinks(:,6);
    fillLinks(:,8) = AreaChange;
    goodAreaChange = (AreaChange > DA_MIN & AreaChange < DA_MAX);

    fillLinks(:,7) = ~goodAreaChange; %error if DA not good


    % find missing links and fill in; error 
    for framenum = 1:linkFrames

        framec = framesource==framenum; %indices for frame from csv
        labelc = labelsource(framec); %source labels for that frame


        startInd = indFrame(framenum);
        endInd = startInd + size(labelc,1)-1;

        full = 1:numRegsperFrame(framenum);
        sample = fillLinks(startInd:endInd,3);

        idx = ismember(full,sample);
        missingregs = full(~idx);

        fillLinks(simplestart(framenum)+size(labelc,1):simpleend(framenum),3) = missingregs;
        fillLinks(simplestart(framenum)+size(labelc,1):simpleend(framenum),4) = NaN;

        %error already handled by DA calc
        % fillLinks(simplestart(framenum)+size(labelc,1):simpleend(framenum),7) = 1;


    end

    % compute error


    % fillTable
 
end

