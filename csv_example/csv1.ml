(* See also 'test.ml' for examples, and 'csv.mli' for documentation. *)

open Printf

let embedded_csv =
  "\"Banner clickins\"\n\
   \"Clickin\",\"Number\",\"Percentage\",\n\
   \"brand.adwords\",\"4,878\",\"14.4\"\n\
   \"vacation.advert2.adwords\",\"4,454\",\"13.1\"\n\
   \"affiliates.generic.tc1\",\"1,608\",\"4.7\"\n\
   \"brand.overture\",\"1,576\",\"4.6\"\n\
   \"vacation.cheap.adwords\",\"1,515\",\"4.5\"\n\
   \"affiliates.generic.vacation.biggestchoice\",\"1,072\",\"3.2\"\n\
   \"breaks.no-destination.adwords\",\"1,015\",\"3.0\"\n\
   \"fly.no-destination.flightshome.adwords\",\"833\",\"2.5\"\n\
   \"exchange.adwords\",\"728\",\"2.1\"\n\
   \"holidays.cyprus.cheap\",\"574\",\"1.7\"\n\
   \"travel.adwords\",\"416\",\"1.2\"\n\
   \"affiliates.vacation.generic.onlinediscount.200\",\"406\",\"1.2\"\n\
   \"promo.home.topX.ACE.189\",\"373\",\"1.1\"\n\
   \"homepage.hp_tx1b_20050126\",\"369\",\"1.1\"\n\
   \"travel.agents.adwords\",\"358\",\"1.1\"\n\
   \"promo.home.topX.SSH.366\",\"310\",\"0.9\""
(* let csvs = List.map (fun name -> (name, Csv.load name)) [
   "csv_example/example1.csv"; "csv_example/example2.csv" ] *)

let csvs =
  List.map
    (fun name -> (name, Csv.load name))
    [ "csv_example/example1.csv" ]

let () =
  let ecsv = Csv.input_all (Csv.of_string embedded_csv) in
  printf "---Embedded CSV---------------------------------\n";
  Csv.print_readable ecsv;

  List.iter
    (fun (name, csv) ->
      printf "---%s----------------------------------------\n" name;
      Csv.print_readable csv)
    csvs;
  printf "Compare (Embedded CSV) example1.csv = %i\n"
    (Csv.compare ecsv (snd (List.hd csvs)))

let () =
  (* Save it to a file *)
  let ecsv = Csv.input_all (Csv.of_string embedded_csv) in
  let fname =
    Filename.concat (Filename.get_temp_dir_name ()) "example.csv"
  in
  Csv.save fname ecsv;
  printf "Saved CSV to file %S.\n" fname