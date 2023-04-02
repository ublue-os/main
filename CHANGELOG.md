# Changelog

## 1.0.0 (2023-04-02)


### Features

* add apr and apr-util ([#92](https://github.com/ublue-os/main/issues/92)) ([ade520f](https://github.com/ublue-os/main/commit/ade520f7e50a12b40672b50b184fba6a41e2d002))
* Add disk management cli tools ([#52](https://github.com/ublue-os/main/issues/52)) ([277e1fe](https://github.com/ublue-os/main/commit/277e1fe0260a22ec76bf9ca45b226144bc1433ff))
* add distrobox, just, and gnome-tweaks ([#17](https://github.com/ublue-os/main/issues/17)) ([15f17ee](https://github.com/ublue-os/main/commit/15f17ee7b779b5331e99a08701b629f53906c050))
* add ffmpegthumbnailer ([#49](https://github.com/ublue-os/main/issues/49)) ([699588c](https://github.com/ublue-os/main/commit/699588cf94a18060835c458452c6a828a6ad7435))
* add fzf for better just support ([#84](https://github.com/ublue-os/main/issues/84)) ([3f9d939](https://github.com/ublue-os/main/commit/3f9d9398ca7b1754234ef06111b66037b2f3531b))
* Add htop package ([#82](https://github.com/ublue-os/main/issues/82)) ([af2b3cf](https://github.com/ublue-os/main/commit/af2b3cfd1f3d8a0e52c03166a553d5f33e156638))
* Add kernel-devel package ([#16](https://github.com/ublue-os/main/issues/16)) ([7e31134](https://github.com/ublue-os/main/commit/7e311342aa80e20ad2c4762b033a6b714a5ae334))
* Add lxqt image ([#47](https://github.com/ublue-os/main/issues/47)) ([2a9eddc](https://github.com/ublue-os/main/commit/2a9eddc4bf67f34763a8c2e3f53642613a228afa))
* Add mate-desktop packages ([#53](https://github.com/ublue-os/main/issues/53)) ([96cf250](https://github.com/ublue-os/main/commit/96cf250141d9ea737a3956f0955a20ad813619ed))
* add package request template ([#3](https://github.com/ublue-os/main/issues/3)) ([9ee86e8](https://github.com/ublue-os/main/commit/9ee86e80c622aef297a7770dc7ec4a02c87affa6))
* add post-install script for finalizing configurations ([#30](https://github.com/ublue-os/main/issues/30)) ([828d712](https://github.com/ublue-os/main/commit/828d71209ee612ccc6373ba76982f63b268d07dc))
* Add release package group configuration support ([#15](https://github.com/ublue-os/main/issues/15)) ([5d33e5e](https://github.com/ublue-os/main/commit/5d33e5e235b26ff56bcf7db7319d5b1d1acadac4))
* add repography ([#66](https://github.com/ublue-os/main/issues/66)) ([95d2e62](https://github.com/ublue-os/main/commit/95d2e62e2e90d7a5f5f76569678e522441e7972f))
* Add RPMs from ublue-os/config ([#22](https://github.com/ublue-os/main/issues/22)) ([ea9dd75](https://github.com/ublue-os/main/commit/ea9dd75d7ef8be10afb33a94e1d391a2dcde8bba))
* add tumbler for thumbnails on sericea ([#56](https://github.com/ublue-os/main/issues/56)) ([07b2736](https://github.com/ublue-os/main/commit/07b2736f03f3b054eebb01ce1f2d668d5284e7bf))
* Add vim, openssl, and pipewire-codec-aptx ([#31](https://github.com/ublue-os/main/issues/31)) ([e1f77e7](https://github.com/ublue-os/main/commit/e1f77e79b99150fff55cd07190f608f7ddd48e5d))
* add zstd ([#63](https://github.com/ublue-os/main/issues/63)) ([4307b8b](https://github.com/ublue-os/main/commit/4307b8bc3fe6f087c0251f0e7105ac173035baac))
* enable mesa-va-drivers-freeworld for all Fedora releases ([#67](https://github.com/ublue-os/main/issues/67)) ([7265922](https://github.com/ublue-os/main/commit/7265922d0a781c396f334582df7a1b04f3a2a32b))
* generate stripped-down base image variants ([ee1d4d4](https://github.com/ublue-os/main/commit/ee1d4d432b0bcd620894412fa30daf9a556bf8b4))
* install libva, and nvtop ([#19](https://github.com/ublue-os/main/issues/19)) ([7e3c54a](https://github.com/ublue-os/main/commit/7e3c54a7a5810e20f53998a432c9d45be38cba78))
* swap mesa-va-drivers and add ffmpeg for F37 ([#21](https://github.com/ublue-os/main/issues/21)) ([79ede2c](https://github.com/ublue-os/main/commit/79ede2ca5028187e29ee7e5c83275b0eff20e55e))


### Bug Fixes

* add usage instructions ([#40](https://github.com/ublue-os/main/issues/40)) ([3c1db1e](https://github.com/ublue-os/main/commit/3c1db1ed5965b3f1547c3cf5f560273cfa0332e3))
* also build the image variant with the correct name ([#12](https://github.com/ublue-os/main/issues/12)) ([a5fde3b](https://github.com/ublue-os/main/commit/a5fde3b9edb2ad3c04e0af25b4f2e3a5c1ebadc4))
* image name and description variable interpolation ([#37](https://github.com/ublue-os/main/issues/37)) ([7f922c9](https://github.com/ublue-os/main/commit/7f922c9343878ceb9a09bba0126ed55e19edc23a))
* keep IMAGE_NAME and set it once ([#13](https://github.com/ublue-os/main/issues/13)) ([85b152e](https://github.com/ublue-os/main/commit/85b152ec097f3be9b15a87b39bffa7ba022ba968))
* maintain the current oci version label ([#89](https://github.com/ublue-os/main/issues/89)) ([be7faed](https://github.com/ublue-os/main/commit/be7faeda71ca2a96e0471d0fada59052b8db3c3d))
* ostree automatic updates not enabled ([#48](https://github.com/ublue-os/main/issues/48)) ([b508c02](https://github.com/ublue-os/main/commit/b508c02b0200846a50e62d31479d7ba83b424b00))
* PRs won't push to registry ([8d21213](https://github.com/ublue-os/main/commit/8d212133ec05899d1ae1e35f2de5a730a55b1364))
* Readme update ([#74](https://github.com/ublue-os/main/issues/74)) ([e290cbf](https://github.com/ublue-os/main/commit/e290cbfd0503598994cc7fee18dde883373783a2))
* remove standalone date tag ([#80](https://github.com/ublue-os/main/issues/80)) ([edb67aa](https://github.com/ublue-os/main/commit/edb67aa48326ac59891e8e28779c0d2b05a92f0f))
* Reorder und add more info about distrobox to README ([#73](https://github.com/ublue-os/main/issues/73)) ([f8bf5bd](https://github.com/ublue-os/main/commit/f8bf5bdac57f777050da058b7590339254847467))
* split variant builds to their own registry ([#11](https://github.com/ublue-os/main/issues/11)) ([17da43c](https://github.com/ublue-os/main/commit/17da43c69d2850501ae611370e8890f02d44de2b))
* update to cosign 2.0 and pin install ([#10](https://github.com/ublue-os/main/issues/10)) ([4fbe168](https://github.com/ublue-os/main/commit/4fbe1688e9dce81efd9597bcd46caaf75945f7d3))

## [1.0.5](https://github.com/bigpod98/main/compare/v1.0.4...v1.0.5) (2023-04-02)


### Bug Fixes

* ISO name addition ([441d3a8](https://github.com/bigpod98/main/commit/441d3a8e6dce6c789667e90c0ff9d9018ca9064a))
