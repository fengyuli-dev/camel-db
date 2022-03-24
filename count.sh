#! /bin/zsh

echo "Count the OCaml loc in the current directory."
echo "cloc is a required dependency."
make clean
cloc --by-file --include-lang=OCaml .
make build