use Test::More tests=>5;

use lib '../Directory-Iterator-PP/blib/lib';
use lib '../Directory-Iterator-XS/blib/lib';
use lib '../Directory-Iterator-XS/blib/arch';
use Directory::Iterator;

is (@Directory::Iterator::ISA, 1, 'found parent');


my $obj = Directory::Iterator->new('t');

# isa_ok($obj, 'Directory::Iterator::XS');

foreach my $method ('get', 'next', 'prune', 'show_dotfiles') {
  ok ($obj->can($method), "can $method");
}


