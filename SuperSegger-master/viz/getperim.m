function totalperim = getperim(msk)
%     totalperim = false(size(labels));
%     lnums = unique(labels);
%     lnums = lnums(lnums>0);
%     for j = lnums.'
%         perim = bwperim(labels == lnums(j));
%         totalperim(perim) = 1;
%     end
    totalperim = (msk~=imtranslate(msk,[1 0])|...
            msk~=imtranslate(msk,[-1,0])|...
            msk~=imtranslate(msk,[0 1])|...
            msk~=imtranslate(msk,[0 -1]))&~msk==0;

end