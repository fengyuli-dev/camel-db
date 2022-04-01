.PHONY: test check
	
build:
	dune build
utop:
	OCAMLRUNPARAM=b dune utop lib

test:
	OCAMLRUNPARAM=b dune exec test/main.exe

test_tree:
	OCAMLRUNPARAM=b dune exec test/tree.exe

# test_expr:
#	OCAMLRUNPARAM=b dune exec test/expr.exe

testall: test test_tree

sample_file:
	OCAMLRUNPARAM=b dune exec csv_files/csv1.exe

file:
	OCAMLRUNPARAM=b dune exec test/table_example.exe

start:
	OCAMLRUNPARAM=b dune exec bin/main.exe

zip:
	rm -f camel_db.zip
	zip -r camel_db.zip . -x@exclude.lst

clean:
	dune clean
	rm -f camel_