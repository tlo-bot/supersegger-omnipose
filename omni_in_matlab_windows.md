# Running Omnipose directly from MATLAB for Windows

Omnipose can be run directly from Supersegger-Omnipose in MATLAB, streamlining the process. The code has already been written into Supersegger-Omnipose (in BatchSuperSeggerOpti.m and condaactivateomnipose.m), and has been tested to work with Windows 10.

## Instructions

Since the code is integrated with Supersegger-Omnipose, simply specify autoomni=1 in the processExp command, ie processExp('dirname', 1).


## Explanation

The file (condaactivateomnipose.m) adds the Omnipose folders to the MATLAB environment/system path, which is equivalent to `conda activate omnipose`, then resets the MATLAB environment/system path after Omnipose has been run. Note that changes to the MATLAB environment are independent of the Windows System and User Environment Variables, so this should not affect paths outside of MATLAB.

Discussion about using a conda environment in MATLAB can be found [here](https://www.mathworks.com/matlabcentral/answers/443558-matlab-crashes-when-using-conda-environment-other-than-base) [(backup)](https://web.archive.org/web/20220709021839/https://www.mathworks.com/matlabcentral/answers/443558-matlab-crashes-when-using-conda-environment-other-than-base#toggle-comments). 

## Troubleshooting

-Error Message: 

The code assumes that the path to Omnipose is of the form '(drivename):\Users\Name\\(mini/ana)conda3\envs\omnipose'. If Omnipose has been installed elsewhere, there should be an error message. In that case, the variable 'omniPath' can be manually entered as a string in the condaactivateomnipose.m file.

-Change segmentation options:

To run automatically with different Omnipose options, can change options for the 'opstr' variable found in BatchSuperSeggerOpti.m file. The current default is with the model "bact_phase_omni" and options "--cluster --mask_threshold 1 --flow_threshold 0"









