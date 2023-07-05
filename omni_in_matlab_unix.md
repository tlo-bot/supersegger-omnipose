# Running Omnipose directly from MATLAB for Linux (verified) & MacOS

Omnipose can be run directly from Supersegger-Omnipose in MATLAB, streamlining the process. The code has already been written into Supersegger-Omnipose (in BatchSuperSeggerOpti.m), and has been tested to work with Linux. The following is a guide to help set up to be able to use Conda from MATLAB.

The main difficulty is the issue of starting python and activating the conda omnipose environment through the MATLAB Command Window's permissions, which may be related to root permissions.

Some combination of the following instructions should work...
Further documentation can be found on the [conda github](https://github.com/conda/conda/issues/7980).

### Instructions
1. Check that conda and activate are available to MATLAB ie included in the MATLAB path. In the MATLAB Command Window, try:
```
getenv('PATH')
```
If you see the bin and condabin directories in the path of the form `/.../anaconda3/bin:/.../anaconda3/condabin` or `\...\miniconda3\condabin:\...\miniconda3\bin\`, continue to step 2. Else, add these to the MATLAB environment:
```
setenv(‘PATH’, [getenv(‘PATH’) ‘:/<...>/miniconda3/condabin’]);
setenv(‘PATH’, [getenv(‘PATH’) ‘:/<...>/miniconda3/bin’]);
```
where <...> should be replaced with the proper path to your conda installations. (possible locations `\Users\[name]\` or `/local/[name]/`)

Tip: the path to the local conda installation should be able to be located with the following command in Terminal
```
conda info | grep -i 'base environment'
```

2. In the MATLAB Command Window, initialize the MATLAB bash shell with the local conda installation: 
``` 
system('conda init bash')
```
or for macOS 10.15+:
```
system('conda init zsh')
```

<!---
May be instead:
```
system('conda init')
```
-->

3. Check that the proper location for conda has been added to your .bashrc/.zshrc file. Should appear similar to:

```
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/local/<rootuser>/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/local/<rootuser>/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/local/<rootuser>/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/local/<rootuser>/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
```


4. In MATLAB Command Window, restart the MATLAB shell:
```
system('source ~/.bashrc')
```
or for macOS 10.15+:
```
system('source ~/.zshrc')
```


5. If conda is now accessible (and Omnipose has already been installed to the system), the following MATLAB command should return a status of 0:
```
[status,~] = system('source activate omnipose')
```












