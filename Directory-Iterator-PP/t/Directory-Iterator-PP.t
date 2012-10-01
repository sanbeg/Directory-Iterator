use Test::More;
BEGIN { use_ok('Directory::Iterator::PP') };

my $list = Directory::Iterator::PP->new('t/data/n');

isa_ok($list, 'Directory::Iterator::PP');

my %save;
for my $i (1 .. 3) {
  ok( $list->next, "got $i" );
  $save{ $list->get } = $i;
}
ok(not(defined($list->next)), "no more files");
for my $i (1..3) {
  ok( $save{"t/data/n/$i"}, "found $i" );
}

done_testing;

