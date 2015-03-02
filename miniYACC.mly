%{
%}

%token MINUS SEMICOLON ASSIGN DEFINE SOPEN SCLOSE EOF
%token < string > VAR
%token < int > NUM
%start cmd 
%type <unit> cmd 
%left MINUX

%%

assign :
    VAR ASSIGN expr {}

expr :
      NUM    {}
    | VAR    {}
    | expr MINUS expr {}

decl :
    DEFINE VAR   {}

cmd:
    decl SEMICOLON cmd  {}
    | assign {}
    | SOPEN cmd SEMICOLON cmd SCLOSE {}

%%
