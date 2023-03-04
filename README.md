# Main

[![build-ublue](https://github.com/ublue-os/main/actions/workflows/build.yml/badge.svg)](https://github.com/ublue-os/main/actions/workflows/build.yml)

A WIP common main image for all other Ublue images.

## What is this?

These are Fedora images that have been modified with the following quality of life features: 

## Features

- Start with a Fedora image
- Adds the following packages to the base image:
  - Hardware acceleration and codecs
  - `distrobox` for terminal CLI
  - A selection of [udev rules and service units](https://github.com/ublue-os/config)
  - Various other tools: check out the [complete list of packages](packages.json)
- Sets automatic staging of updates for the system
- Sets flatpaks to update twice a day
- Everything else (desktop, artwork, etc) remains stock so you can use this as a good starting image

## How to use these:

Note: If you have an Nvidia GPU use [the ublue-os/nvidia images instead](https://github.com/ublue-os/nvidia)

To rebase an existing Silverblue/Kinoite machine to the latest release (37): 
1. Download and install [Fedora Silverblue](https://silverblue.fedoraproject.org/download)
1. After you reboot you should [pin the working deployment](https://docs.fedoraproject.org/en-US/fedora-silverblue/faq/#_about_using_silverblue) so you can safely rollback 
1. Open a terminal and use one of the following commands to rebase the OS:

#### Silverblue (GNOME):

    sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/silverblue-main:37

#### Kinoite (KDE)

    sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/kinoite-main:37
    
#### Sericea (Sway) 
Fedora 38-only, recommended only for advanced users

    sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/sericea-main:38

#### Vauxite (XFCE) 
    
    sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/vauxite-main:37

#### Base

Which does not come with any desktops or window managers:

    sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/base-main:37

## Architecture

This image can be used as an end user desktop or as something to derive from.
If you're interested in [making your own](https://ublue.it/making-your-own/):

Graph of the [uBlue architecture](https://ublue.it/architecture/):

![](https://ublue.it/ublue-architecture-graph.png)

### Adding Applications

Edit the `packages.json` file with your preferred applications.
Flatpak installation is a WIP.

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/ublue-os/base

If you're forking this repo you should [read the docs](https://docs.github.com/en/actions/security-guides/encrypted-secrets) on keeping secrets in github. You need to [generate a new keypair](https://docs.sigstore.dev/cosign/overview/) with cosign. The public key can be in your public repo (your users need it to check the signatures), and you can paste the private key in Settings -> Secrets -> Actions.

## Making your own

See [the documentation](https://ublue.it/making-your-own/) on how use this image in your own projects.
