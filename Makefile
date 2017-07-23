BASEPATH   := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
DOTPATH    := $(BASEPATH)/home
#DOTPATH   := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
DOTFILE_CANDIDATES := $(patsubst home/%, %, $(wildcard home/.??*))
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml
DOTFILES := $(filter-out $(EXCLUSIONS), $(DOTFILE_CANDIDATES))
XDG_CONFIGS := $(patsubst home/XDG_CONFIG_HOME/%, %, $(wildcard home/XDG_CONFIG_HOME/*))

all:

list:
	@echo dotfiles...
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(DOTPATH)/$(val);)
	@echo XDG_CONFIG_HOME...
	@$(foreach val, $(XDG_CONFIGS), /bin/ls -dF $(DOTPATH)/XDG_CONFIG_HOME/$(val);)

link:
	@$(foreach val, $(DOTFILES), ln -sfnv $(DOTPATH)/$(val) $(HOME)/$(val);)
	@$(foreach val, $(XDG_CONFIGS), ln -sfnv $(DOTPATH)/XDG_CONFIG_HOME/$(val) $(HOME)/.config/$(val);)

update:
	git pull origin master

init:
	@bash $(BASEPATH)/bin/install.sh

install: update link init

clean:
	@$(foreach val, $(DOTFILES), unlink $(HOME)/$(val);)
