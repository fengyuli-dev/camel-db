open Rep
open Controller

let db = Controller.

let list_to_string lst =
  String.concat "," lst

let save_file table_name =
  let field_names_pair = get_field_name_list db table_name |> List.split in
  let field_name_string = field_names_pair |> fst in
  let field_name_type = field_names_pair |> snd in
  let embedded_csv =
    field_name_type 



  let () =
  (* Save it to a file *)
  let ecsv = Csv.input_all (Csv.of_string embedded_csv) in
  let fname =
    (* Filename.concat (Filename.get_temp_dir_name ()) "example.csv" *)
    Filename.concat Filename.current_dir_name "csv_example/example.csv"
  in
  Csv.save fname ecsv;
  printf "Saved CSV to file %S.\n" fname