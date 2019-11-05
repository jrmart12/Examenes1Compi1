%option noyywrap
%option reentrant
%x comment
%{

#include "expr_lexer.h"
int counter =0;
#define YY_EXTRA_TYPE std::istream*
#define YY_DECL Token ExprLexer::_getNextToken(yyscan_t yyscanner)
#define YY_INPUT(buf,result,max_size)\
    do{\
        std::istream* in = yyget_extra(yyscanner);\
        in->read(buf,max_size);\
        result = in->gcount();\
    }while(0)

%}
letter [_a-z_A-Z]
DIGIT [0-9]
%%
"#".*                   /*nada*/;
"{"                     BEGIN(comment); 

<comment>"}" BEGIN(INITIAL);
<comment>.|\n /*nada*/;
<comment><<EOF>> BEGIN(INITIAL);
{DIGIT}+(.{DIGIT}+)? {return Token::Num; }
"-"     {return Token::OpSub;}
"+"     {return Token::OpAdd;}
"("     {return Token::OpenPar;}
")"     {return Token::ClosePar;}
";"     {return Token::Semicolon;}
<<EOF>> { return Token::Eof; }
({letter}|_)({DIGIT}|{letter}|_)+ {return Token::Id;}

%%

ExprLexer::ExprLexer(std::istream &in):in(in) {
    yylex_init_extra(&in,&scanner);
}

ExprLexer::~ExprLexer() {
    yylex_destroy(scanner);
}
