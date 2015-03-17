%{
    open Astree;;
%}

%token DEFINE PLUS MINUS ASSIGN EQUAL PARENOPEN PARENCLOSE SOPEN SCLOSE 
%token DOT COLON SEMICOLON LESSTHAN GREATTHAN PARELLEL NULL PROC
%token TRUE FALSE ATOMIC MALLOC IF ELSE WHILE SKIP
%token < string > VAR
%token < string > FIELD 
%token < int > NUM
%start prog 
%type <prog_node> prog 
%type <var_node> var
%type <field_node> field
%type <expr_node> expr
%type <bool_node> boolean
%type <decl_node> decl
%type <cmd_node> cmd
%left PLUS MINUS DOT
%right ASSIGN

%%

prog:
      { Prog ((cmd_node list) []) }
    | cmd SEMICOLON prog { Prog (cmd::prog) }

var :
    VAR      { Variable ($1) }

field :
    FIELD    { Field ($1) }

expr :
      field  { FieldExpr ($1) }
    | NUM    { Number ($1) }
    | expr MINUS expr { Minus ($1, $3) }
    | expr PLUS expr { Plus ($1, $3) }
    | NULL   { Null () }
    | var    { VarExpr ($1) }
    | expr DOT expr { Deref ($1, $3) }
    | PROC var COLON cmd { ProcExpr (Procedure ($2, $4) ) }
    ;

boolean :
      TRUE  { True }
    | FALSE { False }
    | expr EQUAL expr { Equal ($1, $3) }
    | expr LESSTHAN expr { Lt ($1, $3) }
    | expr GREATTHAN expr { Gt ($1, $3) }

decl :
    DEFINE var { Decl ($2) }

cmd:
    decl SEMICOLON cmd  { VarDel ($1, $3) }
    | expr PARENOPEN expr PARENCLOSE { ProcCall ($1, $3) }
    | MALLOC PARENOPEN expr PARENCLOSE { Malloc ($3) }
    | var ASSIGN expr { VarAssign ($1, $3) }
    | expr DOT expr ASSIGN expr { FieldAssign ($1, $3, $5)  } 
    | SKIP { Skip }
    | SOPEN cmd SEMICOLON cmd SCLOSE { Scope ($2, $4) }
    | WHILE boolean cmd { Loop ($2, $3) }
    | IF boolean cmd ELSE cmd { Cond ($2, $3) }
    | SOPEN cmd PARELLEL cmd SCLOSE { Parl ($2, $4) }
    | ATOMIC PARENOPEN cmd PARENCLOSE { Atom ($3) }

%%
