%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "symbolTable.h"
#include "AST.h"
#include "IRcode.h"
#include "Assembly.h"

extern int yylex();
extern int yyparse();
extern FILE* yyin;

FILE * IRcode;
//FILE * MIPScode;


void yyerror(const char* s);
char currentScope[50]; // "global" or the name of the function
int tempVarCounter = 0;

int semanticCheckPassed = 1; // flags to record correctness of semantic checks

char* generateTempVar() {
    char buffer[20]; // Assuming no more than 20 characters for a temp var name
    sprintf(buffer, "$t%d", tempVarCounter++);
    return strdup(buffer);
}

%}

%union {
	char op;
	int number;
	char character;
	char* string;
	struct AST* ast;
}

%token <string> TYPE
%token <string> ID
%token <char> SEMICOLON
%token <char> EQ 
%token <number> NUMBER
%token <string> WRITE
%token <op> OP
%token <string> FUNCTION
%token LPAREN RPAREN 




%printer { fprintf(yyoutput, "%s", $$); } ID;
%printer { fprintf(yyoutput, "%d", $$); } NUMBER;

%type <ast> Program DeclList Decl VarDecl Stmt StmtList Expr FuncDef
%type <ast> BinExpr FunctionCall // New production for function calls


%start Program

%%

Program: DeclList  { $$ = $1;
					 printf("\n--- Abstract Syntax Tree ---\n\n");
					 printAST($$,0);
					}
;

DeclList:	Decl DeclList	{ $1->left = $2;
							  $$ = $1;
							}
	| Decl	{ $$ = $1; }
;

Decl:	VarDecl
	| StmtList | FuncDef
;

VarDecl:	TYPE ID SEMICOLON	{ printf("\n RECOGNIZED RULE: Variable declaration %s\n", $2);
									// Symbol Table
									symTabAccess();
									int inSymTab = found($2, currentScope);
									//printf("looking for %s in symtab - found: %d \n", $2, inSymTab);
									
									if (inSymTab == 0) 
										addItem($2, "Var", $1,0, currentScope);
									else
										printf("SEMANTIC ERROR: Var %s is already in the symbol table", $2);
									showSymTable();
									
								  // ---- SEMANTIC ACTIONS by PARSER ----
								    $$ = AST_Type("Type",$1,$2);
									printf("-----------> %s", $$->LHS);
								}
;

StmtList:	
	| Stmt StmtList
;

Stmt:	SEMICOLON	{}
	| Expr SEMICOLON	{$$ = $1;}
;

Expr:	ID { printf("\n RECOGNIZED RULE: Simplest expression\n"); //E.g. function call
		   }
	| ID EQ ID 	{ printf("\n RECOGNIZED RULE: Assignment statement\n"); 
					// ---- SEMANTIC ACTIONS by PARSER ---- //
					  $$ = AST_assignment("=",$1,$3);

					// ---- SEMANTIC ANALYSIS ACTIONS ---- //  

					// Check if identifiers have been declared

					    if(found($1, currentScope) != 1) {
							printf("SEMANTIC ERROR: Variable %s has NOT been declared in scope %s \n", $1, currentScope);
							semanticCheckPassed = 0;
						}
					    if(found($3, currentScope) != 1){
							printf("SEMANTIC ERROR: Variable %s has NOT been declared in scope %s \n", $1, currentScope);
							semanticCheckPassed = 0;
						}

					// Check types

						printf("\nChecking types: \n");
						int typeMatch = compareTypes ($1, $3, currentScope);
						if (typeMatch == 0){
							printf("SEMANTIC ERROR: Type mismatch for variables %s and %s \n", $1, $3);
							semanticCheckPassed = 0;
						}
						

					if (semanticCheckPassed == 1) {
						printf("\n\n>>> AssignStmt Rule is SEMANTICALLY correct and IR code is emitted! <<<\n\n");

						// ---- EMIT IR 3-ADDRESS CODE ---- //
						
						// The IR code is printed to a separate file

						// Temporary variables management will eventually go in here
						// and the paramaters of the function below will change
						// to using T0, ..., T9 variables

						emitAssignment($1, $3);

						// ----     EMIT MIPS CODE   ----  //

						// The MIPS code is printed to a separate file

						// MIPS registers management will eventually go in here
						// and the paramaters of the function below will change
						// to using $t0, ..., $t9 registers

						emitMIPSAssignment($1, $3);



					}
					

				}

	| ID EQ NUMBER 	{ printf("\n RECOGNIZED RULE: Constant Assignment statement\n"); 
					   // ---- SEMANTIC ACTIONS by PARSER ----
					   char str[50];
					   
					   sprintf(str, "%d", $3); // convert $3 from int to string
					   $$ = AST_assignment("=",$1, str);

						// ---- SEMANTIC ANALYSIS ACTIONS ---- //  

						// Check if identifiers have been declared

					    if(found($1, currentScope) != 1) {
							printf("SEMANTIC ERROR: Variable %s has NOT been declared in scope %s \n", $1, currentScope);
							semanticCheckPassed = 0;
						}
						
						// Check types

						printf("\nChecking types: \n");

						//printf("%s = %s\n", getVariableType($1, currentScope), getVariableType($3, currentScope));
						
						printf("%s = %s\n", "int", "number");  // This temporary for now, until the line above is debugged and uncommented
						
						if (semanticCheckPassed == 1) {
							printf("\n\nRule is semantically correct!\n\n");

							// ---- EMIT IR 3-ADDRESS CODE ---- //
							
							// The IR code is printed to a separate file

							// Temporary variables management will eventually go in here
							// and the paramaters of the function below will change
							// to using T0, ..., T9 variables

							char id1[50], id2[50];
							sprintf(id1, "%s", $1);
							sprintf(id2, "%d", $3);

							// Temporary variables management will eventually go in here
							// and the paramaters of the function below will change
							// to using T0, ..., T9 variables

							emitConstantIntAssignment(id1, id2);

							// ----     EMIT MIPS CODE   ----  //

							// The MIPS code is printed to a separate file

							// MIPS registers management will eventually go in here
							// and the paramaters of the function below will change
							// to using $t0, ..., $t9 registers

							emitMIPSConstantIntAssignment(id1, id2);

						}
					}
	
	| WRITE ID 	{ printf("\n RECOGNIZED RULE: WRITE statement\n");
					$$ = AST_Write("write",$2,"");
					
					// ---- SEMANTIC ANALYSIS ACTIONS ---- //  

					// Check if identifiers have been declared
					    if(found($2, currentScope) != 1) {
							printf("SEMANTIC ERROR: Variable %s has NOT been declared in scope %s \n", $2, currentScope);
							semanticCheckPassed = 0;
						}

					if (semanticCheckPassed == 1) {
							printf("\n\nRule is semantically correct!\n\n");

							// ---- EMIT IR 3-ADDRESS CODE ---- //
							
							// The IR code is printed to a separate file
							
							emitWriteId($2);

							// ----     EMIT MIPS CODE   ----  //

							// The MIPS code is printed to a separate file

							// MIPS registers management will eventually go in here
							// and the paramaters of the function below will change
							// to using $t0, ..., $t9 registers

							emitMIPSWriteId($2);
						}
				}
		| ID EQ BinExpr { 
                printf("\n RECOGNIZED RULE: Assignment with a binary expression\n");
                
                // SEMANTIC ACTIONS and ANALYSIS for binary expressions will go here.
                // ...
                
                $$ = AST_assignmentWithBinExpr("=", $1, $3);
            }
;
BinExpr:   NUMBER OP NUMBER { 
                printf("\n RECOGNIZED RULE: Binary expression with numbers\n");
                char str1[50], str2[50];
                sprintf(str1, "%d", $1);
                sprintf(str2, "%d", $3);
                char opStr[2] = {$2, '\0'};
                char* resultVar = generateTempVar();
                emitBinaryOperation(resultVar, str1, opStr, str2);
		emitMIPSBinaryOperation(str1, opStr, str2);
                $$ = AST_binaryOperation(opStr, str1, str2);
                free(resultVar);
            }
        | ID OP NUMBER { 
                printf("\n RECOGNIZED RULE: Binary expression with variable and number\n");
                char str[50];
                sprintf(str, "%d", $3);
                char opStr[2] = {$2, '\0'};
                char* resultVar = generateTempVar();
                emitBinaryOperation(resultVar, $1, opStr, str);
		emitMIPSBinaryOperation(resultVar,opStr, str);
                $$ = AST_binaryOperation(opStr, $1, str);
                free(resultVar);
            }
        | NUMBER OP ID { 
                printf("\n RECOGNIZED RULE: Binary expression with number and variable\n");
                char str1[50];
                sprintf(str1, "%d", $1);
                char opStr[2] = {$2, '\0'};
                char* resultVar = generateTempVar();
                emitBinaryOperation(resultVar, str1, opStr, $3);
		emitMIPSBinaryOperation(str1, opStr, resultVar);
                $$ = AST_binaryOperation(opStr, str1, $3);
                free(resultVar);
            }
        | ID OP ID { 
                printf("\n RECOGNIZED RULE: Binary expression with two variables\n");
                char opStr[2] = {$2, '\0'};
                char* resultVar = generateTempVar();
                char* resultVar1 = generateTempVar();
                emitBinaryOperation(resultVar, $1, opStr, $3);
		emitMIPSBinaryOperation(resultVar, opStr, resultVar1);
                $$ = AST_binaryOperation(opStr, $1, $3);
                free(resultVar);
            }
		| BinExpr OP NUMBER {
              printf("\n RECOGNIZED RULE: Binary expression with BinExpr and number\n");
              char str[50];
              sprintf(str, "%d", $3);
              char opStr[2] = {$2, '\0'};
              char* resultVar = generateTempVar();
              emitBinaryOperation(resultVar, $1, opStr, str);
	      emitMIPSBinaryOperation2(opStr, str);
              $$ = AST_binaryOperation(opStr, $1, str);
              free(resultVar);
          }
          | BinExpr OP ID {
              printf("\n RECOGNIZED RULE: Binary expression with BinExpr and variable\n");
              char opStr[2] = {$2, '\0'};
              char* resultVar = generateTempVar();
              emitBinaryOperation(resultVar, $1, opStr, $3);
	      emitMIPSBinaryOperation2(opStr, resultVar);
              $$ = AST_binaryOperation(opStr, $1, $3);
              free(resultVar);
          }
;
FunctionCall: ID LPAREN RPAREN {
    // Handle function calls without arguments
    $$ = AST_functionCall($1, NULL);
} | ID LPAREN ID RPAREN {
    // Handle function calls with one argument (for simplicity, only one argument here)
    // You can extend this for multiple arguments
   // $$ = AST_functionCall($1, AST_ID($3));
} | ID LPAREN NUMBER RPAREN {
    // Handle function calls with one argument (for simplicity, only one argument here)
    // You can extend this for multiple arguments
    $$ = AST_functionCall($1, AST_NUMBER($3));
}
// Add more rules for function calls with multiple arguments if needed

FuncDef: FUNCTION TYPE ID LPAREN RPAREN {
    //struct AST* func = AST_functionDefinition($3, $2, NULL);
    printf("\nParsed function definition: %s %s()\n", $2, $3);
    strcpy(currentScope, $3); // Set the current function scope
 // Set the current function scope
 // Set the current function scope
    // You may want to do additional handling for function definitions here
    // such as adding the function to a symbol table, emitting IR code, etc.
    //$$ = func;
} | FUNCTION TYPE ID LPAREN ID RPAREN {
    //struct AST* func = AST_functionDefinition($3, $2, AST_ID($5));
    printf("\nParsed function definition with one parameter: %s %s(%s)\n", $2, $3, $5);
    strcpy(currentScope, $3); // Set the current function scope
// Set the current function scope
 // Set the current function scope
    // You may want to do additional handling for function definitions here
    // such as adding the function to a symbol table, emitting IR code, etc.
    //$$ = func;
}
;



%%

int main(int argc, char**argv)
{
/*
	#ifdef YYDEBUG
		yydebug = 1;
	#endif
*/
	printf("\n\n##### COMPILER STARTED #####\n\n");
	
	if (argc > 1){
	  if(!(yyin = fopen(argv[1], "r")))
          {
		perror(argv[1]);
		return(1);
	  }
	}

	// Initialize IR and MIPS files
	initIRcodeFile();
	initAssemblyFile();

	// Start parser
	yyparse();

	// Add the closing part required for any MIPS file
	emitEndOfAssemblyCode();

}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
