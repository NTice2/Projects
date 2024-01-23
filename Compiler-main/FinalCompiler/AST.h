//Abstract Syntax Tree Implementation
#include <string.h>

typedef enum {
    BINARY_OPERATION,
    ASSIGNMENT,
    // ... other node types ...
} NodeType;


struct AST{

	NodeType type;
	char* value;
	char nodeType[50];
	char LHS[50];
	char RHS[50];
	
	struct AST * left;
	struct AST * right;
	// review pointers to structs in C 
	// complete the tree struct with pointers
};


struct AST* AST_operand(char* operand) {
    struct AST* newNode = (struct AST*)malloc(sizeof(struct AST));
    newNode->value = strdup(operand);
    newNode->left = NULL;
    newNode->right = NULL;
    return newNode;
}




struct AST* AST_binaryOperation(char* operation, char* operand1, char* operand2) {
    struct AST* newNode = malloc(sizeof(struct AST));
    // Here, you would initialize the AST node to represent a binary operation
    // This might involve setting the node's type, its value (the operation, e.g., '+'),
    // and creating child nodes for the operands.
    // The specifics depend on your AST node structure and representation.

    // Sample initialization:
    newNode->type = BINARY_OPERATION;
    newNode->value = strdup(operation);
    newNode->left = AST_operand(operand1);
    newNode->right = AST_operand(operand2);

    return newNode;
}

struct AST* AST_assignmentWithBinExpr(char* operation, char* variable, struct AST* binExpr) {
    struct AST* newNode = malloc(sizeof(struct AST));
    // Again, initialize the AST node to represent an assignment with a binary expression.
    // newNode's left child might be the variable and its right child the binary expression.

    // Sample initialization:
    newNode->type = ASSIGNMENT;
    newNode->value = strdup(operation);
    newNode->left = AST_operand(variable);
    newNode->right = binExpr;

    return newNode;
}

struct AST * AST_assignment(char nodeType[50], char LHS[50], char RHS[50]){
	

	struct AST* ASTassign = malloc(sizeof(struct AST));
	strcpy(ASTassign->nodeType, nodeType);
	strcpy(ASTassign->LHS, LHS);
	strcpy(ASTassign->RHS, RHS);
	

/*
       =
	 /   \
	x     y

*/	
	return ASTassign;
	
}
struct AST * AST_BinaryExpression(char nodeType[50], char LHS[50], char RHS[50]){

	struct AST* ASTBinExp = malloc(sizeof(struct AST));
	strcpy(ASTBinExp->nodeType, nodeType);
	strcpy(ASTBinExp->LHS, LHS);
	strcpy(ASTBinExp->RHS, RHS);
	return ASTBinExp;
	
}
struct AST * AST_Type(char nodeType[50], char LHS[50], char RHS[50]){

	struct AST* ASTtype = malloc(sizeof(struct AST));
	strcpy(ASTtype->nodeType, nodeType);
	strcpy(ASTtype->LHS, LHS);
	strcpy(ASTtype->RHS, RHS);
		
	return ASTtype;
	
}

struct AST * AST_Func(char nodeType[50], char LHS[50], char RHS[50]){
	
	struct AST* ASTtype = malloc(sizeof(struct AST));
	strcpy(ASTtype->nodeType, nodeType);
	strcpy(ASTtype->LHS, LHS);
	strcpy(ASTtype->RHS, RHS);
		
	return ASTtype;
	
}

struct AST * AST_Write(char nodeType[50], char LHS[50], char RHS[50]){
	
	struct AST* ASTtype = malloc(sizeof(struct AST));
	strcpy(ASTtype->nodeType, nodeType);
	strcpy(ASTtype->LHS, LHS);
	strcpy(ASTtype->LHS, RHS);
		
	return ASTtype;
	
}

void printDots(int num)
{
	for (int i = 0; i < num; i++)
		printf("      ");
}

void printAST(struct AST* tree, int level){
	if (tree == NULL) return;
	printDots(level);
	printf("%s\n", tree->nodeType);
	printDots(level);
	printf("%s %s\n", tree->LHS, tree->RHS);
	if(tree->left != NULL) printAST(tree->left, level+1); else return;
	if(tree->right != NULL) printAST(tree->right, level+1); else return;
	
}

























