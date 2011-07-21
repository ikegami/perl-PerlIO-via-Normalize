
package PerlIO::via::Normalize::FCD;

use strict;
use warnings;

use version; our $VERSION = qv('v1.0.0');

use PerlIO::via::NormalizeRole qw( );
use Unicode::Normalize         qw( );

our @ISA = ();
push @ISA, qw( PerlIO::via::NormalizeRole );

use constant {
   IDX_READ_BUF  => 0,
   IDX_WRITE_BUF => 1,
   IDX_NEXT      => 2,
};

sub new {
   my ($class) = @_;
   my $self = bless([], $class);
   $self->[IDX_READ_BUF ] = undef;
   $self->[IDX_WRITE_BUF] = undef;
   return $self;
}

sub get_read_buf  { \( shift->[IDX_READ_BUF ] ) }
sub get_write_buf { \( shift->[IDX_WRITE_BUF] ) }

sub normalize {
   #my $self            =  $_[0];
   our $buf; local *buf = \$_[1];  # alias
   my $partial_ok       =  $_[2];
    
   $buf = Unicode::Normalize::FCD($buf);

   my $ready;
   if ($partial_ok) {
      ($ready, $buf) = Unicode::Normalize::splitOnLastStarter($buf);
   } else {
      $ready = $buf;
      $buf = '';
   }

   return $ready;
}

1;


__END__

~~~
