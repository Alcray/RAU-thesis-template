#!/bin/bash

# RAU LaTeX Template Linux/WSL Setup Script
# Installs required TeX Live packages for Russian-Armenian documents

set -e

echo "[INFO] Updating apt package index..."
sudo apt-get update

echo "[INFO] Installing TeX Live packages..."
sudo apt-get install -y \
  texlive-latex-base \
  texlive-latex-recommended \
  texlive-latex-extra \
  texlive-fonts-recommended \
  texlive-lang-cyrillic \
  texlive-lang-european \
  texlive-lang-other \
  texlive-bibtex-extra

echo "[INFO] Verifying installation..."
pdflatex --version

echo "[SUCCESS] Linux/WSL setup completed."
