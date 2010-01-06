sitedir = /usr/local/lib/plt/site/text/libxslt
objects = libxslt.scm libxml.scm suiker.scm
mainscm = libxslt.ss

all:
	true

# FIXME: Not bullet-proof against spaces in filenames.
install:
	mkdir -p $(sitedir)
	for file in $(objects); do \
	    cp -v $$file $(sitedir)/$$(echo $$file | sed 's/\.scm$$/.ss/'); \
	done
	(cd $(sitedir); ln -sf $(mainscm) main.ss)
