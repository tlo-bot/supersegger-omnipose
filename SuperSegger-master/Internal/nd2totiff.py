import platform
import os 
from aicsimageio.writers import OmeTiffWriter
from aicsimageio import AICSImage

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

# loop through each dim and save as individual tiff files
# basename_t1xy1c1.tif naming format for OmniSegger
# t and c start at 1

numt = numt[0]
numc = numc[0]
numz = numz[0]

basename = os.path.splitext(input_path)[0]
if numz > 1:
    for zz in range(numz):
        zdir = os.path.join(os.path.dirname(input_path), f'z{zz}')
        if not os.path.exists(zdir):
            os.makedirs(zdir)
        for xy in range(numxy):
            imgfile.set_scene(xy)
            for tt in range(numt):
                for cc in range(numc):
                    singimg = imgfile.get_image_dask_data("YX", T=tt, C=cc, Z=zz).compute()
                    # save as tif, with t and c starting at 1 for OmniSegger
                    OmeTiffWriter.save(singimg,os.path.join(zdir, f'{basename}_t{tt+1}xy{xy}c{cc+1}.tif'))
else:
    for xy in range(numxy):
        imgfile.set_scene(xy)
        for tt in range(numt):
            for cc in range(numc):
                singimg = imgfile.get_image_dask_data("YX", T=tt, C=cc).compute()
                # save as tif, with t and c starting at 1 for OmniSegger
                OmeTiffWriter.save(singimg,os.path.join(os.path.dirname(input_path), f'{basename}_t{tt+1}xy{xy}c{cc+1}.tif'))
