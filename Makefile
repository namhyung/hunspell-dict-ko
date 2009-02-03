PYTHON = python

LANG = ko

AFFIX = $(LANG).aff
DICT = $(LANG).dic

DICT_SOURCES = dict-$(LANG)/dict-*.dic

CLEANFILES = $(AFFIX) $(DICT)

DISTDIR = dist

PACKAGE = hunspell-dict-ko
VERSION = $(shell python -c 'import config;print(config.version)')
RELEASETAG = HEAD

SRC_DISTNAME = hunspell-dict-ko-$(VERSION)
SRC_DISTFILE = $(DISTDIR)/$(SRC_DISTNAME).tar.gz

all: $(AFFIX) $(DICT)

$(AFFIX): make-aff.py config.py suffix.py suffixdata.py
	$(PYTHON) make-aff.py > $(AFFIX) || (rm -f $@; false)

$(DICT): make-dic.py $(DICT_SOURCES) config.py  suffix.py suffixdata.py
	$(PYTHON) make-dic.py $(DICT_SOURCES) > $@ || (rm -f $@; false)

distdir:
	if ! [ -d $(DISTDIR) ]; then mkdir $(DISTDIR); fi

clean: 
	rm -f $(CLEANFILES)
	rm -f $(DISTDIR)

dist:: distdir
	git-archive --format=tar --prefix=$(SRC_DISTNAME)/ $(RELEASETAG) | gzip -9 -c > $(SRC_DISTFILE)

.PHONY: all clean dist distdir