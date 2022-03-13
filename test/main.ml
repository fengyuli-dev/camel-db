open OUnit2
open Camel_db.Tree

let parse_where_test name expected actual =
  name >:: fun _ -> assert_equal expected actual ~printer:string_of_bool

let parse_where_tests = []
