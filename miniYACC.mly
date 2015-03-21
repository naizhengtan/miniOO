%{
    open Astree;;
%}

%token DEFINE PLUS MINUS ASSIGN EQUAL PARENOPEN PARENCLOSE SQUREOPEN SQURECLOSE SOPEN SCLOSE 
%token DOT COLON SEMICOLON LESSTHAN GREATTHAN PARELLEL NULL PROC
%token TRUE FALSE LOCK MALLOC IF THEN ELSE WHILE SKIP EOF
%token < string > VAR
%token < string > FIELD 
%token < int > NUM
%start prog 
%type <Astree.cmd_node list> prog 
%type <var_node> var
%type <field_node> field
%type <expr_node> expr
%type <bool_node> boolean
%type <decl_node> decl
%type <cmd_node> cmd
%right ASSIGN
%left PLUS MINUS DOT

%%


var :
    VAR      { Variable ($1) }

field :
      FIELD    { Field ($1) }
    | SQUREOPEN expr SQURECLOSE     { Index ($2) }

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
    | MALLOC PARENOPEN var PARENCLOSE { Malloc ($3) }
    | var ASSIGN expr { VarAssign ($1, $3) }
    | expr DOT field ASSIGN expr { FieldAssign ($1, $3, $5)  } 
    | SKIP { Skip }
    | SOPEN prog SCLOSE { Scope ($2) }
    | WHILE boolean cmd { Loop ($2, $3) }
    | IF boolean THEN cmd ELSE cmd { Cond ($2, $4, $6) }
    | SOPEN cmd PARELLEL cmd SCLOSE { Parl ($2, $4) }
    | LOCK PARENOPEN cmd PARENCLOSE { Lock ($3) }

prog:
    cmd SEMICOLON { [$1] }
    | prog cmd SEMICOLON { $1@[$2] }
%%
