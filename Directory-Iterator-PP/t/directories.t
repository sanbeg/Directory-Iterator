use Test::More tests=>23;
use strict;

use lib 't';
use BackendModule;

use lib '../../Test-Directory/lib';
use Test::Directory;

BEGIN { use_ok(MODULE) };

my $test_dir = Test::Directory->new( 't/data/n' );
$test_dir->mkdir('n2');
$test_dir->touch(1..3, '.dot', 'n2/4');


do {
  #show_directories, no prune
  my $list = MODULE->new( File::Spec->join('t','data'));
  $list->show_directories(1);

  my $n_dirs;
  my %save;
  my $prefix = quotemeta( $test_dir->path );

  for my $i (1 .. 6) {
    ok( $list->next, "got $i" );
    $save{ $list->get } = $i;
    like($list->get, qr/$prefix/, "File $i matched prefix");
    ++ $n_dirs if $list->is_directory;
  }
  is ($n_dirs, 2, 'found 2 dirs');
  ok(not(defined($list->next)), "no more files");
  for my $i (1..3) {
    ok( $save{ $test_dir->path($i) }, "found $i" );
  }
    ok( $save{ $test_dir->path }, "found n" );
};

do {
  #show_directories + prune_directory
  my $list = MODULE->new( $test_dir->path );
  $list->show_directories(1);

  my $count=0;
  while ( $list->next ) {
	  next unless $list->is_directory;
	  ok( $list->is_directory , "Is directory");
	  is ($list->prune_directory, $test_dir->path('n2'), 'pruned right dir');
	  ++ $count;
  }
  is ($count, 1, 'found 1 file');
};

do {
  #show_directories + prune
  my $list = MODULE->new( $test_dir->path );

  my $count=0;
  while ( $list->next ) {
    if ( $list->get eq $test_dir->path('n2/4')) {
      $list->prune;
      next;
    }
    ++ $count;
  }
  is ($count, 3, 'found 3 files after pruning');
};

