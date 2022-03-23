This repo is intended for personal use and reference, it is not actively maintained or supported.

Feel free to refer to it and make use of the code within.

Each directory within `kvm` are intended to be a separate KVM VM that reaches out to a Jenkins server that will run Ansible plays to configure them. Additionally some of the Terraform configurations pull custom scripts to handle things like Arch Linux installation from an install ISO.

The Terraform configs within this repo make calls to a server with webcontent that is supplied by the below repo.

https://github.com/mesoterra/general_scripts
