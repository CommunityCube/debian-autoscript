# bootstrap

The bootstrap is intend to build a base system and a image ready for `qemu`. After a successful bootstrap build
you should be able to try the system like this:

```shell
$ qemu bootstrap/image
```

To build the bootstrap system, simply run the `bootstrap/build` like this:

```shell
$ bootstrap/build
```

Note that the `bootstrap/build` is running as a **non-root** user. The `bootstrap/build` will do everything needed
to build the system from scratch. This system will be a good start to install Community Cube package. It could be
developed into a system image for Odroid *(will need to combine with the official Odroid instructions)*.

How does it work
================
The Community Cube installation is basically installing a bundle of predefined packages. Packages are installed and
setup by a **module**. A **module** is responsible to make a sub-system working in a Community Cube system. A
sub-system is something like *networking*, etc. To work with a **module**, please checkout the [module howto](module-howto.md).
