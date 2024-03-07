%define        ORG          rose-os
%define        CABSDIR      cabs
%define        DOWNLOADSDIR downloads

Name:          %{ORG}-fonts
Packager:      %{ORG}
Vendor:        %{ORG}
Version:       0.1
Release:       1%{?dist}
Summary:       Add extra fonts for for rose-os
License:       MIT
URL:           https://github.com/jostone-stone/rose-os
BuildArch:     noarch

BuildRequires: cabextract
Requires:      fontconfig

%define        FONTSDIR     %{buildroot}%{_datadir}/fonts/%{NAME}

%description
Add additional fonts not available in Fedora repos

%prep

%build

URLS=(
    https://sourceforge.net/projects/corefonts/files/the%20fonts/final/andale32.exe
    https://sourceforge.net/projects/corefonts/files/the%20fonts/final/arialb32.exe
    https://sourceforge.net/projects/corefonts/files/the%20fonts/final/comic32.exe
    https://sourceforge.net/projects/corefonts/files/the%20fonts/final/courie32.exe
    https://sourceforge.net/projects/corefonts/files/the%20fonts/final/georgi32.exe
    https://sourceforge.net/projects/corefonts/files/the%20fonts/final/impact32.exe
    https://sourceforge.net/projects/corefonts/files/the%20fonts/final/webdin32.exe
    https://sourceforge.net/projects/mscorefonts2/files/cabs/EUupdate.EXE
    https://sourceforge.net/projects/corefonts/files/the%20fonts/final/wd97vwr32.exe
    https://sourceforge.net/projects/mscorefonts2/files/cabs/PowerPointViewer.exe
)

cat << EOL > downloads.sha256sum
6b87cd7e67d45f9fcfece7a834a0cbf6afee2ccdaec3438e93d031b3cda5c6d5  %{CABSDIR}/ppviewer.cab
b4212c25d40b992b5fb341794d5b0e90108943e99c35e54b064622da684f570b  %{CABSDIR}/viewer1.cab
0524fe42951adc3a7eb870e32f0920313c71f170c859b5f770d82b4ee111e970  %{DOWNLOADSDIR}/andale32.exe
a425f0ffb6a1a5ede5b979ed6177f4f4f4fdef6ae7c302a7b7720ef332fec0a8  %{DOWNLOADSDIR}/arialb32.exe
9c6df3feefde26d4e41d4a4fe5db2a89f9123a772594d7f59afd062625cd204e  %{DOWNLOADSDIR}/comic32.exe
bb511d861655dde879ae552eb86b134d6fae67cb58502e6ff73ec5d9151f3384  %{DOWNLOADSDIR}/courie32.exe
464dd2cd5f09f489f9ac86ea7790b7b8548fc4e46d9f889b68d2cdce47e09ea8  %{DOWNLOADSDIR}/EUupdate.EXE
2c2c7dcda6606ea5cf08918fb7cd3f3359e9e84338dc690013f20cd42e930301  %{DOWNLOADSDIR}/georgi32.exe
6061ef3b7401d9642f5dfdb5f2b376aa14663f6275e60a51207ad4facf2fccfb  %{DOWNLOADSDIR}/impact32.exe
c4e753548d3092ffd7dd3849105e0a26d9b5a1afe46e6e667fe7c6887893701f  %{DOWNLOADSDIR}/PowerPointViewer.exe
f61126a6d17b2d126a7f31b142504dce4934f7989c55f1c13c6477b3fe80b3d2  %{DOWNLOADSDIR}/wd97vwr32.exe
64595b5abc1080fba8610c5c34fab5863408e806aafe84653ca8575bed17d75a  %{DOWNLOADSDIR}/webdin32.exe
EOL

mkdir -p "%{CABSDIR}" "%{DOWNLOADSDIR}"

for URL in "${URLS[@]}"; do
    FILE="${URL##*/}"
    wget --verbose "${URL}/download" -O "%{DOWNLOADSDIR}/${FILE}"
    cabextract "%{DOWNLOADSDIR}/${FILE}" --lowercase --filter "*.cab" --directory "%{CABSDIR}"
done

sha256sum --check downloads.sha256sum

%install

cat << EOL > fonts.sha256sum
48d9bc613917709d3b0e0f4a6d4fe33a5c544c5035dffe9e90bc11e50e822071  %{FONTSDIR}/andalemo.ttf
1b551e2d9396970fcf7a9d0b823f8df87f389b18c51f646a4b40701a39463aec  %{FONTSDIR}/arialbd.ttf
e381b167b14c83b499487778a70f523d944445dc37487da3a98c8bc4ede50852  %{FONTSDIR}/arialbi.ttf
a45201fa83c9d4bc0700621609d6609555b76d1b7d868b5f7607c8cd481485b5  %{FONTSDIR}/ariali.ttf
df49c8c8ef30e534ca3e762b157a79aab775f3eeb229706014b0003a994a9b67  %{FONTSDIR}/arial.ttf
dad7c04acb26e23dfe4780e79375ca193ddaf68409317e81577a30674668830e  %{FONTSDIR}/ariblk.ttf
5fc2218b5ef0ca1edabe1e694eb6a710f505c8c865a27e377c79d987a9a336e2  %{FONTSDIR}/calibrib.ttf
fde29212db82cd4bf9e118863561c0295dc55c84cb617041798ce9e7363997b9  %{FONTSDIR}/calibrii.ttf
8316b1b5c1e47aad6220e10c83537cd32704e99e7885aabf56a1d897b3d3f1ee  %{FONTSDIR}/calibri.ttf
7fb57eb4c64f249356bb62e2b84ce4ebeb46b89b2d119a2d0888362a278c07ba  %{FONTSDIR}/calibriz.ttf
0aa76048bde8acfafafa3f59ae94a7bfb6613a74d367b3fcb841cd180a7d7a16  %{FONTSDIR}/cambriab.ttf
fc9a9a90cbd828a22733e1f61f089663b95c7304a7b9beef33e3ee454608b73d  %{FONTSDIR}/cambriai.ttf
4fbab6e3f15a3fa7341a7630865f40aade9068270d3c75ef6633f466eb1a8f60  %{FONTSDIR}/cambriaz.ttf
dccbfb201fce3996776dfb28bc64c8fdb9d8d2aaa077c6964ac3326ef01fb66d  %{FONTSDIR}/candarab.ttf
507cf89bc137dd086b8dbdfeebcdc139d724a206abd2a9cc32c75e9ce6ff2cf3  %{FONTSDIR}/candarai.ttf
e9f66a22402b92c5cd9dfc9c5b4d93f1fbe4fa865841dfe031d33288ab3bb4a8  %{FONTSDIR}/candara.ttf
48c036482be2cd50beb203a424e221a1a82a7f9cd60b00430233fc7ca131cb14  %{FONTSDIR}/candaraz.ttf
873361465d994994762d0b9845c99fc7baa2a600442ea8db713a7dd19f8b0172  %{FONTSDIR}/comicbd.ttf
b82c53776058f291382ff7e008d4675839d2dc21eb295c66391f6fb0655d8fc0  %{FONTSDIR}/comic.ttf
5295a046a10ef96b7050891920212295ee8e86e4dd8177ceb6cf054ec1dba5f1  %{FONTSDIR}/consolab.ttf
9de4ef7b2cb04285224a23c1b7725a80a3852d321a6006b1a22b559cd5450ae9  %{FONTSDIR}/consolai.ttf
5f8d58e719a7d724be036145f506acf38b0942e253a7c331887c7056b93deac8  %{FONTSDIR}/consola.ttf
23b32c48f969e88e430b65a11311393180e2ab95be9309a5b286f473a7899f39  %{FONTSDIR}/consolaz.ttf
66b7706fa9e94a9c2907eefe84a1560b081f5aeea624b73a43043d4a2e817ea9  %{FONTSDIR}/constanb.ttf
8aa9def1b2b1abf0ef3a3095daf11fafd9557d9221b2ff57e52465b24a83812d  %{FONTSDIR}/constani.ttf
735808619bb3f40ea10746aabb2bdea275c7f2c8a00cfeb5d765fcca1c834adb  %{FONTSDIR}/constan.ttf
37a083be091532f379dfdcea441ca3e3a3f4aa30e3d8dcf958fe18134219d5b0  %{FONTSDIR}/constanz.ttf
ee6d7fe208a7285cf93d6a94c4a172500fa5b69f98cc7e94898b120db74d2e8a  %{FONTSDIR}/corbelb.ttf
deeaff659011f0357b2714fe184bafb934708c3f11c70c4a7c607f8809611845  %{FONTSDIR}/corbeli.ttf
b899c4cdc0c7193c37d8d6720afe17b6e2f618a47a3c196e5598f245a1a6942e  %{FONTSDIR}/corbel.ttf
6778c7532967aacd43db63a495003aa5a7d1f0fc04eacc2429961ff50d94c9c0  %{FONTSDIR}/corbelz.ttf
edf8a7c5bfcac2e1fe507faab417137cbddc9071637ef4648238d0768c921e02  %{FONTSDIR}/courbd.ttf
66dbfa20b534fba0e203da140fec7276a45a1069e424b1b9c35547538128bbe8  %{FONTSDIR}/courbi.ttf
f3f6b09855b6700977e214aab5eb9e5be6813976a24f894bd7766e92c732fbe1  %{FONTSDIR}/couri.ttf
6715838c52f813f3821549d3f645db9a768bd6f3a43d8f85a89cb6875a546c61  %{FONTSDIR}/cour.ttf
82d2fbadb88a8632d7f2e8ad50420c9fd2e7d3cbc0e90b04890213a711b34b93  %{FONTSDIR}/georgiab.ttf
1523f19bda6acca42c47c50da719a12dd34f85cc2606e6a5af15a7728b377b60  %{FONTSDIR}/georgiai.ttf
7d0bb20c632bb59e81a0885f573bd2173f71f73204de9058feb68ce032227072  %{FONTSDIR}/georgia.ttf
c983e037d8e4e694dd0fb0ba2e625bca317d67a41da2dc81e46a374e53d0ec8a  %{FONTSDIR}/georgiaz.ttf
00f1fc230ac99f9b97ba1a7c214eb5b909a78660cb3826fca7d64c3af5a14848  %{FONTSDIR}/impact.ttf
bb3e4ca1acd0b9e09aa09617e4dad0a18ae0c34ed384a6fe5985b5310fc042de  %{FONTSDIR}/tahoma.ttf
55b95fc06b6e32ea757fa420163077d8374b8fd8f3be586904203feaa4a19f98  %{FONTSDIR}/timesbd.ttf
0ecfc6ee791cdd71f429ec1afb57486a4a32f8c4796567d384357287c92485f2  %{FONTSDIR}/timesbi.ttf
fb28b821d4f2ea8f8c9441210b1c8b4a26f799288f9ee276ed8efbac529219ca  %{FONTSDIR}/timesi.ttf
3bbe9306646e401914bd337d380ad0e808aa1d0ecde869e3a8097aac48a56a7f  %{FONTSDIR}/times.ttf
7fea7f91f1140721bd7837a36ed2b1c856215f3ac08e6d2eb29c1afe235d0900  %{FONTSDIR}/trebucbd.ttf
d374f4cc7819ad7a57204543b5ab01aa1580725bf2571eb66a25155216d90f3b  %{FONTSDIR}/trebucbi.ttf
3f1d76cbf72de8cf7afbb6c4f3fcce5e5e89b92c8647310908aa42c44bd29b5c  %{FONTSDIR}/trebucit.ttf
b69a5b33e997c3bc55f35dde8267cb93fe5fbdc3ecbc23b1d987602a9fd2b1f2  %{FONTSDIR}/trebuc.ttf
5839c5f5e550e3b1c7059a11b8be0064ee61bf3eb26dc6aae7f3fd5491533aec  %{FONTSDIR}/verdanab.ttf
1b323c7f64258f7e0a3b97101569af8dd49f09a4c7c08ad3864719a821a7545b  %{FONTSDIR}/verdanai.ttf
c74da119f4e6e9eae27feb637aa1cc6e696929d17d04ff84f93e5aeedee5fd84  %{FONTSDIR}/verdana.ttf
6f1570e0b419d4afc36959f6429e542ab42ee9d255366cd77e16e50abe9b5386  %{FONTSDIR}/verdanaz.ttf
10d099c88521b1b9e380b7690cbe47b54bb19396ca515358cfdc15ac249e2f5d  %{FONTSDIR}/webdings.ttf
EOL

mkdir -p "%{FONTSDIR}"

find "%{CABSDIR}" "%{DOWNLOADSDIR}"  -type f -exec cabextract {} --lowercase --filter "*.ttf" --directory "%{FONTSDIR}" \;
sha256sum --check fonts.sha256sum

%clean
rm -rf "%{CABSDIR}" "%{DOWNLOADDIR}" 

%post
fc-cache --verbose --really-force --system-only

%postun
fc-cache --verbose --really-force --system-only

%files
%attr(0644,root,root) %{_datadir}/fonts/%{NAME}/*.ttf

%changelog
* Thu Mar 7 2024  Joshua Stone <joshua.gage.stone@gmail.com> 0.1
- Add corefonts and mscorefonts2 files
