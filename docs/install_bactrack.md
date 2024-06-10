# Step-by-step Omnipose & bactrack installation instructions (command line based)
 
 Updated: May 3, 2024.

 [Windows](../../bactrackdev/docs/install_bactrack.md#windows) \ [Linux](../../bactrackdev/docs/install_bactrack.md#linux-debianubuntu) \ [MacOS](../../bactrackdev/docs/install_bactrack.md#macos)

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
> For Windows 11, found compatibility issues with Python 3.11+; confirmed Omnipose compatibility with Python 3.10.12 and bactrack compatibility for 3.10. If there are issues installing, specify python==3.10 in the environment.yaml file.


> Note: activate the bactrack environment each time you want to use bactrack or Omnipose with `conda activate bactrack`.

5. For updating, change directory to the bactrack directory with `cd`. (Tip: The directory should contain the 'setup.py' file.) Then repeat the above install command after activating bactrack environment:

```
pip install .
```

6. Gurobi setup: activate the bactrack environment and install Gurobi via conda according to the [instructions from the bactrack repo](https://github.com/yyang35/bactrack/blob/main/doc/AdanceSetup.md#install-gurobi-using-conda), then activate the license.


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


4. In Command Window/Anaconda Prompt, change the current working directory to the location where you want bactrack to be installed with `cd` before cloning the repository. (ex, `cd Documents`)

```
git clone https://github.com/yyang35/bactrack.git
```

5. Change directory to the bactrack directory, install packages, activate environment, and install bactrack.

```
cd bactrack
conda env create -f environment.yaml
conda activate bactrack
pip install .
```

> Note: activate the bactrack environment each time you want to use bactrack or Omnipose with `conda activate bactrack`.

6. For updating, change directory to the bactrack directory with `cd`. (Tip: The directory should contain the 'setup.py' file.) Then repeat the above install command after activating bactrack environment:

```
pip install .
```

7. Gurobi setup: activate the bactrack environment and install Gurobi via conda according to the [instructions from the bactrack repo](https://github.com/yyang35/bactrack/blob/main/doc/AdanceSetup.md#install-gurobi-using-conda), then activate the license.

> Possible other steps for Gurobi installation [(setting system environment variables)](https://support.gurobi.com/hc/en-us/articles/13443862111761-How-do-I-set-system-environment-variables-for-Gurobi):

8. Set environment variables for bactrack environment to include Gurobi and license. Create env_vars.sh file in directory where bactrack is activated (replace username):

/home/username/Documents/miniconda3/envs/bactrack/etc/conda/activate.d/

9. Paste the following into .bashrc file, where `GRB_LICENSE_FILE` is the path to the Gurobi license file and `GUROBI_HOME` is the path to the Gurobi installation (replace username): 
```
export GRB_LICENSE_FILE=/home/username/Documents/gurobi.lic 
export GUROBI_HOME="/home/username/Documents/miniconda3/pkgs/gurobi-11.0.1-py310_0/"
export PATH="${PATH}:${GUROBI_HOME}/bin"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${GUROBI_HOME}/lib"
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


4. In Command Window/Anaconda Prompt, change the current working directory to the location where you want bactrack to be installed with `cd` before cloning the repository. (ex, `cd Documents`)

```
git clone https://github.com/yyang35/bactrack.git
```

5. Change directory to the bactrack directory, install packages, activate environment, and install bactrack.

```
cd bactrack
conda env create -f environment.yaml
conda activate bactrack
pip install .
```

> Note: activate the bactrack environment each time you want to use bactrack or Omnipose with `conda activate bactrack`.

6. For updating, change directory to the bactrack directory with `cd`. (Tip: The directory should contain the 'setup.py' file.) Then repeat the above install command after activating bactrack environment:

```
pip install .
```

7. Gurobi setup: activate the bactrack environment and install Gurobi via conda according to the [instructions from the bactrack repo](https://github.com/yyang35/bactrack/blob/main/doc/AdanceSetup.md#install-gurobi-using-conda), then activate the license.













