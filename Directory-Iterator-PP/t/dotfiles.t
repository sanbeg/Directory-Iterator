use Test::More tests=>16;
use File::Spec;
use strict;

use lib 't';
use BackendModule;

use lib '../../Test-Directory/lib';
use Test::Directory;

BEGIN { use_ok(MODULE) };

my $test_dir = Test::Directory->new( 't/data/n' );
$test_dir->mkdir('n2');
$test_dir->touch(1..3, '.dot', 'n2/4');

#show_dotfiles
my $prefix = quotemeta( $test_dir->path );
my $list = MODULE->new( $test_dir->path );
$list->show_dotfiles(1);

my %save;
for my $i (1 .. 5) {
  ok( $list->next, "got $i" );
  $save{ $list->get } = $i;
  like($list->get, qr/$prefix/, "File $i matched prefix");
}
ok(not(defined($list->next)), "no more files");
for my $i (1..3, '.dot') {
  ok( $save{ $test_dir->path($i) }, "found $i" );
}

