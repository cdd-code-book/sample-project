BASE_VM_NAME = cdd-base-vm
BASE_OUTPUT_DIR = output-$(BASE_VM_NAME)
BASE_MACHINE_IMAGE = $(BASE_OUTPUT_DIR)/$(BASE_VM_NAME).ovf

WEB_VM_NAME = cdd-web-vm
WEB_OUTPUT_DIR = output-$(WEB_VM_NAME)
WEB_MACHINE_IMAGE = $(WEB_OUTPUT_DIR)/$(WEB_VM_NAME).ovf

default: start-web-vm

start-web-vm: stop-web-vm import-web-vm
	VBoxManage startvm $(WEB_VM_NAME)

stop-web-vm:
	# Poweroff if running
	VBoxManage controlvm $(WEB_VM_NAME) poweroff 2> /dev/null || true

import-web-vm: $(WEB_MACHINE_IMAGE)
	# Import only if necessary
	# Clean to force this
	VBoxManage showvminfo $(WEB_VM_NAME) > /dev/null || \
	VBoxManage import $(WEB_MACHINE_IMAGE)

$(WEB_MACHINE_IMAGE): $(BASE_MACHINE_IMAGE)
	packer build -var base_vm_name=$(BASE_VM_NAME)  \
				 -var web_vm_name=$(WEB_VM_NAME)    \
				 -var-file webserver-variables.json \
				 webserver-build.json

$(BASE_MACHINE_IMAGE):
	packer build -var base_vm_name=$(BASE_VM_NAME) \
				 -var-file base-variables.json     \
				 base-build.json

clean: clean-base-vm stop-web-vm clean-web-vm

clean-web-vm:
	VBoxManage unregistervm --delete $(WEB_VM_NAME) || true
	rm -rf $(WEB_OUTPUT_DIR)

clean-base-vm:
	VBoxManage unregistervm --delete $(BASE_VM_NAME) || true
	rm -rf $(BASE_OUTPUT_DIR)

.PHONY: clean clean-base-vm clean-web-vm import-web-vm stop-web-vm start-web-vm
