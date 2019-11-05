%code requires{
    #define YYSTYPE int
    #define YYSTYPE_IS_DECLARED 1
}

%{
    #include <cstdio>
    #include <sstream>
    #include <unordered_map>
    #include "expr_lexer.h"

    using namespace std;
    int yylex();
     extern std::unordered_map<std::string, int> vars;
     extern std::vector<int> values;

    #define YYERROR_VERBOSE 1

    void yyerror(const char* msg) {
        std::cerr << msg;
    }
    
%}

%token Num OpSub OpAdd OpenPar ClosePar Semicolon EOf Id

%%
input: stmt_list;
stmt_list: stmt_list expr opt_semicolon {values.push_back($2);}
|%empty {values.clear();};

opt_semicolon: ';' | %empty;

expr: expr '+' term {$$=$1+$3;}
    | expr '-' term {$$=$1-$3;}
    | term {$$=$1;};


term: term '*' factor {$$=$1*$3;}
    | term '/' factor {$$=$1/$3;}
    | factor {$$=$1;};

factor: Num {$$=$1;}
    | '(' expr  ')' {$$=$2;}
    ;
%%