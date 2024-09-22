CACHE_CONTAINERFILE ?= build.Containerfile
OS_CONTAINERFILE ?= Containerfile
DEBUG_CONTAINERFILE ?= debug.Containerfile

FEDORA_MAJOR_VERSION ?= 40
REGISTRY ?= ghcr.io/joshua-stone

PULL ?= --pull=newer
SQUASH ?= --squash
RM_ARG ?= --rm
CACHE_IMAGE_NAME ?= fedora-minimal
CACHE_SOURCE_IMAGE ?= fedora-minimal
CACHE_SOURCE_ORG ?= fedora
CACHE_BASE_IMAGE ?= quay.io/$(CACHE_SOURCE_ORG)/$(CACHE_SOURCE_IMAGE)

CACHE_TAG ?= $(REGISTRY)/rose-os-rpms:$(FEDORA_MAJOR_VERSION)

OS_IMAGE_NAME ?= silverblue
OS_SOURCE_IMAGE ?= silverblue
OS_SOURCE_ORG ?= fedora-ostree-desktops
OS_BASE_IMAGE ?= quay.io/$(OS_SOURCE_ORG)/$(OS_SOURCE_IMAGE)

OS_TAG ?= $(REGISTRY)/rose-os-$(OS_IMAGE_NAME):$(FEDORA_MAJOR_VERSION)


DEBUG_IMAGE_NAME ?= rose-os-silverblue
DEBUG_SOURCE_IMAGE ?= rose-os-silverblue
DEBUG_SOURCE_ORG ?= joshua-stone
DEBUG_BASE_IMAGE=$(REGISTRY)/$(DEBUG_SOURCE_IMAGE)

DEBUG_TAG ?= $(REGISTRY)/rose-os-$(OS_IMAGE_NAME)-debug:$(FEDORA_MAJOR_VERSION)

all: build-rpm-cache build-os-image build-debug-image

build-rpm-cache:
	podman build $(RM_ARG) $(PULL) $(SQUASH) \
		--file $(CACHE_CONTAINERFILE) \
		--build-arg IMAGE_NAME=$(CACHE_IMAGE_NAME) \
		--build-arg SOURCE_IMAGE=$(CACHE_SOURCE_IMAGE) \
		--build-arg SOURCE_ORG=$(CACHE_SOURCE_ORG) \
		--build-arg BASE_IMAGE=$(CACHE_BASE_IMAGE) \
		--build-arg FEDORA_MAJOR_VERSION=$(FEDORA_MAJOR_VERSION) \
		--tag $(CACHE_TAG)

build-os-image:
	podman build $(RM_ARG) $(PULL) $(SQUASH) \
		--file $(OS_CONTAINERFILE) \
		--build-arg IMAGE_NAME=$(OS_IMAGE_NAME) \
		--build-arg SOURCE_IMAGE=$(OS_SOURCE_IMAGE) \
		--build-arg SOURCE_ORG=$(OS_SOURCE_ORG) \
		--build-arg BASE_IMAGE=$(OS_BASE_IMAGE) \
		--build-arg FEDORA_MAJOR_VERSION=$(FEDORA_MAJOR_VERSION) \
		--tag $(OS_TAG)

build-debug-image:
	podman build $(RM_ARG) $(PULL) $(SQUASH) \
		--file $(DEBUG_CONTAINERFILE) \
		--build-arg IMAGE_NAME=$(DEBUG_IMAGE_NAME) \
		--build-arg SOURCE_IMAGE=$(DEBUG_SOURCE_IMAGE) \
		--build-arg SOURCE_ORG=$(DEBUG_SOURCE_ORG) \
		--build-arg BASE_IMAGE=$(DEBUG_BASE_IMAGE) \
		--build-arg FEDORA_MAJOR_VERSION=$(FEDORA_MAJOR_VERSION) \
		--tag $(DEBUG_TAG)
