# RAU LaTeX Template Makefile
# Simple build system for LaTeX documents

.PHONY: all clean distclean help pdf view install-deps

# Default target
all: pdf

# Main document name (change if needed)
DOC = main

# LaTeX compiler
LATEX = pdflatex
BIBTEX = bibtex

# PDF compilation
pdf: $(DOC).pdf

$(DOC).pdf: $(DOC).tex titlepage.tex references.bib
	@echo "Compiling LaTeX document..."
	$(LATEX) -interaction=nonstopmode $(DOC).tex
	@if [ -f $(DOC).aux ]; then \
		$(BIBTEX) $(DOC).aux; \
		$(LATEX) -interaction=nonstopmode $(DOC).tex; \
	fi
	$(LATEX) -interaction=nonstopmode $(DOC).tex
	@echo "PDF generated: $(DOC).pdf"

# Clean auxiliary files
clean:
	@echo "Cleaning auxiliary files..."
	rm -f *.aux *.bbl *.blg *.fdb_latexmk *.fls *.log *.out *.toc *.synctex.gz

# Clean all generated files including PDF
distclean: clean
	@echo "Cleaning all generated files..."
	rm -f $(DOC).pdf

# View PDF (macOS)
view: $(DOC).pdf
	open $(DOC).pdf

# Install dependencies (requires setup.sh to be run first)
install-deps:
	./setup.sh

# Quick compilation (single pass, no bibliography)
quick: $(DOC).tex
	$(LATEX) -interaction=nonstopmode $(DOC).tex

# Check for LaTeX installation
check:
	@echo "Checking LaTeX installation..."
	@which pdflatex || (echo "pdflatex not found. Run './setup.sh' first."; exit 1)
	@pdflatex --version | head -1
	@echo "LaTeX is ready!"

# Word count (requires texcount)
wordcount:
	@echo "Word count (requires texcount):"
	@which texcount >/dev/null 2>&1 && texcount $(DOC).tex || echo "Install texcount for word counting"

# Help
help:
	@echo "RAU LaTeX Template Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  all          - Build PDF (default)"
	@echo "  pdf          - Build PDF with bibliography"
	@echo "  quick        - Single-pass compilation (no bibliography)"
	@echo "  clean        - Remove auxiliary files"
	@echo "  distclean    - Remove all generated files"
	@echo "  view         - Open PDF in default viewer"
	@echo "  install-deps - Run setup script"
	@echo "  check        - Check LaTeX installation"
	@echo "  wordcount    - Count words (requires texcount)"
	@echo "  help         - Show this help message"
	@echo ""
	@echo "Usage: make [target]"
