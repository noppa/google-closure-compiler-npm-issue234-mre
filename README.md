# MRE for Google Closure Compiler issue 234

This repository contains two Dockerfiles which are nearly identical.
They both install Node v16 and [google-closure-compiler](https://github.com/google/closure-compiler-npm). The difference is that
one of them uses Ubuntu as its base image, the other uses Arch Linux.

This works as a minimal, reproducible example for [issue 234](https://github.com/google/closure-compiler-npm/issues/234) of closure-compiler-npm ("google-closure-compiler-linux throwing Java exceptions."), because the error occurs when using the Arch Linux container but not when using the Ubuntu container.


## Usage

Build and run the Ubuntu image (which works without an issue)

```sh
./test.sh ubuntu
```

Build and run the Arch image (which will produce an error)

```sh
./test.sh arch
```
