# <p> <b>SuperSegger 2</b> </p>

![Phase image, old SuperSegger segmentation, new SuperSegger 2 segmentation.](/assets/githubfig2.png)


SuperSegger 2 is the SuperSegger MATLAB-based suite modified to work with improved Omnipose segmentation and improved bactrack cell tracking. Bactrack should be installed before running SuperSegger 2.

Information about Omnipose can be found at the [Omnipose Github](https://github.com/kevinjohncutler/omnipose/) and [documentation page](https://omnipose.readthedocs.io/).

Information about bactrack can be found at the [bactrack Github](https://github.com/yyang35/bactrack/tree/main/bactrack/).


---
### Software Requirements

SuperSegger 2 uses the same MATLAB toolboxes as the original SuperSegger:

- Curve Fitting Toolbox
- Deep Learning Toolbox (fka Neural Network Toolbox)
- Global Optimization Toolbox
- Image Processing Toolbox
- Optimization Toolbox
- Parallel Computing Toolbox (not necessary)
- Statistics and Machine Learning Toolbox


---
### Software Documentation

#### SuperSegger 2
The Github for the original SuperSegger is [here](https://github.com/wiggins-lab/SuperSegger). For more detailed documentation, the website for Supersegger can be found [here](http://mtshasta.phys.washington.edu/website/tutorials.php), the [wiki](https://github.com/wiggins-lab/SuperSegger/wiki), and documentation on functions found [here](http://mtshasta.phys.washington.edu/website/superSegger/). SuperSegger 2 uses the same MATLAB functions as the original SuperSegger.

[Quick-start guide for new users](../main/docs/quick_start_guide.md) \ [Original SuperSegger guide to segmentation](https://github.com/wiggins-lab/SuperSegger/wiki/Segmenting-with-SuperSegger) \ [Viewing the results](https://github.com/wiggins-lab/SuperSegger/wiki/Visualization-and-post-processing-tools) \ [The clist](https://github.com/wiggins-lab/SuperSegger/wiki/The-clist-data-file) 

#### Omnipose
[Omnipose](https://omnipose.readthedocs.io/) options have been preselected to work directly with Supersegger 2, but if needed, further documentation can be found by running `python -m omnipose --help` in the omnipose environment. Recommended options can also be found on the [documentation page](https://omnipose.readthedocs.io/command.html). 

#### bactrack
[bactrack](https://github.com/yyang35/bactrack/tree/main/bactrack/) is a cell tracking tool which uses hierarchical segmentation and mixed-integer programming optimization to determine cell lineages in timelapses. While bactrack supports HiGHS, CBC, or Gurobi solvers, SuperSegger 2 only supports HiGHS and Gurobi. In addition, SuperSegger 2 configures bactrack to run tracking on the masks generated by Omnipose.

> ##### Segmentation Options: When running the Omnipose command in conda, the following default Omnipose options can be modified depending on the desired usage: "--cluster --mask_threshold 1 --flow_threshold 0 --diameter 30". 
> 
> --cluster: DBscan clustering, reduces oversegmentation of thin features [can remove option]
> 
> --mask_threshold: mask threshold [0 default, decrease to find more and larger masks]
> 
> --flow_threshold: flow error threshold [0.4 default, 0 to turn off]
> 
> --diameter: approximate diameter of cell in pixels (for rod-shape, this is the length of the short axis) [30 default, 0 to have omnipose estimate for each image]
> 
> Mask and flow threshold numbers can be tested quickly with the [Omnipose GUI](https://omnipose.readthedocs.io/gui.html) (`python -m omnipose`). In addition, other Omnipose options can be added to possibly improve segmentation. 
> 
> ##### Training Models: Other models can be used as well instead of the default "bact_phase_omni".
> 
> ##### Note that the options before "--omni" should not be changed when working with SuperSegger 2.


---
### Installation Instructions

1. Install [MATLAB](https://www.mathworks.com/help/install/install-products.html) and [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).
2. Cd to desired folder and clone Supersegger 2 with git
```
git clone https://github.com/tlo-bot/supersegger-omnipose.git
```
3. Add SuperSegger 2 to MATLAB path, with its subfolders (see "Setting the Path").
4. Install bactrack:
   - Find step-by-step instructions [here](../main/docs/install_bactrack.md). 
   - Omnipose is installed as a bactrack dependency.
   - Further advanced installation instructions for Omnipose can be found [here](https://pypi.org/project/omnipose/).
   - GPU usage for Omnipose is discussed [here](https://omnipose.readthedocs.io/installation.html#gpu-support). The Supersegger 2 command defaults to using CPU only.

---
### Setting the Path

In order for Matlab to be able to find SuperSegger 2, the SuperSegger 2 folder needs to be in your path*. In the Home tab, in the Environment section, click Set Path. The Set Path dialog box appears. Click 'add folder with subfolders' and add the SuperSegger 2 folder. 

>*note that if the original SuperSegger is already installed and on the MATLAB path, you should replace the paths of the original SuperSegger folders & subfolders with the paths to the new SuperSegger 2 folders & subfolders.


---
### Running Supersegger 2 (GUI)

1. Put images (.tif) into a folder.
2. Convert image file names to Supersegger convention (in MATLAB with `superSeggerGui`, or `convertImageNames`; or manually with command line).
3. Run `superSeggerGui`, or configure and run `processExp`. Supersegger 2 will begin aligning the images.
   - After aligning, SuperSegger 2 will pause for segmentation through Omnipose. The Omnipose command should be displayed on the MATLAB Command Window and also automatically copied to your clipboard.
4. Open terminal/Anaconda Prompt and activate the bactrack environment (ie `conda activate bactrack`)
   - Note that you should see the conda environment change from "(base)" to "(bactrack)"
5. Paste in the Omnipose command that was generated by MATLAB into the terminal. Wait for Omnipose to segment images and generate masks.
   -Can also change the command options in this step, if needed.
6. Once Omnipose has completed, continue running Supersegger by pressing the return/Enter key in the MATLAB Command Window.
7. At the cell tracking step, SuperSegger 2 will pause again to run bactrack. In terminal/Anaconda prompt with the bactrack conda environment activated, paste in the bactrack command generated by MATLAB. The bactrack script function will generate the links file. 
8.  Once bactrack has completed, continue running Supersegger by pressing the return/Enter key in the MATLAB Command Window.


---
### Running Supersegger2, Omnipose, and bactrack directly from MATLAB - Recommended!


Only supported when using `processExp`. Specify autobt=1 input for processExp (ie `processExp('dirname',1)`). Disabled by default.
See documentation for setup linked below.



---
### Troubleshooting & Known Issues

- [Segmentation options](../main/docs/segmentation_options.md)
- [Omnipose installation instructions (Windows, Linux & MacOS)](../main/docs/install_omnipose.md)
- [Possible Supersegger 2 errors](../main/docs/so_errors.md)
- [Running Omnipose directly from MATLAB for Windows (verified)](../main/docs/omni_in_matlab_windows.md)
- [Running Omnipose directly from MATLAB for Linux (verified) & MacOS](../main/docs/omni_in_matlab_unix.md)












