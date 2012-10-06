#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"
#include "DirectoryIterator.hh"

using std::string;

MODULE = Directory::Iterator::XS		PACKAGE = Directory::Iterator::XS		

PROTOTYPES: disable

DirectoryIterator *
DirectoryIterator::new (char * dir)

void
DirectoryIterator::show_dotfiles(bool arg)

string
DirectoryIterator::next()
CODE:
	if ( THIS->next() )
	   RETVAL = THIS->get();
	else
	   XSRETURN_UNDEF;
OUTPUT:
	RETVAL

string
DirectoryIterator::get()

void
DirectoryIterator::prune()

void
DirectoryIterator::DESTROY()
