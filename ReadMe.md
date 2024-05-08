# How to install ggCaller with the MAGs-querie function ❓
### You can install ggCaller from Source

> This Mini-Tutorial will guide you through the installation process, from setting up your environment to verifying the successful installation.


You first need to set up your environment with the required packages, which are listed in either [environment_linux.yml](https://github.com/bacpop/ggCaller/blob/master/environment_linux.yml) or [environment_macOS.yml](https://github.com/bacpop/ggCaller/blob/master/environment_macOS.yml) based on your OS. You'll also need a C++17 compiler, such as gcc version 7.3 or higher. After setting up the environment using Conda, clone the ggCaller repository and install it with Python setup tools. 

## Prerequisites

Before you begin, make sure your system meets the following requirements:

- [x] **Operating System**: Linux (recommended) or macOS.
- [x] **Compiler**: GCC (GNU Compiler Collection) version 4.8 or higher.
- [x] **CMake**: Version 3.1.0 or later.
- [x] **Git**: Version 2.0 or later.
- [x] **Python**: Version 3.6 or later.
- [x] **Pip**: Python package installer.
- [x] **Basic familiarity** with the command line interface.

## Overview

1. **Clone the ggCaller repository** with a recursive flag to include submodules.
2. **Create and activate a Conda environment** using the provided YAML file.
3. **Install ggCaller** using Python setup.

## Step-by-Step Guide

### Step 1: Clone ggCaller Repository

1. Open a terminal.
2. Execute the command below to clone the ggCaller repository with the function from [GitHub](https://github.com/Lalemaouloud/ggCaller/tree/master):

```bash
git clone --recursive https://github.com/Lalemaouloud/ggCaller && cd ggCaller
```

## To download the original ggCaller without any modification :
```bash
git clone --recursive https://github.com/samhorsfield96/ggCaller && cd ggCaller
```

### Step 2: Create and Activate a Conda Environment

1. To create a new environment and install the necessary dependencies, execute:

For Linux users:

```bash
conda env create -f environment_linux.yml
```

For macOS users:

```bash
conda env create -f environment_macOS.yml
```

2. Activate the newly created Conda environment:

```bash
conda activate ggc_env
```
### Note: There might be some issues with the version of Bifrost. Make sure you have Bifrost version 1.2.0. Otherwise, you can execute this command:

```bash
conda install --force-reinstall bifrost=1.2.0

```
### Step 3: Install ggCaller

1. With the environment set up and activated, you can now install ggCaller. Run the setup script by executing:

```bash
python setup.py install
```

### Step 4: Verify Installation

To ensure ggCaller is correctly installed:

1. Open a new terminal window.
2. Check the installation by running:

```bash
ggcaller --version
```

If you wish to view the ggCaller help message and confirm it's ready for use, type:

```bash
ggcaller -h
```

You should see the ggCaller help message, indicating a successful installation.

Congratulations! You've successfully installed ggCaller from source. You're now ready to use this powerful tool for your genomic analysis needs✨
