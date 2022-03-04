.PHONY: test check
	
build:
	dune build

utop:
	OCAMLRUNPARAM=b dune utop src

test:
	OCAMLRUNPARAM=b dune exec test/main.exe

run:
	OCAMLRUNPARAM=b dune exec bin/main.exe

check:
	@bash check.sh

finalcheck:
	@bash check.sh final

zip:
	rm -f camel_db.zip
	zip -r camel_db.zip . -x@exclude.lst

clean:
	dune clean
	rm -f camel_db.zip

doc:
	dune build @doc
