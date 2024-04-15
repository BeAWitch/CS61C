.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

    # fopen
    li a1, 0
    jal fopen
    li t0, -1
    beq a0, t0, error_fopen

    # get row
    mv s0, a0 # store file descriptor
    mv a1, s1
    li a2, 4
    jal fread
    li t0, 4
    bne a0, t0, error_fread
    lw s1, 0(s1) # store row

    # get col
    mv a0, s0
    mv a1, s2
    li a2, 4
    jal fread
    li t0, 4
    bne a0, t0, error_fread
    lw s2, 0(s2) # store col

    # malloc
    mul a0, s1, s2
    mul a0, a0, t0 # size
    mv s4, a0 # store size
    jal malloc
    beq a0, zero, error_malloc
    mv s3, a0 # store return value

    # get matrix
    mv a1, a0
    mv a0, s0
    mv a2, s4
    jal fread
    bne a0, s4, error_fread

    # fclose
    mv a0, s0
    jal fclose
    bne a0, zero, error_fclose

    # Epilogue
    mv a0, s3
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24
    jr ra

error_malloc:
    li a0, 26
    j exit

error_fopen:
    li a0, 27
    j exit

error_fclose:
    li a0, 28
    j exit

error_fread:
    li a0, 29
    j exit
