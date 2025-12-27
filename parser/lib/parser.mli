(** Parser - Recursive descent parser for query DSL. *)

(** [parse input] parses a query string into an AST.

    Supports:
    - Terms: [search]
    - Phrases: ["search engine"]
    - Boolean: [AND], [OR], [NOT]
    - Grouping: [(expr)]
    - Implicit AND: [search engine] = [search AND engine] *)
val parse : string -> Ast.expr
