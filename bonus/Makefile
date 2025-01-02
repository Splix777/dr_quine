GREEN = \033[1;32m
YELLOW = \033[1;33m
CYAN = \033[1;36m
RESET = \033[0m

NAME_COLLEEN = Colleen
NAME_GRACE = Grace
NAME_SULLY = Sully

SRC_COLLEEN = Colleen.py
SRC_GRACE = Grace.py
SRC_SULLY = Sully.py

all: colleen grace sully

colleen: $(NAME_COLLEEN)

grace: $(NAME_GRACE)

sully: $(NAME_SULLY)

test: test_colleen test_grace test_sully

test_colleen: colleen
	@printf "$(CYAN)Running $<... $(RESET)\n"
	@if python3 $(NAME_COLLEEN) | diff - $(SRC_COLLEEN); then \
		printf "$(GREEN)Test passed!$(RESET)\n"; \
	else \
		printf "$(RED)Test failed! Differences:$(RESET)\n"; \
		python3 $(NAME_COLLEEN) | diff - $(SRC_COLLEEN); \
	fi

test_grace: grace
	@printf "$(CYAN)Running $<... $(RESET)\n"
	@if python3 $(NAME_GRACE) && diff $(SRC_GRACE) Grace_kid

test_sully: sully
	@printf "$(CYAN)Running Sully tests... $(RESET)\n"
	@success=1; \
	./$(NAME_SULLY); \
	for i in 4 3 2 1 0; do \
		expected_file=Sully_$$i.py; \
		normalized_expected=$(SRC_SULLY).normalized; \
		normalized_output=$$expected_file.normalized; \
		if [ ! -f $$expected_file ]; then \
			printf "$(YELLOW)File $$expected_file not found!$(RESET)\n"; \
			success=0; \
		elif ! diff $$expected_file $(SRC_SULLY); then \
			printf "$(RED)File $$expected_file differs from $(SRC_SULLY)!$(RESET)\n"; \
			success=0; \
		fi; \
		if [ $$i -gt 0 ]; then \
			if [ ! -f $$normalized_expected ]; then \
				printf "$(YELLOW)File $$normalized_expected not found!$(RESET)\n"; \
				success=0; \
			elif ! diff $$normalized_expected $$normalized_output; then \
				printf "$(RED)File $$normalized_expected differs from $$normalized_output!$(RESET)\n"; \
				success=0; \
			fi; \
		fi; \
	done; \
	if [ $$success -eq 1 ]; then \
		printf "$(GREEN)All tests passed!$(RESET)\n"; \
	fi

$(NAME_COLLEEN): $(SRC_COLLEEN)
	@printf "$(CYAN)Copying $< to $@... $(RESET)\n"
	@cp $< $@

$(NAME_GRACE): $(SRC_GRACE)
	@printf "$(CYAN)Copying $< to $@... $(RESET)\n"
	@cp $< $@

$(NAME_SULLY): $(SRC_SULLY)
	@printf "$(CYAN)Copying $< to $@... $(RESET)\n"
	@cp $< $@

clean:
	@printf "$(CYAN)Cleaning... $(RESET)\n"
	@rm -f $(NAME_COLLEEN) $(NAME_GRACE) $(NAME_SULLY)

fclean: clean

re: fclean all

.PHONY: all colleen grace sully test test_colleen test_grace test_sully clean fclean re