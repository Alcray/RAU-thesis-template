#!/bin/bash

# RAU LaTeX Template Setup Script
# Installs BasicTeX and required language packages for Russian-Armenian documents

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on macOS
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "This script is designed for macOS only."
        exit 1
    fi
}

# Check for required tools
check_dependencies() {
    local missing_deps=()

    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi

    if ! command -v brew &> /dev/null; then
        missing_deps+=("homebrew")
    fi

    if [[ ${#missing_deps[@]} -ne 0 ]]; then
        log_error "Missing required dependencies: ${missing_deps[*]}"
        log_info "Please install missing dependencies and run setup again."
        exit 1
    fi
}

# Install BasicTeX
install_basictex() {
    log_info "Installing BasicTeX..."

    if command -v pdflatex &> /dev/null; then
        log_warning "BasicTeX appears to be already installed. Skipping..."
        return
    fi

    # Download BasicTeX from a reliable mirror
    log_info "Downloading BasicTeX (this may take a few minutes)..."
    cd /tmp

    # Try different mirrors in case one fails
    local mirrors=(
        "https://ctan.math.utah.edu/ctan/tex-archive/systems/mac/mactex/mactex-basictex-20250308.pkg"
        "https://mirror.ctan.org/systems/mac/mactex/mactex-basictex-20250308.pkg"
    )

    local downloaded=false
    for mirror in "${mirrors[@]}"; do
        log_info "Trying mirror: $mirror"
        if curl -L --max-time 600 -o BasicTeX.pkg "$mirror" 2>/dev/null; then
            log_success "Downloaded BasicTeX successfully"
            downloaded=true
            break
        else
            log_warning "Failed to download from $mirror, trying next mirror..."
        fi
    done

    if [[ "$downloaded" != true ]]; then
        log_error "Failed to download BasicTeX from all mirrors"
        log_info "Please download manually from: https://www.tug.org/mactex/morepackages.html"
        exit 1
    fi

    # Install BasicTeX
    log_info "Installing BasicTeX..."
    if sudo installer -pkg BasicTeX.pkg -target /; then
        log_success "BasicTeX installed successfully"
    else
        log_error "Failed to install BasicTeX"
        exit 1
    fi

    # Clean up
    rm -f BasicTeX.pkg

    # Update PATH for current session
    export PATH="/Library/TeX/texbin:$PATH"
    log_info "BasicTeX installation completed"
}

# Install LaTeX packages
install_latex_packages() {
    log_info "Installing LaTeX language packages..."

    # Update PATH
    export PATH="/Library/TeX/texbin:$PATH"

    # Install Russian and Armenian language support
    local packages=(
        "babel-russian"
        "collection-langcyrillic"
        "armtex"
        "hyphen-russian"
        "cm-super"  # Better font support
    )

    for package in "${packages[@]}"; do
        log_info "Installing $package..."
        if sudo tlmgr install "$package"; then
            log_success "Installed $package"
        else
            log_warning "Failed to install $package (may already be installed or not available)"
        fi
    done

    log_success "Language packages installation completed"
}

# Setup VS Code integration
setup_vscode() {
    log_info "Setting up VS Code LaTeX Workshop configuration..."

    if [[ ! -d ".vscode" ]]; then
        mkdir -p .vscode
    fi

    # Create settings.json if it doesn't exist
    if [[ ! -f ".vscode/settings.json" ]]; then
        cat > .vscode/settings.json << 'EOF'
{
    "latex-workshop.latex.recipes": [
        {
            "name": "pdflatex",
            "tools": [
                "pdflatex"
            ]
        }
    ],
    "latex-workshop.latex.tools": [
        {
            "name": "pdflatex",
            "command": "pdflatex",
            "args": [
                "-synctex=1",
                "-interaction=nonstopmode",
                "-file-line-error",
                "%DOC%"
            ],
            "env": {
                "PATH": "/Library/TeX/texbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
            }
        }
    ],
    "latex-workshop.latex.autoBuild.run": "onSave",
    "latex-workshop.view.pdf.viewer": "tab",
    "latex-workshop.latex.rootFile.useSubFile": false,
    "latex-workshop.latex.rootFile": "main.tex",
    "latex-workshop.latex.clean.fileTypes": [
        "*.aux",
        "*.bbl",
        "*.blg",
        "*.idx",
        "*.ind",
        "*.lof",
        "*.lot",
        "*.out",
        "*.toc",
        "*.acn",
        "*.acr",
        "*.alg",
        "*.glg",
        "*.glo",
        "*.gls",
        "*.fls",
        "*.log",
        "*.fdb_latexmk",
        "*.synctex.gz"
    ]
}
EOF
        log_success "Created VS Code settings"
    else
        log_info "VS Code settings already exist"
    fi
}

# Test installation
test_installation() {
    log_info "Testing LaTeX installation..."

    export PATH="/Library/TeX/texbin:$PATH"

    # Test pdflatex
    if pdflatex --version &> /dev/null; then
        log_success "pdflatex is working"
    else
        log_error "pdflatex is not working. Please restart your terminal and try again."
        exit 1
    fi

    # Test compilation
    log_info "Testing document compilation..."
    if pdflatex -interaction=nonstopmode main.tex &> /dev/null; then
        log_success "Document compiles successfully"
    else
        log_warning "Document compilation failed, but LaTeX is installed. Check main.tex for errors."
    fi
}

# Update PATH in shell profiles
update_path() {
    log_info "Updating PATH in shell profiles..."

    local path_entry='export PATH="/Library/TeX/texbin:$PATH"'

    # Update .zshrc
    if [[ -f "$HOME/.zshrc" ]]; then
        if ! grep -q "/Library/TeX/texbin" "$HOME/.zshrc"; then
            echo "$path_entry" >> "$HOME/.zshrc"
            log_success "Updated .zshrc"
        else
            log_info ".zshrc already contains TeX path"
        fi
    fi

    # Update .bash_profile
    if [[ -f "$HOME/.bash_profile" ]]; then
        if ! grep -q "/Library/TeX/texbin" "$HOME/.bash_profile"; then
            echo "$path_entry" >> "$HOME/.bash_profile"
            log_success "Updated .bash_profile"
        else
            log_info ".bash_profile already contains TeX path"
        fi
    fi

    log_info "Please restart your terminal or run: source ~/.zshrc (or ~/.bash_profile)"
}

# Main installation function
main() {
    log_info "RAU LaTeX Template Setup"
    log_info "=========================="

    check_macos
    check_dependencies

    install_basictex
    install_latex_packages
    setup_vscode
    test_installation
    update_path

    log_success "Setup completed successfully!"
    log_info ""
    log_info "Next steps:"
    log_info "1. Restart your terminal to update PATH"
    log_info "2. Open the project in VS Code"
    log_info "3. Install LaTeX Workshop extension if not already installed"
    log_info "4. Start editing main.tex - it will auto-compile on save"
    log_info ""
    log_info "Happy LaTeX writing! 📄"
}

# Run main function
main "$@"
