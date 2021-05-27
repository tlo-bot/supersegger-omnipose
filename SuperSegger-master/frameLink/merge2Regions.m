function [data_c,resetRegions] = merge2Regions (data_c, list_merge, CONST)
% merge2Regions : merges reg1 and reg2 into one in the mask_cell
% regions need to be remade after this in order to have the right
% properties.
% INPUT :
%      data_c : current data (seg/err) file.
%      reg1 : id of region 1
%      reg2 : id of region 2 
%      CONST : segmentation parameters
%
% OUTPUT :
%      data_c : data_c with merged regions
%      resetRegions : true if regions were merged and linking should
%      re-run.
%
% Copyright (C) 2016 Wiggins Lab
% Written by Stella Stylianidou, Paul Wiggins.
% University of Washington, 2016
% This file is part of SuperSegger.
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

resetRegions = 0;
masksum = 0*data_c.regs.regs_label; %zero matrix with same size as regs_label

for i = 1 : numel(list_merge)
    mask1 = (data_c.regs.regs_label == list_merge(i)); %focus on the sister1, sister2 part of regs_label
    masksum = (masksum+mask1); %add the focused area to the zero matrix
end

masksum_  = imdilate(masksum,strel('square',3)); %dilate the regions
masksum__  = imerode(masksum_,strel('square',3)); %erode the dilated regions to remove holes/separations

labels =  bwlabel(masksum__); %make labeled mask from new mask
if max(labels(:)) == 1 %if only one labeled area in new mask
    %lowerid = min(list_merge); %find lower region ID (or could do higher)
    maxreg = data_c.regs.num_regs;
    rl = data_c.regs.regs_label;
    rl(rl==list_merge(1)) = 0; %clear the erroneous masks 
    rl(rl==list_merge(2)) = 0;
    %labels(labels==1) = lowerid; %set the merged mask to have the lower ID
    labels(labels==1) = maxreg+1; %set the merged mask to have highest ID in frame
    rl = rl + labels; %add the merged mask to the overall mask
    data_c.regs.regs_label = rl; %save new overall mask into data_c
    
    
%     segsInMask = data_c.segs.segs_label; %all the segs
%     segsInMask(~masksum__) = 0; %ignore segs not in region of focus
%     segsInMask = logical(segsInMask); %set all segs in region to 1
%     data_c.segs.segs_good(segsInMask) = 0; %turn off the segs that were good in that region
%     data_c.segs.segs_bad(segsInMask) = 1; %turn the segs that were bad back on (?)
%     data_c.mask_cell = double((data_c.mask_cell + masksum__)>0); %add the merged mask to the original mask
    resetRegions = true;
end


end