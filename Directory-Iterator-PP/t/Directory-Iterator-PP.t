use Test::More tests=>14;
use File::Spec;

BEGIN { use_ok('Directory::Iterator::PP') };

do {
  my $list = Directory::Iterator::PP->new( File::Spec->join('t','data','n'));
  isa_ok($list, 'Directory::Iterator::PP');

  my %save;
  for my $i (1 .. 3) {
    ok( $list->next, "got $i" );
    $save{ $list->get } = $i;
  }
  ok(not(defined($list->next)), "no more files");
  for my $i (1..3) {
    ok( $save{ File::Spec->join('t','data','n',$i) }, "found $i" );
  }
};


do {
  my $list = Directory::Iterator::PP->new( File::Spec->join('t','data','n'));
  isa_ok($list, 'Directory::Iterator::PP');

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



