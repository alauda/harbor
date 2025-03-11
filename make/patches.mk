PATCHES_DIR := make/patches

.PHONY: apply-patches
apply-patches:
	@echo "Applying beego patches..."
	$(call apply_patches,src/vendor/github.com/beego/beego,$(PATCHES_DIR)/beego)

define apply_patches
	@echo "apply patches to $(1)..."
	@PATCHES=$$(find $(2) -name "*.patch" -type f | sort); \
	if [ -n "$$PATCHES" ]; then \
		for patch in $$PATCHES; do \
			echo "apply patch: $$(basename $$patch)"; \
			if ! patch -p1 -d $(1) -N -f < $$patch; then \
				echo "error: apply patch $$(basename $$patch) failed"; \
				exit 1; \
			fi; \
		done; \
	else \
		echo "warning: no patch files found in $(2)"; \
	fi
endef