PROJECT=AWS-BEDROCK-KNOWLEDGE-BASE
VERSION=0.1.0
PYTHON_VERSION=3.12
SOURCE_OBJECTS=src tests

setup:
	pip3 install uv
	uv sync

format.ruff:
	uv run ruff format ${SOURCE_OBJECTS}
format.isort:
	uv run isort --atomic ${SOURCE_OBJECTS}
format: format.isort format.ruff

lints.format.check:
	uv run ruff format --check ${SOURCE_OBJECTS}
	uv run isort --check-only ${SOURCE_OBJECTS}

test: setup
	uv run coverage run -m pytest -s .

test.coverage: test
	uv run coverage report -m --fail-under=90