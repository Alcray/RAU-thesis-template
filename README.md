# RAU LaTeX Template for Term Papers

A comprehensive LaTeX template for Russian-Armenian (Slavic) University term papers with bilingual support (Russian and Armenian).

## Features

- **Russian Language Support**: Full Cyrillic support with proper hyphenation
- **Armenian Language Support**: Eastern Armenian typesetting capabilities
- **Professional Title Page**: Pre-configured with RAU branding and logos
- **Bibliography Management**: BibTeX support for academic references
- **Auto-compilation**: VS Code integration with LaTeX Workshop extension
- **Table of Contents**: Automatic generation with proper formatting

## Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/rau-latex-template.git
   cd rau-latex-template
   ```

2. **Install LaTeX dependencies:**

   On **macOS**, run the setup script:
   ```bash
   ./setup.sh
   ```

   This will install:
   - BasicTeX (LaTeX distribution)
   - Russian language support
   - Armenian language support
   - Required LaTeX packages

   On **Linux / WSL / Ubuntu**, run the setup script:
   ```bash
   ./setup-linux.sh
   ```

   After installation, verify:
   ```bash
   pdflatex --version
   ```

3. **Open in VS Code:**
   ```bash
   code .
   ```

4. **Start writing:**
   - Edit `main.tex` for your content
   - Edit `titlepage.tex` for title page customization
   - Compile automatically on save

## Project Structure

```
rau-latex-template/
├── main.tex              # Main document file
├── titlepage.tex         # Title page template
├── references.bib        # Bibliography database
├── logo_rau.png          # RAU university logo
├── setup.sh              # Installation script
├── setup-linux.sh        # Linux/WSL installation script
├── .vscode/              # VS Code configuration
│   └── settings.json     # LaTeX Workshop settings
└── README.md             # This file
```

## Usage

### Writing Your Paper

1. **Title Page**: Edit `titlepage.tex` to customize:
   - Paper title
   - Author information
   - Supervisor details
   - Date

2. **Content**: Edit `main.tex` to add your sections:
   - Introduction
   - Background
   - Methods
   - Results
   - Conclusion

3. **References**: Add citations to `references.bib` using BibTeX format

### Compilation

The template is configured for automatic compilation with LaTeX Workshop:

- **Auto-save compilation**: Saves automatically trigger PDF generation
- **SyncTeX support**: Click in PDF to jump to source, and vice versa
- **Error highlighting**: LaTeX errors appear directly in the editor

### Manual Compilation

If needed, compile manually:

```bash
pdflatex main.tex
bibtex main.aux  # For bibliography
pdflatex main.tex
pdflatex main.tex
```

## Requirements

### System Requirements
- macOS 10.14 or later, or Linux/WSL with `apt`
- At least 2GB free disk space
- Internet connection for initial setup

### Software Dependencies
- macOS: BasicTeX (installed by `setup.sh`)
- Linux/WSL: TeX Live packages (installed by `setup-linux.sh`)
- VS Code with LaTeX Workshop extension (recommended)

## Troubleshooting

### Common Issues

**"pdflatex not found"**
- On Linux/WSL, run `./setup-linux.sh`
- On macOS, run `./setup.sh`
- Restart your terminal after installation

**"Unknown option 'russian'"**
- On Linux/WSL, run `./setup-linux.sh`
- On macOS, run `./setup.sh`

**"File `armtex.sty' not found"**
- On Linux/WSL, run `./setup-linux.sh`
- On macOS, run `./setup.sh`

**"Unicode character not set up for use with LaTeX"**
- Ensure you have the correct language packages installed
- Check that your document uses proper encoding

**Compilation hangs or fails**
- Check the log file: `main.log`
- Ensure all required packages are installed
- Try manual compilation: `pdflatex main.tex`

### Getting Help

1. Check the LaTeX log file (`main.log`) for detailed error messages
2. Ensure all prerequisites are installed
3. Try compiling a minimal example first

## Customization

### Changing Languages

The template supports both Russian and Armenian. To modify language settings, edit the preamble in `main.tex`:

```latex
\usepackage[T2A,OT6]{fontenc}        % Font encodings for Russian and Armenian
\usepackage[russian,english]{babel}  % Language support
\usepackage{armtex}                  % Armenian typesetting
```

### Adding New Packages

Add new LaTeX packages to the preamble in `main.tex`:

```latex
\usepackage{your-package-name}
```

If the package isn't in BasicTeX, install it with:

```bash
sudo tlmgr install your-package-name
```

### Modifying Styles

- **Fonts**: Change font family in the document class options
- **Spacing**: Adjust line spacing with `setspace` package
- **Margins**: Modify geometry package settings
- **Colors**: Add color support with `xcolor` package

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This template is provided as-is for educational and academic use.

## Acknowledgments

- Russian-Armenian (Slavic) University
- LaTeX community
- BasicTeX developers
- LaTeX Workshop extension developers
