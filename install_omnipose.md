# Step-by-step Omnipose installation instructions (command line based, assumes cellpose is not already installed)

## Note: this page is a work in progress and intended as a general guide. Feel free to open an issue if there are errors in the installation process

## Note: Omnipose has been updated. If Omnipose was previously installed as Cellpose, feel free to remove the pre-existing installation `conda env remove -n cellpose`

### Windows

1. Install miniconda (https://docs.conda.io/en/latest/miniconda.html)

   Warning: If added to PATH, can run miniconda directly from Command Window, but could cause interferences. If not added to PATH, need to use the separate Anaconda Prompt to run.

2. Install git (https://git-scm.com/download/win)

3. In Command Window, create & navigate to desired folder (ie C:\Users\Name\omnipose\).

4. In Command Window/Anaconda Prompt, create "omnipose" environment, install Python to the environment, activate environment, and install Omnipose.
```
conda env create -n omnipose python
conda activate omnipose
pip install git+https://github.com/kevinjohncutler/omnipose.git
```

   Note: activate the omnipose environment each time you want to use omnipose.

5. For updating:
```
git -C C:\Users\Name\omnipose\ pull origin master
```

### Linux (Debian/Ubuntu)

1. Install Anaconda (https://www.anaconda.com/products/distribution) or Miniconda (recommended)
```
sudo apt-get update
sudo apt-get install curl
sudo apt-get install wget
sudo apt install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6
```

   Tested: Anaconda3-2021.05-Linux-x86_64
```
(sudo) wget https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh 
bash Anaconda3-2021.05-Linux-x86_64.sh 
rm -rf Anaconda3-2021.05-Linux-x86_64.sh 
```

   Latest Anaconda: (as of June 2022; find the full availability here https://repo.anaconda.com/archive/)
```
(sudo) wget https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh
bash Anaconda3-2022.05-Linux-x86_64.sh
rm -rf Anaconda3-2022.05-Linux-x86_64.sh
```

   Latest miniconda:
```
(sudo) wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
rm -rf bash Miniconda3-latest-Linux-x86_64.sh
```

_"Do you accept the license terms?" >yes_

2. Restart shell:
```
source ~/.bashrc
```

   Optional: to prevent base environment from loading automatically, run:
```
conda config --set auto_activate_base false
```
   and restart shell.

3.  Install git (https://git-scm.com/download/linux): 
```
sudo apt-get install git
```

4. In Command Window, create & navigate to desired folder (ie ~/omnipose).

5. In Command Window, create "omnipose" environment, install Python to the environment, activate environment, and install Omnipose.
```
conda env create -n omnipose python
conda activate omnipose
pip install git+https://github.com/kevinjohncutler/omnipose.git
```

   Note: activate the omnipose environment each time you want to use omnipose with `conda activate omnipose`.

6. For updating: 
```
git -C ~/omnipose pull origin master
```




### MacOS (not yet tested, assumes homebrew is installed)

1. Install Anaconda (https://www.anaconda.com/products/distribution)
```
brew install curl
brew install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6
brew install wget
```

   Latest miniconda*:
```
(sudo) wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
bash Miniconda3-latest-MacOSX-x86_64.sh
```
_*Could also install Anaconda (not recommended): https://repo.anaconda.com/archive/_

2. Restart shell:
```
source ~/.bashrc
```

   Optional: to prevent base environment from loading automatically, run:
```
conda config --set auto_activate_base false
```
   and restart shell.

3.  Install git (https://git-scm.com/download/mac): 
```
brew install git
```

4. In Command Window, create & navigate to desired folder (ie ~/omnipose).

5. In Command Window, create "omnipose" environment, install Python to the environment, activate environment, and install Omnipose.
```
conda env create -n omnipose python
conda activate omnipose
pip install git+https://github.com/kevinjohncutler/omnipose.git
```

   Note: activate the omnipose environment each time you want to use omnipose with `conda activate omnipose`. 

6. For updating: 
```
git -C ~/cellpose pull origin master
```











