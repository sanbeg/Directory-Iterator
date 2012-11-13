use Test::More tests=>46;
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
  $list->show_dotfiles(1);

  my %save;
  for my $i (1 .. 4) {
    ok( $list->next, "got $i" );
    $save{ $list->get } = $i;
    like($list->get, qr:t/data/n:);
  }
  ok(not(defined($list->next)), "no more files");
  for my $i (1..3, '.dot') {
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
  is( keys(%save), 3, "Got 3 files from iterator" );
  for my $i (1..3) {
    ok( $save{ File::Spec->join('t','data','n',$i) }, "found $i" );
  }
};

do {
  my $list = Directory::Iterator::XS->new( File::Spec->join('t','data'));
  $list->show_directories(1);

  my $n_dirs;
  my %save;
  for my $i (1 .. 4) {
    ok( $list->next, "got $i" );
    $save{ $list->get } = $i;
    like($list->get, qr:t/data/n:);
	++ $n_dirs if $list->is_directory;
  }
  is ($n_dirs, 1, 'found 1 dir');
  ok(not(defined($list->next)), "no more files");
  for my $i (1..3) {
    ok( $save{ File::Spec->join('t','data','n',$i) }, "found $i" );
  }
    ok( $save{ File::Spec->join('t','data','n') }, "found n" );
};

do {
  my $list = Directory::Iterator::XS->new( File::Spec->join('t','data'));
  $list->show_directories(1);

  my $count=0;
  while ( $list->next ) {
	  ok ( $list->is_directory );
	  is ($list->prune_directory, File::Spec->join('t','data', 'n'), 'pruned right dir');
	  ++ $count;
  }
  is ($count, 1, 'found 1 file');
}


#done_testing;




