# Running Omnipose directly from MATLAB for Windows

Omnipose can be run directly from Supersegger-Omnipose in MATLAB, streamlining the process. In fact, the code has already been written into Supersegger-Omnipose (in BatchSuperSeggerOpti.m), but is disabled by default. However, the process to set up and troubleshoot access permissions (which can change with software updates) may not be worth the effort. The following are suggestions for Windows, with numerous existing errors.

The main difficulty is the issue of starting python and activating the conda environment through the MATLAB Command Window's permissions. 

### Instructions
1. Add conda to command line PATH (or Start>System Variables>Env. Variables>Path): 
``` 
set PATH=%PATH%;C:\Users\Name\miniconda3\envs\cellpose;C:Users\Name\miniconda3\condabin 
```

2. Open Powershell, type >conda init, and close 

3. Tips to enable MATLAB to run python on Windows (not sure which are necessary)
   - Enter ` pyversion C:\Users\Name\miniconda3\envs\cellpose\python.exe ` 
   - In Windows System Environment Variables:
	* User path, add C:\User\Name\miniconda3\envs\cellpose and C:\User\Name\cellpose (the actual cellpose git folder)
	* Also add to System Variables (created variable named PYTHONPATH and added C:\Users\Name\miniconda3\envs\cellpose;C:\Users\Name\cellpose) [not sure if this step is needed, if user has admin priv]
	* Also added miniconda3\condabin but not sure if it is used
   - In command line, update numpy (can check current version with ` pip list `). Navigated to miniconda\envs\cellpose, conda activate cellpose, then did ` pip install numpy --upgrade `
   - One possible check is to try in MATLAB Command window: ` py.help(‘numpy’) `

4. To run, top MATLAB path must be in C:\Users\Name\miniconda3\envs\cellpose (not sure why)
   - I have written a check in Supersegger-Omnipose to see if the path is the one above. If so (with python working and the conda environment is activated), Supersegger-Omnipose can automatically start segmentation with no manual input needed (ie no need to open up a terminal separately and paste in the command for Omnipose).












