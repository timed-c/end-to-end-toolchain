DIRS = src,ext/ucamlib/src

.PHONY: all test clean

# Init submodules if needed and make native version. 
# The resulting executable can be found under /bin and /library (symlinks)
all:    native 


# Compile native version.
native:
	@rm -rf bin; mkdir bin 
	@ocamlbuild -tag use_str -Is $(DIRS) ktc.native 
	@rm -f ktc.native
	@cd bin; cp ../_build/src/ktc.native e2e 


# Handling subtree for ext/ucamlib
UCAMLIB_GIT = https://github.com/david-broman/ucamlib.git
UCAMLIB_MSG = 'Updated ucamlib'
add_ucamlib:
	git subtree add --prefix ext/ucamlib $(UCAMLIB_GIT) master --squash 
pull_ucamlib:
	git subtree pull --prefix ext/ucamlib $(UCAMLIB_GIT) master --squash -m $(UCAMLIB_MSG)
push_ucamlib:
	git subtree push --prefix ext/ucamlib $(UCAMLIB_GIT) master --squash

# Clean all submodules and the main Modelyze source
clean:
	@ocamlbuild -clean	
	@rm -rf bin
	@rm -rf doc/api
	@echo " Finished cleaning up."
