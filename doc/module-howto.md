Module How To
=============
The Community Cube package is including a list of modules. Each **module** is supposed to get a sub-system working on
a target Community Cube system. The **module** is responsible to install corresponding tools and setup all the
configuration for the sub-system. *(TODO: the old auto-scripts will be put into modules)*

The installation of modules is in a strict ordered defined in `modules/list`. It's important to keep modules in order.

A `module` must define a entry script called `install`, which is executed on installation. The the bootstrap, it's
executed by the builder. On other systems, e.g. your own Debian machine, it's supposed to be executed by the
Community Cube Installer *(TODO: the installer is not existed yet)*.

*TODO: description about log messages..*
*TODO: description about error messages...*
