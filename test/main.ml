open OUnit2
open Camel_db.Tokenizer
open Camel_db.Parser

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

let pair_list_title =
  [
    Terminal (String "Language");
    Terminal (String "Country");
    Terminal (String "LandSize");
    Terminal (String "Continent");
    Terminal (String "Population");
  ]

(* condition1 true; condition2 false; *)
let pair_list_china =
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
  ]

(* parse_where_test "condition1_China" parse_where_test
   "condition1_Mexico" parse_where_test "condition2_USA"
   parse_where_test "condition2_China" parse_where_test
   "condition2_Mexico" parse_where_test "condition3_USA"
   parse_where_test "condition3_China" parse_where_test
   "condition3_Mexico"; *)

let parse_where_tests = []

let suite =
  "test suite for expression tree"
  >::: List.flatten [ parse_where_tests ]

let _ = run_test_tt_main suite