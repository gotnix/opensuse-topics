SRC=$(wildcard *.tex)
TARGET=$(patsubst %.tex,%.pdf,${SRC})
SVNVERSION=$(shell svn info|awk '$$1 ~ /^(版本:|Revision:)/{print $$2}')
PDFTARGET=$(patsubst %.pdf,%-r${SVNVERSION}.pdf,${TARGET})
title=$(shell sed -ne 's/title{\(.*\)}/\1/p' ${SRC})
.PHONY:clean html download view blog
all:${PDFTARGET}
clean:
	rm -rf *.pdf
	rm -rf *.out
	rm -rf *.log
	rm -rf *.toc
	rm -rf *.aux
%.pdf:%.tex %.toc
	xelatex  $< 
%.toc:%.tex
	xelatex  $<
${PDFTARGET}:${TARGET}
	cp $< ${PDFTARGET}
html:${SRC}
	latex2html -local_icons -html_version 4.0,latin1,unicode $<
blog:${SRC}
	latex2html -lcase_tags -mkdir -dir blog -split 0 -nonavigation -noinfo -html_version 4.0,latin1,unicode $<
publish:${SRC}
	python ../blog-upload-my.py $<
download:${PDFTARGET}
	@echo "now publish $< to code.google.com..."
	@echo "please make sure you have googlecode_upload.py in your path!"
	@echo "If you DON'T have googlecode_upload.py,Download from http://code.google.com/support"
	@echo "wget http://support.googlecode.com/svn/trunk/scripts/googlecode_upload.py"
	../googlecode_upload.py  -s "${title}" -p opensuse-topics $<
view:${PDFTARGET}
	evince $<&
