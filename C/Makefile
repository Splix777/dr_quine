GREEN = \033[1;32m
YELLOW = \033[1;33m
CYAN = \033[1;36m
RESET = \033[0m

NAME_COLLEEN = Colleen
NAME_GRACE = Grace
NAME_SULLY = Sully

SRC_COLLEEN = Colleen.c
SRC_GRACE = Grace.c
SRC_SULLY = Sully.c

OBJ_DIR = obj
OBJ_COLLEEN = $(OBJ_DIR)/$(SRC_COLLEEN:.c=.o)
OBJ_GRACE = $(OBJ_DIR)/$(SRC_GRACE:.c=.o)
OBJ_SULLY = $(OBJ_DIR)/$(SRC_SULLY:.c=.o)

CC = clang
CFLAGS = -Wall -Wextra -Werror

all: colleen grace sully

colleen: $(NAME_COLLEEN)

grace: $(NAME_GRACE)

sully: $(NAME_SULLY)

test: test_colleen test_grace test_sully

test_colleen: colleen
	@printf "$(CYAN)Running $<... $(RESET)\n"
	@if ./$(NAME_COLLEEN) | diff - $(SRC_COLLEEN); then \
		printf "$(GREEN)Test passed!$(RESET)\n"; \
	else \
		printf "$(RED)Test failed! Differences:$(RESET)\n"; \
		./$(NAME_COLLEEN) | diff - $(SRC_COLLEEN); \
	fi

test_grace: grace
	@printf "$(CYAN)Running $<... $(RESET)\n"
	@if ./$(NAME_GRACE) && diff $(SRC_GRACE) Grace_kid.c; then \
		printf "$(GREEN)Test passed!$(RESET)\n"; \
	else \
		printf "$(RED)Test failed! Differences:$(RESET)\n"; \
		diff $(SRC_GRACE) Grace_kid.c; \
	fi

test_sully: sully
	@printf "$(CYAN)Running Sully tests... $(RESET)\n"
	@success=1; \
	./$(NAME_SULLY); \
	for i in 4 3 2 1 0; do \
		expected_file=Sully_$$i.c; \
		normalized_expected=$(SRC_SULLY).normalized; \
		normalized_output=$$expected_file.normalized; \
		sed 's/^#define X .*/#define X [ignored]/' $(SRC_SULLY) > $$normalized_expected; \
		sed 's/^#define X .*/#define X [ignored]/' $$expected_file > $$normalized_output; \
		if ! diff $$normalized_expected $$normalized_output; then \
			printf "$(RED)Test failed for $$expected_file!$(RESET)\n"; \
			success=0; \
		fi; \
		rm -f $$normalized_expected $$normalized_output; \
	done; \
	if [ $$success -eq 1 ]; then \
		printf "$(GREEN)All Sully tests passed!$(RESET)\n"; \
	else \
		printf "$(RED)Some Sully tests failed!$(RESET)\n"; \
	fi


$(NAME_COLLEEN): $(OBJ_COLLEEN)
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
	@rm -f $(NAME_COLLEEN)
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

.PHONY: all colleen grace sully test test_colleen test_grace test_sully clean fclean re
