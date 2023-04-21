# Main

[![build-ublue](https://github.com/ublue-os/main/actions/workflows/build.yml/badge.svg)](https://github.com/ublue-os/main/actions/workflows/build.yml)

A common main image for all other uBlue images, with minimal (but important) adjustments to Fedora.

1. [Features](#Features)
1. [Tips and Tricks](#Tips-and-Tricks)
1. [How to Install](#How-to-Install)
1. [Verification](#Verification)
1. [Configuring Automatic Updates](#Configuring-Automatic-Updates)
1. [Making your own](#Making-your-own)

## What is this?

You should be familiar with [image-based desktops](https://silverblue.fedoraproject.org/about). These are Fedora OStree images that have been modified with the following quality of life features:

## Features

- Start with a Fedora image
- Adds the following packages to the base image:
  - Hardware acceleration and codecs
  - `distrobox` for terminal CLI and user package installation
  - A selection of [udev rules and service units](https://github.com/ublue-os/config)
  - [libratbag](https://github.com/libratbag/libratbag), to configure supported mice via [piper](https://github.com/libratbag/piper)
  - Various other tools: check out the [complete list of packages](https://github.com/ublue-os/main/blob/main/packages.json)
- Sets automatic staging of updates for the system
- Sets flatpaks to update twice a day
- Everything else (desktop, artwork, etc) remains stock so you can use this as a good starting image

## Tips and Tricks

Unlike traditional Linux distributions, the base image is intended to be used "out of the box" as it is, packages are installed via Flatpak whenever possible (execpt for IDEs in some cases, more below).
Should that not be possible, you can use [distrobox](https://github.com/89luca89/distrobox) to have images of mutable distributions where you can install applications normally.
Want an application that is only available on Arch Linux *and* one that is only on Ubuntu? Well, now can have both!

Distrobox is very powerful, for example you can use to [host your entire development environment](https://github.com/89luca89/distrobox/blob/main/docs/posts/integrate_vscode_distrobox.md) completely separate from your host system. Or use it to run a [container for your virtual machines](https://github.com/89luca89/distrobox/blob/main/docs/posts/run_libvirt_in_distrobox.md).

ublue-os/base-main is also very well suited for servers, and users are expected to make full use of `podman` to host containers running "typical" server software i.e. `nginx`, `caddy` and others. 

## How to Install

1. [Download the image you want](https://github.com/ublue-os/main/releases)
1. [Follow these instructions](https://ublue.it/installation)
1. [File an issue](https://github.com/ublue-os/main/issues) if you find a problem

<details>
<summary>To switch to another Image</summary>

To rebase an existing Silverblue/Kinoite machine to the latest release (37): 

1. Download and install [Fedora Silverblue](https://silverblue.fedoraproject.org/download)
1. After you reboot you should [pin the working deployment](https://docs.fedoraproject.org/en-US/fedora-silverblue/faq/#_about_using_silverblue) so you can safely rollback
1. If you are coming from an existing system it is recommended to not have any layered packages before proceeding. See the [Fedora documentation](https://docs.fedoraproject.org/en-US/fedora-silverblue/) for more information.
1. Open a terminal and use one of the following commands to rebase the OS:

**Silverblue (GNOME):**

    sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/silverblue-main:37

**Kinoite (KDE)**

    sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/kinoite-main:37
    
**LXQt**

    sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/lxqt-main:37
    
**MATE**

    sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/mate-main:37
    
**Sericea (Sway)** 
Fedora 38-only, recommended only for advanced users

    sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/sericea-main:38

**Vauxite (XFCE)**
    
    sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/vauxite-main:37

**Base**

Which does not come with any desktops or window managers:

    sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/base-main:37
    
</details>

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/ublue-os/base

If you're forking this repo you should [read the docs](https://docs.github.com/en/actions/security-guides/encrypted-secrets) on keeping secrets in github. You need to [generate a new keypair](https://docs.sigstore.dev/cosign/overview/) with cosign. The public key can be in your public repo (your users need it to check the signatures), and you can paste the private key in Settings -> Secrets -> Actions.

## Configuring Automatic Updates

> **Warning**
> 
> Disabling automatic updates is an unsupported configuration. If you reconfigure updates, you MUST be on the latest image before opening any issues.

With that said, you can individually disable which automatic update timers [ublue-os/config](https://github.com/ublue-os/config) provides with the following commands:

* flatpak system: `sudo systemctl disable flatpak-system-update.timer`
* flatpak user: `sudo systemctl --global disable flatpak-user-update.timer`

You can also configure automatic `rpm-ostree` updates by editing `/etc/rpm-ostreed.conf` and changing "AutomaticUpdatePolicy" to "none" or "check":

```
[Daemon]
AutomaticUpdatePolicy=check
```

## Making your own

See [the documentation](https://ublue.it/making-your-own/) on how use this image in your own projects.

## [![Repography logo](https://images.repography.com/logo.svg)](https://repography.com) / Recent activity [![Time period](https://images.repography.com/35181738/ublue-os/main/recent-activity/xrA_PaNuNMQaiMXAgCjt1WHFLAbONeWxJABDiQSIMJI/sadhuTBbL8fbqM2jXKHWg-T1EsqHwZ2NlnlT6FB-e7Q_badge.svg)](https://repography.com)
[![Timeline graph](https://images.repography.com/35181738/ublue-os/main/recent-activity/xrA_PaNuNMQaiMXAgCjt1WHFLAbONeWxJABDiQSIMJI/sadhuTBbL8fbqM2jXKHWg-T1EsqHwZ2NlnlT6FB-e7Q_timeline.svg)](https://github.com/ublue-os/main/commits)
[![Issue status graph](https://images.repography.com/35181738/ublue-os/main/recent-activity/xrA_PaNuNMQaiMXAgCjt1WHFLAbONeWxJABDiQSIMJI/sadhuTBbL8fbqM2jXKHWg-T1EsqHwZ2NlnlT6FB-e7Q_issues.svg)](https://github.com/ublue-os/main/issues)
[![Pull request status graph](https://images.repography.com/35181738/ublue-os/main/recent-activity/xrA_PaNuNMQaiMXAgCjt1WHFLAbONeWxJABDiQSIMJI/sadhuTBbL8fbqM2jXKHWg-T1EsqHwZ2NlnlT6FB-e7Q_prs.svg)](https://github.com/ublue-os/main/pulls)
[![Trending topics](https://images.repography.com/35181738/ublue-os/main/recent-activity/xrA_PaNuNMQaiMXAgCjt1WHFLAbONeWxJABDiQSIMJI/sadhuTBbL8fbqM2jXKHWg-T1EsqHwZ2NlnlT6FB-e7Q_words.svg)](https://github.com/ublue-os/main/commits)
[![Top contributors](https://images.repography.com/35181738/ublue-os/main/recent-activity/xrA_PaNuNMQaiMXAgCjt1WHFLAbONeWxJABDiQSIMJI/sadhuTBbL8fbqM2jXKHWg-T1EsqHwZ2NlnlT6FB-e7Q_users.svg)](https://github.com/ublue-os/main/graphs/contributors)
[![Activity map](https://images.repography.com/35181738/ublue-os/main/recent-activity/xrA_PaNuNMQaiMXAgCjt1WHFLAbONeWxJABDiQSIMJI/sadhuTBbL8fbqM2jXKHWg-T1EsqHwZ2NlnlT6FB-e7Q_map.svg)](https://github.com/ublue-os/main/commits)
