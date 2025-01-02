; In section .data we define the source variable as a string containing the source code of the program. We also define a null byte at the end of the string to mark the end of the string. The .data section is used to declare initialized data or constants.
section .data
    source db "section .data%1$c    source db %2$c%3$s%2$c, 0x0%1$c%1$csection .text%1$c    global _start%1$c    extern printf%1$c    extern exit%1$c%1$c_start:%1$c    ; This is a comment inside main%1$c    call print_source%1$c    mov rax, 60%1$c    xor rdi, rdi%1$c    call exit%1$c%1$cprint_source:%1$c    push rbp%1$c    mov rdi, source%1$c    mov rsi, 10%1$c    mov rdx, 34%1$c    mov rcx, source%1$c    call printf%1$c    pop rbp%1$c    ret%1$c%1$c; This is a comment outside functions", 0x0

; In section .text we define the _start label as the entry point of the program. We also define the print_source function that prints the source variable to the standard output using the printf function. The .text section is used to declare the executable instructions of the program.
section .text
    global _start
    extern printf
    extern exit

_start:
    ; Call jmp to the print_source lable, but different from jmp it will push the address of the next instruction on the stack. This will set rsp to the address of the next mnemonic instruction.
    call print_source
    ; Move the value 60 to the rax register. This is the system call number for the exit function.
    mov rax, 60
    ; Move the value 0 to the rdi register. This is the first argument to the exit function.
    xor rdi, rdi
    ; Call the exit function. This will terminate the program.
    call exit

print_source:
    ; When entering a function, we need to save the base pointer (rbp) on the stack. This is done by pushing rbp on the stack. This will save as a bookmark to the current stack frame. Allowing us to use thr rsp to assign local variables.
    push rbp
    ; Set the base pointer to the current stack pointer. This will allow us to access the local variables using the base pointer.
    mov rbp, rsp
    ; Move the address of the source variable to the rdi register. This is the first argument to the printf function.
    mov rdi, source
    ; Move the value 10 to the rsi register. This is the second argument to the printf function.
    mov rsi, 10
    ; Move the value 34 to the rdx register. This is the third argument to the printf function.
    mov rdx, 34
    ; Move the address of the source variable to the rcx register. This is the fourth argument to the printf function.
    mov rcx, source
    ; Call the printf function. This will print the source variable to the standard output.
    call printf
    ; Restore the stack pointer to the base pointer. This will free the local variables from the stack.
    mov rsp, rbp
    ; Pop the base pointer from the stack. This will restore the base pointer to the previous stack frame.
    pop rbp
    ; Return from the function. This will pop the return address from the stack and set the instruction pointer to the return address.
    ret

; 64-bit Registers
; These are the 64-bit versions of the registers. They can hold 64-bit values and are used in x86-64 architecture.

; rax:

; Primary purpose: Used for arithmetic operations and as the return value for functions (in many calling conventions).
; Common uses: Return values of functions, general-purpose arithmetic.
; rbx:

; Primary purpose: This register is often used as a base register for addressing and data manipulation.
; Common uses: Holds data for calculations, can be used as a general-purpose register.
; rcx:

; Primary purpose: Often used for counting operations, like loops (it's the counter register in many instructions).
; Common uses: Loop counters, string operations (e.g., rep for repeated operations).
; rdx:

; Primary purpose: Used in multiplication and division operations.
; Common uses: Holds one of the operands for certain arithmetic operations (like in mul, div), stores the higher 64-bits in multiplication and division.
; rsi:

; Primary purpose: Often used as a source register for operations (especially in string manipulation).
; Common uses: Source for movs, cmps, or scans (in the context of string operations).
; rdi:

; Primary purpose: Often used as a destination register for operations (especially in string manipulation).
; Common uses: Destination for movs, cmps, or scans.
; rsp:

; Primary purpose: The stack pointer. It points to the top of the stack. It is crucial for function calls and returns.
; Common uses: Storing function arguments, return addresses, and local variables.
; rbp:

; Primary purpose: The base pointer. It is used as a frame pointer to reference local variables within a function.
; Common uses: References to local variables and parameters of the current function.