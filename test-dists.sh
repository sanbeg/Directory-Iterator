#! /bin/sh

#TODO - add ''

mkdir test-$$

for type in '-PP' '-XS'
do
    module=Directory-Iterator$type
    tarball=`ls -t $module-*.tar.gz | head -1`
    version=`basename $tarball .tar.gz`

    echo $version
    tar -C test-$$ -xzp -f $tarball

    cd test-$$/$version || exit 1
    perl Makefile.PL
    make test
    cd ../..
done

    