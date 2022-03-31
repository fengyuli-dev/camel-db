(* See also 'test.ml' for examples, and 'csv.mli' for documentation. *)

open Printf

let lst1 = [ "I_miss_java"; "2112"; "ok" ]
let lst2 = [ "Me_too"; "I_know"; "yea" ]
let conc_comma = String.concat ","
let conc_line = String.concat "\n"

let embedded_csv =
  [ lst1 |> conc_comma; lst2 |> conc_comma ] |> conc_line

(* let embedded_csv = "\"I miss java ---- \",\"2112 ----\",\n\ \"Me too
   ------- \",\"5555 -----\"" *)
(* let csvs = List.map (fun name -> (name, Csv.load name)) [
   "csv_example/example1.csv"; "csv_example/example2.csv" ] *)

let csvs =
  List.map
    (fun name -> (name, Csv.load name))
    [ "csv_files/example1.csv" ]

let () =
  let ecsv = Csv.input_all (Csv.of_string embedded_csv) in
  (* printf "---Embedded CSV-----------------\n"; *)
  Csv.print_readable ecsv;
  List.iter
    (fun (name, csv) ->
      (* printf "---%s--------------\n" name; *) Csv.print_readable csv)
    csvs;
  printf "Compare (Embedded\n   CSV)\n example1.csv = %i\n"
    (Csv.compare ecsv (snd (List.hd csvs)))

let () =
  (* Save it to a file *)
  let ecsv = Csv.input_all (Csv.of_string embedded_csv) in
  let fname =
    (* Filename.concat (Filename.get_temp_dir_name ()) "example.csv" *)
    Filename.concat Filename.current_dir_name "csv_files/example.csv"
  in
  Csv.save fname ecsv;
  printf "Saved CSV to file %S.\n" fname

let convert = Csv.to_array (Csv.input_all (Csv.of_string embedded_csv))

let rec print_2d_array lst =
  let rec print_array = function
    | [] -> ""
    | h :: t -> h ^ " " ^ print_array t
  in
  match lst with
  | [] -> ""
  | h :: t -> print_array (Array.to_list h) ^ "\n" ^ print_2d_array t

let () = print_string (print_2d_array (Array.to_list convert))
