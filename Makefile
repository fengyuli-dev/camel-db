.PHONY: test check
	
build:
	dune build

utop:
	OCAMLRUNPARAM=b dune utop lib

test:
	OCAMLRUNPARAM=b dune exec test/main.exe

sample_file:
	OCAMLRUNPARAM=b dune exec csv_files/csv1.exe

file:
	OCAMLRUNPARAM=b dune exec test/table_example.exe

start:
	OCAMLRUNPARAM=b dune exec bin/main.exe

zip:
	rm -f camel_db.zip
	zip -r camel_db.zip . -x@exclude.lst

docs:
	dune build @doc
