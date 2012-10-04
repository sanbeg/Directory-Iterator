package Directory::Iterator;

use 5.006002;
use strict;
use warnings;

our @ISA;
our $VERSION = '1.000';

BEGIN {

    eval {
	require Directory::Iterator::XS;
	@ISA = 'Directory::Iterator::XS';
    };
    if ($@) {
	require Directory::Iterator::PP;
	@ISA = 'Directory::Iterator::PP';
    }
}


1;
__END__
=head1 NAME

Directory::Iterator - Simple, efficient recursive directory listing

=head1 SYNOPSIS

  use Directory::Iterator;

  my $it = Directory::Iterator->new($dir);
  while (my $file = <$it>) {
    print "$file\n";
  }

=head1 DESCRIPTION

This is a simple, efficient way to get a recursive list of all files under a
specified directory.

It implements a typical iterator interface, making it simple to convert code
that processes a list of files to use this instead.  The directory is read
as the list is consumed, so memory overhead is minimal.

This module simply loads the appropriate backend; either
L<Directory::Iterator::PP> or L<Directory::Iterator::XS>.  With the
pure-perl backend, the speed is equivalent to L<file::Find>; the XS backend
is a few times faster.

=head2 METHODS

=over

=item B<next>()

Advance to the next file and return its name; returns undef after all names
have been read.  This is the underlying method for the I<<>> operator.

=item B<get>()

Return the latest file name without advance to the next file; returns undef
after all names have been read.  This is the underlying method for the I<"">
operator.

=item B<prune>()

Close the directory that is currently being read, so no more files from it
will be returned.

=head2 EXPORT

None by default.



=head1 SEE ALSO

L<File::Find>

=head1 AUTHOR

Steve Sanbeg

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Steve Sanbeg

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
