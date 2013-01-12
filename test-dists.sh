#! /bin/sh

#TODO - add ''

tmp=test-tmp-$$

mkdir $tmp

for type in '-PP' '-XS'
do
    module=Directory-Iterator$type
    tarball=`ls -t $module-*.tar.gz | head -1`
    version=`basename $tarball .tar.gz`

    if [ "$tarball" != "" ]
    then
	echo $version
	tar -C $tmp -xzp -f $tarball

	cd $tmp/$version || exit 1
	perl Makefile.PL
	make test
	cd ../..
    else
	echo "No distribution found for $module!"
    fi
done

    