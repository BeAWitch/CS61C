.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    blt zero, a1, pre
    li a0, 36
    j exit
    
pre:
    li t0, 0
    lw t1, 0(a0)
    li t3, 0
    addi a0, a0, 4
    addi a1, a1, -1

loop_start:
    beq t0, a1, loop_end
    lw t2, 0(a0)
    addi t0, t0, 1
    addi a0, a0, 4

    bge t1, t2, loop_start
    mv t3, t0
    mv t1, t2


loop_continue:
    j loop_start

loop_end:
    # Epilogue
    mv a0, t3
    jr ra
