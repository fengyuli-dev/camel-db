open OUnit2
open Camel_db.Tree

let tests = [ ("test suite" >:: fun _ -> assert_equal 0 0) ]

let suite =
  "test suite for the binary search tree" >::: List.flatten [ tests ]

let _ = run_test_tt_main suite
