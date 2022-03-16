open OUnit2
open Camel_db.Tokenizer
open Camel_db.Parser
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

type t = string * string list * val_type list

(** let string_of_t (my_type : string * string list * val_type list) =
    match my_type with | string, string_list, val_type_list -> string ^
    " " ^ string_list ^ " " ^ val_type_list *)

let parse_insert_test
    (name : string)
    (tokens : token list)
    (expected_output : string * string list * val_type list) : test =
  name >:: fun _ ->
  assert_equal expected_output (parse_update_test_version tokens)

(** helper: return the list with the head removed*)
let remove_hd lst =
  match lst with
  | [] -> []
  | h :: t -> t

let insert_token_1 =
  tokenize "INSERT INTO Customers (CustomerName) VALUES ('Cardinal') ;"
  |> remove_hd

let insert_token_2 =
  [
    SubCommand Into;
    Terminal (Camel_db.Tokenizer.String "Customers");
    Terminal (Camel_db.Tokenizer.String "(CustomerName,");
    Terminal (Camel_db.Tokenizer.String "ContactName,");
    Terminal (Camel_db.Tokenizer.String "Address,");
    Terminal (Camel_db.Tokenizer.String "City,");
    Terminal (Camel_db.Tokenizer.String "PostalCode,");
    Terminal (Camel_db.Tokenizer.String "Country)");
    SubCommand Values;
    Terminal (Camel_db.Tokenizer.String "('Cardinal',");
    Terminal (Camel_db.Tokenizer.String "'TomErichsen',");
    Terminal (Camel_db.Tokenizer.String "'Skagen21',");
    Terminal (Camel_db.Tokenizer.String "'Stavanger',");
    Terminal (Camel_db.Tokenizer.Int 4006);
    Terminal (Camel_db.Tokenizer.String "'Norway')");
    EndOfQuery EOQ;
  ]

let insert_token_3 =
  [
    SubCommand Into;
    Terminal (Camel_db.Tokenizer.String "Customers");
    Terminal (Camel_db.Tokenizer.String "(CustomerName,");
    Terminal (Camel_db.Tokenizer.String "ContactName,");
    Terminal (Camel_db.Tokenizer.String "Address,");
    Terminal (Camel_db.Tokenizer.String "City,");
    Terminal (Camel_db.Tokenizer.String "PostalCode,");
    Terminal (Camel_db.Tokenizer.String "Country)");
    SubCommand Values;
    Terminal (Camel_db.Tokenizer.String "('Cardinal',");
    Terminal (Camel_db.Tokenizer.String "'TomErichsen',");
    Terminal (Camel_db.Tokenizer.String "'Skagen21',");
    Terminal (Camel_db.Tokenizer.String "'Stavanger',");
    Terminal (Camel_db.Tokenizer.Float 400.6);
    Terminal (Camel_db.Tokenizer.String "'Norway')");
    EndOfQuery EOQ;
  ]

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
          Camel_db.Database.String "Caridnal";
          Camel_db.Database.String "TomErichsen";
          Camel_db.Database.String "Skagen21";
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
          Camel_db.Database.String "Caridnal";
          Camel_db.Database.String "TomErichsen";
          Camel_db.Database.String "Skagen21";
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

let delete_token =
  tokenize "DELETE FROM Customers WHERE CustomerID = 1 ;" |> remove_hd

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
    "UPDATE Customers SET ContactName = 'AlfredSchmidt', City = \
     'Frankfurt' WHERE CustomerID = 1 ;"
  |> remove_hd

let update_token_2 =
  [
    Terminal (Camel_db.Tokenizer.String "Customers");
    SubCommand Set;
    Terminal (Camel_db.Tokenizer.String "ContactName");
    BinaryOp Camel_db.Tokenizer.EQ;
    Terminal (Camel_db.Tokenizer.Float 6.2);
    Terminal (Camel_db.Tokenizer.String "City");
    BinaryOp Camel_db.Tokenizer.EQ;
    Terminal (Camel_db.Tokenizer.String "'Frankfurt',");
    Terminal (Camel_db.Tokenizer.String "Address");
    BinaryOp Camel_db.Tokenizer.EQ;
    Terminal (Camel_db.Tokenizer.Int 9);
    SubCommand Where;
    Terminal (Camel_db.Tokenizer.String "CustomerID");
    BinaryOp Camel_db.Tokenizer.EQ;
    Terminal (Camel_db.Tokenizer.Int 1);
    EndOfQuery EOQ;
  ]

let parse_update_tests =
  [
    parse_update_test "update command with strings only" update_token_1
      ( "Customers",
        [ "ContactName"; "City" ],
        [
          Camel_db.Database.String "AlfredSchmidt";
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