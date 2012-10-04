# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Directory-Iterator.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More;

use lib '../Directory-Iterator-PP/blib/lib';
use lib '../Directory-Iterator-XS/blib/lib';
use lib '../Directory-Iterator-XS/blib/arch';
use Directory::Iterator;

is (@Directory::Iterator::ISA, 1, 'found parent');


my $obj = Directory::Iterator->new('t');

# isa_ok($obj, 'Directory::Iterator::XS');

foreach my $method ('get', 'next', 'prune') {
  ok (Directory::Iterator->can($method), "can $method");
  ok ($obj->can($method), "can $method");
}

done_testing;



