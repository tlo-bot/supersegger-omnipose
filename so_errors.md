# Possible Supersegger-Omnipose errors & bugs

## processExp bug: Unrecognized function or variable 'maskdir'. - MATLAB Error

Description: after segmenting with Omnipose and continuing in MATLAB, this error appears along with errors in ssoSegFunPerReg, doSeg, intProcessXY, BatchSuperSeggerOpti, processExp

Explanation: Supersegger-Omnipose is not able to find the masks because one of the folders containing your dataset is named 'seg'.

Fix: change the name of the 'seg' folder (ex. 'seg1') and retry (no need to delete existing folders)

## superSeggerViewerGui bugs: Kymograph Mosaic creates 2 duplicate figures and 1 empty figure

Description: when making a cell kymograph mosaic through superSeggerViewerGui, the output is 2 of the same mosaic figures and 1 empty figure.

Explanation: There is a bug.

Fix: Ignore the extra figures.

## superSeggerViewerGui bugs: Saving cell movie - MATLAB Error

Description: when making a cell movie through superSeggerViewerGui, the movie is not made and there is an error.

Explanation: There is probably a bug.

Fix: In progress; try to manually create the movie using makeCellMovie.m

## superSeggerViewerGui bugs: Kymograph Mosaic for 1 cell - MATLAB Error

Description: when making a cell kymograph mosaic for 1 cell through superSeggerViewerGui, there is an error.

Explanation: There is probably a bug.

Fix: Manually create the kymograph using makeKymographC.m
