use Test::More tests=>32;
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
  #No options, explicit method calls
  my $list = MODULE->new( $test_dir->path );
  isa_ok($list, MODULE);

  my %save;
  my $prefix = quotemeta( $test_dir->path );

  for my $i (1 .. 4) {
    ok( $list->next, "got $i" );
    $save{ $list->get } = $i;
    like($list->get, qr/$prefix/, "File $i matched prefix");
  }
  ok(not(defined($list->next)), "no more files");
  for my $i (1..3) {
    ok( $save{ $test_dir->path($i) }, "found $i" );
  }
  ok( $save{ $test_dir->path('n2/4') }, "found 4" );
};

do {
  #default options, explicit method calls
  my $list = MODULE->new( $test_dir->path );
  $list->show_directories(0);
  $list->show_dotfiles(0);

  my %save;
  my $prefix = quotemeta( $test_dir->path );

  for my $i (1 .. 4) {
    ok( $list->next, "got $i" );
    $save{ $list->get } = $i;
    like($list->get, qr/$prefix/, "File $i matched prefix");
  }
  ok(not(defined($list->next)), "no more files");
  for my $i (1..3) {
    ok( $save{ $test_dir->path($i) }, "found $i" );
  }
  ok( $save{ $test_dir->path('n2/4') }, "found 4" );
};

do {
  #No options, overloaded operator
  my $list = MODULE->new( $test_dir->path );

  my %save;
  my $file;
  my $i1=0;
  while ($file = <$list>) {
    $save{ $file } = ++$i1;
  }
  is( keys(%save), 4, "Got 4 files from iterator" );
  for my $i (1..3) {
    ok( $save{ $test_dir->path($i) }, "found $i" );
  }
};


