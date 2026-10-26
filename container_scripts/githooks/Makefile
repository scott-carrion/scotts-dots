# Destination directory
HOOKS_DST_DIR ?= /opt/githooks

# Path to githook scripts to install
HOOKS_SRC_DIR := hooks

install:
	@echo Installing git hooks to \'$(HOOKS_DST_DIR)\'
	install -d $(HOOKS_DST_DIR)
	for hook in $(HOOKS_SRC_DIR)/*; do \
		install -m 755 $$hook $(HOOKS_DST_DIR)/$(hook); \
	done
	@echo Updating system git config hooksPath
	git config --system core.hooksPath $(HOOKS_DST_DIR)


uninstall:
	@echo Uninstalling git hooks
	rm -rf $(HOOKS_DST_DIR)
	git config --system --unset core.hooksPath


.PHONY: install uninstall
