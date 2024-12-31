GREEN = \033[1;32m
YELLOW = \033[1;33m
CYAN = \033[1;36m
RESET = \033[0m

NAME_COLEEN = Colleen
NAME_GRACE = Grace
NAME_SULLY = Sully

SRC_COLLEEN = Colleen.s
SRC_GRACE = Grace.s
SRC_SULLY = Sully.s

OBJ_DIR = obj
OBJ_COLEEN = $(OBJ_DIR)/$(SRC_COLEEN:.s=.o)
OBJ_GRACE = $(OBJ_DIR)/$(SRC_GRACE:.s=.o)
OBJ_SULLY = $(OBJ_DIR)/$(SRC_SULLY:.s=.o)

ASM = nasm
ASMFLAGS = -f elf64 -g -w+all -dNOEXECSTACK

LD = ld
LDFLAGS = --dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc -no-pie

all: colleen grace sully

colleen: $(NAME_COLLEEN)

grace: $(NAME_GRACE)

sully: $(NAME_SULLY)

$(NAME_COLLEEN): $(OBJ_COLLEEN)
	@printf "$(CYAN)Linking $@... $(RESET)\n"
	@$(LD) $(LDFLAGS) -o $@ $^

$(NAME_GRACE): $(OBJ_GRACE)
	@printf "$(CYAN)Linking $@... $(RESET)\n"
	@$(LD) $(LDFLAGS) -o $@ $^

$(NAME_SULLY): $(OBJ_SULLY)	
	@printf "$(CYAN)Linking $@... $(RESET)\n"
	@$(LD) $(LDFLAGS) -o $@ $^

$(OBJ_DIR)/%.o: %.s | $(OBJ_DIR)
	@printf "$(CYAN)Compiling $<... $(RESET)\n"
	@$(ASM) $(ASMFLAGS) $< -o $@
	@printf "$(GREEN)Done!$(RESET)\n"

$(OBJ_DIR):
	@mkdir -p $(OBJ_DIR)
	@printf "$(YELLOW)Created directory $(OBJ_DIR).$(RESET)\n"

clean:
	@printf "$(YELLOW)Cleaning object files... $(RESET)\n"
	@rm -rf $(OBJ_DIR)
	@printf "$(GREEN)Object files and directory removed.$(RESET)\n"

fclean: clean
	@printf "$(YELLOW)Removing $(NAME_COLLEEN)... $(RESET)\n"
	@rm -f $(NAME_COLLEEN)
	@printf "$(GREEN)Executable removed.$(RESET)\n"
	@printf "$(YELLOW)Removing $(NAME_GRACE)... $(RESET)\n"
	@rm -f $(NAME_GRACE)
	@printf "$(GREEN)Executable removed.$(RESET)\n"
	@printf "$(YELLOW)Removing $(NAME_SULLY)... $(RESET)\n"
	@rm -f $(NAME_SULLY)
	@printf "$(GREEN)Executable removed.$(RESET)\n"

re: fclean all

.PHONY: all colleen grace sully clean fclean re


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
