(Research project)

# OSX Docker KVM
Run an OSX KVM virtual machine inside a Docker container.

This project permits to run an OSX virtual machine (KVM) inside a Docker container.

# Run the Image

To execute the container, you need a working `mac_hdd-backing.img`. You can obtain one with [OSX-KVM project](https://github.com/kholia/OSX-KVM). After that, you can mount the backing storage with the Docker command line and pass the KVM device.

    docker --device /dev/kvm:/dev/kvm -v $PWD/backing:/backing -p 2222:2222 -p 5900:5900 -p 5800:5800 run sxkdvm

To persist the change add export the snapshot storage somewhere with `-v $PWD/snapshot:/snapshot`.

# Exposed Ports

This VM exposes an ssh connection at `2222` and a VNC server at `5900,5800` ports.

It is possible to access the VM with:

    ssh appleuser@localhost -p 2222

# Performance Considerations

The environment uses automatic [copy-on-write]() images to provide seamless integration with [Docker layered file system](). The mechanism mentioned above permits to obtain acceptable performance when running multiple VMs without hogging the storage.

Furthermore, this container uses hardware virtualization technologies, like VT-X or AMD-V, to achieve almost native performance.