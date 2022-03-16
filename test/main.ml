open OUnit2
open Camel_db.Tokenizer
include Camel_db.Parser
open Camel_db.Database

(* (Country = Mexico) or (LandSize >= 1000 and Population >= 1000) *)
let condition1 =
  [
    Terminal (String "Country");
    BinaryOp EQ;
    Terminal (String "Mexico");
    LogicOp OR;
    Terminal (String "LandSize");
    BinaryOp GE;
    Terminal (Int 1000);
    LogicOp AND;
    Terminal (String "Population");
    BinaryOp GE;
    Terminal (Int 1000);
  ]

(* (Country = Mexico) or (LandSize < 1000 and Population < 1000) *)
let condition2 =
  [
    Terminal (String "Country");
    BinaryOp EQ;
    Terminal (String "Mexico");
    LogicOp OR;
    Terminal (String "LandSize");
    BinaryOp LT;
    Terminal (Int 1000);
    LogicOp AND;
    Terminal (String "Population");
    BinaryOp LT;
    Terminal (Int 1000);
  ]

(* Country != Mexico *)
let condition3 =
  [
    Terminal (String "Country"); BinaryOp NE; Terminal (String "Mexico");
  ]

let condition4 =
  [
    Terminal (String "Country");
    BinaryOp EQ;
    Terminal (String "Neverland");
  ]

let condition5 =
  [
    Terminal (String "LandSize");
    BinaryOp EQ;
    Terminal (Int 10000);
    LogicOp OR;
    Terminal (String "LandSize");
    BinaryOp EQ;
    Terminal (Int 5000);
    LogicOp OR;
    Terminal (String "LandSize");
    BinaryOp EQ;
    Terminal (Int 100);
  ]

let condition6 =
  [
    Terminal (String "LandSize");
    BinaryOp EQ;
    Terminal (Int 10001);
    LogicOp OR;
    Terminal (String "LandSize");
    BinaryOp EQ;
    Terminal (Int 5001);
    LogicOp OR;
    Terminal (String "LandSize");
    BinaryOp EQ;
    Terminal (Int 101);
  ]

let pair_list_title =
  [
    Terminal (String "Language");
    Terminal (String "Country");
    Terminal (String "LandSize");
    Terminal (String "Continent");
    Terminal (String "Population");
  ]

(* condition1 true; condition2 false; *)
let pair_list_China =
  ( pair_list_title,
    [
      Terminal (String "Chinese");
      Terminal (String "China");
      Terminal (Int 10000);
      Terminal (String "Asia");
      Terminal (Int 1000);
    ] )

(* condition1 false; condition2 false; *)
let pair_list_USA =
  ( pair_list_title,
    [
      Terminal (String "English");
      Terminal (String "USA");
      Terminal (Int 5000);
      Terminal (String "NorthAmerica");
      Terminal (Int 500);
    ] )

(* condition1 true; condition2 true; *)
let pair_list_Mexico =
  ( pair_list_title,
    [
      Terminal (String "Mexcian");
      Terminal (String "Mexico");
      Terminal (Int 100);
      Terminal (String "NorthAmerica");
      Terminal (Int 100);
    ] )

let parse_where_test name expected actual =
  name >:: fun _ -> assert_equal expected actual ~printer:string_of_bool

let parse_where_tests =
  [
    parse_where_test "condition1_USA" false
      (parse_where condition1 pair_list_USA);
    parse_where_test "condition1_China" true
      (parse_where condition1 pair_list_China);
    parse_where_test "condition1_Mexico" true
      (parse_where condition1 pair_list_Mexico);
    parse_where_test "condition2_USA" false
      (parse_where condition2 pair_list_USA);
    parse_where_test "condition2_China" false
      (parse_where condition2 pair_list_China);
    parse_where_test "condition2_Mexico" true
      (parse_where condition2 pair_list_Mexico);
    parse_where_test "condition3_USA" true
      (parse_where condition3 pair_list_USA);
    parse_where_test "condition3_China" true
      (parse_where condition3 pair_list_China);
    parse_where_test "condition3_Mexico" false
      (parse_where condition3 pair_list_Mexico);
    parse_where_test "condition4_USA" false
      (parse_where condition4 pair_list_USA);
    parse_where_test "condition4_China" false
      (parse_where condition4 pair_list_China);
    parse_where_test "condition4_Mexico" false
      (parse_where condition4 pair_list_Mexico);
    parse_where_test "condition5_USA" true
      (parse_where condition5 pair_list_USA);
    parse_where_test "condition5_China" true
      (parse_where condition5 pair_list_China);
    parse_where_test "condition5_Mexico" true
      (parse_where condition5 pair_list_Mexico);
    parse_where_test "condition6_USA" false
      (parse_where condition6 pair_list_USA);
    parse_where_test "condition6_China" false
      (parse_where condition6 pair_list_China);
    parse_where_test "condition6_Mexico" false
      (parse_where condition6 pair_list_Mexico);
  ]

let parse_insert_test
    (name : string)
    (tokens : token list)
    (expected_output : string * string list * val_type list) : test =
  name >:: fun _ ->
  assert_equal expected_output (parse_insert_test_version tokens)

let parse_insert_tests = []

let parse_delete_test
    (name : string)
    (tokens : token list)
    (expected_output : string) : test =
  name >:: fun _ ->
  assert_equal expected_output (parse_delete_test_version tokens)

let parse_delete_tests = []

let parse_update_test
    (name : string)
    (tokens : token list)
    (expected_output : string * string list * val_type list) : test =
  name >:: fun _ ->
  assert_equal expected_output (parse_update_test_version tokens)

let parse_update_tests = []

let suite =
  "test suite for expression tree"
  >::: List.flatten
         [ parse_where_tests; parse_insert_tests; parse_delete_tests ]

let _ = run_test_tt_main suite