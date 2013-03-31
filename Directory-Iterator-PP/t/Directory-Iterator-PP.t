use Test::More tests=>44;
use File::Spec;
use strict;

sub MODULE() {'Directory::Iterator::PP'};
BEGIN { use_ok(MODULE) };

do {
  #No options, explicit method calls
  my $list = MODULE->new( File::Spec->join('t','data','n'));
  isa_ok($list, MODULE);

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
  #No options, overloaded operator
  my $list = MODULE->new( File::Spec->join('t','data','n'));

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
  #show_dotfiles
  my $list = MODULE->new( File::Spec->join('t','data','n'));
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
  #show_directories, no prune
  my $list = MODULE->new( File::Spec->join('t','data'));
  $list->show_directories(1);

  my $n_dirs;
  my %save;

  my $prefix = quotemeta(File::Spec->join('t','data','n'));
  for my $i (1 .. 4) {
    ok( $list->next, "got $i" );
    $save{ $list->get } = $i;
    like($list->get, qr/$prefix/);
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
  #show_directories + prune
  my $list = MODULE->new( File::Spec->join('t','data'));
  $list->show_directories(1);

  my $count=0;
  while ( $list->next ) {
	  ok ( $list->is_directory );
	  is ($list->prune_directory, File::Spec->join('t','data', 'n'), 'pruned right dir');
	  ++ $count;
  }
  is ($count, 1, 'found 1 file');
};

