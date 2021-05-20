function dister = bwdistpaw( rl )

rl = rl*2;
dister = 0*rl+inf;
lister = unique( rl(rl>0 ))';

for ii = lister

    tmp = bwdist( (rl==ii))-bwdist( rl~=ii);
    tmp(rl==ii) =  tmp(rl==ii)+1;
    dister = min(dister,tmp);
    
end

