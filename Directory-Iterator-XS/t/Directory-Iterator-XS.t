# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Directory-Iterator-XS.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

#use Test;
use Test::More;
use File::Spec;

BEGIN { use_ok('Directory::Iterator::XS') };

do {
  my $list = Directory::Iterator::XS->new( File::Spec->join('t','data','n'));
  isa_ok($list, 'Directory::Iterator::XS');

  my %save;
  for my $i (1 .. 3) {
    ok( $list->next, "got $i" );
    $save{ $list->get } = $i;
    like($list->get, qr:t/data/n:);
  }
  ok(not(defined($list->next)), "no more files");
  for my $i (1..3) {
    ok( $save{ File::Spec->join('t','data','n',$i) }, "found $i" );
  }

};


do {

  my $list = Directory::Iterator::XS->new( File::Spec->join('t','data','n'));

  my %save;
  my $file;
  my $i1=0;
  while ($file = <$list>) {
    $save{ $file } = ++$i1;
  }
  is( keys(%save), 3, "Got 3 files" );
  for my $i (1..3) {
    ok( $save{ File::Spec->join('t','data','n',$i) }, "found $i" );
  }
};

done_testing;




