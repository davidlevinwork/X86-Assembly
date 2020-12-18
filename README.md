# X86-Assembly

Assembly program creating `pString struct` and performing manipulations on it. <br />

pString is a struct defined as follows:
* char size - reprensts the length of a string
* char string[255] - the string itself

The following functions are implemented:
* char pstrlen(pString* pstr)
* Pstring* replaceChar(pString* pstr, char oldChar, char newChar)
* Pstring* pstrijcpy(pString* dst, pString* src, char i, char j)
* Pstring* swapCase(pString* pstr)
* int pstrijcmp(pString* pstr1, pString* pstr2, char i, char j)

## How to use

After using `make` you can use the following command-line arguments:
  
> size-of-first-pString |  content-of-first-pString |  size-of-second-pString |  content-of-second-pString |  case-number

### Parameters


Name | Meaning 
-----|-------
`source-file-name` | .txt valid UTF-16 source file
`new-file-name` | .txt file to be overriden with output data
`source-file-os-flag` | source file OS
`new-file-os-flag` | output file OS
`byte-order-flag` | indicator to switch Endians
