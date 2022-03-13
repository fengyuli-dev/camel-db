.PHONY: test check
	
build:
	dune build

test:
	OCAMLRUNPARAM=b dune exec test/main.exe

test2:
	OCAMLRUNPARAM=b dune exec testExpr/main.exe

start:
	OCAMLRUNPARAM=b dune exec bin/main.exe

zip:
	rm -f camel_db.zip
	zip -r camel_db.zip . -x@exclude.lst

clean:
	dune clean
	rm -f camel_db.zip

doc:
	dune build @doc
