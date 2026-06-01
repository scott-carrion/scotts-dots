# Destination directory
HOOKS_DST_DIR := $$HOME/githooks

# Git hooks scripts directory
HOOKS_SRC_DIR := hooks

install:
	@echo Installing git hooks to \'$(HOOKS_DST_DIR)\'
	install -d $(HOOKS_DST_DIR)
	for hook in $(HOOKS_SRC_DIR)/*; do \
		install -m 755 $$hook $(HOOKS_DST_DIR)/$(hook); \
	done
	@echo Updating global git config hooksPath
	git config --global core.hooksPath $(HOOKS_DST_DIR)


uninstall:
	@echo Uninstalling git hooks
	rm -rf $(HOOKS_DST_DIR)
	git config --global --unset core.hooksPath


.PHONY: install uninstall
