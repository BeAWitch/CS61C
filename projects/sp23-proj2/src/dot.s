.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    # Prologue
    bge zero, a2, return_36
    bge zero, a3, return_37
    bge zero, a4, return_37
    j pre

return_36:
    li a0, 36
    j exit
return_37:
    li a0, 37
    j exit

pre:
    li t0, 4
    mul a3, a3, t0
    mul a4, a4, t0
    li t0, 0

loop_start:
    beq a2, zero, loop_end
    lw t1, 0(a0)
    lw t2, 0(a1)
    mul t3, t1, t2
    add t0, t0, t3
    add a0, a0, a3
    add a1, a1, a4
    addi a2, a2, -1
    j loop_start

loop_end:
    # Epilogue
    mv a0, t0
    jr ra
