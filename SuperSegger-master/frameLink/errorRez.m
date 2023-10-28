function [data_c, data_r, cell_count,resetRegions] =  errorRez (time, ...
    data_c, data_r, CONST, cell_count, header)
% errorRez : links cells from the current frame to the frame before and
% attempts to resolve segmentation errors if the linking is inconsistent.
%
% INPUT :
%   time : current frame number
%   data_c : current time frame data (seg/err) file.
%   data_r : reverse time frame data (seg/err) file.
%   CONST : segmentation parameters.
%   cell_count : last cell id used.
%   header : last cell id used.
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

verbose = CONST.parallel.verbose;
resetRegions = false;
cArea = [data_c.regs.props.Area];

% set all ids to 0
data_c.regs.ID = zeros(1,data_c.regs.num_regs);

if ~isempty(data_r)
    assignRtoC = data_r.regs.map.f;
    
    for regNum = 1 : data_r.regs.num_regs
        cRegNums = assignRtoC(regNum);
        cRegNums = cRegNums{1};
            % Case of 1 to 1 link
            if length(cRegNums) == 1 
                cRegNum = cRegNums(1);
                errorStat = (data_c.regs.error.r(cRegNum)>0);
                [data_c, data_r] = continueCellLine(data_c, cRegNum, data_r,...
                    regNum, time, errorStat);
            % Case of 1 divided to multiple 
            elseif  length(cRegNums) >= 2
                sister1 = cRegNums(1); 
                sister2 = cRegNums(2);
                mother = regNum; 
                [data_c, data_r, cell_count] = createDivision (data_c, data_r, mother, sister1, sister2, cell_count, time, header, verbose);
            end
    end
end

% For un-assigned region in c, createNewCell
for regNum = 1 : data_c.regs.num_regs
    if data_c.regs.ID(regNum) == 0 &&  cArea(regNum) ~= 0
        [data_c,cell_count] = createNewCell (data_c, regNum, time, cell_count);
    end
end

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

