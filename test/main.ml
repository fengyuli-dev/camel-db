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

let insert_token_1 =
  tokenize "INSERT INTO Customers (CustomerName) VALUES ('Cardinal')"

let insert_token_2 =
  tokenize
    "INSERT INTO Customers (CustomerName, ContactName, Address, City, \
     PostalCode, Country) VALUES ('Cardinal', 'TomErichsen', \
     'Skagen21', 'Stavanger', 4006, 'Norway');"

let insert_token_3 =
  tokenize
    "INSERT INTO Customers (CustomerName, ContactName, Address, City, \
     PostalCode, Country) VALUES ('Cardinal', 'TomErichsen', \
     'Skagen21', 'Stavanger', 400.6, 'Norway');"

let parse_insert_tests =
  [
    parse_insert_test "all strings" insert_token_1
      ( "Cusomters",
        [ "CustomerName" ],
        [ Camel_db.Database.String "Cardinal" ] );
    parse_insert_test "has ints" insert_token_2
      ( "Cusomters",
        [
          "CustomerName";
          "ContactName";
          "Address";
          "City";
          "PostalCode";
          "Country";
        ],
        [
          Camel_db.Database.String "Cardinal";
          Camel_db.Database.String "TomErichsen";
          Camel_db.Database.String "Skagen21";
          Camel_db.Database.String "Stavanger";
          Camel_db.Database.Int 4006;
          Camel_db.Database.String "Norway";
        ] );
    parse_insert_test "has floats" insert_token_3
      ( "Cusomters",
        [
          "CustomerName";
          "ContactName";
          "Address";
          "City";
          "PostalCode";
          "Country";
        ],
        [
          Camel_db.Database.String "Cardinal";
          Camel_db.Database.String "TomErichsen";
          Camel_db.Database.String "Skagen21";
          Camel_db.Database.String "Stavanger";
          Camel_db.Database.Float 400.6;
          Camel_db.Database.String "Norway";
        ] );
  ]

let parse_delete_test
    (name : string)
    (tokens : token list)
    (expected_output : string) : test =
  name >:: fun _ ->
  assert_equal expected_output (parse_delete_test_version tokens)

let delete_token = tokenize "DELETE FROM Customers WHERE CustomerID = 1"

let parse_delete_tests =
  [ parse_delete_test "delete command" delete_token "Customers" ]

let parse_update_test
    (name : string)
    (tokens : token list)
    (expected_output : string * string list * val_type list) : test =
  name >:: fun _ ->
  assert_equal expected_output (parse_update_test_version tokens)

let update_token_1 =
  tokenize
    "UPDATE Customers SET ContactName = 'Alfred Schmidt', City = \
     'Frankfurt' WHERE CustomerID = 1"

let update_token_2 =
  tokenize
    "UPDATE Customers SET ContactName = 6.2, City = 'Frankfurt', \
     Address = 9 WHERE CustomerID = 1"

let parse_update_tests =
  [
    parse_update_test "update command with strings only" update_token_1
      ( "Customers",
        [ "ContactName"; "City" ],
        [
          Camel_db.Database.String "Alfred Schmidt";
          Camel_db.Database.String "Frankfurt";
        ] );
    parse_update_test "update command with mixed types" update_token_2
      ( "Customers",
        [ "ContactName"; "City"; "Address" ],
        [
          Camel_db.Database.Float 6.2;
          Camel_db.Database.String "Frankfurt";
          Camel_db.Database.Int 9;
        ] );
  ]

let suite =
  "test suite for expression tree"
  >::: List.flatten [ parse_where_tests ]

let _ = run_test_tt_main suite