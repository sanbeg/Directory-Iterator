package Directory::Iterator::PP;

use strict;
use Carp;
use File::Spec;

sub new {
    my $class = shift;
    my $dir = shift;

    $dir =~ s:/$::;

    my %self = (file=>undef, dir=>$dir, dirs=>[]);
    opendir($self{dh},$dir) or croak "$dir: $!";
    bless \%self, $class;
}

sub get {
    my $self = shift;
    return $self->{file};
}

sub _scan {
    my $self = shift;
    while (my $de = readdir $self->{dh}) {
	if ($self->{show_dots}) {
	    next if ($de eq '.' or $de eq '..');
	} else {
	    next if ( $de =~ m/^\./ );
	}
	my $path = File::Spec->join("$self->{dir}", $de);
	if ( -d $path and ! -l _) {
	    push @{$self->{dirs}}, $path;
	}
	elsif ( -f _ ) {
	    return $self->{file} = $path;
	}
    }
    return undef;
}

sub next {
  my $self = shift;
  
  if ($self->{dh}) {
    my $rv = $self->_scan;
    if( defined $rv ) {
      return $rv;
    }
    else {
      $self->{dh} = undef;
    }
  }
  
  while ( @{ $self->{dirs} } ) {
    $self->{dir} = pop @{ $self->{dirs} };
    opendir( $self->{dh}, $self->{dir} ) or croak "$self->{dir}: $!";
    if ( $self->{dh} ) {
      my $rv = $self->_scan;
      return $rv if defined $rv; 
    }
  }
  return undef;
}

sub prune {
    my $self = shift;
    undef $self->{dh};
}

use overload '<>' => \&next, '""' => \&get;
1;

__END__

=head1 NAME

Directory::Iterator::PP - Recursively list file contents

=head1 SYNOPSIS

  use Directory::Iterator::PP

  my $list = Directory::Iterator::PP->new($directory);
  while ($list->next) {
    print $list->get, "\n";
  }

=head1 DESCRIPTION

The module creates a list-like generator to recursively list files in a
directory.  The directories are scanned as the list is consumed, so only the
one directory handle and a list of directories to scan are stored in memory.

=head2 METHODS

=over

=item B<new>(I<DIRECTORY>)

Create a new instance on the specified I<DIRECTORY>, which must be the name
of an existing directory.

=item B<next>

Advance to the next item.  Returns 1 if there is a next item, 0 otherwise.

=item B<get>

Get the current file (which must be set from a previous call to next).

=item B<prune>

Prune the current diretory, so no more files are read from it.  When
scanning the list of files, when you get a file from a directory that you
aren't interested in, calling I<prune> will close that directory, to prevent
spending time listing its contents.

=back


