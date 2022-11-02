## Quick Start Guide for SuperSegger

- Using the GUI

	<img src="https://camo.githubusercontent.com/2903acaebd8ee6da9498dd5ccff1c9939624b16827758ab401b06a005344d706/687474703a2f2f6d747368617374612e706879732e77617368696e67746f6e2e6564752f776562736974652f696d616765732f7365676765726775692e706e67" width="20vw" height="30vh">

	1. Image directory: 

	Paste the image directory into the input box, or use the folder icon to select the folder. 

	2. Image requirements: 

	Images should be monochromatic and .tif format. Images do not need to be a specific resolution, because Omnipose segmentation has been trained with various resolutions.

	3. Image file naming: 

	The file naming convention is `[somebasename]t[number]xy[number]c[number].tif` where the numbers after 't' are the time frames after 'xy' are for the different timelapse positions, and after 'c' are the different channels (c1 are the phase images, c2 onwards are the fluorescence channels), eg MG1655_t001xy1c1.tif.
	The program can segment images for snapshots (i.e. if t is missing from the filename, [somebasename]xy[number]c[number].tif) or for one xy position (i.e. if xy is missing from the filename [somebasename]t[number]c[number].tif).

	To rename images can be done with the GUI or with the function convertImageNames.m.
	For the GUI:

	- Fill Basename with the desired identification of the images (suggested is date-strain).
	- Fill Channels with the corresponding channel names as identified in your original filenames, separated by a comma. The first entry should correspond to the phase image. (ie if the file names are MG1655_GFP.tif, MG1655_BF.tif, enter `BF,GFP`)
	- Fill Time prefix/suffix with a unique substring that precedes the number indicating the time frame in the filename (ie strain_t0001.tif would use prefix `t` or `_t` and suffix `.tif`)
	- Fill XY prefix/suffix similarly to the Time prefix/suffix.
	- The prefix/suffix can also be left blank (ex snapshots have a single time; a single XY)
	- Click 'Convert Image Names'

	4. Selecting constants

	Note that since Omnipose has replaced Supersegger's segmentation, segmentation constants no longer need to be selected. Omnipose segmentation [parameters](https://github.com/tlo-bot/supersegger-omnipose#omnipose) can be tested via the Omnipose GUI (`python -m omnipose`). The default segmentation parameters were selected for E. coli. 

	5. Modifying constants parameters

	The main parameters that may need to be adjusted are the Foci and Minimum Cell Age. 
	Foci: maximum number of foci in the fluorescence channels that should be identified per cell (ie for 2 fluorescence channels, `4,2` will identify up to 4 foci in the first channel and 2 in the second) 
	Minimum Cell Age: Minimum frames of cell age to be considered full cell cycle.

	Find [further details](https://github.com/wiggins-lab/SuperSegger/wiki/Segmenting-with-SuperSegger#modifying-constants-parameters-) about other constants parameters.

	6. Follow the rest of the [Supersegger-Omnipose GUI instructions](https://github.com/tlo-bot/supersegger-omnipose#running-supersegger-omnipose-gui).

- Using processExp

	processExp contains all the functions of the GUI, but can be run directly from the command line. In addition, the functionality to automatically run Omnipose (without needing to manually open a Terminal window) and also save a log of the processing has been added.

	First, edit processExp to your desired parameters.	
	1. 'Converting other microscopes files': Convert image names if needed. The strings can be modified similarly to the GUI instructions above.
	2. 'Parallel Processing Mode': Set parallel processing to 'true' if desired.
	3. 'Calculation Options': change CONST.trackLoci.numSpots to max number of foci to identify for each fluorescence channel; CONST.view.fluorColor to the color(s) to display the fluorescence in superSeggerViewerGui (eg {'g','r','b','c','o','y'})

	Automatically run Omnipose: Add a 1 after the dirname input (default 0). There is some setup required for [Linux/MacOS systems](https://github.com/tlo-bot/supersegger-omnipose/blob/main/omni_in_matlab_unix.md), but Windows should not require setup.
	`processExp('dirname',1)`

	Save a log of the processing: Add another 1 after the automatic input. The log will be saved as 'output_log.txt'.
	`processExp('dirname',1,1)` or `processExp('dirname',[],1)`


- Channel alignment (for fluorescence)

	Documentation in progress.
