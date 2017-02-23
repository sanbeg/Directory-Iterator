test: Directory-Iterator-PP.test Directory-Iterator-XS.test Directory-Iterator.test

%.test: %
	cd $< && perl Makefile.PL && make test

