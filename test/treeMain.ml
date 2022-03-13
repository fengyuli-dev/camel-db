open OUnit2
open Camel_db.ETree
open Camel_db.Parser

(** (A = 1) or (D = 4) *)
let (tokens1 : expr_type list) =
  [ String "A"; EQ; String "1"; OR; String "D"; EQ; String "4" ]

let tokens1_or =
  [ [ String "A"; EQ; String "1" ]; [ String "D"; EQ; String "4" ] ]

(** (A = 1 and D = 4 and C >= 3) *)
let (tokens2 : expr_type list) =
  [
    String "A";
    EQ;
    String "1";
    AND;
    String "B";
    EQ;
    String "2";
    AND;
    String "C";
    LE;
    String "3";
  ]

let tokens2_or =
  [
    [
      String "A";
      EQ;
      String "1";
      AND;
      String "B";
      EQ;
      String "2";
      AND;
      String "C";
      LE;
      String "3";
    ];
  ]

(** (A = 1) or ( B > 2 and C >= 3 ) or ( NOT D = 4 ) *)
let (tokens3 : expr_type list) =
  [
    String "A";
    EQ;
    String "1";
    OR;
    String "B";
    GT;
    String "2";
    AND;
    String "C";
    LE;
    String "3";
    OR;
    NOT;
    String "D";
    EQ;
    String "4";
  ]

let tokens3_or =
  [
    [ String "A"; EQ; String "1" ];
    [ String "B"; GT; String "2"; AND; String "C"; LE; String "3" ];
    [ NOT; String "D"; EQ; String "4" ];
  ]

let or_tests =
  [
    ( "token1" >:: fun _ ->
      assert_equal (expressions_or tokens1) tokens1_or );
    ( "token2" >:: fun _ ->
      assert_equal (expressions_or tokens2) tokens2_or );
    ( "token3" >:: fun _ ->
      assert_equal (expressions_or tokens3) tokens3_or );
  ]

let suite = "test suite for expression tree" >::: List.flatten []
let _ = run_test_tt_main suite
