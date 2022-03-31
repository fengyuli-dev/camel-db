open Camel_db

(** [main] prompts for the game to play, then starts it. *)
let main () =
  let _ =
    ANSITerminal.print_string [ ANSITerminal.green ]
      "\n\nStart using the database.\n";
    print_endline "Please enter commands below.\n";
    print_string "> ";
    let rec recursive_parse () =
      try
        let line = read_line () in
        print_endline "The tokenizer tokenizes this string as: \n";
        print_endline (Helper.pp_tokens (Tokenizer.tokenize line));
        Parser.parse (Rep.create_empty_database "parent") line;
        print_string "\n> ";
        recursive_parse ()
      with
      | Parser.Malformed m ->
          print_endline m;
          print_string "\n> ";
          recursive_parse ()
      | Parser.Empty ->
          print_endline "The command cannot be empty. \n";
          print_string "\n> ";
          recursive_parse ()
    in
    recursive_parse ()
  in
  ()

(* Execute the game engine. *)
let () = main ()