# Rose OS

[![build-rose-os](https://github.com/joshua-stone/rose-os/actions/workflows/build.yml/badge.svg)](https://github.com/joshua-stone/rose-os/actions/workflows/build.yml)

A set of OS images based on the [Universal Blue project](https://universal-blue.org/). The images incorporate a smaller set of [package inclusions/exclusions](https://github.com/joshua-stone/rose-os/blob/main/packages.json) and have a more streamlined support matrix.

# Features:

* Wayland-only; no X11 sessions
* mesa-freeworld, ffmpegthumbnailer, and gnome-epub-thumbnailer provide support for more file formats
* alsa-firmware and pipewire-codec-aptx provide broader audio support
* solaar-udev provides runtime support files for [Solaar](https://flathub.org/apps/io.github.pwr_solaar.solaar)

# Installing

So far the only supported installation method is to rebase from base [Silverblue](https://fedoraproject.org/atomic-desktops/silverblue/).

```
$ rpm-ostree rebase ostree-unverified-registry:ghcr.io/joshua-stone/rose-os-silverblue:latest
$ reboot
$ rpm-ostree rebase ostree-image-signed:docker://ghcr.io/joshua-stone/rose-os-silverblue:latest
```
