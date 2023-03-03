# Main

[![build-ublue](https://github.com/ublue-os/main/actions/workflows/build.yml/badge.svg)](https://github.com/ublue-os/main/actions/workflows/build.yml)

A WIP common main image for all other Ublue images.

## What is this?

This is an upstream image for all of the other Ublue images to inherit from. This image contains common packages for different editions and is inteded for further customization by downstream images.

Graph of the Ublue structure:
![Graph of the Ublue structure. Fedora-built images on the top, and only the opionated main aka this image inherits from it. Users is on the bottom, and users get the Ublue main image, a hypothetical image intended for Amd gpus and another existing one for Nvidia gpus. A startingpoint image inherits from the main, Amd and Nvidia images, and it is inteded for further customization by tinkerers into community-built images.](ublue-structure-graph.png)

## Features

TBA

## Applications

TBA

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/ublue-os/base

If you're forking this repo you should [read the docs](https://docs.github.com/en/actions/security-guides/encrypted-secrets) on keeping secrets in github. You need to [generate a new keypair](https://docs.sigstore.dev/cosign/overview/) with cosign. The public key can be in your public repo (your users need it to check the signatures), and you can paste the private key in Settings -> Secrets -> Actions.

## Making your own

See [the documentation](https://ublue.it/making-your-own/) on how use this image in your own projects.
