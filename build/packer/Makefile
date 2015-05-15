BASE_VM_NAME = cdd-base-vm
BASE_OUTPUT_DIR = output-$(BASE_VM_NAME)
BASE_MACHINE_IMAGE = $(BASE_OUTPUT_DIR)/$(BASE_VM_NAME).ovf
BASE_VM_DISK_SIZE_MB = 12000

WEB_VM_NAME = cdd-web-vm
WEB_OUTPUT_DIR = output-$(WEB_VM_NAME)
WEB_MACHINE_IMAGE = $(WEB_OUTPUT_DIR)/$(WEB_VM_NAME).ovf

GOCD_VM_NAME = cdd-gocd-vm
GOCD_OUTPUT_DIR = output-$(GOCD_VM_NAME)
GOCD_MACHINE_IMAGE = $(GOCD_OUTPUT_DIR)/$(GOCD_VM_NAME).ovf

default: start-web-vm

start-gocd-vm: stop-gocd-vm import-gocd-vm
	VBoxManage startvm $(GOCD_VM_NAME)

stop-gocd-vm:
	VBoxManage controlvm $(GOCD_VM_NAME) poweroff 2> /dev/null || true

start-web-vm: stop-web-vm import-web-vm
	VBoxManage startvm $(WEB_VM_NAME)

stop-web-vm:
	# Poweroff if running
	VBoxManage controlvm $(WEB_VM_NAME) poweroff 2> /dev/null || true

stop-base-vm:
	VBoxManage controlvm $(BASE_VM_NAME) poweroff 2> /dev/null || true

import-gocd-vm: $(GOCD_MACHINE_IMAGE)
	VBoxManage showvminfo $(GOCD_VM_NAME) > /dev/null || \
	VBoxManage import $(GOCD_MACHINE_IMAGE)

import-web-vm: $(WEB_MACHINE_IMAGE)
	# Import only if necessary
	# Clean to force this
	VBoxManage showvminfo $(WEB_VM_NAME) > /dev/null || \
	VBoxManage import $(WEB_MACHINE_IMAGE)

$(GOCD_MACHINE_IMAGE): $(BASE_MACHINE_IMAGE) gocd-build.json
	make clean-gocd-vm
	packer build -var base_vm_name=$(BASE_VM_NAME) \
				 -var gocd_vm_name=$(GOCD_VM_NAME) \
				 -var-file gocd-variables.json     \
				 gocd-build.json

$(WEB_MACHINE_IMAGE): $(BASE_MACHINE_IMAGE) webserver-build.json
	make clean-web-vm
	packer build -var base_vm_name=$(BASE_VM_NAME)  \
				 -var web_vm_name=$(WEB_VM_NAME)    \
				 -var-file webserver-variables.json \
				 webserver-build.json

$(BASE_MACHINE_IMAGE): base-build.json
	make clean-base-vm
	packer build -var base_vm_name=$(BASE_VM_NAME)         \
				 -var disk_size_mb=$(BASE_VM_DISK_SIZE_MB) \
				 -var-file base-variables.json             \
				 base-build.json

clean: clean-gocd-vm clean-web-vm clean-base-vm

clean-gocd-vm: stop-gocd-vm
	VBoxManage unregistervm --delete $(GOCD_VM_NAME) 2> /dev/null || true
	rm -rf $(GOCD_OUTPUT_DIR)

clean-web-vm: stop-web-vm
	VBoxManage unregistervm --delete $(WEB_VM_NAME) 2> /dev/null || true
	rm -rf $(WEB_OUTPUT_DIR)

clean-base-vm: stop-base-vm
	VBoxManage unregistervm --delete $(BASE_VM_NAME) 2> /dev/null || true
	rm -rf $(BASE_OUTPUT_DIR)

.PHONY: clean clean-base-vm stop-base-vm
	clean-web-vm import-web-vm stop-web-vm start-web-vm     \
	clean-gocd-vm import-gocd-vm stop-gocd-vm start-gocd-vm
