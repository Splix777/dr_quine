GREEN = \033[1;32m
YELLOW = \033[1;33m
CYAN = \033[1;36m
RESET = \033[0m

NAME_COLEEN = Colleen
NAME_GRACE = Grace
NAME_SULLY = Sully

SRC_COLEEN = Colleen.c
SRC_GRACE = Grace.c
SRC_SULLY = Sully.c

OBJ_DIR = obj
OBJ_COLEEN = $(OBJ_DIR)/$(SRC_COLEEN:.c=.o)
OBJ_GRACE = $(OBJ_DIR)/$(SRC_GRACE:.c=.o)
OBJ_SULLY = $(OBJ_DIR)/$(SRC_SULLY:.c=.o)

CC = clang
CFLAGS = -Wall -Wextra -Werror

all: colleen grace sully

colleen: $(NAME_COLEEN)

grace: $(NAME_GRACE)

sully: $(NAME_SULLY)

$(NAME_COLEEN): $(OBJ_COLEEN)
	@printf "$(CYAN)Linking $@... $(RESET)\n"
	@$(CC) $(CFLAGS) -o $@ $^

$(NAME_GRACE): $(OBJ_GRACE)
	@printf "$(CYAN)Linking $@... $(RESET)\n"
	@$(CC) $(CFLAGS) -o $@ $^

$(NAME_SULLY): $(OBJ_SULLY)
	@printf "$(CYAN)Linking $@... $(RESET)\n"
	@$(CC) $(CFLAGS) -o $@ $^

$(OBJ_DIR)/%.o: %.c | $(OBJ_DIR)
	@printf "$(CYAN)Compiling $<... $(RESET)\n"
	@$(CC) $(CFLAGS) -c $< -o $@
	@@printf "$(GREEN)Done!$(RESET)\n"

$(OBJ_DIR):
	@mkdir -p $(OBJ_DIR)
	@printf "$(YELLOW)Created directory $(OBJ_DIR).$(RESET)\n"

clean:
	@printf "$(YELLOW)Cleaning object files... $(RESET)\n"
	@rm -rf $(OBJ_DIR)
	@printf "$(GREEN)Object files and directory removed.$(RESET)\n"

fclean: clean
	@printf "$(YELLOW)Removing $(NAME_COLEEN)... $(RESET)\n"
	@rm -f $(NAME_COLEEN)
	@printf "$(GREEN)Executable removed.$(RESET)\n"
	@printf "$(YELLOW)Removing $(NAME_GRACE)... $(RESET)\n"
	@rm -f $(NAME_GRACE)
	@rm -f Grace_kid.c
	@printf "$(GREEN)Executable removed.$(RESET)\n"
	@printf "$(YELLOW)Removing $(NAME_SULLY)... $(RESET)\n"
	@rm -f $(NAME_SULLY)
	@rm -f Sully_*
	@printf "$(GREEN)Executable removed.$(RESET)\n"

re: fclean all

.PHONY: all clean fclean re
