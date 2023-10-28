function [data_c, data_r, cell_count,resetRegions] =  errorRez (time, ...
    data_c, data_r, CONST, cell_count, header)
% errorRez : links cells from the current frame to the frame before and
% attempts to resolve segmentation errors if the linking is inconsistent.
%
% INPUT :
%   time : current frame number
%   data_c : current time frame data (seg/err) file.
%   data_r : reverse time frame data (seg/err) file.
%   data_f : forward time frame data (seg/err) file.
%   CONST : segmentation parameters.
%   cell_count : last cell id used.
%   header : last cell id used.
%   ignoreError : when set to true, no cells are merged or divided.
%   debug_flag : 1 to display figures for debugging
%
% OUTPUT :
%   data_c : updated current time frame data (seg/err) file.
%   data_r : updated reverse time frame data (seg/err) file.
%   cell_count : last cell id used.
%   resetRegions : if true, regions were modified and this frame needs to
%   be relinked.
%
% Copyright (C) 2016 Wiggins Lab
% Written by Stella Stylianidou
% University of Washington, 2016
% This file is part of SuperSegger.
%
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

global REMOVE_STRAY
global header_string
global regToDelete

%debug_flag=1;
%verbose=1;
header_string = header;
verbose = CONST.parallel.verbose;
REMOVE_STRAY = CONST.trackOpti.REMOVE_STRAY;
DA_MIN = CONST.trackOpti.DA_MIN;
DA_MAX =  CONST.trackOpti.DA_MAX;
regToDelete = [];
resetRegions = false;
minAreaToMerge = CONST.trackOpti.SMALL_AREA_MERGE;

% set all ids to 0
cArea = [data_c.regs.props.Area];
data_c.regs.ID = zeros(1,data_c.regs.num_regs);
modRegions = [];  
maxIndex = data_c.regs.num_regs;
cTor = NaN(1, maxIndex);

if ~isempty(data_r)
    rAssignmnet = data_r.regs.map.f; 
    % Loop through each cell and update the result array
    for i = 1:numel(rAssignmnet)
        indices = rAssignmnet{i};
        cTor(indices) = i;
    end
end

for regNum =  1 : data_c.regs.num_regs

    if data_c.regs.props(regNum).Area == 0
        continue
    end

    % if isfield (data_c.regs, 'manual_link')
    %     manual_link = data_c.regs.manual_link.r(regNum);
    % else
    %     manual_link = 0;
    % end

    if data_c.regs.ID(regNum) ~= 0
        disp ([header, 'ErRes: Frame: ', num2str(time), ' already has an id ',num2str(regNum)]);
    elseif ismember (regNum,modRegions)
        disp ([header, 'ErRes: Frame: ', num2str(time), ' already modified ',num2str(regNum)]);
    else

        rIndex = cTor(regNum);

        if isnan(rIndex)
            [data_c,cell_count] = createNewCell (data_c, regNum, time, cell_count);
        else
            cCellsFromR = data_r.regs.map.f(rIndex);
            cCellsFromR = cCellsFromR{1};
    
            if numel(cCellsFromR) == 1 
                %disp('into branch == 1')
                %disp(cCellsFromR)
                
                errorStat = (data_c.regs.error.r(regNum)>0);
                [data_c, data_r] = continueCellLine(data_c, regNum, data_r,...
                    rIndex, time, errorStat);
            elseif numel(cCellsFromR) == 2
                disp('into branch 2')
                %disp(cCellsFromR)
    
                sister1 = cCellsFromR(1); 
                sister2 = cCellsFromR(2);
                
                mother = rIndex; 
                [data_c, data_r, cell_count] = createDivision (data_c, data_r, mother, sister1, sister2, cell_count, time, header, verbose);
            end
        end
    end

end
[data_c] = deleteRegions( data_c,regToDelete);

end



function [ data_c, data_r, cell_count ] = createDivision (data_c,data_r,mother,sister1,sister2, cell_count, time, header, verbose)

data_c.regs.error.label{sister1} = (['Frame: ', num2str(time),...
    ', reg: ', num2str(sister1),' and ', num2str(sister2),' . cell division from mother reg', num2str(mother),'. [L1,L2,Sc] = [',...
    num2str(data_c.regs.L1(sister1),2),', ',num2str(data_c.regs.L2(sister1),2),...
    ', ',num2str(data_c.regs.scoreRaw(sister1),2),'].']);
if verbose
    disp([header, 'ErRes: ', data_c.regs.error.label{sister1}] );
end
data_r.regs.error.r(mother) = 0;
data_c.regs.error.r(sister1) = 0;
data_c.regs.error.r(sister2) = 0;
[data_c, data_r, cell_count] = markDivisionEvent( ...
    data_c, sister1, data_r, mother, time, 0, sister2, cell_count);

end

