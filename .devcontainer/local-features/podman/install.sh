#!/usr/bin/bash

set -e

USERNAME="${USERNAME:-"{_REMOTE_USER:-"automatic"}"}"

mkdir -p /usr/local/bin

if [ "$(id -u)" -ne 0 ]; then
    echo '(!) Script must be run as root.' >&2
    exit 1
fi

# Username
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
        if id -u "${CURRENT_USER}" >/dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u "${USERNAME}" >/dev/null 2>&1; then
    USERNAME=root
fi

dnf5 install -y \
    fuse-overlayfs \
    podman \
    podman-machine \
    podman-remote

dnf5 install --setopt=install_weak_deps=False -y \
    docker-buildx \
    docker-cli \
    docker-compose

# Usually only have 65536 within rootless podman
rm -f /etc/sub{u,g}id
echo "$USERNAME:50000:10000" >/etc/subuid
echo "$USERNAME:50000:10000" >/etc/subgid
chmod u+s /usr/bin/new{u,g}idmap

mkdir -p "/home/$USERNAME/.local/share/containers/"
chown "$USERNAME:$USERNAME" -R "/home/$USERNAME/"

mkdir -p /usr/local/share
tee /usr/local/share/podman-in-podman-init.sh >/dev/null <<'EOF'
#!/usr/bin/env bash

set -e

podman_start="$(cat << 'INNEREOF'
    # -- Start: dind wrapper script --
    # Maintained: https://github.com/moby/moby/blob/master/hack/dind

    # Using Podman
    export container=podman

    if [ -d /sys/kernel/security ] && ! mountpoint -q /sys/kernel/security; then
        mount -t securityfs none /sys/kernel/security || {
            echo >&2 'Could not mount /sys/kernel/security.'
            echo >&2 'AppArmor detection and --privileged mode might break.'
        }
    fi

    # Mount /tmp (conditionally)
    if ! mountpoint -q /tmp; then
        mount -t tmpfs none /tmp
    fi

    set_cgroup_nesting()
    {
        # cgroup v2: enable nesting
        if [ -f /sys/fs/cgroup/cgroup.controllers ]; then
            # move the processes from the root group to the /init group,
            # otherwise writing subtree_control fails with EBUSY.
            # An error during moving non-existent process (i.e., "cat") is ignored.
            mkdir -p /sys/fs/cgroup/init
            xargs -rn1 < /sys/fs/cgroup/cgroup.procs > /sys/fs/cgroup/init/cgroup.procs || :
            # enable controllers
            sed -e 's/ / +/g' -e 's/^/+/' < /sys/fs/cgroup/cgroup.controllers \
                > /sys/fs/cgroup/cgroup.subtree_control
        fi
    }

    # Set cgroup nesting, retrying if necessary
    retry_cgroup_nesting=0

    until [ "${retry_cgroup_nesting}" -eq "5" ];
    do
        set +e
            set_cgroup_nesting

            if [ $? -ne 0 ]; then
                echo "(*) cgroup v2: Failed to enable nesting, retrying..."
            else
                break
            fi

            retry_cgroup_nesting=`expr $retry_cgroup_nesting + 1`
        set -e
    done
    # -- End: dind wrapper script --
INNEREOF
)"

sudo_if() {
    COMMAND="$*"

    if [ "$(id -u)" -ne 0 ]; then
        sudo $COMMAND
    else
        $COMMAND
    fi
}

if [ "$(id -u)" -ne 0 ]; then
    sudo_if sh -c "$podman_start"
else
    eval "$podman_start"
fi

# Work for Podman in Docker
sudo_if mount --make-rshared / || true

# Make any user able to create XDG_RUNTIME_DIR
sudo_if chmod 777 /run/user

# Don't Block
exec "$@"
EOF

tee -a /etc/bashrc >/dev/null <<'EOF'
# Bind Mount Volume to User. Podman Unshare works.

if [ "$(id -u)" -ne 0 ]; then
    if [ ! -O "/srv/containers" ]; then
        sudo chown "$USERNAME:$USERNAME" /srv/containers || true
    fi
    if ! mountpoint -q "/home/$USERNAME/.local/share/containers"; then
        sudo mount --bind /srv/containers "/home/$USERNAME/.local/share/containers" || true
    fi
fi
EOF

chmod +x /usr/local/share/podman-in-podman-init.sh
chown "$USERNAME:root" /usr/local/share/podman-in-podman-init.sh

dnf5 clean all
