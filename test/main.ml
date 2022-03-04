open OUnit2
open Camel_db
 
let test = [
  "hello" >:: fun _ -> assert_equal 1 1 
]

let suite =
  "test suite for camel_db"
  >::: List.flatten [ test ]

let _ = run_test_tt_main suite