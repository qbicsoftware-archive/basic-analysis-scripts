# Basic Analysis Scripts

## How to clone this repo correctly

This repository contains submodules, which point to different GitHub repositories themselves. If you do a normal `git clone <repo>`, the submodules folders will be there, but empty.

### Clone and activate submodules

If you have already cloned it, just `init` submodules afterwards:

```bash
$ git clone https://github.com/qbicsoftware/basic-analysis-scripts.git
$ git submodule init
$ git submodule update
```

or as 1-liner right from the first clone command:

```bash
$ git clone --recurse-submodules https://github.com/qbicsoftware/basic-analysis-scripts.git
```

### Add a new submodule

If you want to add a new repository as additional submodule, just do:

```bash
$ git submodule add <new repo url>
```

### Add changes in your submodule to this repository

Once you have made changes to your onw repository, they won't be visible here as this submodule points to a certain commit of your repository. To show the changes also in this repository, you have to run the following commands in your local repository of this project:

```bash
$ git submodule update --remote
$ git add .
$ git commit -m "Some details about the commit"
```

