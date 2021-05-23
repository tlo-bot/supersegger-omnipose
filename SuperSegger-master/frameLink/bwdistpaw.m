function dister = bwdistpaw( rl )

rl = rl*2; %multiply by 2 since registered mask is labeled with 0.5,1
dister = 0*rl+inf;
lister = unique( rl(rl>0 ))'; %region labels

for ii = lister

    tmp = bwdist( (rl==ii))-bwdist( rl~=ii);
    tmp(rl==ii) =  tmp(rl==ii)+1;
    dister = min(dister,tmp);
    
end

