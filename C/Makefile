GREEN = \033[1;32m
YELLOW = \033[1;33m
CYAN = \033[1;36m
RESET = \033[0m

NAME = Colleen
CC = clang
CFLAGS = -Wall -Wextra -Werror

SRC = Colleen.c
OBJ = $(SRC:.c=.o)

all: $(NAME)

$(NAME): $(OBJ)
	@printf "$(CYAN)Compiling $(NAME)... $(RESET)\n"
	@$(CC) $(CFLAGS) -o $(NAME) $(OBJ)
	@printf "$(GREEN)Done!$(RESET)\n"

%.o: %.c
	@$(CC) $(CFLAGS) -c -o $@ $<

clean:
	@printf "$(YELLOW)Cleaning object files... $(RESET)\n"
	@rm -f $(OBJ)
	@printf "$(GREEN)Object files removed.$(RESET)\n"

fclean: clean
	@printf "$(YELLOW)Removing $(NAME)... $(RESET)\n"
	@rm -f $(NAME)
	@printf "$(GREEN)Executable removed.$(RESET)\n"

re: fclean all

.PHONY: all clean fclean re
