function mask = removeBorderCells(mask, crop_box)
% removeBorderCells : removes cells on border from mask
%
% INPUT :
%       mask : cell mask 
%       crop_box : information about alignment of the image
%
% OUTPUT :
%       mask : mask with cells on border removed

    crop_box = round( crop_box );
    
    if ~isempty( crop_box );
        mask(:,1:crop_box(2))   = false;
        mask(:,crop_box(4):end) = false;
        mask(1:crop_box(1),:)   = false;
        mask(crop_box(3):end,:) = false;
        
        mask(:,1:crop_box(2))   = false;
        mask(:,crop_box(4):end) = false;
        mask(1:crop_box(1),:)   = false;
        mask(crop_box(3):end,:) = false;
    end

end