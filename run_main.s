#   316554641   David Levin

.section	.rodata                  
# Strings format for scanf:
sizeValue: .string "%d"
strValue: .string "%s"

.section    .text                                   

.globl run_main
	.type	run_main, @function
run_main:
    pushq %rbp
    movq %rsp, %rbp

    xor %r13, %r13                          # init %r13
    xor %r14, %r14                          # init %r14 

    subq $4, %rsp                           # allocate memory for one int - first pString length
    movq %rsp, %rsi                         # rsi (second arg) is able to hold the given int from the user
    movq $sizeValue, %rdi                   # %rdi (first arg) holds the format
    xor %rax, %rax                          # init %rax
    call scanf

    movzbq (%rsp), %r12                     # %r8 holds the size of the first string
    subq $-4, %rsp                          # deallocate line 19
    subq $1, %rsp                           # allocate memory for null char
    movb $0, (%rsp)                         # put null char       
    subq %r12, %rsp                         # allocate the given size for the first string
    movq %rsp, %rsi                         # rsi (second arg) is able to hold the given string from the user
    movq $strValue, %rdi                    # %rdi (first arg) holds the format
    xor %rax, %rax                          # init %rax
    call scanf

    subq $1, %rsp                           # allocate memory for first pString byte - size of string
    movb %r12b, (%rsp)                      # %rsp holds the size of the first pString
    movq %rsp, %r13                         # %r13 holds the entire first pString

    subq $4, %rsp                           # allocate memory for one int - second pString length
    movq %rsp, %rsi                         # rsi (second arg) is able to hold the given int from the user
    movq $sizeValue, %rdi                   # %rdi (first arg) holds the format
    xor %r12, %r12                          # init %r12
    xor %rax, %rax                          # init %rax
    call scanf

    movzbq (%rsp), %r12                     # %r12 holds the size of the second string
    subq $-4, %rsp                          # deallocate line 39
    subq $1, %rsp                           # allocate memory for null char
    movb $0, (%rsp)                         # put null char              
    sub %r12, %rsp                          # allocate the given size for the second string
    movq %rsp, %rsi                         # rsi (second arg) is able to hold the given string from the user
    movq $strValue, %rdi                    # %rdi (first arg) holds the format
    xor %rax, %rax                          # init %rax
    call scanf

    subq $1, %rsp                           # allocate memory for first pString byte - size of string
    movb %r12b, (%rsp)                      # %rsp holds the size of the second pString
    movq %rsp, %r14                         # %r14 holds the entire first pString
    
    subq $4, %rsp                           # allocate memory for one int - number of case
    movq %rsp, %rsi                         # rsi (second arg) is able to hold the given int from the user
    movq $sizeValue, %rdi                   # %rdi (first arg) holds the format
    xor %rax, %rax                          # init %rax
    call scanf

    movzbq (%rsp), %rdi                     # %rdi (first arg) holds the case choice
    movq %r13, %rsi                         # %rsi (second arg) holds the first pString
    movq %r14, %rdx                         # %rdx (third arg) holds the second pString
    xor %rax, %rax                          # init %rax
    call run_func

    movq %rbp, %rsp                         # restore "old" stack frame %rsp
    popq %rbp                               # release %rbp
    ret