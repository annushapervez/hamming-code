.data 0x10000000 
.asciiz "\nHamming Code System\n
Select:\n
1 - Enter a 7-bit Hamming code\n
2 - Extract the 4-bit data word encoded by a 7-bit Hamming code\n
3 - Determine if there is an error in a 7-bit Hamming code\n
4 - Enter a 4-bit data word\n
5 - Encode the 4-bit data word to a 7-bit Hamming code\n
6 - Print 4-bit data word\n
7 - Print 7-bit Hamming code\n
8 - Quit\n
Enter Choice: "
.data 0x10000200 
.asciiz "\nEnter code: "
.data 0x10000230 
.asciiz "\n"
.data 0x10000250
.asciiz "\nError at position: "
.data 0x10000270
.asciiz "\nNo error"
.data 0x10000280
.asciiz "\nEnter 4-bit data word: "
.data 0x10000400 # your range is 0x10000000 to 0x100003FF = 1024 bytes
HMGCW:    .asciiz    "1010001"  # This Hamming code word has one bit error
space:    .space     0x4
DATAW:    .asciiz    "1011"     # This data word corresponds to the corrected
                                # Hamming code word above


.text
.globl Hamming
.globl main



#null terminate everything
#increment $a0/ $a1 register possitions when adding 
#data addresses right 

main:
        lui  $a0, 0x1000
        ori  $a0, $a0, 0x400
        ori  $a1, $a0, 0x00C
        jal  Hamming
        or   $0,  $0,  $0

        ori  $v0, $0, 0xA
        syscall              # Exit syscall

Hamming: 
    #save memory address for $a0 and $a1
    add $s5, $0, $a0
    add $s6, $0, $a1

menu:
    # Display the prompt to the user
    addi $v0, $0, 4
    lui $a0, 0x1000
    syscall

    # Read user input (will be one number)
    addi $v0, $0, 8
    lui $a0, 0x1000
    addi $a0, $a0, 0x0170
    addi $a1, $0, 2
    syscall
    
    lui $t0, 0x1000
    addi $t0, $t0, 0x0170
    lb $s0, ($t0)

    #if 1 pressed
    addi $t9, $0, 49
    beq $s0, $t9, option_1
    and $0, $0, $0
    #if 2 is pressed
    addi $t9, $0, 50
    beq $s0, $t9, option_2
    and $0, $0, $0
    #if 3 is pressed
    addi $t9, $0, 51
    beq $s0, $t9, option_3
    and $0, $0, $0
    #if 4 is pressed 
    addi $t9, $0, 52
    beq $s0, $t9, option_4
    and $0, $0, $0
    #if 5 is pressed 
    addi $t9, $0, 53
    beq $s0, $t9, option_5
    and $0, $0, $0
    #if 6 is pressed 
    addi $t9, $0, 54
    beq $s0, $t9, option_6
    and $0, $0, $0
    #if 7 is pressed 
    addi $t9, $0, 55
    beq $s0, $t9, option_7
    and $0, $0, $0
    #if 8 is pressed
    addi $t9, $0, 56
    beq $s0, $t9, option_8
    and $0, $0, $0

    jr $ra
    and $0, $0, $0

option_1:
    #read prompt of "Enter a 7-bit Hamming code\n"" 
    addi $v0, $0, 4
    lui $a0, 0x1000
    addi $a0, $a0, 0x0200
    syscall

    # Read user input (will be 7 bits)
    addi $v0, $0, 8
    lui $a0, 0x1000
    addi $a0, $a0, 0x0210
    addi $a1, $0, 8
    syscall
    lb $t7,  ($a0)   
    j storing_a0

storing_a0: 
    lui $t8, 0x1000
    addi $t8, $t8, 0x0210
    
    lb $t1, 6($t8) 
    lb $t2, 5($t8)  
    lb $t3, 4($t8) 
    lb $t4, 3($t8)   
    lb $t5, 2($t8)   
    lb $t6, 1($t8)   

    sb $t7, ($s5)
    addi $s5, $s5, 1 

    sb $t6, ($s5)
    addi $s5, $s5, 1 
 
    sb $t5, ($s5)
    addi $s5, $s5, 1 

    sb $t4, ($s5)
    addi $s5, $s5, 1 

    sb $t3, ($s5)
    addi $s5, $s5, 1 

    sb $t2, ($s5)
    addi $s5, $s5, 1 

    sb $t1, ($s5)
    addi $s5, $s5, 1  
    sb $zero, ($s5)

    addi $s5, $s5, -7
    add $a0, $0, $s5

    j menu
    and $0, $0, $0

option_2:
    lui $t8, 0x1000
    addi $t8, $t8, 0x0210

    lb $t1, 6($t8) 
    lb $t2, 5($t8)  
    lb $t3, 4($t8) 
    lb $t4, 3($t8)   
    lb $t5, 2($t8)   
    lb $t6, 1($t8)   
    lb $t7,  ($t8)   

    #bit c3, postions  4, 5, 6, and 7
    #changing c2 
    addi $s3, $0, 0

    xor $s3, $s3, $t4
    xor $s3, $s3, $t5
    xor $s3, $s3, $t6
    xor $s3, $s3, $t7

    #bit c2, postions  2, 3, 6 and 7
    #changing c2 
    addi $s2, $0, 0

    xor $s2, $s2, $t2
    xor $s2, $s2, $t3
    xor $s2, $s2, $t6
    xor $s2, $s2, $t7

    #bit c1, postions  1, 3, 5, and 7 
    #changing c1
    addi $s1, $0, 0

    xor $s1, $s1, $t1
    xor $s1, $s1, $t3
    xor $s1, $s1, $t5
    xor $s1, $s1, $t7

    sll $s3, $s3, 2   
    sll $s2, $s2, 1   
    or $s3, $s3, $s2   
    or $s3, $s3, $s1  

    bne $s3, $zero, flip
    and $0, $0, $0

    j storing_a1
    and $0, $0, $0

flip:
    lui $t1, 0x1000
    addi $t1, $t1, 0x0217  
    sub $t1, $t1, $s3  
    lb $s7, ($t1) 

    addi $s4, $0, 1
    xor $s4, $s4, $s7  
    sb $s4, ($t1)
    j storing_a1
    and $0, $0, $0

storing_a1:
    lui $t8, 0x1000
    addi $t8, $t8, 0x0210
    lb $t3, 4($t8) 
    lb $t5, 2($t8)   
    lb $t6, 1($t8)   
    lb $t7,  ($t8)  

    sb $t7, ($s6)
    addi $s6, $s6, 1 

    sb $t6, ($s6)
    addi $s6, $s6, 1 
 
    sb $t5, ($s6)
    addi $s6, $s6, 1 

    sb $t3, ($s6)
    addi $s6, $s6, 1 

    sb $zero, ($s6)
    addi $s6, $s6, -4
    add $a1, $0, $s6

    j menu
    and $0, $0, $0

option_3:
    lb $t1, 6($s5) 
    lb $t2, 5($s5)  
    lb $t3, 4($s5) 
    lb $t4, 3($s5)   
    lb $t5, 2($s5)   
    lb $t6, 1($s5)   
    lb $t7,  ($s5)   

    #bit c3, postions  4, 5, 6, and 7
    #changing c2 
    addi $s3, $0, 0

    xor $s3, $s3, $t4
    xor $s3, $s3, $t5
    xor $s3, $s3, $t6
    xor $s3, $s3, $t7

    #bit c2, postions  2, 3, 6 and 7
    #changing c2 
    addi $s2, $0, 0

    xor $s2, $s2, $t2
    xor $s2, $s2, $t3
    xor $s2, $s2, $t6
    xor $s2, $s2, $t7

    #bit c1, postions  1, 3, 5, and 7 
    #changing c1
    addi $s1, $0, 0

    xor $s1, $s1, $t1
    xor $s1, $s1, $t3
    xor $s1, $s1, $t5
    xor $s1, $s1, $t7

    sll $s3, $s3, 2   
    sll $s2, $s2, 1   
    or $s3, $s3, $s2   
    or $s3, $s3, $s1  

    bne $s3, $zero, error
    and $0, $0, $0
    # print out no error from address 300
    addi $v0, $0, 4
    lui $a0, 0x1000
    addi $a0, $a0, 0x0270
    syscall
    j menu
    and $0, $0, $0

error:  
    addi $v0, $0, 4
    lui $a0, 0x1000
    addi $a0, $a0, 0x0250
    syscall

    addi $v0, $0, 1
    add $a0, $0, $s3
    syscall
    j menu 

option_4: 
    addi $v0, $0, 4
    lui $a0, 0x1000
    addi $a0, $a0, 0x0280
    syscall

    # Read user input (will be 7 bits)
    addi $v0, $0, 8
    lui $a0, 0x1000
    addi $a0, $a0, 0x0300
    addi $a1, $0, 5
    syscall
    lb $t4, ($a0)   
    j storing_a12
    and $0, $0, $0

storing_a12:
    lui $t8, 0x1000
    addi $t8, $t8, 0x0300
    
    lb $t1, 3($t8) 
    lb $t2, 2($t8)  
    lb $t3, 1($t8) 

    sb $t4, ($s6)
    addi $s6, $s6, 1 

    sb $t3, ($s6)
    addi $s6, $s6, 1 

    sb $t2, ($s6)
    addi $s6, $s6, 1 

    sb $t1, ($s6)
    addi $s6, $s6, 1  
    sb $zero, ($s6)

    addi $s6, $s6, -4
    add $a1, $0, $s6
    j menu

option_5:
    lui $t8, 0x1000
    addi $t8, $t8, 0x0300

    lb $t3, 3($t8) 
    lb $t5, 2($t8)   
    lb $t6, 1($t8)   
    lb $t7,  ($t8)   


    #bit c3, postions  4, 5, 6, and 7
    #changing c2 
    addi $s3, $0, 0
    xor $s3, $s3, $t5
    xor $s3, $s3, $t6
    xor $s3, $s3, $t7

    #bit c2, postions  2, 3, 6 and 7
    #changing c2 
    addi $s2, $0, 0
    xor $s2, $s2, $t3
    xor $s2, $s2, $t6
    xor $s2, $s2, $t7

    #bit c1, postions  1, 3, 5, and 7 
    #changing c1
    addi $s1, $0, 0
    xor $s1, $s1, $t3
    xor $s1, $s1, $t5
    xor $s1, $s1, $t7

    j storing_a02
    and $0, $0, $0

storing_a02:
    sb $t7, ($s5)
    addi $s5, $s5, 1 

    sb $t6, ($s5)
    addi $s5, $s5, 1 
 
    sb $t5, ($s5)
    addi $s5, $s5, 1 

    #s3
    sb $s3, ($s5)
    addi $s5, $s5, 1 

    sb $t3, ($s5)
    addi $s5, $s5, 1 

    #s2
    sb $s2, ($s5)
    addi $s5, $s5, 1 
    #s1
    sb $s1, ($s5)
    addi $s5, $s5, 1  
    sb $zero, ($s5)

    addi $s5, $s5, -7
    add $a0, $0, $s5

    j menu
    and $0, $0, $0
  
option_6:    
    addi $v0, $0, 4
    lui $a0, 0x1000
    addi $a0, $a0, 0x0230
    syscall

    addi $v0, $0, 4
    add $a0, $0, $s6
    syscall
    j menu 
    and $0, $0, $0

option_7:
    addi $v0, $0, 4
    lui $a0, 0x1000
    addi $a0, $a0, 0x0230
    syscall

    addi $v0, $0, 4
    add $a0, $0, $s5
    syscall
    j menu 
    and $0, $0, $0

option_8:
    add $a1, $0, $s6
    add $a0, $0, $s5
    jr $ra
    and $0, $0, $0
