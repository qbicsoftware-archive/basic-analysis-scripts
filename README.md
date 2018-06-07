# Basic Analysis Scripts

## How to clone this repo correctly

This repository contains submodules, which point to different GitHub repositories themselves. If you do a normal `git clone <repo>`, the submodules folders will be there, but empty.

### Clone and activate submodules

If you have already cloned it, just `init` submodules afterwards:

```bash
$ git clone https://github.com/qbicsoftware/basic-analysis-script
$ git submodule init
$ git submodule update
```

or as 1-liner right from the first clone command:

```bash
$ git clone --recurse-submodules 
```

### Add a new submodule

If you want to add a new repository as additional submodule, just do:

```bash
$ git submodule add <new repo url>
```
