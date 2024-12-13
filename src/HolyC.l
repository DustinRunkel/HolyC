%e  1019
%p  2807
%n  371
%k  284
%a  1213
%o  1117

O   [0-7]
D   [0-9]
NZ  [1-9]
L   [a-zA-Z_]
A   [a-zA-Z_0-9]
H   [a-fA-F0-9]
HP  (0[xX])
E   ([Ee][+-]?{D}+)
P   ([Pp][+-]?{D}+)
FS  (f|F|l|L)
IS  (((u|U)(l|L|ll|LL)?)|((l|L|ll|LL)(u|U)?))
CP  (u|U|L)
SP  (u8|u|U|L)
ES  (\\(['"\?\\abfnrtv]|[0-7]{1,3}|x[a-fA-F0-9]+))
WS  [ \t\v\n\f]

%{
#include <stdio.h>
#include "HolyC.tab.h"

extern void yyerror(const char *);  /* prints grammar violation message */

extern int sym_type(const char *);  /* returns type from symbol table */

#define sym_type(identifier) IDENTIFIER /* with no symbol table, fake it */

static int check_type(void);
%}

%%
"//".*                  { /*HolyC only officially supports line comments
                           * Therefore we pass over anything following '//'
                           */ }

"U0"					{ /* U0 serves as void and has a true size of 0 bytes */
                          return(U0); 
                          }
"U8"					{ return(U8);  }
"U16"					{ return(U16); }
"U32"					{ return(U32); }
"U64"					{ return(U64); }
"I8"					{ return(I8);  }
"I16"					{ return(I16); }
"I32"					{ return(I32); }
"I64"					{ return(I64); }
"F64"    				{ // No F32, Why would you want less precision???
                          return(F64);
                          //HolyC Bools are capitalized 
                                            }
"TRUE"					{ return(1);        }
"FALSE"					{ return(0);        }
"Bool"					{ return(BOOL);     }
"break"					{ return(BREAK);    }
"case"					{ return(CASE);     }
"const"					{ return(CONST);    }
"default"				{ return(DEFAULT);  }
"do"					{ return(DO);       }
"else"					{ return(ELSE);     }
"enum"					{ return(ENUM);     }
"extern"				{ return(EXTERN);   }
"for"					{ return(FOR);      } 
"goto"					{ return(GOTO);     }
"if"					{ return(IF);       }
"inline"				{ return(INLINE);   }
"return"				{ return(RETURN);   }
"sizeof"				{ return(SIZEOF);   }
"static"				{ return(STATIC);   }
"struct"				{ return(STRUCT);   }
"switch"				{ return(SWITCH);   }
"typedef"				{ return(TYPEDEF);  }
"volatile"				{ return(VOLATILE); }
"while"					{ return(WHILE);    }

{L}{A}*					{ return check_type(); }

{HP}{H}+{IS}?				{ //TODO: Handle uints
                              sscanf(yytext, "%d", &yylval.ival); return I_CONSTANT; }
{NZ}{D}*{IS}?				{ sscanf(yytext, "%d", &yylval.ival); return I_CONSTANT; }
"0"{O}*{IS}?				{ sscanf(yytext, "%d", &yylval.ival); return I_CONSTANT; }
{CP}?"'"([^'\\\n]|{ES})+"'"	{ sscanf(yytext, "%d", &yylval.ival); return I_CONSTANT; }

{D}+{E}{FS}?				{ sscanf(yytext, "%lf", &yylval.dval);return F_CONSTANT;  }
{D}*"."{D}+{E}?{FS}?		{ sscanf(yytext, "%lf", &yylval.dval);return F_CONSTANT;  }
{D}+"."{E}?{FS}?			{ sscanf(yytext, "%lf", &yylval.dval);return F_CONSTANT;  }
{HP}{H}+{P}{FS}?			{ sscanf(yytext, "%lf", &yylval.dval);return F_CONSTANT;  }
{HP}{H}*"."{H}+{P}{FS}?		{ sscanf(yytext, "%lf", &yylval.dval);return F_CONSTANT;  }
{HP}{H}+"."{P}{FS}?			{ sscanf(yytext, "%lf", &yylval.dval);return F_CONSTANT;  }

({SP}?\"([^"\\\n]|{ES})*\"{WS}*)+	{ return STRING_LITERAL; }

"..."					{ return ELLIPSIS; }
">>="					{ return RIGHT_ASSIGN; }
"<<="					{ return LEFT_ASSIGN; }
"+="					{ return ADD_ASSIGN; }
"-="					{ return SUB_ASSIGN; }
"*="					{ return MUL_ASSIGN; }
"/="					{ return DIV_ASSIGN; }
"%="					{ return MOD_ASSIGN; }
"&="					{ return AND_ASSIGN; }
"^="					{ return XOR_ASSIGN; }
"|="					{ return OR_ASSIGN; }
">>"					{ return RIGHT_OP; }
"<<"					{ return LEFT_OP; }
"++"					{ return INC_OP; }
"--"					{ return DEC_OP; }
"->"					{ return PTR_OP; }
"&&"					{ return AND_OP; }
"||"					{ return OR_OP; }
"<="					{ return LE_OP; }
">="					{ return GE_OP; }
"=="					{ return EQ_OP; }
"!="					{ return NE_OP; }
";"					    { return ';'; }
("{"|"<%")				{ return '{'; }
("}"|"%>")				{ return '}'; }
","					    { return ','; }
":"					    { return ':'; }
"="					    { return '='; }
"("					    { return '('; }
")"					    { return ')'; }
("["|"<:")				{ return '['; }
("]"|":>")				{ return ']'; }
"."					    { return '.'; }
"&"					    { return '&'; }
"!"					    { return '!'; }
"~"					    { return '~'; }
"-"					    { return '-'; }
"+"					    { return '+'; }
"*"					    { return '*'; }
"/"					    { return '/'; }
"%"					    { return '%'; }
"<"					    { return '<'; }
">"					    { return '>'; }
"^"					    { return '^'; }
"|"					    { return '|'; }
"?"					    { return '?'; }

{WS}+					{ /* whitespace separates tokens */ }
.					    { /* discard bad characters */ }

%%

int yywrap(void)        /* called at end of input */
{
    return 1;           /* terminate now */
}

static int check_type(void)
{
    //TODO: Remove type checking... well actually, it just needs to be moved
    // Implicitly to the backend as LLVM will not tolerate this greatness
    switch (sym_type(yytext))
    {
    case TYPEDEF_NAME:                /* previously defined */
        return TYPEDEF_NAME;
    case ENUMERATION_CONSTANT:        /* previously defined */
        return ENUMERATION_CONSTANT;
    default:                          /* includes undefined */
        return IDENTIFIER;
    }
}