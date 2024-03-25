.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    bge zero, a1, return_38
    bge zero, a2, return_38
    bge zero, a4, return_38
    bge zero, a5, return_38
    bne a2, a4, return_38
    # Prologue
    addi sp, sp, -40
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)

    mv s0, a0
    mv s1, a3
    mv s2, a1 # row of m0
    mv s3, a2 # col of m0
    mv s4, a5 # col of m1
    mv s5, a6 # d

    li s6, 0 # index of d
    li s7, 0 # row

    j outer_loop_start

return_38:
    li a0, 38
    j exit

outer_loop_start:
    beq s7, s2, outer_loop_end
    
    li s8, 0
inner_loop_start:
    beq s8, s4, inner_loop_end

    mv a0, s0
    mv a1, s1
    mv a2, s3
    li a3, 1
    mv a4, s4
    jal ra dot

    sw a0, 0(s5)
    addi s5, s5, 4
    addi s1, s1, 4
    addi s8, s8, 1

    j inner_loop_start

inner_loop_end:
    addi s7, s7, 1
    li t0, 4
    mul t0, t0, s3 # offset
    add s0, s0, t0
    # go back
    li t0, 4
    mul t0, t0, s4
    sub s1, s1, t0
    j outer_loop_start

outer_loop_end:
    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    lw s5 24(sp)
    lw s6 28(sp)
    lw s7 32(sp)
    lw s8 36(sp)
    addi sp sp 40
    jr ra
