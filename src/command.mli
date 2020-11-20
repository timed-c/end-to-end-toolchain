open Ustring.Op

val wcet_command : string list -> ustring 

val compile_command : string list -> ustring 

val sens_command : string list -> ustring 

val help : string -> ustring -> ustring option
