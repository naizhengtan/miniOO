%{
%}

%token DEFINE PLUS MINUS ASSIGN EQUAL PARENOPEN PARENCLOSE SOPEN SCLOSE 
%token DOT COLON SEMICOLON LESSTHAN GREATTHAN PARELLEL NULL PROC
%token TRUE FALSE ATOMIC MALLOC IF ELSE WHILE SKIP
%token < string > VAR
%token < string > FIELD 
%token < int > NUM
%start cmd 
%type <unit> cmd 
%left PLUS MINUS  
%right ASSIGN DOT

%%

var :
    VAR      {}

field :
    FIELD    {}

expr :
      field  {}
    | NUM    {}
    | expr MINUS expr {}
    | expr PLUS expr {}
    | NULL   {}
    | var    {}
    | expr DOT expr {}
    | PROC var COLON cmd {}

boolean :
      TRUE  {}
    | FALSE {}
    | expr EQUAL expr {}
    | expr LESSTHAN expr {}
    | expr GREATTHAN expr {}

assign :
    var ASSIGN expr {}

decl :
    DEFINE var {}

cmd:
    decl SEMICOLON cmd  {}
    | expr PARENOPEN expr PARENCLOSE {}
    | MALLOC PARENOPEN expr PARENCLOSE {}
    | assign {}
    | SKIP {}
    | SOPEN cmd SEMICOLON cmd SCLOSE {}
    | WHILE boolean cmd {}
    | IF boolean cmd ELSE cmd {}
    | SOPEN cmd PARELLEL cmd SCLOSE {}
    | ATOMIC PARENOPEN cmd PARENCLOSE {}

%%
