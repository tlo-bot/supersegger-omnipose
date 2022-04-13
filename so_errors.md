# Possible Supersegger-Omnipose errors

## Unrecognized function or variable 'maskdir'. - MATLAB Error

Description: after segmenting with Omnipose and continuing in MATLAB, this error appears along with errors in ssoSegFunPerReg, doSeg, intProcessXY, BatchSuperSeggerOpti, processExp

Explanation: Supersegger-Omnipose is not able to find the masks because one of the folders containing your dataset is named 'seg'.

Fix: change the name of the 'seg' folder (ex. 'seg1') and retry (no need to delete existing folders)
