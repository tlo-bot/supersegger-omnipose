"""
nd2totiff.py

This script converts ND2 image files to OME-TIFF format.

Usage:
    python nd2totiff.py <input_path>

Arguments:
    input_path : str
        The path to the input ND2 file.

Example:
    python nd2totiff.py /path/to/your/file.nd2

Dependencies:
    - platform
    - os
    - argparse
    - aicsimageio
    - aicsimageio[nd2]
    - bioformats-jar

The script will save the converted OME-TIFF files in the same directory as the input file.
It will also save the metadata of the ND2 file in a text file.
"""

import platform
import os 
import argparse
from aicsimageio.writers import OmeTiffWriter
from aicsimageio import AICSImage

# parse input arguments
parser = argparse.ArgumentParser(description='Convert nd2 image to OME-TIFF')
parser.add_argument('input_path', type=str, help='path to input nd2 file')
args = parser.parse_args()

input_path = args.input_path

if platform.system() == "Windows":
    input_path = r"{}".format(input_path)

# open the nd2 file
imgfile = AICSImage(input_path)

# detect number of channels, time points, xy, z planes, and image size
dims = imgfile.dims  # TCZYX

numt = dims['T']
numz = dims['Z']
numxy = len(imgfile.scenes)
numc = dims['C']
imsize = imgfile.shape[-2:]

print('timepoints:', numt[0], '\nz-planes:', numz[0],  '\nxy:', numxy,  '\nchannels:', numc[0], '\nimage size:', imsize)

# save metadata
md = imgfile.metadata
with open(f"{os.path.splitext(input_path)[0]}_metadata.txt", "w") as f:
    f.write(str(md))
f.close()

print('Saving metadata to:', f"{os.path.splitext(input_path)[0]}_metadata.txt")

# loop through each dim and save as individual tiff files
# basename_t1xy1c1.tif naming format for OmniSegger
# t and c start at 1 for OmniSegger
numt = numt[0]
numc = numc[0]
numz = numz[0]

basename = os.path.basename(os.path.splitext(input_path)[0])  # Ensure basename does not include directory path
if numz > 1:
    for zz in range(numz):
        zdir = os.path.join(os.path.dirname(input_path), f'z{zz}')
        zdir = os.path.abspath(zdir)  # Ensure absolute path
        if not os.path.exists(zdir):
            os.makedirs(zdir)
            print(f"Creating directory: {zdir}")
        for xy in range(numxy):
            imgfile.set_scene(xy)
            for tt in range(numt):
                for cc in range(numc):
                    singimg = imgfile.get_image_dask_data("YX", T=tt, C=cc, Z=zz).compute()
                    # save as tif, with t and c starting at 1 for OmniSegger
                    file_path = os.path.join(zdir, f'{basename}_z{zz}_t{tt+1}xy{xy}c{cc+1}.tif')
                    # print(zdir, file_path)
                    OmeTiffWriter.save(singimg, file_path)
else:
    for xy in range(numxy):
        imgfile.set_scene(xy)
        for tt in range(numt):
            for cc in range(numc):
                singimg = imgfile.get_image_dask_data("YX", T=tt, C=cc).compute()
                # save as tif, with t and c starting at 1 for OmniSegger
                file_path = os.path.join(os.path.dirname(input_path), f'{basename}_t{tt+1}xy{xy}c{cc+1}.tif')
                OmeTiffWriter.save(singimg, file_path)

print('Nd2 to tiff conversion complete.')
