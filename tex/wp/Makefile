all: sep.pdf clean

sep.pdf: sep.tex ../../models/one/jacobian-0.tikz ../../models/one/jacobian-1.tikz ../../models/one/jacobian-2.tikz ../../models/one/jacobian-sparse-tree-2.tikz ../../models/rbc/rbc.tikz ../../models/rbcii/rbcii.tikz ../../models/rbcii/rbcii_.tikz ../plots/sparse-stacked-jacobian-3-nodes.tikz ../plots/sparse-stacked-jacobian-11-nodes.tikz ../plots/sparse-stacked-jacobian-sep-2.tikz ../plots/sparse-stacked-jacobian-sep-10.tikz ../plots/tree.tex ../plots/sparse-tree.tex
	@latexindent -l -rv -w -s sep.tex
	@latexmk -pdf -shell-escape sep
	@latexmk -c

clean:
	@rm -f *.aux *.log *.out *.nav *.rel *.toc *.snm *.synctex.gz *.vrb *.rubbercache
	@rm -f sep.bak*
	@rm -rf auto

clean-all:
	@rm -f *.pdf

.PHONY: all
