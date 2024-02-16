Name:           rose-os-just
Packager:       rose-os
Vendor:         rose-os
Version:        0.1
Release:        1%{?dist}
Summary:        Justfile support for rose-os
License:        MIT
URL:            https://github.com/jostone-stone/rose-os

BuildArch:      noarch

Source0:        rose-os-just.tar.gz

%global sub_name %{lua:t=string.gsub(rpm.expand("%{NAME}"), "^rose%-os%-", ""); print(t)}

%description
Adds justfiles to rose-os images

%prep
%setup -q -c -T

%build
mkdir -p -m0755 %{buildroot}%{_datadir}/%{VENDOR}
mkdir -p -m0755 %{buildroot}%{_exec_prefix}/etc/profile.d
mkdir -p -m0755 %{buildroot}%{_exec_prefix}/usr/share/rose-os/just

tar xf %{SOURCE0} -C %{buildroot} --strip-components=2

%files
%attr(0755,root,root) %{_exec_prefix}/etc/profile.d/rose-os-just.sh
%attr(0644,root,root) %{_exec_prefix}/share/rose-os/flatpak-apps.txt
%attr(0644,root,root) %{_exec_prefix}/share/rose-os/justfile
%attr(0755,root,root) %{_exec_prefix}/share/rose-os/just/setup-flatpak-apps.sh


%changelog
* Fri Feb 16 2024 Joshua Stone <joshua.gage.stone@gmail.com> - 0.1
- Add package for justfiles
