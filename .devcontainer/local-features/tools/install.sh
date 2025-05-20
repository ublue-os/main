#!/usr/bin/bash

set -e

dnf5 install -y \
    ShellCheck \
    dosfstools \
    erofs-utils \
    fd \
    gh \
    glibc-langpack-en \
    grub2 \
    grub2-efi \
    grub2-tools \
    grub2-tools-extra \
    npm \
    openssl \
    ripgrep \
    sbsigntools \
    shfmt \
    shim \
    skopeo \
    socat \
    squashfs-tools \
    tmux \
    xorriso \
    yamllint \
    yq \
    zstd

# TODO: Handle arm64
dnf5 install -y \
    grub2-efi-x64 \
    grub2-efi-x64-cdboot \
    grub2-efi-x64-modules

mkdir -p /usr/local/bin
npm install -g \
    dockerfile-language-server-nodejs \
    neo-bash-ls \
    pyright \
    tldr \
    vscode-langservers-extracted \
    yaml-language-server

# TODO: Handle arm64
# just
while [[ -z "${JUST:-}" || "${JUST:-}" == "null" ]]; do
    JUST="$(curl -Ls https://api.github.com/repos/casey/just/releases/latest | jq -r '.assets[] | select(.name | test(".*x86_64-unknown-linux-musl.*gz")).browser_download_url')" || (true && sleep 30)
done
curl --retry 3 -L# "$JUST" | tar -xz -C /usr/local/bin/
# eza
while [[ -z "${EZA:-}" || "${EZA:-}" == "null" ]]; do
    EZA="$(curl -Ls https://api.github.com/repos/eza-community/eza/releases/latest | jq -r '.assets[] | select(.name | test(".*x86_64-unknown-linux-gnu.*gz")).browser_download_url')" || (true && sleep 5)
done
curl --retry 3 -L# "$EZA" | tar -xz -C /usr/local/bin/

# cosign
while [[ -z "${COSIGN:-}" || "${COSIGN}" == "null" ]]; do
    COSIGN="$(curl -Ls https://api.github.com/repos/sigstore/cosign/releases/latest | jq -r '.assets[] | select(.name | test(".*-linux-amd64$")).browser_download_url')" || (true && sleep 5)
done
curl --retry 3 -L#o /usr/local/bin/cosign "$COSIGN"
chmod +x /usr/local/bin/cosign

# dockerfmt
while [[ -z "${DOCKER_FMT:-}" || "${DOCKER_FMT:-}" == "null" ]]; do
    DOCKER_FMT="$(curl -Ls https://api.github.com/repos/reteps/dockerfmt/releases/latest | jq -r '.assets[] | select(.name| test(".*linux-amd64.*gz$")).browser_download_url')" || (true && sleep 5)
done
curl --retry 3 -L# "$DOCKER_FMT" | tar -xz -C /usr/local/bin/
ln -sf /usr/local/bin/dockerfmt /usr/local/bin/dockfmt
dockerfmt completion bash >/etc/bash_completion.d/dockerfmt

# Emacs LSP Booster (the superior editor with too many flaws)
while [[ -z "${EMACS_LSP_BOOSTER:-}" || "${EMACS_LSP_BOOSTER:-}" == "null" ]]; do
    EMACS_LSP_BOOSTER="$(curl -Ls https://api.github.com/repos/blahgeek/emacs-lsp-booster/releases/latest | jq -r '.assets[] | select(.name| test(".*musl.zip$")).browser_download_url')" || (true && sleep 5)
done
curl --retry 3 -L#o /tmp/emacs-lsp-booster.zip "$EMACS_LSP_BOOSTER"
unzip -d /usr/local/bin/ /tmp/emacs-lsp-booster.zip
rm -f /tmp/emacs-lsp-booster.zip

# syft
while [[ -z "${SYFT:-}" || "${SYFT:-}" == "null" ]]; do
    SYFT="$(curl -Ls https://api.github.com/repos/anchore/syft/releases/latest | jq -r '.assets[] | select(.name | test(".*_linux_amd64.*gz$")).browser_download_url')" || (true && sleep 5)
done
curl --retry 3 -L# "$SYFT" | tar -xz -C /usr/local/bin/

# yamlfmt
while [[ -z "${YAMLFMT:-}" || "${YAMLFMT:-}" == "null" ]]; do
    YAMLFMT="$(curl -Ls https://api.github.com/repos/google/yamlfmt/releases/latest | jq -r '.assets[] | select(.name | test(".*_Linux_x86_64.*gz$")).browser_download_url')" || (true && sleep 5)
done
curl --retry 3 -L# "${YAMLFMT}" | tar -xz -C /usr/local/bin/

tee -a /etc/bashrc >/dev/null <<'EOF'
# Pretty Colors
alias ll='ls -la'
alias la='ls -la'
alias ls='eza'
EOF

# Linuxbrew Path Compat for tools
mkdir -p /home/linuxbrew/.linuxbrew/bin/
for f in /usr/local/bin/*; do
    ln -sf /usr/local/bin/"$(basename "$f")" /home/linuxbrew/.linuxbrew/bin/"$(basename "$f")"
done

# Cleanup
dnf5 clean all
