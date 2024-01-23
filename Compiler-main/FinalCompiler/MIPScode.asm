.text
main:
# -----------------------
li $t0, 4
li $t1, 4
li $t2, $t0
li $t3, 1
add $t2, $t2, $t3
move $a0, $t2
# -----------------
#  Done, terminate program.

li $v0, 1   # call code for terminate
syscall      # system call (terminate)
li $v0, 10   # call code for terminate
syscall      # system call (terminate)
.end main
