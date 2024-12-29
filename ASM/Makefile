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