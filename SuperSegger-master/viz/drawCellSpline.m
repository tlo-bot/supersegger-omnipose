function drawCellSpline( data, ID, cc, weight, rainbow)
% drawCellSpline : draws a spline outline of cell for publication quality figures 
% Outlines drawn based on mask.
% Outline is drawn on top of the image in the current figure.
%
% INPUT:
%
% data: A loaded err.mat file for the image you want outlines drawn on
% ID: A vector of cell IDs to draw outlines for. If empty, all cells are drawn.
% cc: Colormap to draw the outlines in. Default is yellow.
% weight: Line width of the outlines. Default is 1.
% rainbow: If true, each cell is drawn in a different color. Default is false.
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


% if no cell IDs are passed, do them all
if ~exist( 'ID', 'var' ) || isempty( ID )
    if ~isfield( data, 'CellA' )
        disp( 'Error: No field CellA.');
        ID = [];
    else
        ID = data.regs.ID;
    end
end

% if no color is passed, make cells yellow:
if ~exist( 'cc', 'var' ) || isempty( cc )
    cc = 'y';
end

% if no weight is passed, make linewidth = 1:
if ~exist( 'weight', 'var' ) || isempty( weight )
    weight = 1;
end

% default to no rainbow/all the same color
if ~exist( 'rainbow', 'var' ) || isempty( rainbow )
    rainbow = false;
end

%% Do drawing here
% draw each outline on a region by region basis
for ii = 1:numel(ID)
    ID_ = ID(ii);

    ind = find( data.regs.ID==ID_);

    if numel(ind)==1

        CellAA = data.CellA{ind};

        offset = [CellAA.xx(1)-1,CellAA.yy(1)-1];
        if rainbow
            intDrawCellSpline( CellAA.mask, offset, cc{ii}, weight );
        else
            intDrawCellSpline( CellAA.mask, offset, cc, weight );
        end
    else
        %disp('Fail');
    end
end
end


function intDrawCellSpline( mask, offset, cc, weight )

tmp = bwboundaries( mask, 8 );
if isempty( tmp )
    disp('error');
else
    for ii = 1:numel(tmp)
        tmp2 = tmp{ii};
        xy = tmp2(1:5:end,[2,1])';
        xy = xy(:,[end,1:end]);
        xy(1,:) = xy(1,:) + offset(1);
        xy(2,:) = xy(2,:) + offset(2);

        h = fnplt(cscvn(xy));
    
        plot( h(1,:), h(2,:), 'Color', cc, 'Linewidth', weight);
        % patchline( h(1,:), h(2,:), 'edgecolor', cc, 'linewidth', weight, 'edgealpha', 0.3);
    end
end
end



