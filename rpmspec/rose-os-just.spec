Name:           rose-os-just
Packager:       rose-os
Vendor:         rose-os
Version:        0.2
Release:        1%{?dist}
Summary:        Justfile support for rose-os
License:        MIT
URL:            https://github.com/jostone-stone/rose-os

BuildArch:      noarch

Source0:        rose-os-just.sh
Source1:        flatpak-apps.txt
Source2:        justfile
Source3:        setup-flatpak-apps.sh

%global sub_name %{lua:t=string.gsub(rpm.expand("%{NAME}"), "^rose%-os%-", ""); print(t)}

%description
Adds justfiles to rose-os images

%prep
%setup -q -c -T

%build
install -Dm0755 %{SOURCE0} %{buildroot}%{_exec_prefix}/etc/profile.d/rose-os-just.sh
install -Dm0644 %{SOURCE1} %{buildroot}%{_exec_prefix}/share/rose-os/flatpak-apps.txt
install -Dm0644 %{SOURCE2} %{buildroot}%{_exec_prefix}/share/rose-os/justfile
install -Dm0755 %{SOURCE3} %{buildroot}%{_exec_prefix}/share/rose-os/just/setup-flatpak-apps.sh

%files
%attr(0755,root,root) %{_exec_prefix}/etc/profile.d/rose-os-just.sh
%attr(0644,root,root) %{_exec_prefix}/share/rose-os/flatpak-apps.txt
%attr(0644,root,root) %{_exec_prefix}/share/rose-os/justfile
%attr(0755,root,root) %{_exec_prefix}/share/rose-os/just/setup-flatpak-apps.sh


%changelog
* Sat Apr 13 2024 Joshua Stone <joshua.gage.stone@gmail.com> - 0.2
- Split up files into separate sources to work around tar permission issue

* Fri Feb 16 2024 Joshua Stone <joshua.gage.stone@gmail.com> - 0.1
- Add package for justfiles
