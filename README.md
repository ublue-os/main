# Main

[![build-ublue](https://github.com/ublue-os/main/actions/workflows/build.yml/badge.svg)](https://github.com/ublue-os/main/actions/workflows/build.yml)

A WIP common main image for all other Ublue images.

## What is this?

This is an upstream image for all of the other Ublue images to inherit from. This image contains common packages for different editions and is inteded for further customization by downstream images.

Graph of the [uBlue architecture](https://ublue.it/architecture/):

![](https://ublue.it/ublue-architecture-graph.png)

## Features

- Start with a base Fedora Silverblue 37 image
- Adds the following packages to the base image:
  - distrobox and gnome-tweaks
- Sets automatic staging of updates for the system
- Sets flatpaks to update twice a day
- Everything else (desktop, artwork, etc) remains stock so you can use this as a good starting image

## Applications

Edit the `packages.json` file with your preferred applications

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/ublue-os/base

If you're forking this repo you should [read the docs](https://docs.github.com/en/actions/security-guides/encrypted-secrets) on keeping secrets in github. You need to [generate a new keypair](https://docs.sigstore.dev/cosign/overview/) with cosign. The public key can be in your public repo (your users need it to check the signatures), and you can paste the private key in Settings -> Secrets -> Actions.

## Making your own

See [the documentation](https://ublue.it/making-your-own/) on how use this image in your own projects.
