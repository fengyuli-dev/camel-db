.PHONY: test check
	
build:
	dune build

test:
	OCAMLRUNPARAM=b dune exec test/main.exe

test1:
	OCAMLRUNPARAM=b dune exec testTree/main.exe

test2:
	OCAMLRUNPARAM=b dune exec testExpr/main.exe

testall:	test	test2	test1

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
