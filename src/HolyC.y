%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "codegen.hpp"

	int yylex();
	extern int lineno;
	void yyerror (const char *);
%}

//TODO add more sizing types
//allocate one buffer to 
%union 
{
	int ival;
	unsigned int uival;
	double dval;
	char *str;
}

%token<str>	IDENTIFIER STRING_LITERAL FUNC_NAME TYPEDEF_NAME
%token<ival> I_CONSTANT
%token<dval> F_CONSTANT
%token  SIZEOF
%token	PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token	AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token	SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token	XOR_ASSIGN OR_ASSIGN
%token	ENUMERATION_CONSTANT

%token	TYPEDEF EXTERN STATIC INLINE
%token	CONST VOLATILE
%token	BOOL U0 U8 U16 U32 U64 I8 I16 I32 I64 F64
%token	STRUCT ENUM ELLIPSIS

%token	CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO BREAK RETURN

%start translation_unit
%%

translation_unit : pre_processor
				 | statement
				 ;

pre_processor : /*In progresss*/;

statement : expression ';'
		  | declaration ';'
		  ;

type : BOOL
     | U0
	 | U8
	 | U16
	 | U32
	 | U64
	 | I8
	 | I16
	 | I32
	 | I64
	 | F64
	 ;

declaration : type IDENTIFIER 
			;

expression : assignment_expression
		   | IDENTIFIER 
		   | 
		   ;
 
assignment_expression : type IDENTIFIER '=' expression
                      | IDENTIFIER '=' expression
					  ;

%%
#include <stdio.h>

void yyerror(const char *s)
{
	fflush(stdout);
	fprintf(stderr, "*** %s\n", s);
}

int main ()
{
	if(yyparse())
	{
		yyerror("Some error");
	}
}