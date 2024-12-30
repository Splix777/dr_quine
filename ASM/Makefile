NAME = Colleen
# Netwide Assembler used to compile the assembly code
ASM = nasm
# Flags for the assembler
# -f elf64: specifies the output format as 64-bit ELF
# -g: adds debugging information to the executable
# -w+all: enables all warnings
# -dNOEXECSTACK: specifies that the stack is not executable
ASMFLAGS = -f elf64 -g -w+all -dNOEXECSTACK
# Linker used to link the object files
# The GNU linker takes the .o and combines them into an executable
LD = ld
LDFLAGS = --dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc -no-pie

SRC = Colleen.s
OBJ = $(SRC:.s=.o)

all: $(NAME)

$(NAME): $(OBJ)
	@$(LD) $(OBJ) -o $(NAME) $(LDFLAGS)
	@echo "Program $(NAME) created!"

$(OBJ): $(SRC)
	@$(ASM) $(ASMFLAGS) $(SRC) -o $(OBJ)
	@echo "Assembly file compiled"

clean:
	@echo "Cleaning up..."
	@rm -f $(OBJ)

fclean: clean
	@echo "Removing $(NAME)..."
	@rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re


# ELF formats ("Executable and Linkable Format"):

# elf32 - 32-bit Linux object files
# elf64 - 64-bit Linux object files (what you're using)

# Windows formats:

# win32 - 32-bit Windows object files
# win64 - 64-bit Windows object files

# macOS formats:

# macho32 - 32-bit macOS object files
# macho64 - 64-bit macOS object files

# Raw binary formats:

# bin - flat binary (raw machine code, no metadata)
# raw - same as bin

# ----------------

# --dynamic-linker /lib64/ld-linux-x86-64.so.2

# Purpose:
# This flag specifies the dynamic linker to be used at runtime. The dynamic linker is responsible for loading and linking shared libraries when the program starts.

# Details:
# The program uses extern printf and extern exit, indicating it calls functions from external shared libraries (in this case, from libc). 
# This flag tells the linker to embed the path to the dynamic linker into the executable. When your program runs, this dynamic linker will be invoked to load the necessary libraries, like libc.so.2 for printf and exit.

# Implication:
# Without this flag, the system would use a default dynamic linker, but specifying it can be useful for ensuring compatibility across different systems or for testing with alternative dynamic linkers.

# -lc

# Purpose:
# This flag tells the linker to link against the C standard library (libc).

# Details:
# Since your program uses printf and exit, which are part of libc, this flag ensures that these functions are resolved. 
# The -l option tells ld to search for a library named c (which translates to libc.so in shared form or libc.a for static linking, but here it's used for dynamic linking).

# Implication:
# If omitted, your program would fail to link because the linker wouldn't know where to find printf or exit.

# -no-pie

# Purpose:
# This stands for "no Position Independent Executable". It tells the linker not to create a PIE (Position Independent Executable), which is a security feature.

# Details:
# PIE executables are designed to be loaded at a random memory address each time they run, making certain types of attacks like return-to-libc more difficult by increasing address space layout randomization (ASLR).
# By specifying -no-pie, you're asking for a traditional executable where the code's memory addresses are fixed at link time.

# Implication:
# Without -no-pie, the linker would produce a PIE by default on many modern Linux systems, which might change the behavior or performance of your assembly code due to address randomization. 
