SOURCE = P$(DOCNO).md
TARGET = $(PD)$(DOCNO)R$(REV)

PANDOC = pandoc
PANDOC_FMT = markdown_github+yaml_metadata_block+citations+smart

$(TARGET).html: $(SOURCE) header.html pandoc-template.html ../pandoc.css
	$(PANDOC) -f $(PANDOC_FMT) -t html -o $@ --filter pandoc-citeproc --csl=../acm-sig-proceedings.csl -s --template=pandoc-template --include-before-body=header.html --include-in-header=../pandoc.css $<

# FIXME
$(TARGET).pdf: $(SOURCE)
	$(PANDOC) -f $(PANDOC_FMT) -t latex -o $@ --filter pandoc-citeproc --csl=../acm-sig-proceedings.csl -s $<

header.html: header.html.in Makefile
	sed 's/%%DOCNO%%/$(TARGET)/g' < $< > $@ || rm -f $@

clean:
	rm -f header.html $(TARGET).html $(TARGET).pdf *~

view: $(TARGET).html
	gnome-www-browser $(TARGET).html

cooked.txt: raw.txt
	sed -rf ../cook < $< > $@ || rm -f $@