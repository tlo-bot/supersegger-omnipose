function clist2xls( clistpath, filename )
% clist2xls : function that exports the clist as a excel file.
% 
% INPUT :
%       clistpath : path to clist file
%       filename : optional name for xls file; default to save to xy folder
%
%
%
% Copyright (C) 2024 Wiggins Lab 
% Written by Paul Wiggins, Nathan Kuwada, Stella Stylianidou, Teresa Lo.
% University of Washington, 2024
% This file is part of OmniSegger.
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

clist = load(clistpath);

clist = removeDuplicates( clist );

% default filename if input empty
if nargin < 2 || isempty(filename)
    xy_dir = fileparts(clistpath);
    filename = [xy_dir filesep 'clist.xls'];
end

% erase file if it exists
if exist( filename, 'file') 
    delete( filename );
end

% write data first
tab = array2table(clist.data,...
    'VariableNames',clist.def);

writetable(tab,filename,'sheet','Per cell data')

% Loop through 3D data types
nn = numel( clist.def3D );

nID    = size( clist.data3D, 1 );
nFrames = size( clist.data3D, 3 );


Frame_text = cell( [1,nFrames+1] );
Frame_text{1} = 'Cell ID';

for ii = 1:nFrames
    Frame_text{ii+1} = ['Frame ',num2str(ii)]; 
end

for ii = 1:nn

    tab = array2table( [(1:nID)',squeeze(clist.data3D(:,ii,:))],...
    'VariableNames',Frame_text);

    name = clist.def3D{ii};
    if numel(name) > 31 %?
        name = name(1:31);
    end

    writetable( tab, filename, 'sheet', name );

end


end


function clist = removeDuplicates( clist )


%% Do data first
rem_ind = [];

n = numel( clist.def );

for ii = 1:n

    ind = find(strcmp( clist.def{ii}, clist.def ));

    if numel(ind) ~= 1
        ind2 = ind(2:end);
        rem_ind = [rem_ind,ind2(ind2>ii)];       
    end
end

ind = 1:n;
ind = ind( ~ismember( ind,rem_ind ));


clist.def = clist.def(ind);
clist.data = clist.data(:,ind);

%% Do data3D 
rem_ind = [];

n = numel( clist.def3D );

for ii = 1:n

    ind = find(strcmp( clist.def3D{ii}, clist.def3D ));

    if numel(ind) ~= 1
        ind2 = ind(2:end);
        rem_ind = [rem_ind,ind2(ind2>ii)];    
    end
end

ind = 1:n;
ind = ind( ~ismember( ind,rem_ind ));


clist.def3D = clist.def3D(ind);
clist.data3D = clist.data3D(:,ind,:);






end