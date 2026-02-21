SHELL := /bin/bash
VAULT_FILE := secrets.vault
SECRETS_DIR := secrets
ARCHIVE := secrets.tar.gz

.PHONY: encrypt decrypt edit verify lint clean help

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

encrypt: ## Pack secrets/ → tar.gz → ansible-vault encrypt → secrets.vault
	@if [ ! -d "$(SECRETS_DIR)" ]; then \
		echo "Error: $(SECRETS_DIR)/ directory not found."; \
		echo "Create it with: mkdir -p $(SECRETS_DIR)/ssh"; \
		exit 1; \
	fi
	@echo "Packing $(SECRETS_DIR)/ ..."
	tar czf $(ARCHIVE) -C $(SECRETS_DIR) .
	@echo "Encrypting..."
	ansible-vault encrypt $(ARCHIVE) --output $(VAULT_FILE)
	@rm -f $(ARCHIVE)
	@echo "Created $(VAULT_FILE)"
	@echo "Don't forget to shred plaintext: make clean"

decrypt: ## Decrypt secrets.vault → tar.gz → secrets/
	@if [ ! -f "$(VAULT_FILE)" ]; then \
		echo "Error: $(VAULT_FILE) not found."; \
		exit 1; \
	fi
	@echo "Decrypting..."
	ansible-vault decrypt $(VAULT_FILE) --output $(ARCHIVE)
	@mkdir -p $(SECRETS_DIR)
	tar xzf $(ARCHIVE) -C $(SECRETS_DIR)
	@rm -f $(ARCHIVE)
	@echo "Extracted to $(SECRETS_DIR)/"

edit: ## Decrypt, open shell in secrets/, re-encrypt on exit
	@$(MAKE) decrypt
	@echo "Opening shell in $(SECRETS_DIR)/. Exit shell to re-encrypt."
	@cd $(SECRETS_DIR) && $$SHELL || true
	@$(MAKE) encrypt
	@$(MAKE) clean

verify: ## Test that vault can be decrypted
	@if [ ! -f "$(VAULT_FILE)" ]; then \
		echo "Error: $(VAULT_FILE) not found."; \
		exit 1; \
	fi
	@ansible-vault decrypt $(VAULT_FILE) --output /dev/null && \
		echo "Vault OK: $(VAULT_FILE) can be decrypted." || \
		echo "Vault FAIL: could not decrypt $(VAULT_FILE)."

lint: ## Run shellcheck on bootstrap.sh
	shellcheck bootstrap.sh

clean: ## Shred all plaintext secret files
	@if [ -d "$(SECRETS_DIR)" ]; then \
		find $(SECRETS_DIR) -type f -exec shred -u {} \; 2>/dev/null || true; \
		rm -rf $(SECRETS_DIR); \
		echo "Shredded $(SECRETS_DIR)/"; \
	fi
	@if [ -f "$(ARCHIVE)" ]; then \
		shred -u $(ARCHIVE) 2>/dev/null || rm -f $(ARCHIVE); \
		echo "Shredded $(ARCHIVE)"; \
	fi
	@echo "Clean complete."
