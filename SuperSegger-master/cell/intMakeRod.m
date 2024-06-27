function [Rhat,Lhat] = intMakeRod( mask, r0 )
% intMakeRod : find radius and length of rod shaped cell from cell mask

if ~exist( "r0", 'var' ) || isempty( r0 )
    r0 = -.5;
end

%mask area
A    = sum( double( mask(:) ));

%sum of distance field of mask
dist = bwdist(~mask);
DA = sum( double( dist(:) ))+r0*A;



%calculate effective rod radius and length
[Rhat,Lhat] = rodGeom(A,DA);

end