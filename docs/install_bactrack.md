# Step-by-step Omnipose & bactrack installation instructions (command line based)
 
 Updated: May 3, 2024.

 [Windows](../../tree/bactrackdev/docs/install_bactrack.md#windows) \ [Linux](../../tree/bactrackdev/docs/install_bactrack.md#linux-debianubuntu) \ [MacOS](../../tree/bactrackdev/docs/install_bactrack.md#macos)

 Note: this page is intended as a general guide. Feel free to open an issue if there are errors in the installation process

 Update notes: Omnipose is installed as a bactrack dependency. If you previously installed Omnipose and wish to remove the independent installation, please run `pip uninstall omnipose && pip cache remove omnipose` to prevent version conflicts. Feel free to remove the pre-existing installation `conda env remove -n omnipose` and delete the Omnipose folder.

## Windows

1. Install git (https://git-scm.com/download/win)

> Note: recommended to add to PATH (ie select 'Use Git from Windows Command Prompt' option, not the 'Use Git from Git Bash only' option)

2. Install miniconda (https://docs.conda.io/en/latest/miniconda.html)

> Warning: Adding to PATH is optional. If added to PATH, can run miniconda directly from Command Line, but may cause interferences with other programs in Command Line. If not added to PATH, need to use the separately installed Anaconda Prompt to run Omnipose and bactrack. To manually add conda to PATH, try adding `C:\Users\Name\miniconda3\condabin;` to Path in Environment Variables. May be instead `C:\Users\Name\miniconda3\Scripts;` 

3. In Command Window/Anaconda Prompt, change the current working directory to the location where you want bactrack to be installed with `cd` before cloning the repository. (ex, `cd Documents`)

```
git clone https://github.com/yyang35/bactrack.git

```

4. Change directory to the bactrack directory, install packages, activate environment, and install bactrack.

```
cd bactrack
conda env create -f environment.yaml
conda activate bactrack
pip install .
```

> Note: for Windows 10, found compatibility issue with some versions of Python (v3.10.5, 3.11+). 3.8.5 recommended but other versions may work as well.
> For Windows 11, found compatibility issues with Python 3.11+; confirmed Omnipose compatibility with Python 3.10.12 and bactrack compatibility for 3.10. If there are issues installing, specify python=3.10 in the environment.yaml file.


> Note: activate the bactrack environment each time you want to use bactrack or Omnipose with `conda activate bactrack`.

5. For updating, change directory to the bactrack directory with `cd`. (Tip: The directory should contain the 'setup.py' file.) Then repeat the above install command after activating bactrack environment:

```
pip install .
```

6. Gurobi setup: activate the bactrack environment and install Gurobi via conda according to the (instructions from the bactrack repo)[https://github.com/yyang35/bactrack?tab=readme-ov-file#gurobi-setup], then activate the license.


## Linux (Debian/Ubuntu)

1.  Install [git](https://git-scm.com/download/linux): 
```
sudo apt-get install git
```

2. Install [Miniconda](https://docs.conda.io/en/main/miniconda.html):
```
sudo apt-get update
```

```
sudo apt-get install curl
```

```
sudo apt-get install wget
```

```
sudo apt install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6
```

```
sudo apt install libxcb-xinerama0
```


   Latest Miniconda*:
```
(sudo) wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
rm -rf bash Miniconda3-latest-Linux-x86_64.sh
```

>*Could also install [Anaconda](https://www.anaconda.com/products/distributionhttps://www.anaconda.com/products/distribution) (not recommended): https://repo.anaconda.com/archive/


3. Restart shell:
```
source ~/.bashrc
```

   Optional: to prevent base environment from loading automatically, run:
```
conda config --set auto_activate_base false
```
   and restart shell.


4. In Command Window, create environment named 'omnipose', install Python to the environment, activate environment, and install Omnipose.
```
conda create -n omnipose 'python==3.10.12' pytorch
```

```
conda activate omnipose
```
Change directory to the location where you want Omnipose to be installed with `cd` before cloning the repository.

```
git clone https://github.com/kevinjohncutler/omnipose.git

```
```
cd omnipose
pip install -e .
```

>   Note: if you previously installed Omnipose, please run `pip uninstall cellpose_omni && pip cache remove cellpose_omni` to prevent version conflicts.

>   Note: for the latest stable release of Omnipose, use instead: `pip install omnipose`

>   Note: activate the omnipose environment each time you want to use omnipose with `conda activate omnipose`.

5. For updating, change directory to the omnipose directory with `cd`. The directory should contain the 'setup.py' file. Then repeat the above install command after activating omnipose environment:
```
pip install -e .
```



## MacOS 

(assumes homebrew is installed)

1.  Install [git](https://git-scm.com/download/mac): 
```
brew install git
```

2. Install [Miniconda](https://docs.conda.io/en/main/miniconda.html):
```
brew install curl
```

```
brew install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6
```

```
brew install wget
```

   Latest miniconda*:
```
(sudo) wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
bash Miniconda3-latest-MacOSX-x86_64.sh
rm -rf bash Miniconda3-latest-MacOSX-x86_64.sh
```
>*Could also install [Anaconda](https://www.anaconda.com/products/distributionhttps://www.anaconda.com/products/distribution) (not recommended): https://repo.anaconda.com/archive/

3. Restart shell:
```
source ~/.bashrc
```
   or for macOS 10.15+:
```
source ~/.zshrc
```

   Optional: to prevent base environment from loading automatically, run:
```
conda config --set auto_activate_base false
```
   and restart shell.

4. In Command Window, create environment named "omnipose", install Python to the environment, activate environment, and install Omnipose.
```
conda create -n omnipose 'python==3.10.12' pytorch
```

```
conda activate omnipose
```

Change directory to the location where you want Omnipose to be installed with `cd` before cloning the repository.
```
git clone https://github.com/kevinjohncutler/omnipose.git
```
```
cd omnipose
pip install -e .
```
>   Note: if you previously installed Omnipose, please run `pip uninstall cellpose_omni && pip cache remove cellpose_omni` to prevent version conflicts.

>   Note: for the latest stable release of Omnipose, use instead: `pip install omnipose`

>   Note: activate the omnipose environment each time you want to use omnipose with `conda activate omnipose`. 

5. For updating, change directory to the omnipose directory with `cd`. The directory should contain the 'setup.py' file. Then repeat the above install command after activating omnipose environment:
```
pip install -e .
```












