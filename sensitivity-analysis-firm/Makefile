DIRS = src

.PHONY: all

# Init submodules if needed and make native version.
# The resulting executable can be found under /bin and /library (symlinks)
all:   utils ustring sensitivity native

# Compile native version.
utils:
	@rm -f -r bin
	@mkdir bin
	@ocamlbuild -no-hygiene -cflags '-w -a' -use-ocamlfind -pkgs 'cil,yojson,csv' -Is $(DIRS) utils.cmx
	@ocamlbuild   -no-hygiene -cflags '-w -a' -use-ocamlfind -pkgs 'cil,yojson,csv' -Is $(DIRS) utils.cmxa
	@rm -f bytes.ml

ustring:
	@ocamlbuild -no-hygiene -cflags '-w -a' -use-ocamlfind -pkgs 'cil,yojson,csv' -Is $(DIRS) ustring.cmx
	@ocamlbuild   -no-hygiene -cflags '-w -a' -use-ocamlfind -pkgs 'cil,yojson,csv' -Is $(DIRS) ustring.cmxa
	@rm -f bytes.ml

sensitivity:
	@rm -f -r libs
	@mkdir libs
	@ocamlbuild -no-hygiene -cflags '-w -a' -use-ocamlfind -pkgs 'cil,yojson,csv' -Is $(DIRS) sensitivity.cmx
	@ocamlbuild   -no-hygiene -cflags '-w -a' -use-ocamlfind -pkgs 'cil,yojson,csv' -Is $(DIRS) sensitivity.cmxa
	@rm -f bytes.ml


native:
	@ocamlbuild -cflags '-w -a' -no-hygiene  -use-ocamlfind -pkgs 'cil,yojson,csv'  -Is $(DIRS) main.native
	@rm -f main.native
	@cd bin; cp ../_build/src/main.native sensitivity

clean:
	@rm -f -r libs
	@rm -f -r _build
	@rm -f -r bin


