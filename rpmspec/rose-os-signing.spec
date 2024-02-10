Name:           rose-os-signing
Packager:       rose-os
Vendor:         rose-os
Version:        0.2
Release:        1%{?dist}
Summary:        Signing files and keys for rose-os
License:        MIT
URL:            https://github.com/jostone-stone/rose-os

BuildArch:      noarch

Source0:        rose-os-signing.tar.gz

%global sub_name %{lua:t=string.gsub(rpm.expand("%{NAME}"), "^rose%-os%-", ""); print(t)}

%description
Adds files and keys for signing rose-os images

%prep
%setup -q -c -T

%build
mkdir -p -m0755 %{buildroot}%{_datadir}/%{VENDOR}
mkdir -p -m0755 %{buildroot}%{_exec_prefix}/etc/containers/registries.d
mkdir -p -m0755 %{buildroot}%{_exec_prefix}/etc/pki/rpm-gpg

tar xf %{SOURCE0} -C %{buildroot}%{_datadir}/%{VENDOR} --strip-components=1
tar xf %{SOURCE0} -C %{buildroot} --strip-components=2

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
* Fri Feb 9 2024 Joshua Stone <joshua.gage.stone@gmail.com> - 0.2
- Add GPG key for signing RPMs

* Fri Feb 9 2024 Joshua Stone <joshua.gage.stone@gmail.com> - 0.1
- Add package for signing files and keys
