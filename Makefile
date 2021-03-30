BASEPATH   := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
DOTPATH    := $(BASEPATH)/home
#DOTPATH   := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
DOTFILE_CANDIDATES := $(patsubst home/%, %, $(wildcard home/.??*))
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml
DOTFILES := $(filter-out $(EXCLUSIONS), $(DOTFILE_CANDIDATES))
XDG_CONFIGS := $(patsubst home/XDG_CONFIG_HOME/%, %, $(wildcard home/XDG_CONFIG_HOME/*))

.DEFAULT_GOAL := help
PHONY_LENGTH := 10

.PHONY: list
list: ## Show list of target to create symbolic links
	@echo dotfiles...
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(DOTPATH)/$(val);)
	@echo XDG_CONFIG_HOME...
	@$(foreach val, $(XDG_CONFIGS), /bin/ls -dF $(DOTPATH)/XDG_CONFIG_HOME/$(val);)

.PHONY: link
link: ## Create symbolic links for dotfiles
	@$(foreach val, $(DOTFILES), ln -sfnv $(DOTPATH)/$(val) $(HOME)/$(val);)
	@$(foreach val, $(XDG_CONFIGS), chmod 700 $(DOTPATH)/XDG_CONFIG_HOME/$(val);)
	@$(foreach val, $(XDG_CONFIGS), if [ -z "${XDG_CONFIG_HOME}" ]; then ln -sfnv $(DOTPATH)/XDG_CONFIG_HOME/$(val) $(HOME)/.config/$(val); else ln -sfnv $(DOTPATH)/XDG_CONFIG_HOME/$(val) ${XDG_CONFIG_HOME}/$(val); fi;)

.PHONY: update
update: ## (Obsoleted) Update dotfiles
	git pull --ff-only

.PHONY: init
init: ## (Obsoleted) Exec bin/install.sh
	@bash $(BASEPATH)/bin/install.sh

.PHONY: install
install: init link ## (Obsoleted) Exec bin/install.sh and create symbolic links

.PHONY: clean
clean: ## Unlink dotfiles
	@$(foreach val, $(DOTFILES), unlink $(HOME)/$(val);)
	@$(foreach val, $(XDG_CONFIGS), if [ -z "${XDG_CONFIG_HOME}" ]; then unlink $(HOME)/.config/$(val); else unlink ${XDG_CONFIG_HOME}/$(val); fi;)

.PHONY: help
help: ## Show this help messages
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-$(PHONY_LENGTH)s\033[0m %s\n", $$1, $$2}'

