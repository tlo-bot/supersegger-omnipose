function [data_new,success] = missingSeg2to1 (data_c,regC,data_r,regR,data_f,regF,CONST)
% missingSeg2to1 : finds missing segment in regC.
% Segments in regC are used that are close to the segment
% between the two regions regR(1) and regR(2) in data_r.
% if a segment is found that fits the requirements data_new is made with
% the new cell_mask and success is returned as true. Else the same data is
% returned and success is false.
%
% INPUT :
%      data_c : current data (seg/err) file.
%      regC : numbers of region in current data that needs to be separated
%      data_r : reverse data (seg/err) file.
%      regR : numbers of regions in reverse data file
%      data_f : forward data (seg/err) file.
%      regF : numbers of regions in forward data file
%      CONST : segmentation parameters
%
% OUTPUT :
%      data_new : data_c with new segment in good_segs and modified cell mask
%      success : true if segment was found succesfully.
%
% Copyright (C) 2016 Wiggins Lab
% Written by Stella Stylianidou
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
%
% You should have received a copy of the GNU General Public License
% along with SuperSegger.  If not, see <http://www.gnu.org/licenses/>.

    success = false;
    data_new = data_c;
    debug_flag = 0;

    %%

    rl = data_c.regs.regs_label;
    rlr = data_r.regs.regs_label;
    rlf = data_f.regs.regs_label;
    maskc = double(rl == regC); %pick out region causing error
    maskr = double(rlr==regR(1)); %get mask of 2 cells from previous frame 
    maskr = maskr + 2*double(rlr==regR(2)); %label as 1 and 2
    regisr = registerMasks_monointensity(maskr,maskc); %register mask from r frame to current mask
    regisr_mask = regisr.RegisteredImage; %registered mask, normalized to one

    if numel(regR)==2 && numel(regF)==2 %if 2:1:2, also use f info

        maskf = double(rlf==regF(1));
        maskf = maskf + 2*double(rlf==regF(2));
        regisf = registerMasks_monointensity(maskf,maskc);
        regisf_mask = 4*regisf.RegisteredImage; %multiply by 4 to have labels 2,4

        regisrf_mask = regisr_mask + regisf_mask; %adding 0.5,1 and 2,4 should have overlap

        %depending on how labels were assigned by registration, possible
        %overlap regions could be 2.5,5 or 3,4.5; assume highest total number are
        %correct regions (most overlap)
        n1 = sum(regisrf_mask==2.5,'all') + sum(regisrf_mask==5,'all');
        n2 = sum(regisrf_mask==3,'all') + sum(regisrf_mask==4.5,'all');
        if n1>n2 %more 2.5,5 than 3,4.5

            numr1 = 2.5;
            numr2 = 5;
            masknewlabel = createMask(maskc, regisrf_mask, numr1, numr2);

        elseif n2>n1 %more 3,4.5 than 2.5,5

            numr1 = 3;
            numr2 = 4.5;
            masknewlabel = createMask(maskc, regisrf_mask, numr1, numr2);

        else %something is weird so just give up on using forward frame info
            masknewlabel = createMask(maskc, regisr_mask, 0.5, 1);
        end

    else %if 2:1:1, only use r info    
        masknewlabel = createMask(maskc, regisr_mask, 0.5, 1);
    end

    %% apply new mask to output data_new

    if max(masknewlabel(:))==2 %only add if 2 new regions found
        maxreg = data_c.regs.num_regs; %get the max region in the current frame
        masknewlabel(masknewlabel==1) = maxreg+1; %relabel regions to be greater than max region
        masknewlabel(masknewlabel==2) = maxreg+2; %hopefully no overlap/double labeled regions

        rl(rl==regC)=0; %set erroneous merged mask to zero
        rl = rl + masknewlabel; %add fixed mask

        data_new.regs.regs_label = rl;
    end

    if ~isequal(rl,data_c.regs.regs_label) %if the regs_label mask has been changed
        success = true;
    end

end

function masknewlabel = createMask(maskc, registeredmask, numr1, numr2)
    
    r1 = (registeredmask==numr1); %one cell labeled by 0.5 
    r2 = (registeredmask==numr2); %other cell labeled by 1
    sr1 = bwdist(~r1);
    sr2 = bwdist(~r2);
    sr12 = -(sr1 + sr2);
    mark = imextendedmin(sr12,2); %find the mimima of the registered mask
    dsr12 = imimposemin(sr12,mark); %impose labeled cells as markers
    L = watershedpaw(dsr12); %watershed the registered mask, paw function modified to not leave a dividing segment
    masknewlabel = double(L).*maskc;

end
