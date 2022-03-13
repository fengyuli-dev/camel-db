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
    String "D";
    EQ;
    String "4";
  ]

let tokens3_or =
  [
    [ String "A"; EQ; String "1" ];
    [ String "B"; GT; String "2"; AND; String "C"; LE; String "3" ];
    [ String "D"; EQ; String "4" ];
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

let a = String "A"
let b = String "B"
let c = String "C"
let d = String "D"
let one = Int 1
let two = Int 2
let three = Int 3
let four = Int 4
let one = Int 1
let pair_list = [ (a, one); (b, two); (c, three); (d, four) ]

let and_test name expected actual =
  name >:: fun _ -> assert_equal expected actual ~printer:string_of_bool

let and_tests =
  [
    and_test "EQ_true" true (and_condition_evaluater a EQ one pair_list);
    and_test "EQ_false" false
      (and_condition_evaluater a EQ two pair_list);
    and_test "NE_true" true (and_condition_evaluater a EQ a pair_list);
    and_test "NE_false" false
      (and_condition_evaluater b NE two pair_list);
    and_test "LE_true" true
      (and_condition_evaluater c LE three pair_list);
    and_test "LE_false" false
      (and_condition_evaluater c LE two pair_list);
    and_test "GE_true" true (and_condition_evaluater d GE two pair_list);
    and_test "GE_fale" false
      (and_condition_evaluater a GE two pair_list);
  ]

let suite =
  "test suite for expression tree"
  >::: List.flatten [ or_tests; and_tests ]

let _ = run_test_tt_main suite
