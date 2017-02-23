test: Directory-Iterator-PP.test Directory-Iterator-XS.test Directory-Iterator.test

%.test: %
	cpanm --quiet --installdeps --notest $<
	cd $< && perl Makefile.PL
	make -c $< test

