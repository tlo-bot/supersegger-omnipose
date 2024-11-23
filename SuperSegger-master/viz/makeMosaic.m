function makeMosaic( dat )
% makeMosaic : Make image mosaic of various time points
% Can also draw the cell outlines, show the fluorescence (channel 2),
% and show the time points in minutes
%
% INPUT:
%
% dat: parameters for the mosaic. It can be a struct with the following fields:
%   basename: Path of the xy folder
%   basename1: (if basename missing) Path to seg directory up to the t of the err file
%      ie: '/imgdir/xy0/seg/filename_t'
%   basename2: (if basename missing) Last part of the err filename
%      ie: 'xy0_err.mat'
%   formating: The formating string for the time points (optional)
%       ie: t1 becomes t001, t10 becomes t010, etc
%   tstart: First frame to include in the mosaic, default is 1
%   tend: Last frame to include in the mosaic, default is the last frame
%   DT: Frame rate in minutes, default is 1
%   dt: Interval to skip from tstart to tend, default is 1
%   axis: Coordinates to crop mosaic, [x0 x1 y0 y1] (optional)
%   nv: The number of vertical subplots (optional)
%   nh: The number of horizontal subplots, default is 1
%
% Optional dat fields for drawing cell outlines and/or showing fluorescence:
%   ind: A cell array of cell IDs to draw - can use getFamily for progenitors
%   cc: A cell array of colors to use for each cell ID
%   ccfluor: Color to use for the fluorescence, default is green
%   showfluor: Flag to show the fluorescence
%   drawspline: Flag to draw the cell outlines 
%   drawsplineAll: Flag to draw all cell outlines in 1 color 
%   weight: Lineweight for the cell outlines 
%   resetpadding: Flag to reset the padding of the mosaic 
%   rainbow: Flag to plot each cell ID in a different color 

% mothers: A list of the mother cell IDs you want to get the progeny of
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

% set frame rate in minutes
if isfield( dat, 'DT')
    DT = dat.DT;
else 
    DT = 1; % min
end

% set frame skip
if isfield( dat, 'dt')
    dt = dat.dt;
else 
    dt = 1; % min
end

% trim axis
if isfield( dat, 'axis')
    tmp_axis = dat.axis;
else
    tmp_axis = [];
end

% Check if rainbow option is provided
if ~isfield( dat, 'rainbow' )
    dat.rainbow = false;
end
rainbow = dat.rainbow;

% Data files setup
if isfield( dat, 'basename1' )
% data files setup here
    basename1 = dat.basename1;
    basename2 = dat.basename2;
    formating = dat.formating;
else
    % Default setup for basenames and formatting
    segtxt = '/seg/';

    % Get list of files matching the pattern
    contents = dir( [dat.basename,segtxt,'*err.mat' ] );
    tmpname = contents(1).name;

    % Find the position of 't' in the filename
    ind_t = find(tmpname == 't' );
    ind_t = ind_t(end-1);
    ind_tnum = ind_t+1;

    % Find the position of the first non-digit character after 't'
    ind_num = isstrprop(tmpname,'digit');
    ind_tnum2 = find(~ind_num(ind_tnum:end), 1, 'first' )-1+ind_tnum-1;

    
    % Create formatting string based on the number of digits
    formating = ['%0',num2str(ind_tnum2-ind_tnum+1), 'd'];

    % Extract basename2 from the filename
    basename2 = tmpname( (ind_tnum2+1):end );

    % Create basename1 using the provided basename and segment text
    basename1 = [dat.basename,segtxt,tmpname(1:ind_t)];

end

% last frame number
if isfield( dat, 'tend')
    tend = dat.tend;
else 
    tend =  numel( dir( [basename1,'*']));
end

% first frame number
if isfield( dat, 'tstart')
    tstart = dat.tstart;
else 
    tstart = 1;
end

% make frame times here
tt = tstart:dt:tend;
nt = numel(tt);

% Chose the vertical dimensions of the figure here
if isfield( dat, 'nv')
    nv = dat.nv;
else
    nv = floor( sqrt(nt ));
end

if isfield( dat, 'nh')
    nh = dat.nh;
else
    % Calculate the number of horizontal subplots
    nh = ceil(nt/nv);  
end

% show fluorescence
if isfield( dat, 'showfluor')
    showfluor = dat.showfluor;
else
    showfluor = 0;
end

% set fluorescence color
if isfield( dat, 'ccfluor')
    ccfluor = dat.ccfluor;
else
    ccfluor = 'g';
end


% get cell IDs
if isfield(dat, 'ind')
    ind_ = dat.ind;
else
    ind_ = {};
end

% default yellow outlines if none specified
if isfield(dat, 'cc')
    cc_ = dat.cc;
else
    cc_ = 'y';
end

% draw outlines by cell ID
if isfield( dat, 'drawspline')
    drawspline = dat.drawspline;
else
    drawspline = 0;
end

% draw all outlines in 1 color
if isfield( dat, 'drawsplineAll')
    drawsplineAll = dat.drawsplineAll;
    if drawsplineAll && drawspline
        disp('Warning: Drawing all cell outlines and individual cell outlines at the same time.');
    end
else
    drawsplineAll = 0;
end

if ~iscell( ind_ )
    ind_ = {ind_};
    cc_  = {cc_};
end


% Create the first subplot
subplot( nv, nh, 1 );

% Loop through each time point
for ii = 1:nt

    % Create a subplot for the current time point
    subplot( nv, nh, ii );

    % Get the current time point
    tt_ = tt(ii);

    % Convert the time point to a string with the specified formatting
    number_text = num2str( tt_,formating);

    % Load the err file for the current time point
    data = load( [basename1,number_text,basename2]);
       
   % If the data contains 'fluor1', initialize fluorescence range
    if isfield( data, 'fluor1' )
        fl1 = min(data.fluor1(:));
        fl2 = max(data.fluor1(:));
        fl1 = fl1 + (fl2-fl1)*.2;
    end

    % Initialize phase range
    ph1 = min(data.phase(:));
    ph2 = max(data.phase(:));

    % If this is the first time point, initialize some variables
    if ii == 1
        % Get the dimensions of the phase data
        dx0 = size(data.phase,2);
        dy0 = size(data.phase,1);
    end
   

    if isfield( data, 'fluor1' ) && showfluor
        % show phase and fluorescence
        comp( {data.phase,0.75}, {data.fluor1,ccfluor,[fl1,fl2],.75})
        % comp(  {data.fluor1,'y',[50,fl2],1}) %only fluor
    else
        % show phase only
        comp( {data.phase,1.5,[ph1,ph2]} )
        %comp( {data.phase,0.5,[ph1,ph2]} )
    end

    hold on;

    %plot individual IDs
    if drawspline
        for jj = 1:numel(ind_)
    
            if rainbow
                nc    = size(dat.cc_,1);
                ccc = {};
                for kk = 1:numel(ind_{jj})
                    inder = mod(ind_{jj}(kk)-1,nc)+1;
                    ccc{kk}   = dat.cc_(inder,:);
                end
                drawCellSpline( data, ind_{jj}, ccc, [], rainbow );
    
            else
                ccc = cc_{jj};
                drawCellSpline( data, ind_{jj}, ccc );
            end
        end
    end

    %plot all IDs 
    if drawsplineAll
        drawCellSpline(data, [], dat.cc, dat.weight, 0)
    end


    % crop the axis
    if isempty( tmp_axis )
        tmp_axis = axis;
    end
    axis( tmp_axis );
    

    dx0 = tmp_axis(2)-tmp_axis(1)+1;
    dy0 = tmp_axis(4)-tmp_axis(3)+1;
    
    %axis('equal');

     

    plot( tmp_axis(1)+[0,0], tmp_axis(3:4), 'w:' );
    plot( tmp_axis(1:2), tmp_axis(3)+[0,0], 'w:' );

    axis(tmp_axis);

    % show time label, in minutes
    h = text(tmp_axis(2)-2,tmp_axis(4)-2,['  {\it{t}} = ', num2str(ceil((tt_-tt(1))*DT)), ' min'], 'Color','w');
    h.VerticalAlignment = 'bottom';
    h.HorizontalAlignment = 'right';

end

%% change padding 

if isfield( dat, 'resetpadding')
    resetpadding = dat.resetpadding;
else 
    resetpadding = 0;
end

if resetpadding
    
    % reset padding
    fptr = gcf;
    
    %set( fptr.Children(1),'DataAspectRatioMode','auto')
    
    
    %dx0 = fptr.Children(1).Position(3)
    %dy0 = fptr.Children(1).Position(4)
    
    dX0 = dx0*nh;
    dY0 = dy0*nv;
    
    maxs = max( [dX0,dY0] );
    gain = 1/maxs;
    
    dx1 = dx0*gain;
    dy1 = 1/nv;
    dX1 = dX0*gain;
    dY1 = 1;
    
    xstart = (1 - dX1)/2;
    ystart = (1 - dY1)/2;
    
    fig_pos = get( fptr, 'Position' );
    if fig_pos(3)/fig_pos(4) > dX0/dY0
        fig_pos(3) = fig_pos(4)*dX0/dY0;
    else
        fig_pos(4) = fig_pos(3)*dY0/dX0;
    end
    set( fptr, 'Position', floor(fig_pos) );
    %set( fptr, 'OuterPosition', floor(fig_pos) );
    %set( fptr, 'InnerPosition', floor(fig_pos) );
    
    dn = nh*nv-nt;
    
    
    % make paper size
    ppi = 150;
    margin            = 0.2500;
    PaperPosition     = [ margin, margin, dX0/ppi, dY0/ppi ];
    PaperPositionMode = 'manual';
    PaperSize         = [2*margin+dX0/ppi, 2*margin+dY0/ppi];
    set( gcf, 'PaperPosition',    PaperPosition,...
              'PaperPositionMode',PaperPositionMode,... 
              'PaperSize',        PaperSize,...
              'RendererMode', 'manual', ...
              'Renderer', 'Painters');
    
    for ii = 1:nt
        sizer = get( fptr.Children(ii), 'Position' );
        sizer(3) = dx1;
        sizer(4) = dy1;
    
        [col,row] = ind2sub( [nh, nv], ii+dn);
    
        sizer(1) = 1-(xstart+dx1*(col));
        sizer(2) = (ystart+dy1*(row-1));
    
        set( fptr.Children(ii), 'Position',  sizer );
    
        set( fptr.Children(ii),'DataAspectRatioMode','auto')
        %annotation('line',sizer(1)+[0,0],sizer(2)+[0,.5],'Color','w')
    end
    
    set(gcf, 'InvertHardCopy', 'off');

end


end
