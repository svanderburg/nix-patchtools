nix-patchtools
==============
The [Nix package manager](http://nixos/nix) is a powerful package manager
supporting a number of unique advantages over conventional solutions, such as
automatic deployment from declarative specifications, dependency completeness,
atomic upgrades and rollbacks.

Although many packages can be convienently packaged in source form, prebuilt
binary packages are typically much harder to deploy -- when running them
unmodified on [NixOS](http://nixos.org), their dependencies cannot be found,
because they reside in global locations such as `/bin` and `/lib` which Nix
does not use. Instead, Nix stores the content of each packages in isolated
directories in the Nix store (`/nix/store`).

There are variety of solutions to patch binary packages to make them work
in the Nix store (most notably [PatchELF](http://github.com/nixos/patchelf)
but using them requires a substantial amount of investigation and
trial-and-error runs.

This package provides a toolset that can be used to *automatically* patch
prebuilt binary packages as much as possible so that they can find their
dependencies in isolated directories in the Nix store. As a result, they can be
conveniently deployed by the Nix package manager with little to no manual
adjustments.

Available tools
===============
This package provides a number of tools.

autopatchelf
------------
* Auto patches ELF binaries by checking for their required libraries and
  searching the contents of a provided list of packages.
* Detects `x86` and `x86_64` executables and prevents binaries of different
  architectures to conflict.

Installation
============
Clone the Git repository, then run the following command to install the
program in your Nix profile:

```bash
$ nix-env -f default.nix -iA build
```

Usage
=====

autopatchelf
------------
Idea: specify the search library paths in an environment variable
and run `autopatchelf` to automatically bind to the package that
provides the library.

### Specifying the library search locations

You can specify the search library paths by setting the `libs`
variable in the shell session or in a Nix expression:

```nix
libs = stdenv.lib.makeLibraryPath [ pkgs.zlib pkgs.openssl ];
```

You can also specify the search libraries per CPU architecture. `autopatchelf`
ignores the search paths for an architecture that does not match the
architecture of an ELF executable:

```nix
libs_i386 = [ pkgs_i686.zlib pkgs_i686.openssl ]; 
libs_x86_64 = [ pkgs_x86_64.zlib pkgs_x86_64.openssl ];
```

This is particular convenient for packages that have a mix of `i386` and
`x86_64` binaries.

### Patching an individual executable

The following command auto patches a single executable:

```bash
$ autopatchelf ./myexecutable
```

### Recursively patching all executables in a directory

When the parameter is a directory, `autopatchelf` attempts to recursively patch
all executables in the directory.

```bash
$ autopatchelf ./bin
```

### Patching all executables in a directory non-recursively

It is also possible to not recurse in any sub folders by providing the
`--no-recurse` parameter:

```bash
$ autopatchelf --no-recurse ./bin
```

### Specifying the search path variable name

By default, `autopatchelf` uses the `libs` search environment variables. The
name of the search path environment variable can be adjusted with the
`--variable` parameter:

```bash
$ autopatchelf --variable LD_LIBRARY_PATH ./myexecutable
```

The above command uses the `LD_LIBRARY_PATH` environment variable to search
for packages.

Examples
========
The `examples/` sub folder contains a number of example use cases:
* `kzipmix.nix` deploys kzip and kzipmix executables for `i686-linux` and `x86_64-linux`.
* `cpio-dpkg.nix` deploys GNU cpio by patching a Debian package.
* `quake4-demo.nix` deploys a demo version of the Quake 4 computer game.

License
=======
The contents of this package is available under the same license as Nixpkgs --
the [MIT](https://opensource.org/licenses/MIT) license.

