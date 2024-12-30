**x86-64 Assembly Language Summary**  
Dr. Orion Lawlor, last update 2019-10-14

These are all the normal x86-64 registers accessible from user code:

| Name | Notes | Type | 64-bit long | 32-bit int | 16-bit short | 8-bit char |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| rax | Values are returned from functions in this register.   | scratch | rax | eax | ax | ah and al |
| rcx | Typical scratch register.  Some instructions also use it as a counter. | scratch | rcx | ecx | cx | ch and cl |
| rdx | Scratch register. | scratch | rdx | edx | dx | dh and dl |
| *rbx* | *Preserved register: don't use it without saving it\!* | *preserved* | *rbx* | *ebx* | *bx* | *bh and bl* |
| *rsp* | *The stack pointer.  Points to the top of the stack.* | *preserved* | *rsp* | *esp* | *sp* | *spl* |
| *rbp* | *Preserved register.  Sometimes used to store the old value of the stack pointer, or the "base".* | *preserved* | *rbp* | *ebp* | *bp* | *bpl* |
| rsi | Scratch register.  Also used to pass function argument \#2 in 64-bit Linux.  String instructions treat it as a source pointer. | scratch | rsi | esi | si | sil |
| rdi | Scratch register.  Function argument \#1 in 64-bit Linux.  String instructions treat it as a destination pointer. | scratch | rdi | edi | di | dil |
| r8 | Scratch register.  These were added in 64-bit mode, so they have numbers, not names. | scratch | r8 | r8d | r8w | r8b |
| r9 | Scratch register. | scratch | r9 | r9d | r9w | r9b |
| r10 | Scratch register. | scratch | r10 | r10d | r10w | r10b |
| r11 | Scratch register. | scratch | r11 | r11d | r11w | r11b |
| *r12* | *Preserved register.  You can use it, but you need to save and restore it.* | *preserved* | *r12* | *r12d* | *r12w* | *r12b* |
| *r13* | *Preserved register.* | *preserved* | *r13* | *r13d* | *r13w* | *r13b* |
| *r14* | *Preserved register.* | *preserved* | *r14* | *r14d* | *r14w* | *r14b* |
| *r15* | *Preserved register.* | *preserved* | *r15* | *r15d* | *r15w* | *r15b* |

Functions return values in rax.    
How you pass parameters into functions varies depending on the platform:

![][image1]

* A 64 bit x86 Linux machine, like NetRun:  
  * Call nasm like: nasm  \-f elf64  yourCode.asm  
  * [Function parameters](https://en.wikipedia.org/wiki/X86_calling_conventions#System_V_AMD64_ABI) go in registers rdi, rsi, rdx, rcx, r8, and r9.  Any additional parameters get pushed on the stack.  OS X in 64 bit uses the same parameter scheme.    
  * Linux 64 floating-point parameters and return values go in xmm0.  All xmm0 registers are scratch.  
  * If the function takes a variable number of arguments, like printf, rax is the number of floating point arguments (often zero).  
  * If the function modifies floating point values, you need to align the stack to a 16-byte boundary before making the call.  
  * Example linux 64-bit function call:

    extern putchar  
    mov rdi,'H' ; function parameter: one char to print  
    call putchar

* Windows in 64 bit x86 is quite different:  
  * Call nasm like: nasm  \-f win64  \-gcv8  yourCode.asm  
  * Win64 [function parameters](https://en.wikipedia.org/wiki/X86_calling_conventions#Microsoft_x64_calling_convention) go in registers rcx, rdx, r8, and r9.  
  * Win64 treats the registers rdi and rsi as preserved.  
  * Win64 passes float arguments in xmm0-3, but the register matches the location in the argument list (Linux passes the first float in xmm0 no matter which argument number it is.)  
  * Win64 floating point registers xmm6-15 are preserved.  
  * Win64 functions assume you've allocated 32 bytes of stack space to store the four parameter registers (called the "Parameter Home Area" or "Shadow Space"), plus another 8 bytes to align the stack to a 16-byte boundary. 

    sub rsp,32+8; parameter area, and stack alignment  
    extern putchar  
    mov rcx,'H' ; function parameter: one char to print  
    call putchar  
    add rsp,32+8 ; clean up stack

  * Some functions such as printf only get linked if they're called from C/C++ code, so to call printf from assembly, you need to include at least one call to printf from the C/C++ too.    
  * If you use the Windows MinGW or Visual Studio C++ compiler, "long" is the same size as "int", only 32 bits / 4 bytes even in 64-bit mode.  You need to use "long long" to get a 64 bit / 8 byte integer variable on these systems.  (Even on Windows, gcc, g++, or WSL makes "long" 64 bits, just like Linux or Mac or Java.)  It's probably safest to [\#include \<stdint.h\>](https://en.cppreference.com/w/c/types/integer) and refer to int64\_t.  
  * See [NASM assembly in 64-bit Windows in Visual Studio](https://www.cs.uaf.edu/2017/fall/cs301/reference/nasm_vs/) to make linking work.  
  * If you use the Microsoft MASM assembler, memory accesses must include "PTR", like "DWORD PTR \[rsp\]".   
    * I have some [notes on Windows Visual Studio \+ MASM assembly](https://docs.google.com/document/d/1A70BO5UDw80FdLHSbX4iw4CHTHJYeBCaUVESidAhIbY/edit). (advantage: breakpoints work even in assembly.  Disadvantage: Microsoft everything).  
* In 32 bit mode, parameters are passed by pushing them onto the stack in reverse order, so the function's first parameter is on top of the stack before making the call.  In 32-bit mode Windows and OS X compilers also seem to add an underscore before the name of a user-defined function, so if you call a function foo from C/C++, you need to define it in assembly as "\_foo".

## **Constants, Registers, Memory**

"12" means decimal 12; "0xF0" is hex.  "some\_function" is the address of the first instruction of the function.  Memory access (use register as pointer): "\[rax\]".  Same as C "\*rax".  
Memory access with offset (use register \+ offset as pointer): "\[rax+4\]".  Same as C "\*(rax+4)".  
Memory access with scaled index (register \+ another register \* scale): "\[rax+rbx\*4\]".  Same as C "\*(rax+rbx\*4)".

Different C++ datatypes get stored in different sized registers, and need to be accessed differently:

| C/C++ datatype | Bits | Bytes | Register | Access memory  \*ptr | Access Array  ptr\[idx\] | Allocate Static Memory |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| char | 8 | 1 | al | BYTE \[ptr\] | BYTE \[ptr \+ 1\*idx\] | [db](https://www.nasm.us/doc/nasmdoc3.html#section-3.2.1) |
| short | 16 | 2 | ax | WORD \[ptr\] | WORD \[ptr \+ 2\*idx\] | dw |
| int  | 32 | 4 | eax | DWORD \[ptr\] | DWORD \[ptr \+ 4\*idx\] | dd |
| long    \[1\] | 64 | 8 | rax | QWORD \[ptr\] | QWORD \[ptr \+ 8\*idx\] | dq |
| float | 32 | 4 | xmm0 | DWORD \[ptr\] | DWORD \[ptr \+ 4\*idx\] | dd |
| double | 64 | 8 | xmm0 | QWORD \[ptr\] | QWORD \[ptr \+ 8\*idx\] | dq |

\[1\] It's "long long" or "int64\_t" on Windows MinGW or Visual Studio; but just "long" everywhere else.

You can convert values between different register sizes using different mov instructions:

|  | Source Size |  |  |  |  |
| :---- | :---- | :---- | :---- | :---- | :---- |
|  | 64 bit rcx | 32 bit ecx | 16 bit cx | 8 bit cl | **Notes** |
| 64 bit rax | mov rax,rcx | [movsxd](https://lawlor.cs.uaf.edu/netrun/run?name=Testing&code=mov%20rcx%2C0xaabbccddeeff0011%0D%0Amovsxd%20rax%2Cecx%0D%0Aret%0D%0A&lang=Assembly-NASM&mach=x64&mode=frag&input=&linkwith=&foo_ret=long&foo_arg0=void&orun=Run&orun=Disassemble&orun=Grade&ocompile=Optimize&ocompile=Warnings) rax,ecx | [movsx](https://lawlor.cs.uaf.edu/netrun/run?name=Testing&code=mov%20rcx%2C0xaaeeccddeeffaabb%0D%0Amovsx%20rax%2Ccx%0D%0Aret%0D%0A&lang=Assembly-NASM&mach=x64&mode=frag&input=&linkwith=&foo_ret=long&foo_arg0=void&orun=Run&orun=Disassemble&orun=Grade&ocompile=Optimize&ocompile=Warnings) rax,cx | [movsx](https://lawlor.cs.uaf.edu/netrun/run?name=Testing&code=mov%20rcx%2C0xaaeeccddeeffaabb%0D%0Amovsx%20rax%2Ccl%0D%0Aret%0D%0A&lang=Assembly-NASM&mach=x64&mode=frag&input=&linkwith=&foo_ret=long&foo_arg0=void&orun=Run&orun=Disassemble&orun=Grade&ocompile=Optimize&ocompile=Warnings) rax,cl | Writes to whole register |
| 32 bit eax | mov eax,ecx | mov eax,ecx | [movsx](https://lawlor.cs.uaf.edu/netrun/run?name=Testing&code=mov%20rax%2C0xeeeeeeeeeeeeeeee%0D%0Amov%20rcx%2C0xaaeeccddeeffaabb%0D%0Amovsx%20eax%2Ccx%0D%0Aret%0D%0A&lang=Assembly-NASM&mach=x64&mode=frag&input=&linkwith=&foo_ret=long&foo_arg0=void&orun=Run&orun=Disassemble&orun=Grade&ocompile=Optimize&ocompile=Warnings) eax,cx | [movsx](https://lawlor.cs.uaf.edu/netrun/run?name=Testing&code=mov%20rax%2C0xeeeeeeeeeeeeeeee%0D%0Amov%20rcx%2C0xaaeeccddeeffaabb%0D%0Amovsx%20eax%2Ccl%0D%0Aret%0D%0A&lang=Assembly-NASM&mach=x64&mode=frag&input=&linkwith=&foo_ret=long&foo_arg0=void&orun=Run&orun=Disassemble&orun=Grade&ocompile=Optimize&ocompile=Warnings) eax,cl | Top half of destination gets zeroed |
| 16 bit ax | mov ax,cx | mov ax,cx | mov ax,cx | [movsx](https://lawlor.cs.uaf.edu/netrun/run?name=Testing&code=mov%20rax%2C0xeeeeeeeeeeeeeeee%0D%0Amov%20rcx%2C0xaaeeccddeeffaabb%0D%0Amovsx%20ax%2Ccl%0D%0Aret%0D%0A&lang=Assembly-NASM&mach=x64&mode=frag&input=&linkwith=&foo_ret=long&foo_arg0=void&orun=Run&orun=Disassemble&orun=Grade&ocompile=Optimize&ocompile=Warnings) ax,cl | Only affects low 16 bits, rest unchanged. |
| 8 bit al | mov al,cl | mov al,cl | mov al,cl | mov al,cl | Only affects low 8 bits, rest unchanged.  |

Registers can store either signed or unsigned values.

| Signed | Unsigned | Description |
| :---- | :---- | :---- |
| int | unsigned int | In C/C++, int is signed by default. |
| signed char | unsigned char | In C/C++, char may be signed (default on gcc) or unsigned (default on Windows compilers) by default. |
| movsxd | movzxd | Assembly, **s**ign e**x**tend or **z**ero e**x**tend to change register sizes. |
| jo | jc | Assembly, **o**verflow is for signed values, **c**arry for unsigned values. |
| jg | ja | Assembly, jump **g**reater is signed, jump **a**bove is unsigned. |
| jl | jb | Assembly, jump **l**ess signed, jump **b**elow unsigned. |
| imul | mul | Assembly, imul is signed (and more modern), mul is for unsigned (and ancient and horrible\!). idiv/div work similarly. |

Normally, your assembly code lives in the code section, which can be read but not modified.  When you declare static data, you need to put it in section .data for it to be writeable.

| Name | Use | Discussion |
| :---- | :---- | :---- |
| section .data | r/w data | This data is initialized, but can be modified. |
| section .rodata | r/o data | This data can't be modified, which lets it be shared across copies of the program.  In C/C++, global "const" or "const static" data is stored in .rodata. |
| section .bss | r/w space | This is automatically initialized to zero, meaning the contents don't need to be stored explicitly.  This saves space in the executable. |
| section .text | r/o code | This is the program's executable machine code (it's binary data, not plain text--the Microsoft assembler calls this section ".code", a better name). |

Before you can call some existing function, you need to declare that the function is "extern":  
	extern puts  
	call puts

If you want to define a function that can be called from outside, you need to declare your function "global":  
	global myGreatFunction  
	myGreatFunction:  
		ret

When linking a program that calls functions directly like this, you may need gcc's "-no-pie" option, to disable the position-independent executable support.

## **Instructions**

For gory instruction set details, read this [per-instruction reference](http://www.felixcloutier.com/x86/), or the [uselessly huge Intel PDF](https://software.intel.com/sites/default/files/managed/39/c5/325462-sdm-vol-1-2abcd-3abcd.pdf) (4000 pages\!).

| Instruction | Purpose | Examples |
| :---- | :---- | :---- |
| mov *dest,src* | Move data between registers, load immediate data into registers, move data between registers and memory. | mov rax,4  ; Load constant into rax mov rdx,rax  ; Copy rax into rdx mov \[rdi\],rdx  ; Copy rdx into the memory that rdi is pointing to |
| push *src* | Insert a value onto the stack.  Useful for passing arguments, saving registers, etc. | push rbx |
| pop *dest* | Remove topmost value from the stack.  Equivalent to "mov *dest*, \[rsp\]; add 8,rsp" | pop rbx |
| call *func* | Push the address of the next instruction and start executing func. | call puts |
| ret | Pop the return program counter, and jump there.  Ends a function. | ret |
| add *dest,src* | *dest=dest+src* | add rax,rdx ; Add rdx to rax |
| imul *dest,src* | *dest=dest\*src* This is the signed multiply. | imul rcx,4 ; multiply rcx by 4 |
| mul *src* | Multiply rax and *src* as unsigned integers, and put the result in rax.  High 64 bits of product (usually zero) go into rdx. | mul rdx ; Multiply rax by rdx ; rax=low bits, rdx overflow |
| jmp *label* | Goto the instruction *label*:.  Skips anything else in the way. | jmp post\_mem mov \[0\],rax ; Write to NULL\! post\_mem: ; OK here... |
| cmp *a,b*  | Compare two values.  Sets flags that are used by the conditional jumps (below).  | cmp rax,10    |
| jl *label* | Goto *label* if previous comparison came out as less-than.  Other conditionals available are:     jle (\<=), je (==), jge (\>=), jg (\>), jne (\!=) Also available in unsigned comparisons:     jb (\<), jbe (\<=), ja (\>), jae (\>=) And checking for overflow (jo) and carry (jc). | jl loop\_start  ; Jump if rax\<10 |

## **Standard Idioms**

Looping over an array of 64-bit long integers, including the first-time test at startup:

**; rdi: pointer to array.  rsi: number of elements**  
**mov rcx,0 ; i, loop counter**  
**jmp testFirst ; because rsi might be zero**  
**startLoop:**  
	**… work on QWORD\[rdi+8\*rcx\], which is array\[i\] ...**  
	**add rcx,1 ; i++**  
	**testFirst:**  
	**cmp rcx,rsi ; keep looping while i\<n**  
	**jl startLoop**

[(Try this in NetRun now\!)](https://lawlor.cs.uaf.edu/netrun/run?name=Testing&code=mov%20rdi%2CarrayPtr%0D%0Amov%20rsi%2C3%0D%0A%3B%20rdi%3A%20pointer%20to%20array.%20%20rsi%3A%20number%20of%20elements%0D%0Amov%20rax%2C0%20%3B%20output%20sum%0D%0Amov%20rcx%2C0%20%3B%20i%2C%20loop%20counter%0D%0Ajmp%20testFirst%20%3B%20because%20rsi%20might%20be%20zero%0D%0AstartLoop%3A%0D%0A%09add%20rax%2C%20QWORD%5Brdi%2B8%2Arcx%5D%20%3B%20sum%20%2B%3D%20array%5Bi%5D%3B%0D%0A%09add%20rcx%2C1%0D%0A%09testFirst%3A%0D%0A%09%09cmp%20rcx%2Crsi%0D%0A%09%09jl%20startLoop%0D%0Aret%0D%0A%0D%0A%0D%0Asection%20.data%0D%0AarrayPtr%3A%0D%0A%09dq%207%0D%0A%09dq%2010%0D%0A%09dq%20100%0D%0A&lang=Assembly-NASM&mach=skylake64&mode=frag&input=&linkwith=&foo_ret=long&foo_arg0=void&orun=Run&orun=Grade&ocompile=Optimize&ocompile=Warnings)

Allocating and deallocating memory:

| Memory type | The Stack | The Heap | Static Data |
| :---- | :---- | :---- | :---- |
| Allocate *nBytes* of memory | sub rsp,*nBytes* | mov rdi,*nBytes* extern malloc call malloc | section .data *stuff*:    times *nBytes* db 0 |
| Pointer to the allocated data | rsp | rax | *stuff* or lea rdx,\[rel *stuff*\] |
| Deallocate the memory | add rsp,*nBytes* | mov rdi,rax extern free call free | ; Not needed |
| Properties | The stack is only 8 megs on most machines. | Slowest memory allocation: costs at least a half-dozen function calls. | Static data stays allocated until the program exits. |

## **SSE Floating Point Instructions**

There are at least three generations of x86 floating point instructions:

* fldpi, the original "floating point register stack", mostly limited to 32-bit machines now.  
* addss xmm0,xmm2   the SSE instructions  
* vmovss xmm0,xmm1,xmm2  the VEX-coded instructions

The SSE registers are named "xmm0" through "xmm15".  The SSE instructions can be coded as shown below, or with a "v" in front for the VEX-coded AVX version, which allows the use of the 32-byte AVX "ymm" registers, and three-operand (destination, source1, source2) instruction format.

|  | Serial Single- precision (1 float) | Serial Double- precision (1 double) | Parallel Single- precision (4 floats) | Parallel Double- precision (2 doubles) | Comments |
| :---- | :---- | :---- | :---- | :---- | :---- |
| *add* | addss | addsd | addps | addpd | sub, mul, div all work the same way |
| min | minss | minsd | minps | minpd | max works the same way |
| sqrt | sqrtss | sqrtsd | sqrtps | sqrtpd | Square root (sqrt), reciprocal (rcp), and reciprocal-square-root (rsqrt) all work the same way |
| *mov* | movss | movsd | movaps *(aligned)* movups *(unaligned)* | movapd *(aligned)* movupd *(unaligned)* | Aligned loads are up to 4x faster, but will crash if given an unaligned address\!  The stack is always 16-byte aligned before calling a function, specifically for this instruction, as described below. Use "align 16" directive for static data.  |
| *cvt* | cvtss2sd cvtss2si cvttss2si   | cvtsd2ss cvtsd2si cvttsd2si | cvtps2pd cvtps2dq cvttps2dq | cvtpd2ps cvtpd2dq cvttpd2dq | Convert to ("2", get it?) Single Integer (si, stored in register like eax) or four DWORDs (dq, stored in xmm register).  "cvtt" versions do truncation (round down); "cvt" versions round to nearest. |
| com | ucomiss | ucomisd | *n/a* | *n/a* | Sets CPU flags like normal x86 "cmp" instruction for unsigned, from SSE registers. |
| cmp | cmpeqss | cmpeqsd | cmpeqps | cmpeqpd | Compare for equality ("lt", "le", "neq", "nlt", "nle" versions work the same way).  Sets all bits of float to zero if false (0.0), or all bits to ones if true (a NaN).  Result is used as a bitmask for the bitwise AND and OR operations. |
| and | *n/a* | *n/a* | andps andnps | andpd andnpd | Bitwise AND operation.  "andn" versions are bitwise AND-NOT operations (A=(\~A) & B).  "or" version works the same way. |

The algebra of bitwise operators:

| Instruction | C++ Operator | Useful to... |
| :---- | :---- | :---- |
| AND | & | Mask out bits (set other bits to zero) 0=A&0 	AND by 0's creates 0's, used to mask out bad stuff A=A&\~0 	AND by 1's has no effect |
| OR | | | Reassemble bit fields A=A|0  	OR by 0's has no effect \~0=A|\~0	OR by 1's creates 1's |
| XOR | ^ | Invert selected bits A=A^0 		XOR by zeros has no effect \~A \= A ^ \~0  	XOR by 1's inverts all the bits 0=A^A  	XOR by yourself creates 0's--used for initialization A=A^B^B	XOR is its own inverse operation--used for cryptography |
| NOT | \~ | Invert all the bits in a number \~0		All bits are set to one \~A		All the bits of A are inverted A=\~\~A		Inverting twice recovers the bits |

## **Weird Instructions**

x86 is ancient, and it has many weird old instructions.  The more useful ones include:

| [div](https://www.felixcloutier.com/x86/DIV.html) *src* | Unsigned divide rax by *src*, and put the ratio into rax, and the remainder into rdx. Bizarrely, on input rdx must be zero (high bits of numerator), or you get a SIGFPE. | mov rax, 100 ; numerator mov rdx,0 ; avoid error mov rcx, 3 ; denominator div rcx ; compute rax/rcx |
| :---- | :---- | :---- |
| [idiv](https://www.felixcloutier.com/x86/IDIV.html) *src* | Signed divide rax by the register *src*.       rdx \= rax % src     rax \= rax / src Before idiv, rdx must be a sign-extended version of rax, usually using [cqo](https://www.felixcloutier.com/x86/CWD:CDQ:CQO.html) (Convert Quadword rax to Octword rdx:rax). | mov rax, 100 ; numerator cqo ; sign-extend into rdx mov rcx, 3 ; denominator idiv rcx |
| [shr](https://www.felixcloutier.com/x86/SAL:SAR:SHL:SHR.html) *val,bits* | Bitshift a value right by a constant, or the low 8 bits of rcx ("cl"). Shift count MUST go in rcx, no other register will work\! | add rcx,4 shr rax,cl ; shift by rcx |
| [lea](https://www.felixcloutier.com/x86/LEA.html) *dest*,\[*ptr expression*\] | Load Effective Address of the pointer into the destination register--doesn't actually access memory, but uses the memory syntax. | lea rcx,\[rax \+ 4\*rdx \+12\] |
| [loop](https://www.felixcloutier.com/x86/LOOP:LOOPcc.html) *jumplabel* | Decrement rcx, and if it's not zero, jump to the label. | mov rcx,10 start:   add rax,7   loop start |
| [lodsb](https://www.felixcloutier.com/x86/LODS:LODSB:LODSW:LODSD:LODSQ.html) | Load one char of a string:     al \= BYTE PTR \[rsi++\] |  |
| [stosb](https://www.felixcloutier.com/x86/STOS:STOSB:STOSW:STOSD:STOSQ.html) | Store one char of a string:    BYTE PTR \[rdi++\] \= al |  |
| [movsb](https://www.felixcloutier.com/x86/MOVS:MOVSB:MOVSW:MOVSD:MOVSQ.html) | Copy one char of a string:   BYTE PTR \[rdi++\] \= BYTE PTR \[rsi++\] |  |
| [scasb](https://www.felixcloutier.com/x86/SCAS:SCASB:SCASW:SCASD.html) | Compare the next char from string with register al:   cmp BYTE PTR\[rdi++\], al |  |
| [cmpsb](https://www.felixcloutier.com/x86/CMPS:CMPSB:CMPSW:CMPSD:CMPSQ.html) | Compare the next char from each of two strings:   cmp BYTE PTR \[rdi++\], BYTE PTR \[rsi++\] |  |
| [rep](https://www.felixcloutier.com/x86/REP:REPE:REPZ:REPNE:REPNZ.html) *stringinstruction* | Repeat the string instruction rcx times.  Only works with string instructions (lods, stos, cmps, scas, cmps, ins, outs) | mov al,'x' mov rcx,100 mov rdi,bufferStart rep stosb |
| [repne](https://www.felixcloutier.com/x86/REP:REPE:REPZ:REPNE:REPNZ.html) *stringinstruction* | Repeat the string instruction until the instruction sets the zero flag, or rcx gets decremented down to zero. | mov al,0 mov rcx,-1 mov rsi,stringStart repne lodsb |

## **Debugging Assembly**

Disassembly using objdump:  
	objdump \-drC \-M intel code.obj  
The command line flags there are:

* \-d: disassemble  
* \-r: include linker relocations  
* \-C: demangle C++ linker names  
* \-M intel: use the Intel syntax (mov rax,1), instead of the gnu syntax (movl $1,%rax)

error: parser: instruction expected  
error: label or instruction expected at start of line

* This means you spelled the instruction name wrong.

error: invalid combination of opcode and operands

* Another way to say this: "there is no instruction taking those arguments".  For example, there's a 64-bit "mov rax,rcx", and a 32-bit "mov eax,ecx", but there is no "mov rax,ecx".

It compiles but won't link: "undefined reference to foo**()**"   \<- note parenthesis\!

* The C++ side needs to use "extern **"C"** long foo(void);" because you get this C++-vs-C link error if you leave out the extern "C".

It compiles but won't link: "undefined reference to \_foo"   \<- note underscore\!

* The assembly side may need to add underscores to match the compiler's linker names.  This seems common on 32-bit machines.

It compiles but won't link: "undefined reference to foo"

* The assembly side needs to say "global foo" to get the linker to see it.

It compiles but then crashes with a SIGSEGV

* This means your code accessed a bad memory location  
* Do you access \[memory\] one too many times?  Accessing memory like "mov rax,\[rdx\]" when rdx is a number instead of a pointer will crash, accessing a low address like 0x0.  
* Do you have write access to your \[memory\]?  You may need to put your values into section .data  
* Is your stack manipulation (push/pop) OK?  It's common to leave extra garbage on the stack, which causes ret to pop the garbage and jump there; or to accidentally remove the return address with an extra pop.  Every push must have exactly one pop.  
* Is something trashing your pointer or counter registers?  For example, if you call a function to print your output, it trashes all scratch registers.  The fix is to push/pop scratch registers around function calls, or use preserved registers.  
* Are you using 64-bit pointers?  Some folks doing 32-bit accesses want to write "mov eax, DWORD \[ecx\]" which can crash--even if the value you're accessing is 32 bit, all your address arithmetic needs to be 64 bit, so write "mov eax, DWORD \[rcx\]".

It runs but gives the wrong output

* Do you need to access \[thingy\] instead of bare thingy?  I've had programs that return the value \*of\* the pointer "mov rax,rdx" instead of the value the pointer is pointing to "mov rax,\[rdx\]"  
* Do your loops run the right number of times?  It's always tricky getting the last iteration correct.  
* If you access arrays, are you multiplying by the size correctly?  It's common to write to DWORD \[rdi+1\] instead of DWORD\[rdi+4\], which results in byte slices of the value you're after.  

Using a debugger, like gdb, is very handy both for writing new code, and analysing existing programs even if you just have a compiled binary without source code.  Here's my [GDB reverse engineering cheat sheet](https://docs.google.com/document/d/1ggjB8IYmdGDjAD1JMv7ys9SGemlDrWk3zZyWZNheLlM/).

[image1]: <data:image/png;base64,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>