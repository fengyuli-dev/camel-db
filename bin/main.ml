open Camel_db

(** [main] prompts for the game to play, then starts it. *)
let main () =
  let _ =
    ANSITerminal.print_string [ ANSITerminal.red ]
      "\n\nStart using the database.\n";
    print_endline "Please enter commands below.\n";
    print_string "> ";
    let rec recursive_parse () =
      Parser.parse (read_line ());
      print_string "> ";
      recursive_parse ()
    in
    recursive_parse ()
  in
  ()

(* Execute the game engine. *)
let () = main ()