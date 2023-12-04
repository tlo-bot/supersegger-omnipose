# Step-by-step Omnipose installation instructions (command line based, assumes cellpose is not already installed)
 
 Updated: Dec 4, 2023.

 [Windows](https://github.com/tlo-bot/supersegger-omnipose/blob/main/docs/install_omnipose.md#windows) \ [Linux](https://github.com/tlo-bot/supersegger-omnipose/blob/main/docs/install_omnipose.md#linux-debianubuntu) \ [MacOS](https://github.com/tlo-bot/supersegger-omnipose/blob/main/docs/install_omnipose.md#macos)

 Note: this page is a work in progress and intended as a general guide. Feel free to open an issue if there are errors in the installation process

 Update notes: Omnipose has been updated. If you previously installed Omnipose, please run `pip uninstall cellpose_omni && pip cache remove cellpose_omni` to prevent version conflicts. If Omnipose was previously installed as Cellpose, feel free to remove the pre-existing installation `conda env remove -n cellpose` and delete the cellpose folder

## Windows

1. Install git (https://git-scm.com/download/win)

> Note: recommended to add to PATH (ie select 'Use Git from Windows Command Prompt' option, not the 'Use Git from Git Bash only' option)

2. Install miniconda (https://docs.conda.io/en/latest/miniconda.html)

> Warning: Adding to PATH is optional. If added to PATH, can run miniconda directly from Command Line, but may cause interferences with other programs in Command Line. If not added to PATH, need to use the separately installed Anaconda Prompt to run Omnipose. To manually add conda to PATH, try adding `C:\Users\Name\miniconda3\condabin;` to Path in Environment Variables. May be instead `C:\Users\Name\miniconda3\Scripts;` 

3. In Command Window/Anaconda Prompt, create "omnipose" environment, install Python to the environment, activate environment, and install Omnipose.

> Note: for Windows 10, found compatibility issue with some versions of Python (v3.10.5, 3.11+). 3.8.5 recommended but other versions may work as well.
> For Windows 11, confirmed compatibility with Python 3.10.12.

```
conda create -n omnipose 'python==3.10.12' pytorch
```

```
conda activate omnipose
```

```
git clone https://github.com/kevinjohncutler/omnipose.git
cd omnipose
pip install -e .
```

> Note: if you previously installed Omnipose, please run `pip uninstall cellpose_omni && pip cache remove cellpose_omni` to prevent version conflicts.

> Note: for the latest stable release of Omnipose from PyPi, use instead: `pip install omnipose` 

> Note: activate the omnipose environment each time you want to use omnipose with `conda activate omnipose`.

4. For updating, repeat the above install command after activating omnipose environment:
```
cd omnipose
pip install -e .
```



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

```
git clone https://github.com/kevinjohncutler/omnipose.git
cd omnipose
pip install -e .
```

>   Note: if you previously installed Omnipose, please run `pip uninstall cellpose_omni && pip cache remove cellpose_omni` to prevent version conflicts.

>   Note: for the latest stable release of Omnipose, use instead: `pip install omnipose`

>   Note: activate the omnipose environment each time you want to use omnipose with `conda activate omnipose`.

5. For updating, repeat the above install command after activating omnipose environment:
```
cd omnipose
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

```
git clone https://github.com/kevinjohncutler/omnipose.git
cd omnipose
pip install -e .
```
>   Note: if you previously installed Omnipose, please run `pip uninstall cellpose_omni && pip cache remove cellpose_omni` to prevent version conflicts.

>   Note: for the latest stable release of Omnipose, use instead: `pip install omnipose`

>   Note: activate the omnipose environment each time you want to use omnipose with `conda activate omnipose`. 

5. For updating, repeat the above install command after activating omnipose environment:
```
cd omnipose
pip install -e .
```












