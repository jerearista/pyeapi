#!/usr/bin/make
# WARN: gmake syntax
########################################################
# Makefile for pyeapi
#
# useful targets:
#	make sdist -- build python source distribution
#	make pep8 -- pep8 checks
#	make pyflakes -- pyflakes checks
#	make tests -- run all of the tests
#   make unittest -- runs the unit tests
#   make systest -- runs the system tests
#	make clean -- clean distutils
#	make html -- build html docs: docs/_build/html/index.html
#	make pdf -- build PDF: docs/_build/latex/AristaeAPIPythonLibrary.pdf
#	make docs-clean -- clean docs/_build/
#
########################################################
# variable section

NAME = "pyeapi"

PYTHON=python
SITELIB = $(shell $(PYTHON) -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")

VERSION := $(shell cat VERSION)

########################################################

all: clean pep8 pyflakes tests

pep8:
	-pep8 -r --ignore=E501,E221,W291,W391,E302,E251,E203,W293,E231,E303,E201,E225,E261,E241 pyeapi/ test/

pyflakes:
	pyflakes pyeapi/ test/

clean: docs-clean
	@echo "Cleaning up distutils stuff"
	rm -rf build
	rm -rf dist
	rm -rf MANIFEST
	rm -rf *.egg-info
	@echo "Cleaning up byte compiled python stuff"
	find . -type f -regex ".*\.py[co]$$" -delete

sdist: clean
	$(PYTHON) setup.py sdist

tests: unittest systest

unittest: clean
	$(PYTHON) -m unittest discover test/unit -v

systest: clean
	$(PYTHON) -m unittest discover test/system -v

.PHONY: docs pdf docs-clean latexpdf

html:
	# Using -C fails due to 
	$(MAKE) -C docs html
	#(cd docs; $(MAKE) html)

latexpdf: pdf

pdf:
	#(cd docs; $(MAKE) latexpdf)
	$(MAKE) -C docs latexpdf

docs-clean:
	#(cd docs; $(MAKE) clean)
	$(MAKE) -C docs clean
