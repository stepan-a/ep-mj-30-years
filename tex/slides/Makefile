LATEX = pdflatex

all: sep.pdf clean

sep.pdf: sep.tex 
	@rubber --src-specials --unsafe --pdf sep
	@rubber --clean sep

clean:
	@rm -f *.aux *.log *.out *.nav *.rel *.toc *.snm *.synctex.gz *.vrb *.rubbercache
	@rm -rf auto

clean-all:
	@rm -f *.pdf

.PHONY: all
