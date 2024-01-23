// ---- Functions to handle IR code emissions ---- //
//#include <stdio.h>
FILE *IRcode;
//int tempVarCounterr = 0;

void emitBinaryOperation(const char* result, const char* operand1, const char* operation, const char* operand2) {
    fprintf(IRcode, "%s = ASSIGN %s %s %s\n", result, operand1, operation, operand2);
}


void  initIRcodeFile(){
    IRcode = fopen("IRcode.ir", "a");
    fprintf(IRcode, "\n\n#### IR Code ####\n\n");
}


void emitAssignment(char* id1, char* id2){
    fprintf(IRcode, "%s = LOAD %s\n", id1, id2);
}

void emitConstantIntAssignment (char id1[50], char id2[50]){
    fprintf(IRcode, "%s = LOAD %s\n", id1, id2);
}

void emitWriteId(char * id){
    fprintf (IRcode, "OUTPUT %s\n", "T2");
}
