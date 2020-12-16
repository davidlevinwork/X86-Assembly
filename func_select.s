.section	.rodata                       
# Strings format for printf & scanf:
intValue: .string "%hhu"
charValue: .string " %c"
strCase50_60: .string "first pstring length: %d, second pstring length: %d\n"
strCase52: .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
strCase53: .string "length: %d, string: %s\n"
strCase54: .string "length: %d, string: %s\n"
strCase55: .string "compare result: %d\n"
strDefaultCase: .string "invalid option!\n"

# Building the jump table
    .align 8                                # Align address to multiple of 8
.SwitchTable:
  .quad .case50                             # case 50: pstrlen function
  .quad .caseDefault                        # case 51: default case
  .quad .case52                             # case 52: replaceChar function
  .quad .case53                             # case 53: pstrijcpy function
  .quad .case54                             # case 54: swapCase function
  .quad .case55                             # case 55: pstrijcmp function
  .quad .caseDefault                        # case 56: default case
  .quad .caseDefault                        # case 57: default case
  .quad .caseDefault                        # case 58: default case
  .quad .caseDefault                        # case 59: default case
  .quad .case50                             # case 60: pstrlen function ()

.section  .text    

.globl run_func
	.type	run_func, @function
run_func:
  leaq -50(%rdi), %rcx                      # change the rcx value to be flag - 50 (%rdi holds the flag value)
  cmpq $10, %rcx                            # comapre flag:10
  ja .caseDefault                           # if rcx > 60 OR 50 > rcx --> go to default case
  jmp *.SwitchTable(,%rcx,8)                # get the address in the SwitchTable

.case50:                                    # case 50: pstrlen function
  pushq %rbp
  movq %rsp, %rbp
  
  movq %rsi, %rdi                           # %rdi (first arg) holds the first string
  xor %rax ,%rax                            # init %rax
  call pstrlen
  movq %rax, %r12                           # %r12 holds the length of the first string

  movq %rdx, %rdi                           # %rdi (first arg) holds the second string
  xor %rax, %rax                            # init %rax
  call pstrlen
  movq %rax, %r13                           # %r13 holds the length of the second string

  movq $strCase50_60, %rdi                  # %rdi (first arg) holds the string format 
  movq %r12, %rsi                           # %rsi (second arg) holds the first string length
  movq %r13, %rdx                           # %rdx (third arg) holds the second string length
  xor %rax, %rax                            # init %rax
  call printf

  movq %rbp, %rsp                           # restore "old" stack frame %rsp  
  popq %rbp                                 # release %rbp
  ret 

.case52:                                    # case 52: replaceChar function
  pushq %rbp
  movq %rsp, %rbp 

  movq %rsi, %r12                           # %r12 holds the first string
  movq %rdx, %r13                           # %r13 holds the second string

  subq $1, %rsp                             # allocate memory for one char
  movq %rsp, %rsi                           # rsi (second arg) is able to hold the given char from the user
  movq $charValue, %rdi                     # %rdi (first arg) holds the format
  xor %rax, %rax                            # init %rax
  call scanf

  movb (%rsp), %r14b                        # %r14 holds the "old" char input of the user (the char is in %rsp)
  addq $1, %rsp                             # deallocate line 70

  subq $1, %rsp                             # allocate memory for one char
  movq %rsp, %rsi                           # rsi (second arg) is able to hold the given char from the user
  movq $charValue, %rdi                     # %rdi (first arg) holds the format
  xor %rax, %rax                            # init %rax
  call scanf

  movb (%rsp), %r15b                        # %r15 holds the "new" char input of the user (the char is in %rsp)
  addq $1, %rsp                             # deallocate line 79

  xor %rax, %rax                            # init %rax
  movq %r12, %rdi                           # %rdi (first arg) holds the first string BEFORE the swap
  movq %r14, %rsi                           # %rsi (second arg) holds the "old" char
  movq %r15, %rdx                           # %rdx (third arg) holds the "new" char
  call replaceChar

  movq %rax, %r12                           # %r12 holds the first string AFTER the swap
  
  xor %rax,%rax                             # init %rax
  movq %r13, %rdi                           # %rdi (first arg) holds the second string BEFORE the swap
  movq %r14, %rsi                           # %rsi (second arg) holds the "old" char
  movq %r15, %rdx                           # %rdx (third arg) holds the "new" char
  call replaceChar

  movq %rax, %r13                           # %r13 holds the second string AFTER the swap

  movq $strCase52, %rdi                     # %rdi (first arg) holds the format
  movq %r14, %rsi                           # %rsi (second arg) holds the "old" char
  movq %r15, %rdx                           # %rdx (third arg) holds the "new" char
  movq %r12, %rcx                           # %rcx (fourth arg) holds the first string AFTER the swap
  add $1, %rcx                              # print only the chars (without the string size)
  movq %r13, %r8                            # %r8 (fifth arg) holds the second string AFTER the swap
  add $1, %r8                               # print only the chars (without the string size)
  xor %rax, %rax                            # init %rax
  call printf

  movq %rbp, %rsp                           # restore "old" stack frame %rsp  
  popq %rbp                                 # release %rbp
  ret 

.case53:                                    # case 53: pstrijcpy function
  pushq %rbp
  movq %rsp, %rbp
  
  movq %rsi, %r12                           # init %r12
  movq %rdx, %r13                           # init %r13

  subq $1, %rsp                             # allocate memory for one char
  movq %rsp, %rsi                           # rsi (second arg) is able to hold the given int from the user
  movq $intValue, %rdi                      # %rdi (first arg) holds the format
  xor %rax, %rax                            # init %rax
  call scanf

  movq (%rsp), %r14                         # %r14 holds the index i input of the user (the int is in %rsp)
  subq $-1, %rsp                            # deallocate line 125

  subq $1, %rsp                             # allocate memory for one char
  movq %rsp, %rsi                           # rsi (second arg) is able to hold the given int from the user
  movq $intValue, %rdi                      # %rdi (first arg) holds the format
  xor %rax, %rax                            # init %rax
  call scanf

  movq (%rsp), %r15                         # %r15 holds the index j input of the user (the int is in %rsp)
  subq $-1, %rsp                            # deallocate line 134

  xor %rax, %rax                            # init %rax
  movq %r12, %rdi                           # %rdi holds the dst string 
  movq %r13, %rsi                           # %rsi holds the src string
  movzbq %r14b, %rdx                        # %rdx holds the first index (i) (the rest are 0's)
  movzbq %r15b, %rcx                        # %rcx holds the second index (j) (the rest are 0's)
  call pstrijcpy
  
  movq %rax, %rdx                           # %rdx (third arg) holds the result of the pstrijcpy
  xor %rax, %rax                            # init %rax
  movq %r12, %rdi                           
  call pstrlen
  movq %rax, %r14                           # %r14 holds the length of the dst string
  movq %r13, %rdi                           # %rdi holds the src string
  xor %rax, %rax                            # init %rax
  call pstrlen
  movq %rax, %r15                           # %r15 holds the length of the src string  

  movq $strCase53, %rdi                     # %rdi (first arg) holds the format
  movq %r14, %rsi                           # %rsi (second arg) holds the length of dst
  add $1, %rdx                              # print only the chars (without the string size)
  xor %rax, %rax                            # init %rax
  call printf

  movq $strCase53, %rdi                     # %rdi (first arg) holds the format
  movq %r15, %rsi                           # %rsi (second arg) holds the length of src
  movq %r13, %rdx                           # %rdx (third arg) holds the src string
  add $1, %rdx                              # print only the chars (without the string size)
  xor %rax, %rax                            # init %rax
  call printf

  movq %rbp, %rsp                           # restore "old" stack frame %rsp 
  popq %rbp                                 # release %rbp
  ret 

.case54:                                    # case 54: swapCase function
  pushq %rbp  
  movq %rsp, %rbp

  xor %rax, %rax                            # init %rax
  movq %rsi, %rdi                           # %rdi (first arg) holds the first string
  call pstrlen 
  movq %rax, %r12                           # %r12 holds the length of the first string
  xor %rax, %rax                            # init %rax
  call swapCase
  movq %rax, %r13                           # %r13 holds the "new" first string (after the swap function)

  xor %rax, %rax                            # init %rax
  movq %rdx, %rdi                           # rdi (first arg) holds the second arg
  call pstrlen                            
  movq %rax, %r14                           # %r14 holds the length of the second string
  xor %rax, %rax                            # init %rax
  call swapCase
  movq %rax, %r15                           # %r15 holds the "new" second string (after the swap function)

  movq $strCase54, %rdi                     # %rdi (first arg) holds the string format 
  movq %r12, %rsi                           # %rsi (second arg) holds the length of the first string
  movq %r13, %rdx                           # %rdx (third arg) holds the "new" first string (after the swap function)
  add $1, %rdx                              # print only the chars (without the string size)
  xor %rax, %rax                            # init %rax
  call printf                               # printing the data of the first string

  movq $strCase54, %rdi                     # %rdi (first arg) holds the string format 
  movq %r14, %rsi                           # %rsi (second arg) holds the length of the second string
  movq %r15, %rdx                           # %rdx (third arg) holds the "new" second string (after the swap function)
  add $1, %rdx                              # print only the chars (without the string size)
  xor %rax, %rax                            # init %rax
  call printf                               # printing the data of the first string

  movq %rbp, %rsp                           # restore "old" stack frame %rsp
  popq %rbp                                 # release %rbp
  ret 

.case55:                                    # case 55: pstrijcmp function
  pushq %rbp
  movq %rsp, %rbp
  
  movq %rsi, %r12                           # %r12 holds the first string
  movq %rdx, %r13                           # %r13 holds the second string

  subq $1, %rsp                             # allocate memory for one char
  movq %rsp, %rsi                           # rsi (second arg) is able to hold the given int from the user
  movq $intValue, %rdi                      # %rdi (first arg) holds the format
  xor %rax, %rax                            # init %rax
  call scanf

  movq (%rsp), %r14                         # %r14 holds the index i input of the user (the int is in %rsp)
  subq $-1, %rsp                            # deallocate line 222

  subq $1, %rsp                             # allocate memory for one char
  movq %rsp, %rsi                           # rsi (second arg) is able to hold the given int from the user
  movq $intValue, %rdi                      # %rdi (first arg) holds the format
  xor %rax, %rax                            # init %rax
  call scanf

  movq (%rsp), %r15                         # %r15 holds the index j input of the user (the int is in %rsp)
  subq $-1, %rsp                            # deallocate line 231

  xor %rax, %rax                            # init %rax
  movq %r12, %rdi                           # %rdi holds the first string
  movq %r13, %rsi                           # %rsi holds the second string
  movzbq %r14b, %rdx                        # %rdx holds the first index (i)
  movzbq %r15b, %rcx                        # %rcx holds the second index (j)
  call pstrijcmp

  movq %rax, %rsi                           # %rsi (second arg) holds the result of the compare
  movq $strCase55, %rdi                     # %rdi (first arg) holds the format
  xor %rax, %rax                            # init %rax
  call printf

  movq %rbp, %rsp                           # restore "old" stack frame %rsp 
  popq %rbp                                 # release %rbp 
  ret 

.caseDefault:                               # case DEFAULT
  movq $strDefaultCase, %rdi                # %rdi (first arg) holds the format
  xor %rax, %rax                            # init %rax
  call printf 
  ret
