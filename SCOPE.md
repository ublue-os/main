# Welcome to Universal Blue

## Scope of ublue-os/main

As mentioned in the readme, this is a common main image for all other uBlue images, with minimal (but important) adjustments to Fedora. The adjustments included in this repo are:

- Hardware enablement
- Non-free codecs 
- Other non-free packages Fedora can't ship

## Out of scope for ublue-os/main

- Tools with universal utility (these should be added to Fedora globally at [fedora-comps](https://pagure.io/fedora-comps)) 
- Opinionated changes that lack universal utility (these should be added to downstream images)

## FAQ

### Why is _ package included?

We are in the process of reducing the package set to the intended scope of this repo. This is an incremental process.