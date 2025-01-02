# Color codes for console output
GREEN  = \033[1;32m
YELLOW = \033[1;33m
CYAN   = \033[1;36m
RED    = \033[1;31m
RESET  = \033[0m

# Define script names
COLLEEN = Colleen.py
GRACE   = Grace.py
SULLY   = Sully.py

# Default target
all: $(COLLEEN) $(GRACE) $(SULLY)

# Test targets for each script
test: test_colleen test_grace test_sully

test_colleen: $(COLLEEN)
	@echo "$(CYAN)Running $(COLLEEN)... $(RESET)"
	@python3 $(COLLEEN) | diff - $(COLLEEN) > /dev/null && echo "$(GREEN)Test passed!$(RESET)" || (echo "$(RED)Test failed! Differences:$(RESET)" && python3 $(COLLEEN) | diff - $(COLLEEN))

test_grace: $(GRACE)
	@echo "$(CYAN)Running $(GRACE)... $(RESET)"
	@python3 $(GRACE) && diff $(GRACE) Grace_kid.py > /dev/null && echo "$(GREEN)Test passed!$(RESET)" || (echo "$(RED)Test failed! Differences:$(RESET)" && diff $(GRACE) Grace_kid.py)

test_sully: $(SULLY)
	@printf "$(CYAN)Running Sully tests... $(RESET)\n"
	@success=1; \
	python3 $(SULLY); \
	for i in 4 3 2 1 0; do \
		expected_file=Sully_$$i.py; \
		normalized_expected=$(SULLY).normalized; \
		normalized_output=$$expected_file.normalized; \
		sed 's/^X: int =.*/X: int [ignored]/' $(SULLY) > $$normalized_expected; \
		sed 's/^X: int =.*/X: int [ignored]/' $$expected_file > $$normalized_output; \
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

clean:
	@rm -f Grace_kid.py $(SULLY).normalized Sully_*.py Sully_*.py.normalized

fclean: clean

re: fclean all

.PHONY: all test test_colleen test_grace test_sully clean fclean re