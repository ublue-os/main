Name:           rose-os-signing
Packager:       rose-os
Vendor:         rose-os
Version:        0.3
Release:        1%{?dist}
Summary:        Signing files and keys for rose-os
License:        MIT
URL:            https://github.com/jostone-stone/rose-os

BuildArch:      noarch

Source0:        policy.json
Source1:        rose-os.yaml
Source2:        rose-os.pub
Source3:        RPM-GPG-KEY-rose-os

%global sub_name %{lua:t=string.gsub(rpm.expand("%{NAME}"), "^rose%-os%-", ""); print(t)}

%description
Adds files and keys for signing rose-os images

%prep
%setup -q -c -T

%build
install -Dm644 %{SOURCE1} %{buildroot}%{_datadir}/%{VENDOR}/%{sub_name}/%{_exec_prefix}/etc/containers/policy.json
install -Dm644 %{SOURCE1} %{buildroot}%{_datadir}/%{VENDOR}/%{sub_name}/%{_exec_prefix}/etc/containers/registries.d/rose-os.yaml
install -Dm644 %{SOURCE2} %{buildroot}%{_datadir}/%{VENDOR}/%{sub_name}/%{_exec_prefix}/etc/pki/containers/rose-os.pub
install -Dm644 %{SOURCE3} %{buildroot}%{_datadir}/%{VENDOR}/%{sub_name}/%{_exec_prefix}/etc/pki/rpm-gpg/RPM-GPG-KEY-rose-os

install -Dm644 %{SOURCE1} %{buildroot}%{_exec_prefix}/etc/containers/policy.json
install -Dm644 %{SOURCE1} %{buildroot}%{_exec_prefix}/etc/containers/registries.d/rose-os.yaml
install -Dm644 %{SOURCE2} %{buildroot}%{_exec_prefix}/etc/pki/containers/rose-os.pub
install -Dm644 %{SOURCE3} %{buildroot}%{_exec_prefix}/etc/pki/rpm-gpg/RPM-GPG-KEY-rose-os

%files
%dir %attr(0755,root,root) %{_datadir}/%{VENDOR}/%{sub_name}
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/%{_exec_prefix}/etc/containers/policy.json
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/%{_exec_prefix}/etc/containers/registries.d/rose-os.yaml
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/%{_exec_prefix}/etc/pki/containers/rose-os.pub
%attr(0644,root,root) %{_datadir}/%{VENDOR}/%{sub_name}/%{_exec_prefix}/etc/pki/rpm-gpg/RPM-GPG-KEY-rose-os
%attr(0644,root,root) %{_exec_prefix}/etc/containers/policy.json
%attr(0644,root,root) %{_exec_prefix}/etc/containers/registries.d/rose-os.yaml
%attr(0644,root,root) %{_exec_prefix}/etc/pki/containers/rose-os.pub
%attr(0644,root,root) %{_exec_prefix}/etc/pki/rpm-gpg/RPM-GPG-KEY-rose-os


%changelog
* Sat Apr 13 2024 Joshua Stone <joshua.gage.stone@gmail.com> - 0.3
- Split up files into separate sources to work around tar permission issue

* Fri Feb 9 2024 Joshua Stone <joshua.gage.stone@gmail.com> - 0.2
- Add GPG key for signing RPMs

* Fri Feb 9 2024 Joshua Stone <joshua.gage.stone@gmail.com> - 0.1
- Add package for signing files and keys
