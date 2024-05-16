export project_root := `git rev-parse --show-toplevel`
export git_branch := ` git branch --show-current`
export gts := "39"
export latest := "40"
export default_image := "silverblue"

alias run := run-container
alias build-iso := build-iso-release

_default:
    @just --list

_container_mgr:
    @{{ project_root }}/just_scripts/container_mgr.sh

_tag image:
    @echo {{image}}-build

# Build image
build image="" version="":
    @{{ project_root }}/just_scripts/build-image.sh {{image}} {{version}}

# Build ISO
build-iso-release image="" version="":
    @{{ project_root }}/just_scripts/build-iso.sh {{image}} {{version}}

# Build ISO using ISO Builder Git Head
build-iso-git image="" version="":
    @{{ project_root }}/just_scripts/build-iso-installer-main.sh {{image}} {{version}}

# Run ISO
run-iso image="" version="":
    @{{ project_root }}/just_scripts/run-iso.sh {{image}} {{version}}

# Run Container
run-container image="" version="":
    @{{ project_root }}/just_scripts/run-image.sh {{image}} {{version}}

# List Images
list-images:
    @{{ project_root }}/just_scripts/list-images.sh

# Clean Images
clean-images:
    @{{ project_root }}/just_scripts/cleanup-images.sh

# Clean ISOs
clean-isos:
    @{{ project_root }}/just_scripts/cleanup-dir.sh
