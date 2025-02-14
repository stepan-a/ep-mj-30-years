LATEX = pdflatex

all: sep.pdf clean

sep.pdf: sep.tex ../../models/one/jacobian-0.tikz ../../models/one/jacobian-1.tikz ../../models/one/jacobian-2.tikz ../../models/one/jacobian-sparse-tree-2.tikz ../../models/rbc/rbc.tikz ../../models/rbcii/rbcii.tikz ../../models/rbcii/rbcii_.tikz
	@rubber --unsafe --pdf sep
	@rubber --clean sep

clean:
	@rm -f *.aux *.log *.out *.nav *.rel *.toc *.snm *.synctex.gz *.vrb *.rubbercache
	@rm -rf auto

clean-all:
	@rm -f *.pdf

.PHONY: all
