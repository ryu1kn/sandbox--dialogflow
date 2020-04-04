log_file := sample-log-entry.txt

.PHONY: run
run:
	python main.py $(log_file)

.PHONY: test
test:
	poetry run pytest -s tests
