function cell_list = getFamily( clist, mothers )
% getFamily : Get the list of all progeny of a cell
%
% INPUT:
% clist: A loaded clist.mat file 
% mothers: A list of the mother cell IDs you want to get the progeny of
%
% OUTPUT:
% cell_list: A list of all the progeny of the mothers list
%
% Copyright (C) 2024 Wiggins Lab
% Written by Paul Wiggins, Teresa Lo.
% University of Washington, 2024. This file is part of OmniSegger.
%
% OmniSegger is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% OmniSegger is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with OmniSegger.  If not, see <http://www.gnu.org/licenses/>.

% initialize the flagger and cell list
flagger = true;
cell_list = [];

% find the index for the mother IDs from the 2D clist
moth_ind = find(ismember(clist.def,'Mother ID'));


% compile the list of cell progeny
while flagger

    % add mothers from previous loop to cell_list
    cell_list = [cell_list,mothers];

    % check that mother cell IDs are in mother IDs from clist
    ind = ismember( clist.data(:,moth_ind), mothers );
    mothers = clist.data(ind,1)';

    % end loop when no more mothers are found 
    flagger = numel(mothers)>0;

end

end