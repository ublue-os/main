# Changelog

## [2.2.0](https://github.com/ublue-os/main/compare/v2.1.0...v2.2.0) (2024-11-17)


### Features

* add `wl-clipboard` to all images ([#641](https://github.com/ublue-os/main/issues/641)) ([77e26e6](https://github.com/ublue-os/main/commit/77e26e6e553a1e2466b2cd9d7faecd3d637d5116))
* Add a beta tag ([#651](https://github.com/ublue-os/main/issues/651)) ([73e6d04](https://github.com/ublue-os/main/commit/73e6d049cd2328cb30754cdbcff0da33d142fc25))
* Add flatpak-spawn package by default ([#583](https://github.com/ublue-os/main/issues/583)) ([2d8dca6](https://github.com/ublue-os/main/commit/2d8dca6e7d9b54b8637be49a2f0d0d80f3eb0bfc))
* add fprint and libcamera ([#616](https://github.com/ublue-os/main/issues/616)) ([3b629bb](https://github.com/ublue-os/main/commit/3b629bbfa04e766b82c452d8fcf2e222a451717c))
* add missing packages to Fedora 41 builds ([#655](https://github.com/ublue-os/main/issues/655)) ([0373f7a](https://github.com/ublue-os/main/commit/0373f7af656c424de31f6141a777d53a00ee1bdd))
* Add squashfs-tools ([#586](https://github.com/ublue-os/main/issues/586)) ([0afd8cf](https://github.com/ublue-os/main/commit/0afd8cf0caf9f4109bf10e12fae0ab0795e6ac3b))
* add yubikey-manager ([#630](https://github.com/ublue-os/main/issues/630)) ([7d01b96](https://github.com/ublue-os/main/commit/7d01b9670091a301ecfbf094cdb250f4f14400f3))
* **ci:** honor `IMAGE_REGISTRY` in Containerfile ([#607](https://github.com/ublue-os/main/issues/607)) ([3107f29](https://github.com/ublue-os/main/commit/3107f29c9abce745648c1236e8fd5f6e2e7f9739))
* create emeritus.md ([#621](https://github.com/ublue-os/main/issues/621)) ([f2e0055](https://github.com/ublue-os/main/commit/f2e005523f981dc08166e3eec1b2ba6ff16024fd))
* **dev:** add justfile for local testing and integration with vscode ([#578](https://github.com/ublue-os/main/issues/578)) ([7e07358](https://github.com/ublue-os/main/commit/7e073587cee57db4d77ca7677cf80d07f5bc0583))
* enable Fedora 41 builds ([#638](https://github.com/ublue-os/main/issues/638)) ([f959353](https://github.com/ublue-os/main/commit/f9593536d60d2de93a55084ace11501552ae5bb1))
* Improve Containerfile / enable workflow usage of containerized buildah (tag: v1) ([#604](https://github.com/ublue-os/main/issues/604)) ([85d2bd8](https://github.com/ublue-os/main/commit/85d2bd8333851b4d6797f385e813d630643c16b4))
* Remove lchsh ([#637](https://github.com/ublue-os/main/issues/637)) ([2e5e007](https://github.com/ublue-os/main/commit/2e5e007a3310df664822a47b4689f629786c81d7))
* Replace gnome-software with non-dkms version on F41 and above. ([#671](https://github.com/ublue-os/main/issues/671)) ([90054b9](https://github.com/ublue-os/main/commit/90054b90907a9e403ea626e637ca367f78694cc3))
* set dracut zstd compression for initramfs regen ([#595](https://github.com/ublue-os/main/issues/595)) ([ea43f00](https://github.com/ublue-os/main/commit/ea43f00fd0fb4c3c4379d71fd30e00522df0fa4a))
* Sign kernel with our akmods key ([#588](https://github.com/ublue-os/main/issues/588)) ([e72d5af](https://github.com/ublue-os/main/commit/e72d5afc246e45530bf9c56c1605c66ed1d11f11))
* Stop supporting chsh ([#624](https://github.com/ublue-os/main/issues/624)) ([1298125](https://github.com/ublue-os/main/commit/12981252b81966813927744ae5f39ef6ceb53283))
* Update tags for F41 Release ([#657](https://github.com/ublue-os/main/issues/657)) ([a411c6a](https://github.com/ublue-os/main/commit/a411c6aba3ad035de588c9c5daf3f288e269a405))
* use cached kernel ([#605](https://github.com/ublue-os/main/issues/605)) ([a7af108](https://github.com/ublue-os/main/commit/a7af108a27d454cc699fb0ee955892ded65a8506))
* use negativo17 in lieu of rpmfusion ([#636](https://github.com/ublue-os/main/issues/636)) ([3dd8884](https://github.com/ublue-os/main/commit/3dd8884f8de176fb3fe53e5f96e85c176f94c56a))


### Bug Fixes

* bug in negativo prioritization command ([#649](https://github.com/ublue-os/main/issues/649)) ([5006127](https://github.com/ublue-os/main/commit/500612786d72f0377fe075138c8269332c08a938))
* **ci:** Don't sign kernel on PR ([#590](https://github.com/ublue-os/main/issues/590)) ([a7dfe88](https://github.com/ublue-os/main/commit/a7dfe88f71b6db1fa540fdd5901cf2bee22e1ea9))
* Correct rpm-ostree issue that prevents rollbacks ([#635](https://github.com/ublue-os/main/issues/635)) ([2a37660](https://github.com/ublue-os/main/commit/2a376609a5bd3227a982952bd173dc2f767c7d1e))
* github release install silently fails if no urls found ([#571](https://github.com/ublue-os/main/issues/571)) ([4561ed4](https://github.com/ublue-os/main/commit/4561ed4858e9a7ad131e7ea2e051ea1a690cff82))
* handle new F41 selinux policies for sulogin-generator ([#654](https://github.com/ublue-os/main/issues/654)) ([55a4433](https://github.com/ublue-os/main/commit/55a4433ebf7458f69c791dc69cff32d522afdfd0))
* Include fuse package for AppImage support ([#631](https://github.com/ublue-os/main/issues/631)) ([8b9725b](https://github.com/ublue-os/main/commit/8b9725b2caa79f1484dfaf2a83a60b2ccc1b03fa))
* **kinoite:** Include missing KDE image format codecs ([#660](https://github.com/ublue-os/main/issues/660)) ([147b76b](https://github.com/ublue-os/main/commit/147b76b112cae7f624a66752ceb26c6733855174))
* Override copr plugin config to use fedora chroot by default ([#663](https://github.com/ublue-os/main/issues/663)) ([12829ea](https://github.com/ublue-os/main/commit/12829ea1b846497085a38342af8a3821efff6102))
* Override copr plugin config to use fedora chroot by default (resubmission) ([#665](https://github.com/ublue-os/main/issues/665)) ([99b6864](https://github.com/ublue-os/main/commit/99b6864790c6605c652f591003bccefe605fae63))
* reduce gap between upstream builds and ublue builds ([#589](https://github.com/ublue-os/main/issues/589)) ([897a07b](https://github.com/ublue-os/main/commit/897a07b0a7a8df226197631b69af1d2999ca4302))
* remove ffmpeg-free from all images ([#582](https://github.com/ublue-os/main/issues/582)) ([9f5b4e7](https://github.com/ublue-os/main/commit/9f5b4e74add8c053402e99a99fa37fe7f20b978e))
* remove mate images ([#639](https://github.com/ublue-os/main/issues/639)) ([39bd13d](https://github.com/ublue-os/main/commit/39bd13db95a317080c06f4ca7813b2a8c24f72ee))
* Remove no longer needed rpm-ostree override ([#640](https://github.com/ublue-os/main/issues/640)) ([da4f78f](https://github.com/ublue-os/main/commit/da4f78fc304f33f0dcb87086e056dfb8ecd7a69d))
* remove redundant and less performant thumbnailer ([#659](https://github.com/ublue-os/main/issues/659)) ([77e6b44](https://github.com/ublue-os/main/commit/77e6b443f6a6023582ef964e36fa7fd1c158033c))

## [2.1.0](https://github.com/ublue-os/main/compare/v2.0.0...v2.1.0) (2024-05-07)


### Features

* Add Gnome EPUB files thumbnailing support ([#457](https://github.com/ublue-os/main/issues/457)) ([1c73f37](https://github.com/ublue-os/main/commit/1c73f37c8cf56adc8eb2260e9272f4546da006b8))
* Add powerstat for laptops & handhelds ([#567](https://github.com/ublue-os/main/issues/567)) ([aec2dd0](https://github.com/ublue-os/main/commit/aec2dd03bbd6a940580870f8552e5c9821c52abc))
* Adding gvfs-nfs package to silverblue image. ([#480](https://github.com/ublue-os/main/issues/480)) ([c4b4cc7](https://github.com/ublue-os/main/commit/c4b4cc737a3585182a0a537acf292386dae7c664))
* allow rescue/emergency boot with grub cmdline args ([#488](https://github.com/ublue-os/main/issues/488)) ([c2ad2bf](https://github.com/ublue-os/main/commit/c2ad2bfe1d1642afeb1c2959e2630a16fb5ecd43))
* bump Fedora 40 to latest and Fedora 39 to stable ([#563](https://github.com/ublue-os/main/issues/563)) ([d3289e9](https://github.com/ublue-os/main/commit/d3289e95417f546c02a7690a31092d6cbb556ae4))
* drop v4l2loopback from kmods since it fails to build on 6.8 ([#549](https://github.com/ublue-os/main/issues/549)) ([6c3ddf2](https://github.com/ublue-os/main/commit/6c3ddf2088106b997bd5532d29a735b9bca4dfb3))
* enable preview of Fedora 40 main builds ([#521](https://github.com/ublue-os/main/issues/521)) ([72e1f64](https://github.com/ublue-os/main/commit/72e1f644ee34e024b1c814b90cab7df241980a53))
* Fedora 37 is EOL 2023-12-05 ([#442](https://github.com/ublue-os/main/issues/442)) ([e84e7d8](https://github.com/ublue-os/main/commit/e84e7d885b0d9b1da452187e0c92805883cf5a85))
* leverage retry-action to increase reliability of builds. ([#503](https://github.com/ublue-os/main/issues/503)) ([4dda9bc](https://github.com/ublue-os/main/commit/4dda9bc864b3fcc807e85b6fab952d1fce9540ae))
* **sericea:** Android support packages for Thunar ([#515](https://github.com/ublue-os/main/issues/515)) ([bd83f3c](https://github.com/ublue-os/main/commit/bd83f3c412ecc800d6f933c7098a988ae02ad3da))


### Bug Fixes

* add gitattributes file to fix linguist ([#520](https://github.com/ublue-os/main/issues/520)) ([70fa994](https://github.com/ublue-os/main/commit/70fa994232df0d0c1449ac941b8b6a6703c1783c))
* add lazurite to the build matrix ([#458](https://github.com/ublue-os/main/issues/458)) ([201844d](https://github.com/ublue-os/main/commit/201844de237c3093d0dbff0985203130635c9371))
* add mesa-filesystem package ([#455](https://github.com/ublue-os/main/issues/455)) ([b226fe4](https://github.com/ublue-os/main/commit/b226fe40c31e48f6cd9ed32c4766839b551b95e8))
* add ublue-sulogin-generatore to image ([#511](https://github.com/ublue-os/main/issues/511)) ([d794f4b](https://github.com/ublue-os/main/commit/d794f4b8b03d32a09d1d850e34e9ae3bb9a00afb))
* **ci:** never skip successful builds check ([#436](https://github.com/ublue-os/main/issues/436)) ([d7f2918](https://github.com/ublue-os/main/commit/d7f29187ef253beb097bb88d7337c61c9db4d44d))
* Correct upstream podman issue ([#438](https://github.com/ublue-os/main/issues/438)) ([bfee8ab](https://github.com/ublue-os/main/commit/bfee8abfc16348fb4efde971df4351e7268346d7))
* Drop wget for curl ([e4f13ae](https://github.com/ublue-os/main/commit/e4f13aed195c41f00458d3e56d4cf1f9d4c08b38))
* enable boot to tty for base image ([#424](https://github.com/ublue-os/main/issues/424)) ([82ccb30](https://github.com/ublue-os/main/commit/82ccb3090864279453a7871c236402715b10be03))
* Enforce 64-bit version of mesa-va-drivers-freeworld ([#474](https://github.com/ublue-os/main/issues/474)) ([472ed8a](https://github.com/ublue-os/main/commit/472ed8a9f342f31d66b9327d921c780052569fe6))
* **f39:** Restore cjk fonts ([#417](https://github.com/ublue-os/main/issues/417)) ([3b3358e](https://github.com/ublue-os/main/commit/3b3358ea0aabdd04539bae95668249a3a21f94e6))
* remove lxqt 39 as lazurite replaced it ([#467](https://github.com/ublue-os/main/issues/467)) ([cb54f2c](https://github.com/ublue-os/main/commit/cb54f2c85b07e6a51dcfc6e2fd38fd6eb6647de1))
* remove podman-compose ([#432](https://github.com/ublue-os/main/issues/432)) ([2d7b47b](https://github.com/ublue-os/main/commit/2d7b47b84e7153058a0cc72050ab97b84bb08436))
* remove vestigial isogenerator ([#531](https://github.com/ublue-os/main/issues/531)) ([462bd7a](https://github.com/ublue-os/main/commit/462bd7a4b2e3cb61077288d0fa4041f8ab99126e))
* switch to distro bootc for F38 and F39 ([#426](https://github.com/ublue-os/main/issues/426)) ([2bc3101](https://github.com/ublue-os/main/commit/2bc3101c1a1bdffd45e2b0022e1946c10e175de4))

## [1.11.0](https://github.com/ublue-os/main/compare/v1.10.0...v1.11.0) (2023-11-08)


### Features

* Add PAM modules for YubiKey support ([#397](https://github.com/ublue-os/main/issues/397)) ([49b02bd](https://github.com/ublue-os/main/commit/49b02bd9e5373401da8204e915bce6691af43e35))
* Exclude kmods from Fedora 39 and future images ([#375](https://github.com/ublue-os/main/issues/375)) ([4bec2a4](https://github.com/ublue-os/main/commit/4bec2a4283f17c8a2e3e0dfe4617e9bd23d90560))
* **f39:** Use official images for Silverblue, Kinoite, and Sericea ([#407](https://github.com/ublue-os/main/issues/407)) ([5062628](https://github.com/ublue-os/main/commit/50626281e7cb2a31e5c1f5829f8540df487a8ddd))
* Mark Fedora 39 images as stable and roll out gts ([#391](https://github.com/ublue-os/main/issues/391)) ([ff78ed2](https://github.com/ublue-os/main/commit/ff78ed26295d0a8d1ad2d9fd5d607bae7fd3cf7e))
* re-add libheif-freeworld ([#408](https://github.com/ublue-os/main/issues/408)) ([cb0dd8f](https://github.com/ublue-os/main/commit/cb0dd8fc02413958df31b3d6d29ce79e905a48a9))
* turn on F39 for vauxite ([#392](https://github.com/ublue-os/main/issues/392)) ([3db7257](https://github.com/ublue-os/main/commit/3db725760df890225b581c81164eb83605c85f6b))


### Bug Fixes

* **f39:** temp: Install pipewire from testing ([#396](https://github.com/ublue-os/main/issues/396)) ([b4d73c1](https://github.com/ublue-os/main/commit/b4d73c1eb5e0ff6e740e543ac68c1e0530e194e0))
* stop excluding kwrite ([#401](https://github.com/ublue-os/main/issues/401)) ([b866e6e](https://github.com/ublue-os/main/commit/b866e6e538d01c1847694fcaebecec5a16dec2a3))
* Target Fedora 40 for official images, revert 39 to ci-test ([#410](https://github.com/ublue-os/main/issues/410)) ([bfd786e](https://github.com/ublue-os/main/commit/bfd786e8988faa374438d632fa1e34282a59a067))

## [1.10.0](https://github.com/ublue-os/main/compare/v1.9.0...v1.10.0) (2023-10-11)


### Features

* add a bootc snapshot ([#367](https://github.com/ublue-os/main/issues/367)) ([b9b3095](https://github.com/ublue-os/main/commit/b9b3095925e76a9bded365b8419634ef003790cb))
* add cosign ([#308](https://github.com/ublue-os/main/issues/308)) ([4ba7efd](https://github.com/ublue-os/main/commit/4ba7efd440efd31b83c81b9fd88e5a99f1322763))
* Add OpenRazer kmod ([#340](https://github.com/ublue-os/main/issues/340)) ([76a95c6](https://github.com/ublue-os/main/commit/76a95c6e706b57d49c711a983b13cfe8419b211f))
* Add udev rules for android phones ([#362](https://github.com/ublue-os/main/issues/362)) ([6e7ac65](https://github.com/ublue-os/main/commit/6e7ac653f5c361b4a023bd47e5297b9d0b8df603))
* Add udev rules for Logitech steering wheels ([#366](https://github.com/ublue-os/main/issues/366)) ([03ccff2](https://github.com/ublue-os/main/commit/03ccff21751ce74e51d41a41dce6e2b794d81e67))
* Add udev rules for Solaar ([#349](https://github.com/ublue-os/main/issues/349)) ([913a9e5](https://github.com/ublue-os/main/commit/913a9e5707fe80d3b714bbaa6ecc944265cea69e))
* Add WL driver by default (Disabled by default) ([#350](https://github.com/ublue-os/main/issues/350)) ([f1a0e1c](https://github.com/ublue-os/main/commit/f1a0e1cb2b38cf8f408adc658c1285da751735b4))
* Add xone and xpad-noone drivers ([#314](https://github.com/ublue-os/main/issues/314)) ([940a231](https://github.com/ublue-os/main/commit/940a231bcd9418db3c2a4e1f4f150ed265647ad4))
* build nvidia images in main repo ([#319](https://github.com/ublue-os/main/issues/319)) ([40e6c5d](https://github.com/ublue-os/main/commit/40e6c5d1facb90b3d5340f113ae3a52f169bd1ac))
* enable fedora 39 builds ([#301](https://github.com/ublue-os/main/issues/301)) ([67d4669](https://github.com/ublue-os/main/commit/67d466928fd28398fef7d9d574273756f28293bd))
* enable onyx builds ([#348](https://github.com/ublue-os/main/issues/348)) ([ec3e1c2](https://github.com/ublue-os/main/commit/ec3e1c211afb8aae0fe849cf579c2c50bf3bed4c))
* Generate image info ([75e26c9](https://github.com/ublue-os/main/commit/75e26c93540cfe2b46aad2d3a3af12e7fc23d783))
* re-add xwaylandvideobridge ([#352](https://github.com/ublue-os/main/issues/352)) ([df4e369](https://github.com/ublue-os/main/commit/df4e36912cb2fd19702a139247886e41224c6877))
* remove google-noto-sans-cjk-vf-fonts and replace it with google-noto-sans-cjk-fonts ([#334](https://github.com/ublue-os/main/issues/334)) ([50541f2](https://github.com/ublue-os/main/commit/50541f2d77c7208dd7b18d5e3947f6bac6c267c1))
* restore libheif-freeworld for F37-F38 ([#354](https://github.com/ublue-os/main/issues/354)) ([bd53a9a](https://github.com/ublue-os/main/commit/bd53a9a4914b8bec099529ac5378e8fcfbe4e93f))


### Bug Fixes

* add missing blacklist for wl modprobe config ([#355](https://github.com/ublue-os/main/issues/355)) ([7972f3c](https://github.com/ublue-os/main/commit/7972f3c4a04d34da9027944b19b0e3f147b6b1b8))
* add workaround for podman/crun regression ([#335](https://github.com/ublue-os/main/issues/335)) ([d23273c](https://github.com/ublue-os/main/commit/d23273cf484a9627df7862dfcd31d33dd8e6b4f6))
* **nvidia-32bit:** Append release to packages ([#338](https://github.com/ublue-os/main/issues/338)) ([d94c197](https://github.com/ublue-os/main/commit/d94c197ce2932162840358ac6a4416ce05d1d651))
* **nvidia-32bit:** Correct package name ([#339](https://github.com/ublue-os/main/issues/339)) ([dc380d4](https://github.com/ublue-os/main/commit/dc380d4b8594d565a83418ffa351c075cd93cccc))
* **nvidia:** Install 32 bit driver libraries ([#336](https://github.com/ublue-os/main/issues/336)) ([ed724e0](https://github.com/ublue-os/main/commit/ed724e0b5a3d1fddd1e7627e779395aa144d0c74))
* re-remove libheif-freeworld for F37-F38 ([#358](https://github.com/ublue-os/main/issues/358)) ([ec73435](https://github.com/ublue-os/main/commit/ec7343533a91d4acdb95316e4cdd15d472c371ce))
* remove extra 'tags' line from cosign ([#321](https://github.com/ublue-os/main/issues/321)) ([36fcf22](https://github.com/ublue-os/main/commit/36fcf22bc0b1bcfda66f6fdfec21d95923bb5f6f))
* remove libheif-freeworld from packages to fix build ([#332](https://github.com/ublue-os/main/issues/332)) ([9cb853b](https://github.com/ublue-os/main/commit/9cb853bfe535426a9113f32f972f3ae7b210db32))
* switch back to free builders to fix skopeo inspect issue ([#322](https://github.com/ublue-os/main/issues/322)) ([1cfad9e](https://github.com/ublue-os/main/commit/1cfad9e1f728707f65864125959126dadfe3ab29))
* use new akmods:main-RELEASE tag structure ([#372](https://github.com/ublue-os/main/issues/372)) ([86149a1](https://github.com/ublue-os/main/commit/86149a1f8b9b396091a5ebad142fc936997cbc0f))
* use raw output from jq to install cosign again ([#312](https://github.com/ublue-os/main/issues/312)) ([9b12fd5](https://github.com/ublue-os/main/commit/9b12fd58401c9118ca24c6de5d79076455d5ad93))

## [1.9.0](https://github.com/ublue-os/main/compare/v1.8.0...v1.9.0) (2023-08-16)


### Features

* add `lshw` (issue [#225](https://github.com/ublue-os/main/issues/225)) ([#230](https://github.com/ublue-os/main/issues/230)) ([5501e3c](https://github.com/ublue-os/main/commit/5501e3c008aaed027c2bbfc25c3a952a2500db4d))
* add adw-gtk3-theme for Silverblue ([#204](https://github.com/ublue-os/main/issues/204)) ([3aa1345](https://github.com/ublue-os/main/commit/3aa1345d46507a4158ff7df29cbb92b186c89b4b))
* Add alsa-firmware package needed for some sound cards ([#270](https://github.com/ublue-os/main/issues/270)) ([0eb781b](https://github.com/ublue-os/main/commit/0eb781b117f90437ab68eeee442bdffbf0d966b0))
* add apr and apr-util ([#92](https://github.com/ublue-os/main/issues/92)) ([ade520f](https://github.com/ublue-os/main/commit/ade520f7e50a12b40672b50b184fba6a41e2d002))
* add cinnamon image to iso ([#237](https://github.com/ublue-os/main/issues/237)) ([d6d98a2](https://github.com/ublue-os/main/commit/d6d98a238a2d6f9702d428de5ef94011df6a4a3e))
* add clipman for sericea ([#273](https://github.com/ublue-os/main/issues/273)) ([09c59b5](https://github.com/ublue-os/main/commit/09c59b5ec03c49d8c34f8344d87e5ddbdca8e217))
* Add disk management cli tools ([#52](https://github.com/ublue-os/main/issues/52)) ([277e1fe](https://github.com/ublue-os/main/commit/277e1fe0260a22ec76bf9ca45b226144bc1433ff))
* add distrobox, just, and gnome-tweaks ([#17](https://github.com/ublue-os/main/issues/17)) ([15f17ee](https://github.com/ublue-os/main/commit/15f17ee7b779b5331e99a08701b629f53906c050))
* add ffmpegthumbnailer ([#49](https://github.com/ublue-os/main/issues/49)) ([699588c](https://github.com/ublue-os/main/commit/699588cf94a18060835c458452c6a828a6ad7435))
* add fzf for better just support ([#84](https://github.com/ublue-os/main/issues/84)) ([3f9d939](https://github.com/ublue-os/main/commit/3f9d9398ca7b1754234ef06111b66037b2f3531b))
* Add htop package ([#82](https://github.com/ublue-os/main/issues/82)) ([af2b3cf](https://github.com/ublue-os/main/commit/af2b3cfd1f3d8a0e52c03166a553d5f33e156638))
* add intel-media-driver ([#98](https://github.com/ublue-os/main/issues/98)) ([9d7f2e2](https://github.com/ublue-os/main/commit/9d7f2e26d39d90eaf38449f8a7bcfda97142f7b3))
* Add kernel-devel package ([#16](https://github.com/ublue-os/main/issues/16)) ([7e31134](https://github.com/ublue-os/main/commit/7e311342aa80e20ad2c4762b033a6b714a5ae334))
* add kernel-tools ([#208](https://github.com/ublue-os/main/issues/208)) ([b2d0b07](https://github.com/ublue-os/main/commit/b2d0b0795067de0630ef4f64a3471dda5d33e5d9))
* add libheif-freeworld & heif-pixbuf-loader ([#255](https://github.com/ublue-os/main/issues/255)) ([5f21453](https://github.com/ublue-os/main/commit/5f2145300d11d2c844ce73df13f6a53520655c6e))
* Add libheif-tools ([#253](https://github.com/ublue-os/main/issues/253)) ([8703dc8](https://github.com/ublue-os/main/commit/8703dc8c3ab6c63237e2e3d948796d7e3fe67919))
* Add lxqt image ([#47](https://github.com/ublue-os/main/issues/47)) ([2a9eddc](https://github.com/ublue-os/main/commit/2a9eddc4bf67f34763a8c2e3f53642613a228afa))
* Add mate-desktop packages ([#53](https://github.com/ublue-os/main/issues/53)) ([96cf250](https://github.com/ublue-os/main/commit/96cf250141d9ea737a3956f0955a20ad813619ed))
* add openrgb udev rules ([#197](https://github.com/ublue-os/main/issues/197)) ([a95ec2d](https://github.com/ublue-os/main/commit/a95ec2d42e059eb3595f31b5c1bc8251e1cb0662))
* add package request template ([#3](https://github.com/ublue-os/main/issues/3)) ([9ee86e8](https://github.com/ublue-os/main/commit/9ee86e80c622aef297a7770dc7ec4a02c87affa6))
* add podman-compose ([#180](https://github.com/ublue-os/main/issues/180)) ([4eea999](https://github.com/ublue-os/main/commit/4eea999b5771d438e819735b9f000b9d0b4ef27c))
* add post-install script for finalizing configurations ([#30](https://github.com/ublue-os/main/issues/30)) ([828d712](https://github.com/ublue-os/main/commit/828d71209ee612ccc6373ba76982f63b268d07dc))
* Add release package group configuration support ([#15](https://github.com/ublue-os/main/issues/15)) ([5d33e5e](https://github.com/ublue-os/main/commit/5d33e5e235b26ff56bcf7db7319d5b1d1acadac4))
* add repography ([#66](https://github.com/ublue-os/main/issues/66)) ([95d2e62](https://github.com/ublue-os/main/commit/95d2e62e2e90d7a5f5f76569678e522441e7972f))
* Add RPMs from ublue-os/config ([#22](https://github.com/ublue-os/main/issues/22)) ([ea9dd75](https://github.com/ublue-os/main/commit/ea9dd75d7ef8be10afb33a94e1d391a2dcde8bba))
* add some indonesian fonts ([#248](https://github.com/ublue-os/main/issues/248)) ([abfc70d](https://github.com/ublue-os/main/commit/abfc70d21cc9ea97b839564fe959587e0dbb7fef))
* add tmux ([#190](https://github.com/ublue-os/main/issues/190)) ([c5491b9](https://github.com/ublue-os/main/commit/c5491b9a903be6eb5311e01c9dbefc638c3567d9))
* add tumbler for thumbnails on sericea ([#56](https://github.com/ublue-os/main/issues/56)) ([07b2736](https://github.com/ublue-os/main/commit/07b2736f03f3b054eebb01ce1f2d668d5284e7bf))
* Add vim, openssl, and pipewire-codec-aptx ([#31](https://github.com/ublue-os/main/issues/31)) ([e1f77e7](https://github.com/ublue-os/main/commit/e1f77e79b99150fff55cd07190f608f7ddd48e5d))
* add wireguard-tools ([#241](https://github.com/ublue-os/main/issues/241)) ([44cb522](https://github.com/ublue-os/main/commit/44cb522091433b2e1e4a84f4bdac4ea592e353b0))
* add xfce4-clipman-plugin to vauxite ([#182](https://github.com/ublue-os/main/issues/182)) ([5a7a820](https://github.com/ublue-os/main/commit/5a7a820180dd878b9be8bc2729ba3c51c2e3594d))
* add xwaylandvideobridge ([#232](https://github.com/ublue-os/main/issues/232)) ([ef29a6b](https://github.com/ublue-os/main/commit/ef29a6bbfc4edd28bebef63994f8a6ab922818a1))
* add zstd ([#63](https://github.com/ublue-os/main/issues/63)) ([4307b8b](https://github.com/ublue-os/main/commit/4307b8bc3fe6f087c0251f0e7105ac173035baac))
* align packagelist with fedora workstation ([#235](https://github.com/ublue-os/main/issues/235)) ([fe48ba8](https://github.com/ublue-os/main/commit/fe48ba84a061ef193285830f72c95d3f71c7a496))
* enable mesa-va-drivers-freeworld for all Fedora releases ([#67](https://github.com/ublue-os/main/issues/67)) ([7265922](https://github.com/ublue-os/main/commit/7265922d0a781c396f334582df7a1b04f3a2a32b))
* enable ublue-os akmods ([#234](https://github.com/ublue-os/main/issues/234)) ([df93c4f](https://github.com/ublue-os/main/commit/df93c4f17fe4262dad7e59233097513c734cc007))
* Fix inconsistent thumbnails across images ([#262](https://github.com/ublue-os/main/issues/262)) ([3fc9c69](https://github.com/ublue-os/main/commit/3fc9c69b7c3d4f8571eebc0788a1a7015e5bdfe0))
* generate stripped-down base image variants ([ee1d4d4](https://github.com/ublue-os/main/commit/ee1d4d432b0bcd620894412fa30daf9a556bf8b4))
* Include libratbag ([#139](https://github.com/ublue-os/main/issues/139)) ([4dcd439](https://github.com/ublue-os/main/commit/4dcd439c4b0a07c9ed96d6dd96d8a997a092b5b4))
* install libva, and nvtop ([#19](https://github.com/ublue-os/main/issues/19)) ([7e3c54a](https://github.com/ublue-os/main/commit/7e3c54a7a5810e20f53998a432c9d45be38cba78))
* KDE QoL additions ([#259](https://github.com/ublue-os/main/issues/259)) ([a2a561e](https://github.com/ublue-os/main/commit/a2a561e57ace78d975e33c07232e21d50e79df45))
* move to a unified ISO for all images ([#109](https://github.com/ublue-os/main/issues/109)) ([9c52e30](https://github.com/ublue-os/main/commit/9c52e302741968a0d290a70fb863464bd41fa970))
* new akmods build process ([#87](https://github.com/ublue-os/main/issues/87)) ([f0503ff](https://github.com/ublue-os/main/commit/f0503ffd4ac769e9c38f58adc274e35af9edf50f))
* promote ISO to F38 GA ([#156](https://github.com/ublue-os/main/issues/156)) ([4968d34](https://github.com/ublue-os/main/commit/4968d34aef7a9e4a6c55bfee1e2e2eb8d095e6c1))
* remove xwaylandvideobridge ([#284](https://github.com/ublue-os/main/issues/284)) ([477e15a](https://github.com/ublue-os/main/commit/477e15a26fd0aaf8c75d8ceca90175457a9e256b))
* swap mesa-va-drivers and add ffmpeg for F37 ([#21](https://github.com/ublue-os/main/issues/21)) ([79ede2c](https://github.com/ublue-os/main/commit/79ede2ca5028187e29ee7e5c83275b0eff20e55e))
* switch the latest tag to F38 ([#177](https://github.com/ublue-os/main/issues/177)) ([9aca46a](https://github.com/ublue-os/main/commit/9aca46a742d9128e9b22bfbc5e380f5394ee269a))
* use custom repos provided by akmods ([#236](https://github.com/ublue-os/main/issues/236)) ([efe5364](https://github.com/ublue-os/main/commit/efe53640acc871ed2d60903774577e8a5565672c))
* use tagged release for isogenerator ([#155](https://github.com/ublue-os/main/issues/155)) ([f7d05b4](https://github.com/ublue-os/main/commit/f7d05b4f58096fa87df920523390cfe51774cdee))
* **vauxite:** add xfce4-whiskermenu-plugin ([#293](https://github.com/ublue-os/main/issues/293)) ([ca58833](https://github.com/ublue-os/main/commit/ca588333009d01e40a41d94b6a64dff87490c106))


### Bug Fixes

* add usage instructions ([#40](https://github.com/ublue-os/main/issues/40)) ([3c1db1e](https://github.com/ublue-os/main/commit/3c1db1ed5965b3f1547c3cf5f560273cfa0332e3))
* also build the image variant with the correct name ([#12](https://github.com/ublue-os/main/issues/12)) ([a5fde3b](https://github.com/ublue-os/main/commit/a5fde3b9edb2ad3c04e0af25b4f2e3a5c1ebadc4))
* Be selective in which kmods are brought into main. ([#278](https://github.com/ublue-os/main/issues/278)) ([aac58b0](https://github.com/ublue-os/main/commit/aac58b0480d8c8a0a44aae1882e2288547a0fde1))
* bump isogenerator dep and regen ISOs ([#222](https://github.com/ublue-os/main/issues/222)) ([b3d690b](https://github.com/ublue-os/main/commit/b3d690b338e32d28210e00112973e15797cf6749))
* bump isogenerator to 1.2.0 ([#167](https://github.com/ublue-os/main/issues/167)) ([2a46e49](https://github.com/ublue-os/main/commit/2a46e49765fea7683278f74e1d2eb6fe2b3b9ff4))
* delete changelog to unstick release-please action ([#100](https://github.com/ublue-os/main/issues/100)) ([6dc1d80](https://github.com/ublue-os/main/commit/6dc1d808d8cdb33e912926a587c843b3a9d9c993))
* image name and description variable interpolation ([#37](https://github.com/ublue-os/main/issues/37)) ([7f922c9](https://github.com/ublue-os/main/commit/7f922c9343878ceb9a09bba0126ed55e19edc23a))
* keep IMAGE_NAME and set it once ([#13](https://github.com/ublue-os/main/issues/13)) ([85b152e](https://github.com/ublue-os/main/commit/85b152ec097f3be9b15a87b39bffa7ba022ba968))
* kick off an iso build ([#114](https://github.com/ublue-os/main/issues/114)) ([1ce2350](https://github.com/ublue-os/main/commit/1ce235014932000625c47f6a89319647e37a190e))
* kick off ISO build ([#119](https://github.com/ublue-os/main/issues/119)) ([95a5651](https://github.com/ublue-os/main/commit/95a5651a205e9839f76d0fbcd5bcdf7c3351ded9))
* kick off ISO build ([#159](https://github.com/ublue-os/main/issues/159)) ([7c9e430](https://github.com/ublue-os/main/commit/7c9e43008eb65a6af6ed1c69a3c08dfbc819ba63))
* kick off ISO build ([#217](https://github.com/ublue-os/main/issues/217)) ([fe67565](https://github.com/ublue-os/main/commit/fe675656ad5e7fae24849eb8af200bbd6cf8a588))
* **Kinoite:** Remove Discover rpm-ostree plugin ([#282](https://github.com/ublue-os/main/issues/282)) ([7a011ff](https://github.com/ublue-os/main/commit/7a011ff719e351ee53ccb3da27fe4083e0423028))
* maintain the current oci version label ([#89](https://github.com/ublue-os/main/issues/89)) ([be7faed](https://github.com/ublue-os/main/commit/be7faeda71ca2a96e0471d0fada59052b8db3c3d))
* make intro text more clear ([#128](https://github.com/ublue-os/main/issues/128)) ([5c8567d](https://github.com/ublue-os/main/commit/5c8567d72f8ad5ba68c2e20a04ab10a72df40980))
* ostree automatic updates not enabled ([#48](https://github.com/ublue-os/main/issues/48)) ([b508c02](https://github.com/ublue-os/main/commit/b508c02b0200846a50e62d31479d7ba83b424b00))
* PRs won't push to registry ([8d21213](https://github.com/ublue-os/main/commit/8d212133ec05899d1ae1e35f2de5a730a55b1364))
* README line fix ([#135](https://github.com/ublue-os/main/issues/135)) ([35cd1c0](https://github.com/ublue-os/main/commit/35cd1c079aeec5a25dca57d2e73d1abd83ace3e2))
* Readme update ([#74](https://github.com/ublue-os/main/issues/74)) ([e290cbf](https://github.com/ublue-os/main/commit/e290cbfd0503598994cc7fee18dde883373783a2))
* remove standalone date tag ([#80](https://github.com/ublue-os/main/issues/80)) ([edb67aa](https://github.com/ublue-os/main/commit/edb67aa48326ac59891e8e28779c0d2b05a92f0f))
* removed the matrix ([#116](https://github.com/ublue-os/main/issues/116)) ([89b1a5e](https://github.com/ublue-os/main/commit/89b1a5e8c23b415b0cf5e49256721bb9252bca1d))
* rename README.mdlol to README.md ([#219](https://github.com/ublue-os/main/issues/219)) ([5548e8f](https://github.com/ublue-os/main/commit/5548e8fd8b1b2585dbfb6b07a498c716c7b7521e))
* Reorder und add more info about distrobox to README ([#73](https://github.com/ublue-os/main/issues/73)) ([f8bf5bd](https://github.com/ublue-os/main/commit/f8bf5bdac57f777050da058b7590339254847467))
* Revert to older version of ostree to fix Flatpak installations ([#261](https://github.com/ublue-os/main/issues/261)) ([0859834](https://github.com/ublue-os/main/commit/0859834454591a4b231a710e491825c08391235d))
* split variant builds to their own registry ([#11](https://github.com/ublue-os/main/issues/11)) ([17da43c](https://github.com/ublue-os/main/commit/17da43c69d2850501ae611370e8890f02d44de2b))
* temporarily disable mesa-va-drivers-freeworld for f38 ([#163](https://github.com/ublue-os/main/issues/163)) ([73a10d0](https://github.com/ublue-os/main/commit/73a10d02c7b814cb382823c1571c97a86309e22a))
* update ISOs ([#133](https://github.com/ublue-os/main/issues/133)) ([728f7d6](https://github.com/ublue-os/main/commit/728f7d6e71b7360355f8bb86e85371f28408c289))
* update readme a bit ([#148](https://github.com/ublue-os/main/issues/148)) ([1ca2aaa](https://github.com/ublue-os/main/commit/1ca2aaacf9291f8dca28c5dd189192386be1db36))
* update readme to kick off build ([#121](https://github.com/ublue-os/main/issues/121)) ([83186eb](https://github.com/ublue-os/main/commit/83186eb1dd72c5cc5903b8ba308cbcb5a96e7ff7))
* update readme to kick off iso ([#125](https://github.com/ublue-os/main/issues/125)) ([7fc2dbf](https://github.com/ublue-os/main/commit/7fc2dbf454e2a5aa7184c8bc968bf9196dc9bfcc))
* update to cosign 2.0 and pin install ([#10](https://github.com/ublue-os/main/issues/10)) ([4fbe168](https://github.com/ublue-os/main/commit/4fbe1688e9dce81efd9597bcd46caaf75945f7d3))
* upgrade container to 38 ([#118](https://github.com/ublue-os/main/issues/118)) ([cf607b4](https://github.com/ublue-os/main/commit/cf607b4627082b25ea81e511ad96c2ef70ef66b3))


### Reverts

* "fix: Revert to older version of ostree to fix Flatpak installations ([#261](https://github.com/ublue-os/main/issues/261))" ([#265](https://github.com/ublue-os/main/issues/265)) ([f2c2a31](https://github.com/ublue-os/main/commit/f2c2a314b57b585c467ebc6bbbb40febfd40a11f))
* "fix: temporarily disable mesa-va-drivers-freeworld for f38" ([#166](https://github.com/ublue-os/main/issues/166)) ([32b29ac](https://github.com/ublue-os/main/commit/32b29ac8299919b2e97e16058a6c94e66410ef10))
* "revert: "fix: Revert to older version of ostree to fix Flatpak installations ([#261](https://github.com/ublue-os/main/issues/261))"" ([#266](https://github.com/ublue-os/main/issues/266)) ([36711fa](https://github.com/ublue-os/main/commit/36711fa635afba4dcb2be667fadc96a8d9feeb48))

## [1.8.0](https://github.com/ublue-os/main/compare/v1.7.0...v1.8.0) (2023-08-11)


### Features

* **vauxite:** add xfce4-whiskermenu-plugin ([#293](https://github.com/ublue-os/main/issues/293)) ([ca58833](https://github.com/ublue-os/main/commit/ca588333009d01e40a41d94b6a64dff87490c106))

## [1.7.0](https://github.com/ublue-os/main/compare/v1.6.0...v1.7.0) (2023-08-08)


### Features

* Add alsa-firmware package needed for some sound cards ([#270](https://github.com/ublue-os/main/issues/270)) ([0eb781b](https://github.com/ublue-os/main/commit/0eb781b117f90437ab68eeee442bdffbf0d966b0))
* add clipman for sericea ([#273](https://github.com/ublue-os/main/issues/273)) ([09c59b5](https://github.com/ublue-os/main/commit/09c59b5ec03c49d8c34f8344d87e5ddbdca8e217))
* remove xwaylandvideobridge ([#284](https://github.com/ublue-os/main/issues/284)) ([477e15a](https://github.com/ublue-os/main/commit/477e15a26fd0aaf8c75d8ceca90175457a9e256b))


### Bug Fixes

* Be selective in which kmods are brought into main. ([#278](https://github.com/ublue-os/main/issues/278)) ([aac58b0](https://github.com/ublue-os/main/commit/aac58b0480d8c8a0a44aae1882e2288547a0fde1))
* **Kinoite:** Remove Discover rpm-ostree plugin ([#282](https://github.com/ublue-os/main/issues/282)) ([7a011ff](https://github.com/ublue-os/main/commit/7a011ff719e351ee53ccb3da27fe4083e0423028))

## [1.6.0](https://github.com/ublue-os/main/compare/v1.5.0...v1.6.0) (2023-06-30)


### Features

* add libheif-freeworld & heif-pixbuf-loader ([#255](https://github.com/ublue-os/main/issues/255)) ([5f21453](https://github.com/ublue-os/main/commit/5f2145300d11d2c844ce73df13f6a53520655c6e))
* Add libheif-tools ([#253](https://github.com/ublue-os/main/issues/253)) ([8703dc8](https://github.com/ublue-os/main/commit/8703dc8c3ab6c63237e2e3d948796d7e3fe67919))
* add some indonesian fonts ([#248](https://github.com/ublue-os/main/issues/248)) ([abfc70d](https://github.com/ublue-os/main/commit/abfc70d21cc9ea97b839564fe959587e0dbb7fef))
* add wireguard-tools ([#241](https://github.com/ublue-os/main/issues/241)) ([44cb522](https://github.com/ublue-os/main/commit/44cb522091433b2e1e4a84f4bdac4ea592e353b0))
* Fix inconsistent thumbnails across images ([#262](https://github.com/ublue-os/main/issues/262)) ([3fc9c69](https://github.com/ublue-os/main/commit/3fc9c69b7c3d4f8571eebc0788a1a7015e5bdfe0))
* KDE QoL additions ([#259](https://github.com/ublue-os/main/issues/259)) ([a2a561e](https://github.com/ublue-os/main/commit/a2a561e57ace78d975e33c07232e21d50e79df45))


### Bug Fixes

* Revert to older version of ostree to fix Flatpak installations ([#261](https://github.com/ublue-os/main/issues/261)) ([0859834](https://github.com/ublue-os/main/commit/0859834454591a4b231a710e491825c08391235d))


### Reverts

* "fix: Revert to older version of ostree to fix Flatpak installations ([#261](https://github.com/ublue-os/main/issues/261))" ([#265](https://github.com/ublue-os/main/issues/265)) ([f2c2a31](https://github.com/ublue-os/main/commit/f2c2a314b57b585c467ebc6bbbb40febfd40a11f))
* "revert: "fix: Revert to older version of ostree to fix Flatpak installations ([#261](https://github.com/ublue-os/main/issues/261))"" ([#266](https://github.com/ublue-os/main/issues/266)) ([36711fa](https://github.com/ublue-os/main/commit/36711fa635afba4dcb2be667fadc96a8d9feeb48))

## [1.5.0](https://github.com/ublue-os/main/compare/v1.4.2...v1.5.0) (2023-05-31)


### Features

* add `lshw` (issue [#225](https://github.com/ublue-os/main/issues/225)) ([#230](https://github.com/ublue-os/main/issues/230)) ([5501e3c](https://github.com/ublue-os/main/commit/5501e3c008aaed027c2bbfc25c3a952a2500db4d))
* add cinnamon image to iso ([#237](https://github.com/ublue-os/main/issues/237)) ([d6d98a2](https://github.com/ublue-os/main/commit/d6d98a238a2d6f9702d428de5ef94011df6a4a3e))
* add xwaylandvideobridge ([#232](https://github.com/ublue-os/main/issues/232)) ([ef29a6b](https://github.com/ublue-os/main/commit/ef29a6bbfc4edd28bebef63994f8a6ab922818a1))
* align packagelist with fedora workstation ([#235](https://github.com/ublue-os/main/issues/235)) ([fe48ba8](https://github.com/ublue-os/main/commit/fe48ba84a061ef193285830f72c95d3f71c7a496))
* enable ublue-os akmods ([#234](https://github.com/ublue-os/main/issues/234)) ([df93c4f](https://github.com/ublue-os/main/commit/df93c4f17fe4262dad7e59233097513c734cc007))
* use custom repos provided by akmods ([#236](https://github.com/ublue-os/main/issues/236)) ([efe5364](https://github.com/ublue-os/main/commit/efe53640acc871ed2d60903774577e8a5565672c))

## [1.4.2](https://github.com/ublue-os/main/compare/v1.4.1...v1.4.2) (2023-05-20)


### Bug Fixes

* bump isogenerator dep and regen ISOs ([#222](https://github.com/ublue-os/main/issues/222)) ([b3d690b](https://github.com/ublue-os/main/commit/b3d690b338e32d28210e00112973e15797cf6749))
* rename README.mdlol to README.md ([#219](https://github.com/ublue-os/main/issues/219)) ([5548e8f](https://github.com/ublue-os/main/commit/5548e8fd8b1b2585dbfb6b07a498c716c7b7521e))

## [1.4.1](https://github.com/ublue-os/main/compare/v1.4.0...v1.4.1) (2023-05-19)


### Bug Fixes

* kick off ISO build ([#217](https://github.com/ublue-os/main/issues/217)) ([fe67565](https://github.com/ublue-os/main/commit/fe675656ad5e7fae24849eb8af200bbd6cf8a588))

## [1.4.0](https://github.com/ublue-os/main/compare/v1.3.3...v1.4.0) (2023-05-17)


### Features

* add adw-gtk3-theme for Silverblue ([#204](https://github.com/ublue-os/main/issues/204)) ([3aa1345](https://github.com/ublue-os/main/commit/3aa1345d46507a4158ff7df29cbb92b186c89b4b))
* add kernel-tools ([#208](https://github.com/ublue-os/main/issues/208)) ([b2d0b07](https://github.com/ublue-os/main/commit/b2d0b0795067de0630ef4f64a3471dda5d33e5d9))
* add openrgb udev rules ([#197](https://github.com/ublue-os/main/issues/197)) ([a95ec2d](https://github.com/ublue-os/main/commit/a95ec2d42e059eb3595f31b5c1bc8251e1cb0662))
* add podman-compose ([#180](https://github.com/ublue-os/main/issues/180)) ([4eea999](https://github.com/ublue-os/main/commit/4eea999b5771d438e819735b9f000b9d0b4ef27c))
* add tmux ([#190](https://github.com/ublue-os/main/issues/190)) ([c5491b9](https://github.com/ublue-os/main/commit/c5491b9a903be6eb5311e01c9dbefc638c3567d9))
* add xfce4-clipman-plugin to vauxite ([#182](https://github.com/ublue-os/main/issues/182)) ([5a7a820](https://github.com/ublue-os/main/commit/5a7a820180dd878b9be8bc2729ba3c51c2e3594d))
* new akmods build process ([#87](https://github.com/ublue-os/main/issues/87)) ([f0503ff](https://github.com/ublue-os/main/commit/f0503ffd4ac769e9c38f58adc274e35af9edf50f))
* switch the latest tag to F38 ([#177](https://github.com/ublue-os/main/issues/177)) ([9aca46a](https://github.com/ublue-os/main/commit/9aca46a742d9128e9b22bfbc5e380f5394ee269a))

## [1.3.3](https://github.com/ublue-os/main/compare/v1.3.2...v1.3.3) (2023-04-20)


### Bug Fixes

* bump isogenerator to 1.2.0 ([#167](https://github.com/ublue-os/main/issues/167)) ([2a46e49](https://github.com/ublue-os/main/commit/2a46e49765fea7683278f74e1d2eb6fe2b3b9ff4))

## [1.3.2](https://github.com/ublue-os/main/compare/v1.3.1...v1.3.2) (2023-04-20)


### Bug Fixes

* temporarily disable mesa-va-drivers-freeworld for f38 ([#163](https://github.com/ublue-os/main/issues/163)) ([73a10d0](https://github.com/ublue-os/main/commit/73a10d02c7b814cb382823c1571c97a86309e22a))


### Reverts

* "fix: temporarily disable mesa-va-drivers-freeworld for f38" ([#166](https://github.com/ublue-os/main/issues/166)) ([32b29ac](https://github.com/ublue-os/main/commit/32b29ac8299919b2e97e16058a6c94e66410ef10))

## [1.3.1](https://github.com/ublue-os/main/compare/v1.3.0...v1.3.1) (2023-04-18)


### Bug Fixes

* kick off ISO build ([#159](https://github.com/ublue-os/main/issues/159)) ([7c9e430](https://github.com/ublue-os/main/commit/7c9e43008eb65a6af6ed1c69a3c08dfbc819ba63))

## [1.3.0](https://github.com/ublue-os/main/compare/v1.2.1...v1.3.0) (2023-04-18)


### Features

* promote ISO to F38 GA ([#156](https://github.com/ublue-os/main/issues/156)) ([4968d34](https://github.com/ublue-os/main/commit/4968d34aef7a9e4a6c55bfee1e2e2eb8d095e6c1))
* use tagged release for isogenerator ([#155](https://github.com/ublue-os/main/issues/155)) ([f7d05b4](https://github.com/ublue-os/main/commit/f7d05b4f58096fa87df920523390cfe51774cdee))

## [1.2.1](https://github.com/ublue-os/main/compare/v1.2.0...v1.2.1) (2023-04-15)


### Bug Fixes

* update readme a bit ([#148](https://github.com/ublue-os/main/issues/148)) ([1ca2aaa](https://github.com/ublue-os/main/commit/1ca2aaacf9291f8dca28c5dd189192386be1db36))

## [1.2.0](https://github.com/ublue-os/main/compare/v1.1.8...v1.2.0) (2023-04-12)


### Features

* Include libratbag ([#139](https://github.com/ublue-os/main/issues/139)) ([4dcd439](https://github.com/ublue-os/main/commit/4dcd439c4b0a07c9ed96d6dd96d8a997a092b5b4))

## [1.1.8](https://github.com/ublue-os/main/compare/v1.1.7...v1.1.8) (2023-04-10)


### Bug Fixes

* README line fix ([#135](https://github.com/ublue-os/main/issues/135)) ([35cd1c0](https://github.com/ublue-os/main/commit/35cd1c079aeec5a25dca57d2e73d1abd83ace3e2))

## [1.1.7](https://github.com/ublue-os/main/compare/v1.1.6...v1.1.7) (2023-04-08)


### Bug Fixes

* update ISOs ([#133](https://github.com/ublue-os/main/issues/133)) ([728f7d6](https://github.com/ublue-os/main/commit/728f7d6e71b7360355f8bb86e85371f28408c289))

## [1.1.6](https://github.com/ublue-os/main/compare/v1.1.5...v1.1.6) (2023-04-08)


### Bug Fixes

* make intro text more clear ([#128](https://github.com/ublue-os/main/issues/128)) ([5c8567d](https://github.com/ublue-os/main/commit/5c8567d72f8ad5ba68c2e20a04ab10a72df40980))

## [1.1.5](https://github.com/ublue-os/main/compare/v1.1.4...v1.1.5) (2023-04-07)


### Bug Fixes

* update readme to kick off iso ([#125](https://github.com/ublue-os/main/issues/125)) ([7fc2dbf](https://github.com/ublue-os/main/commit/7fc2dbf454e2a5aa7184c8bc968bf9196dc9bfcc))

## [1.1.4](https://github.com/ublue-os/main/compare/v1.1.3...v1.1.4) (2023-04-07)


### Bug Fixes

* update readme to kick off build ([#121](https://github.com/ublue-os/main/issues/121)) ([83186eb](https://github.com/ublue-os/main/commit/83186eb1dd72c5cc5903b8ba308cbcb5a96e7ff7))

## [1.1.3](https://github.com/ublue-os/main/compare/v1.1.2...v1.1.3) (2023-04-07)


### Bug Fixes

* kick off ISO build ([#119](https://github.com/ublue-os/main/issues/119)) ([95a5651](https://github.com/ublue-os/main/commit/95a5651a205e9839f76d0fbcd5bcdf7c3351ded9))

## [1.1.2](https://github.com/ublue-os/main/compare/v1.1.1...v1.1.2) (2023-04-07)


### Bug Fixes

* removed the matrix ([#116](https://github.com/ublue-os/main/issues/116)) ([89b1a5e](https://github.com/ublue-os/main/commit/89b1a5e8c23b415b0cf5e49256721bb9252bca1d))
* upgrade container to 38 ([#118](https://github.com/ublue-os/main/issues/118)) ([cf607b4](https://github.com/ublue-os/main/commit/cf607b4627082b25ea81e511ad96c2ef70ef66b3))

## [1.1.1](https://github.com/ublue-os/main/compare/v1.1.0...v1.1.1) (2023-04-06)


### Bug Fixes

* kick off an iso build ([#114](https://github.com/ublue-os/main/issues/114)) ([1ce2350](https://github.com/ublue-os/main/commit/1ce235014932000625c47f6a89319647e37a190e))

## [1.1.0](https://github.com/ublue-os/main/compare/v1.0.1...v1.1.0) (2023-04-06)


### Features

* add intel-media-driver ([#98](https://github.com/ublue-os/main/issues/98)) ([9d7f2e2](https://github.com/ublue-os/main/commit/9d7f2e26d39d90eaf38449f8a7bcfda97142f7b3))
* move to a unified ISO for all images ([#109](https://github.com/ublue-os/main/issues/109)) ([9c52e30](https://github.com/ublue-os/main/commit/9c52e302741968a0d290a70fb863464bd41fa970))

## [1.0.1](https://github.com/ublue-os/main/compare/v1.0.0...v1.0.1) (2023-04-02)


### Bug Fixes

* delete changelog to unstick release-please action ([#100](https://github.com/ublue-os/main/issues/100)) ([6dc1d80](https://github.com/ublue-os/main/commit/6dc1d808d8cdb33e912926a587c843b3a9d9c993))
