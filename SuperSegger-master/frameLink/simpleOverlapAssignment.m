function [assignments,errorR, dA,revAssign]  = simpleOverlapAssignment ...
    (data_c, data_f, CONST, forward, debug_flag)
% simpleOverlapAssignmentSparse : assigns regions in data_c to regions in data_f.
% Uses a area overlap.
%
% INPUT :
%    data_c : current frame file
%    data_f : forward frame file
%    CONST : segmentation parameters
%    forward : 1 for forward direction (e.g current to forward), 0 for
%    reverse
%    debug_flag : 1 to display assignment result.
%
% OUTPUT :
%   assignments : cell matrix. cell of region c is assigned id of region f
%   errorR : matrix with 2 (DA<MIN) or 3(DA>MAX) if error, 0 if no error
%   totCost : cost matrix
%   indexC : region ids in data_c for cost matrix
%   indexF : region ids in data_f for cost matrix
%   dA :  area change
%   revAssign : cell matrix with reverse assignments (from ids in f to c)
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


if ~exist('debug_flag','var') || isempty(debug_flag)
    debug_flag = 0;
end

if ~exist('forward','var') || isempty(forward)
    forward = 1;
end

revAssign = [];
assignments = [];
errorR = [];
dA = [];

if ~isempty(data_c)
    if ~isfield(data_c,'regs')
        data_c = updateRegionFields (data_c,CONST);
    end
    
    numRegs1 = data_c.regs.num_regs;
    assignments  = cell( 1, numRegs1);
    errorR = zeros(1,numRegs1);
    dA = nan*zeros(1,numRegs1);
    mapC = cell( 1, numRegs1);

    if ~isempty(data_f)
        if ~isfield(data_f,'regs')
            data_f = updateRegionFields (data_f,CONST);
        end
        
        if ~isfield (data_c.regs, 'manual_link')
            data_c.regs.manual_link.f = zeros(1,numel(data_c.regs.num_regs));
        end

        regsInC = 1:data_c.regs.num_regs;
        
        if forward
            manualC = data_c.regs.manual_link.f;
            if any(manualC)
                mapC = data_c.regs.map.f;
            end
            manualF = data_f.regs.manual_link.r;
        else
            manualC = data_c.regs.manual_link.r;
            if any(manualC)
                mapC = data_c.regs.map.r;
            end
            manualF = data_f.regs.manual_link.f;
        end

        regsInC = regsInC(~manualC); % Remove manually linked regions.
        
        if ~isfield (data_f.regs, 'manual_link')
            data_f.regs.manual_link = zeros(1,numel(data_f.regs.num_regs));
        end

        regsInF = 1:data_f.regs.num_regs;
        regsInF = regsInF(~manualF);  % Remove manually linked regions
        
        maskMatrixC = data_c.regs.regs_label;
        maskMatrixF = data_f.regs.regs_label;
        propsF = data_f.regs.props;
        propsC = data_c.regs.props;

        for ii=regsInF % loop through the targeted regions
             fRegion = maskMatrixF == ii ;
             fRegionArea =  propsF(ii).Area;
             boundingBoxF = propsF(ii).BoundingBox;
             [x1,x2,y1,y2] = getBoxCornerIndex(boundingBoxF);
             LargestIOU = 0; %IOU: Insection Over Union
             bestSourceCell = -1;
           for jj=regsInC
               cRegion = maskMatrixC == jj;
               intersection = bwarea(fRegion(y1:y2, x1:x2) & cRegion(y1:y2, x1:x2));
               if intersection == 0
                   continue;
               end
               cRegionArea = propsC(jj).Area;
               union = cRegionArea + fRegionArea - intersection;
               currentIOU = intersection/union;
               if currentIOU > LargestIOU
                   LargestIOU = currentIOU;
                   bestSourceCell = jj;
               end    
           end
           

           if bestSourceCell ~= -1
               assignments{bestSourceCell} = [assignments{bestSourceCell}, ii];
           end
            
        end
        
        % assign the manual assignments
        manualRegsIdsC = find(manualC);
        for yy = manualRegsIdsC
            assignments{yy} =  mapC{yy};
        end
        
        cArea = [data_c.regs.props.Area];
        fArea = [data_f.regs.props.Area];
        
        dA = changeInArea(assignments, cArea,fArea);
    end
end
end



function dA = changeInArea(assignments, cArea,fArea)
    % change in area set for data_c
    numRegs1 = size(assignments,2);
    dA = nan*zeros(1,numRegs1);
    for ll = 1 : numRegs1
        tmpAssgn =  assignments{ll};
        carea_tmp =  (cArea(ll));
        farea_tmp = sum(fArea(tmpAssgn));
        dA(ll) = (farea_tmp - carea_tmp) / max(carea_tmp,farea_tmp);
    end
    
end

function [x1,x2,y1,y2] = getBoxCornerIndex(bbox)
% getBoxLimits : returns the bounding box for regNums
[x, y, width, height] = deal(round(bbox(1)), round(bbox(2)), round(bbox(3)), round(bbox(4)));
x1 = x;
x2 = x + width - 1;
y1 = y;
y2 = y + height - 1;
end

