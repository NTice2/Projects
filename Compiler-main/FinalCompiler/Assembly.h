#include <stdio.h>
#include <stdbool.h>

// Register allocation
char* registers[10] = {"$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", "$t8", "$t9"};
bool registerInUse[10] = {false}; // Initially, all registers are available
char* addReg = "";

char* getAvailableRegister() {
    for (int i = 0; i < 10; i++) {
        if (!registerInUse[i]) {
            registerInUse[i] = true; // Mark the register as in use
            return registers[i];
        }
    }
    // If all registers are in use, you should handle this situation accordingly (e.g., spill to memory).
    // For this example, we'll just return a random register, but in a real implementation, you should handle it better.
    return registers[0];
}

void releaseRegister(char* registerName) {
    for (int i = 0; i < 10; i++) {
        if (strcmp(registerName, registers[i]) == 0) {
            registerInUse[i] = false; // Mark the register as available
            break;
        }
    }
}


int isNumeric(const char* str) {
    for (int i = 0; str[i] != '\0'; i++) {
        if (!isdigit(str[i])) {
            return 0; // Not numeric
        }
    }
    return 1; // Numeric
}

// Set of functions to emit MIPS code
FILE* MIPScode;

void initAssemblyFile() {
    // Create a MIPS file with a generic header that needs to be in every file
    MIPScode = fopen("MIPScode.asm", "a");

    fprintf(MIPScode, ".text\n");
    fprintf(MIPScode, "main:\n");
    fprintf(MIPScode, "# -----------------------\n");
}

void emitMIPSConstantIntAssignment(char* id1, char* id2) {
    char* targetRegister = getAvailableRegister();

    // Store id2 in the selected register
    fprintf(MIPScode, "li %s, %s\n", targetRegister, id2);
}

void emitMIPSAssignment(char* id1, char* id2) {
    char* targetRegister = getAvailableRegister();

    // Store id1 in the selected register
    fprintf(MIPScode, "li %s, %s\n", targetRegister, id1);

    // Use a temporary register for id2
    char* tempRegister = getAvailableRegister();
    fprintf(MIPScode, "li %s, %s\n", tempRegister, id2);

    // Copy the value from the temporary register to the target register
    fprintf(MIPScode, "move %s, %s\n", targetRegister, tempRegister);

    // Release the temporary register
    releaseRegister(tempRegister);
}

void emitMIPSBinaryOperation(char* id1, char* OP, char* id2) {
    char* targetRegister = getAvailableRegister();
    

     if (isNumeric(id1)) {
        fprintf(MIPScode, "li %s, %s\n", targetRegister, id1);
    } else {
        fprintf(MIPScode, "move %s, %s\n", targetRegister, id1);
    }


    // Load values into the selected register and a temporary register
    //fprintf(MIPScode, "li %s, %s\n", targetRegister, id1);
    
    char* tempRegister = getAvailableRegister();
    
    //fprintf(MIPScode, "li %s, %s\n", tempRegister, id2);
    
      if (isNumeric(id2)) {
        fprintf(MIPScode, "li %s, %s\n", tempRegister, id2);
    } else {
        fprintf(MIPScode, "move %s, %s\n", tempRegister, id2);
    }

    
    
    
    // Perform the binary operation and store the result in the selected register
    fprintf(MIPScode, "add %s, %s, %s\n", targetRegister, targetRegister, tempRegister);
    
    
    addReg = targetRegister;

    // Release the temporary register
    releaseRegister(tempRegister);
}

void emitMIPSBinaryOperation2(char* OP, char* id1) {
    char* targetRegister = getAvailableRegister();

    // Check if id1 is a numeric value or a variable
    if (isNumeric(id1)) {
        // If id1 is numeric, load it into the target register using 'li'
        fprintf(MIPScode, "li %s, %s\n", targetRegister, id1);
    } else {
        // If id1 is a variable, load its value into the target register using 'move'
        fprintf(MIPScode, "move %s, %s\n", targetRegister, id1);
    }

    // Perform the binary operation and store the result in the selected register
    fprintf(MIPScode, "add %s, %s, %s\n", targetRegister, targetRegister, addReg);

    addReg = targetRegister;
}





void emitMIPSWriteId(char* id) {
    // Use $a0 for printing
    fprintf(MIPScode, "move $a0, %s\n", addReg);
}

void emitEndOfAssemblyCode() {
    fprintf(MIPScode, "# -----------------\n");
    fprintf(MIPScode, "#  Done, terminate program.\n\n");
    fprintf(MIPScode, "li $v0, 1   # call code for terminate\n");
    fprintf(MIPScode, "syscall      # system call (terminate)\n");
    fprintf(MIPScode, "li $v0, 10   # call code for terminate\n");
    fprintf(MIPScode, "syscall      # system call (terminate)\n");
    fprintf(MIPScode, ".end main\n");
}

