.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    li t0, 5
    bne a0, t0, error_args

    # Prologue
    addi sp, sp, -52
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp) # m0
    sw s4, 20(sp) # row of m0
    sw s5, 24(sp) # col of m0
    sw s6, 28(sp) # m1
    sw s7, 32(sp) # row of m1
    sw s8, 36(sp) # col of m1
    sw s9, 40(sp) # input
    sw s10, 44(sp) # row of input
    sw s11, 48(sp) # col of input

    mv s0, a0
    mv s1, a1
    mv s2, a2

    # Read pretrained m0
    lw a0, 4(s1)
    addi sp, sp, -4
    mv a1, sp
    addi sp, sp, -4
    mv a2, sp
    jal read_matrix
    mv s3, a0
    lw s5, 0(sp)
    lw s4, 4(sp)
    addi sp, sp, 8

    # Read pretrained m1
    lw a0, 8(s1)
    addi sp, sp, -4
    mv a1, sp
    addi sp, sp, -4
    mv a2, sp
    jal read_matrix
    mv s6, a0
    lw s8, 0(sp)
    lw s7, 4(sp)
    addi sp, sp, 8

    # Read input matrix
    lw a0, 12(s1)
    addi sp, sp, -4
    mv a1, sp
    addi sp, sp, -4
    mv a2, sp
    jal read_matrix
    mv s9, a0
    lw s11, 0(sp)
    lw s10, 4(sp)
    addi sp, sp, 8

    # Compute h = matmul(m0, input)
    li a0, 4
    mul a0, a0, s4
    mul a0, a0, s11
    jal malloc
    beq a0, zero, error_malloc
    mv s0, a0

    mv a0, s3
    mv a1, s4
    mv a2, s5
    mv a3, s9
    mv a4, s10
    mv a5, s11
    mv a6, s0
    jal matmul


    # Compute h = relu(h)
    mv a0, s0
    mul a1, s4, s11
    jal relu

    # Compute o = matmul(m1, h)
    li a0, 4
    mul a0, a0, s7
    mul a0, a0, s11
    jal malloc
    beq a0, zero, error_malloc
    
    mv s3, a0
    mv a6, a0
    mv a0, s6
    mv a1, s7
    mv a2, s8
    mv a3, s0
    mv a4, s4
    mv a5, s11
    jal matmul
    mv a0, s0
    jal free
    mv s0, s3

    # Write output matrix o
    lw a0, 16(s1)
    mv a1, s0
    mv a2, s7
    mv a3, s11
    jal write_matrix

    # Compute and return argmax(o)
    mv a0, s3
    mul a1, s7, s11
    jal argmax
    mv s3, a0

    # If enabled, print argmax(o) and newline
    bne s2, zero, classify_end
    jal print_int
    li a0, '\n'
    jal print_char

classify_end:
    mv a0, s0
    jal free

    mv a0, s3
    
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52

    jr ra

error_malloc:
    li a0 26
    j exit

error_args:
    li a0, 31
    j exit
