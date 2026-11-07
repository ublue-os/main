# NOTICE 7 November 2026:
**NVIDIA image retirement**
This repository no longer builds or updates `base-nvidia`, `silverblue-nvidia`, or `kinoite-nvidia`, following the year-old decision in [#927](https://github.com/ublue-os/main/issues/927). Existing published tags will not receive further updates. This change does not automatically migrate installed systems.

For a maintained NVIDIA desktop, use the appropriate NVIDIA image from Bluefin, Aurora, or Bazzite. For custom images, see [Adding NVIDIA drivers in image-template](https://github.com/ublue-os/image-template#adding-nvidia-drivers). NVIDIA akmods images and their bundled installer remain available; only the standalone desktop/base NVIDIA images built here are retired.

# NOTICE 22 October 2026: 
fcitx5 has been removed from the image in favor of using the more up to date flatpak. See [here](https://linux.kde.org/docs/cjkv-input/#fixing-compatibility-issues) and [here](https://flathub.org/en/apps/org.fcitx.Fcitx5) for more information.

# NOTICE 15 October 2025: 
The deprecated sway, budgie, and cosmic images have now been removed, see [#927](https://github.com/ublue-os/main/issues/927)

# Main

[![build-latest](https://github.com/ublue-os/main/actions/workflows/build-latest.yml/badge.svg)](https://github.com/ublue-os/main/actions/workflows/build-latest.yml)

A common main image for all other uBlue images, with minimal (but important) adjustments to Fedora. <3

Deprecation Notice: Universal Blue is trimming support for intermediate images (such as those built in main) which are not used in our project's final images (Aurora, Bazzite, Bluefin).

As of September 2025, this repo will only build base, kinoite, and silverblue images.

# Documentation

- [Main website](https://universal-blue.org)
- [Documentation](https://universal-blue.org/documentation.html)
- [Scope document](https://universal-blue.org/mission.html)
