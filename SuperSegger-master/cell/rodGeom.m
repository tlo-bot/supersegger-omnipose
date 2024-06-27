function [R,L] = rodGeom( A, DA )
p = -(3/pi)*A;
q = (6/pi)*DA;

D1 = p^3/27+q^2/4;
C1 = (-q/2+(D1)^(1/2))^(1/3);
C2 = C1*(-1+(-3)^(1/2))/2;
C3 = C1*(-1-(-3)^(1/2))/2;





R1 = C1-p/(3*C1);
R2 = C2-p/(3*C2);
R3 = C3-p/(3*C3);


R_ = real([R1,R2,R3]);

R_ = R_(R_>0);

[R_,ord] = sort( R_);

if A == 0 || DA == 0 
    R = nan;
    L = nan;
else;
    R = R_(1);
    L = (A-pi*R^2)./(2*R) + 2*R;
end

end