ostreesetup --osname="fedora" --remote="fedora" --url="https://d2uk5hbyrobdzx.cloudfront.net/" --ref="fedora/37/x86_64/silverblue" --nogpg
url --url="https://download.fedoraproject.org/pub/fedora/linux/releases/37/Everything/x86_64/os/"

%post --logfile=/root/ks-post.log --erroronfail
%end