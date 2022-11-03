function  [out] = intAlignIm2( imA, imB, precision )
% intAlignIm : aligning image A to image B with given precision
%
% INPUT :
%      imA : path to image A (reference)
%      imB : path to image B (registered)
%      precision :  Upsampling factor (integer). Images will be registered to 
%           within 1/precision of a pixel. 
%
% OUTPUT :
%       out :  [error,diffphase,net_row_shift,net_col_shift]
%           error : Translation invariant normalized RMS error between f and g
%           diffphase : Global phase difference between the two images (should be
%           zero if images are non-negative).
%           net_row_shift, net_col_shift : Y,X Pixel shifts between images
%
% Copyright (C) 2022 Wiggins Lab 
% Written by Paul Wiggins & Teresa Lo.
% University of Washington, 2022
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

% check precision 
if ~exist( 'precision', 'var' ) || isempty( precision ) 
    precision = 1000;
end

% load images
imAA = imread(imA);
imBB = imread(imB);

% crop images and find crop XY coords
[crop1,coords] = imcrop(imAA);
crop2 = imcrop(imBB, coords);

% convert to double 
crop1 = im2double(crop1);
crop2 = im2double(crop2);

% fourier transform images
fftAA = fft2(crop1);
fftBB = fft2(crop2);

% subpixel image registration of image B to image A by crosscorrelation
try
    out = dftregistration(fftAA,fftBB,precision);
    out(3:4) = -out(3:4); % use negative values
catch ME
    printError( ME )
end


end