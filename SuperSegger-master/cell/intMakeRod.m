function [Rhat,Lhat] = intMakeRod( mask, r0 )

if ~exist( "r0", 'var' ) || isempty( r0 )
    r0 = -.5;
end

A    = sum( double( mask(:) ));

dist = bwdist(~mask);
DA = sum( double( dist(:) ))+r0*A;




[Rhat,Lhat] = rodGeom(A,DA);

end