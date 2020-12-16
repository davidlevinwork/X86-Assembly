.section	.rodata                       
# Strings format for printf:
invalidValue: .string "invalid input!\n"

.section  .text      

.globl pstrlen
	.type	pstrlen, @function
pstrlen:
  xor %rax, %rax                            # init %rax
  movb (%rdi), %al                          # copy the first byte of first arg (holds the size)
  ret

.global replaceChar
  .type replaceChar, @function
replaceChar:
  pushq %rbp            
  movq %rsp, %rbp 
  
  xor %rax, %rax                            # init %rax
  xor %r8, %r8                              # init %r8
  xor %r9, %r9                              # init %r9
  xor %r10, %r10                            # init %r10 - will be our counter (to iterate over the string)
  movq %rdi, %r9                            # %r9 holds the begining address of the given string
  call pstrlen        
  movq %rax, %r8                            # %r8 holds the length of the given string 
  add $1, %r8                               # ensure that we will check each character in the string

.replaceCharLoop:
  cmpq %r10, %r8                            # check if we reach the end of the string
  je .replaceCharLoopQuit                   # if we got to the end of the string - quit the loop
  cmpb (%rdi), %sil                         # check if we find match: "old" char with current char
  je .replaceCharAction                     # if we found - jump to replace loop
  add $1, %rdi                              # increment the string to point next char
  incq %r10                                 # increment the counter 
  jmp .replaceCharLoop                      # iterate again

.replaceCharAction:
  movb %dl, (%rdi)                          # switch "old" char (dl) to "new" char (rdi)
  add $1, %rdi                              # increment the string to point the next char
  incq %r10                                 # increment the counter
  jmp .replaceCharLoop                            
  
.replaceCharLoopQuit:
  movq %r9, %rax                            # %rax holds now the new string
  movq %rbp, %rsp                           # restore "old" stack frame %rsp  
  popq %rbp                                 # release %rbp
  ret


.global pstrijcpy
  .type pstrijcpy, @function
pstrijcpy:
  pushq %rbp
  movq %rsp, %rbp 
  movq %rdi, %r15                           # %r15 holds the dst string
  movzbq (%rsi), %r10                       # %r10 holds the length of the src string (the rest are 0's)
  movzbq (%rdi), %r11                       # %r11 holds the length of the dst string (the rest are 0's)
  xor %rax, %rax                            # init %rax

  cmpb %cl, %dl                             # checking if i > j (illegal)
  ja .pstrijcpyError   
  cmpq %r10, %rcx                           # checking if the index j is legall in his size (unsigned comparison)
  jae .pstrijcpyError                       # illegal 
  cmpq %r10, %rdx                           # checking if the index i is legall in his size (unsigned comparison)
  jae .pstrijcpyError                       # illegal
  cmpq %r11, %rcx                           # checking if the index j is legall in his size (unsigned comparison)
  jae .pstrijcpyError                       # illegal
  cmpq %r11, %rdx                           # checking if the index i is legall in his size (unsigned comparison)
  jae .pstrijcpyError                       # illegal

  add %dl, %dil                             # start from the i'th index of the dst string
  add %dl, %sil                             # start from the i'th index of the src string
  add $1, %rcx                              # ensure that we will check each character in the strings

.pstrijcpyLoop:
  add $1, %rdi                              # increment the dst string to point the next char
  add $1, %rsi                              # increment the src string to point the next char
  cmpb %cl, %dl                             # check if we reach the end (i = j) 
  je .pstrijcpyBeforeQuit                   # if we got to the end of the string - quit the loop
  add $1, %dl                               # jump to the next i'th value
  movzbq (%rsi), %r14                       # copy the current byte of the src string to r14b (the rest are 0's)
  movb %r14b, (%rdi)                        # copy the current byte of the src string to dil (current byte of dst string)
  jmp .pstrijcpyLoop                        # iterate next loop           

.pstrijcpyError:
  movq %r15, %r14                           # %r14 holds the original dst string
  movq $invalidValue, %rdi                  # %rdi holds the format
  xor %rax, %rax                            # init %rax
  call printf
  movq %r14, %rax                           # %rax holds the original string
  jmp .pstrijcpyLoopQuit                    # end function

.pstrijcpyBeforeQuit:
  movzbq (%rsi), %r14                       # copy the current byte of the src string to r14b (the rest are 0's)
  movq %r15, %rax                           # %rax holds the "converted" string
  jmp .pstrijcpyLoopQuit                    # end function

.pstrijcpyLoopQuit:
  movq %rbp, %rsp                           # restore "old" stack frame %rsp
  popq %rbp                                 # release %rbp
  ret

.global swapCase
  .type swapCase, @function
swapCase:
  pushq %rbp
  movq %rsp, %rbp 

  xor %rax, %rax                            # init %rax
  xor %r8, %r8                              # init %r8
  xor %r9, %r9                              # init %r9
  xor %r10, %r10                            # init %r10 - will be our counter (to iterate over the string)
  movq %rdi, %r9                            # %r9 holds the string (first arg of the function)
  call pstrlen  
  movq %rax, %r8                            # %r8 holds the length of the given string 
  add $1, %r8                               # ensure that we will check each character in the string 

.swapCaseLoop:
  cmpq %r10, %r8                            # check if we reach the end of the string
  je .swapCaseLoopQuit                      # if we got to the end of the string - quit the loop
  cmpb $65, (%rdi)                          # if the current char is smaller then 'A' (65 in ASCII) - continue
  jb .updateSwapCaseLoop                    # not a char
  cmpb $91, (%rdi)                          # if the current char is smaller then 'Z' (90 in ASCII) - go to upperCase
  jb .updateUpperCase                       # uppercase char
  cmpb $97, (%rdi)                          # if the current char is smaller then 'a' (97 in ASCII) - continue                   
  jb .updateSwapCaseLoop                    # not a char
  cmpb $123, (%rdi)                         # if the current char is smaller then 'z' (123 in ASCII) - go to smallerCase
  jb .updateSmallerCase                     # lowercase char

.updateUpperCase:
  add $32, (%rdi)                           # add 32 to change from CAPITAL to LOWER
  jmp .updateSwapCaseLoop

.updateSmallerCase:
  sub $32, (%rdi)                           # substract 32 to change from LOWER to CAPITAL
  jmp .updateSwapCaseLoop

.updateSwapCaseLoop:
  add $1, %rdi                              # increment the string to point the next char
  incq %r10                                 # increment the counter 
  jmp .swapCaseLoop                         # continue to iterate

.swapCaseLoopQuit:
  movq %r9, %rax                            # %rax holds now the new string
  movq %rbp, %rsp                           # restore "old" stack frame %rsp
  popq %rbp                                 # release %rbp 
  ret

.global pstrijcmp
  .type pstrijcmp, @function
pstrijcmp:
  pushq %rbp
  movq %rsp, %rbp 
  movzbq (%rdi), %r10                       # %r10 holds the length of the first string (the rest are 0's)
  movzbq (%rsi), %r11                       # %r11 holds the length of the second string (the rest are 0's)
  xor %rax, %rax                            # init return value = 0

  cmpb %cl, %dl                             # checking if i > j (illegal)
  ja .pstrijcmpError                        # illegal
  cmpq %r10, %rcx                           # checking if the index j is legall in his size (unsigned comparison)
  jae .pstrijcmpError                       # illegal
  cmpq %r10, %rdx                           # checking if the index i is legall in his size (unsigned comparison)
  jae .pstrijcmpError                       # illegal
  cmpq %r11, %rcx                           # checking if the index j is legall in his size (unsigned comparison)
  jae .pstrijcmpError                       # illegal
  cmpq %r11, %rdx                           # checking if the index i is legall in his size (unsigned comparison)
  jae .pstrijcmpError                       # illegal
              
  add %dl, %dil                             # start from the i'th index of the first string
  add %dl, %sil                             # start from the i'th index of the second string

.pstrijcmpLoop:
  add $1, %rdi                              # increment the first string to point the next char
  add $1, %rsi                              # increment the second string to point the next char
  xor %r8, %r8                              # init %r8
  xor %r9, %r9                              # init %r9
  cmpb %cl, %dl                             # check if we reach the end of the string 
  je .pstrijcmpBeforeQuit                   # if we got to the end of the string - quit the loop
  add $1, %dl                               # continue to the next i'th value
  movb (%rdi), %r8b                         # copy the current byte of the first string to %r8b
  movb (%rsi), %r9b                         # copy the current byte of the second string to %r9b
  cmpq %r8, %r9                             # compare the two chars
  je .pstrijcmpLoop                         # if the two chars are equal - continue iterate
  jb .setPlusValue                          # if the current char in string2 SMALLER then the current char in string1
  ja .setMinusValue                         # if the current char in string2 BIGGER then the current char in string1

.setMinusValue:
  movq $-1, %rax                            # set return value to -1
  jmp .pstrijcmpLoopQuit                    # end function

.setPlusValue:
  movq $1, %rax                             # set return value to 1
  jmp .pstrijcmpLoopQuit                    # end function

.pstrijcmpError:
  movq $invalidValue, %rdi                  # %rdi holds the format
  call printf                               # print illegal case
  movq $-2, %rax                            # set return value to -2
  jmp .pstrijcmpLoopQuit                    # end function

.pstrijcmpBeforeQuit:
  movb (%rdi), %r8b                         # copy the current byte of the first string to %r8b
  movb (%rsi), %r9b                         # copy the current byte of the second string to %r9b
  cmpq %r8, %r9                             # compare the two chars
  jb .setPlusValue                          # if the current char in string2 SMALLER then the current char in string1
  ja .setMinusValue                         # if the current char in string2 BIGGER then the current char in string1
  movq $0, %rax                             # set return value to 0
  jmp .pstrijcmpLoopQuit                    # end function

.pstrijcmpLoopQuit:
  movq %rbp, %rsp                           # restore "old" stack frame %rsp 
  popq %rbp                                 # release %rbp
  ret
