# X86-Assembly

Assembly program creating `pString struct` and performing manipulations on it. <br />

pString is a struct defined as follows:
* char size - reprensts the length of a string
* char string[255] - the string itself

functions_name | arguments | Meaning 
-----------|-----------|-----------
`pstrlen` | pString* str | resturns the length of the pString
`replaceChar` | pString* str, char oldChar, char newChar | replace the 'old' char with 'new' char
`pstrijcpy` | pString* dst, pString* src, char i, char j | copy the subsrting(i, j) of src to dst
`swapCase` | pString* str | swaps each lowerCase letter to upperCase and vice versa
`pstrijcmp` | pString* str1, pString* str2, char i, char j | Compares the substring(i,j) of both pstrings

## How to use

After using `make` you can use the following command-line arguments:
  
> size-of-first-pString |  content-of-first-pString |  size-of-second-pString |  content-of-second-pString |  case-number

### Parameters
case_number | Meaning
-----|------
`case_50` | calls pstrln on each pString and prints the string with his length
`case_52` | scans two chars, calling replaceChar on each pString and prints the chars with the updated pStrings
`case_53` | scans two integers, calling pstrijcpy, and prints each pString with his length
`case_54` | calls swapCase on each pstring and prints the updated pString
`case_55` | scans two integers, calls pstrijcmp, and prints the comparison result
