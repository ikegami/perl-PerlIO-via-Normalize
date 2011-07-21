
package PerlIO::via::NormalizeRole;

use strict;
use warnings;

use version; our $VERSION = qv('v1.0.0');


use Unicode::Normalize qw( );


sub PUSHED {
   my ($class, $mode, $super) = @_;
   my $self = $class->new();
   ${ $self->get_read_buf()  } = '';
   ${ $self->get_write_buf() } = '';
   return $self;
}


sub UTF8 { 1 }


sub FILL {
   my ($self, $fh) = @_;

   our $in_buf; local *in_buf = $self->get_read_buf();  # alias

   my $out_buf = '';
   for (;;) {
      # sysread does not work here.
      # Fortunately, read behaves like sysread here.
      my $rv = read($fh, $in_buf, 4096, length($in_buf));
      #return undef if !defined($rv);  # Perl5 RT 69332
      last if !$rv;
    
      $out_buf = $self->normalize($in_buf, 1);
      last if length($out_buf);
   }
    
   if (!length($out_buf)) {
      $out_buf = $self->normalize($in_buf, 0);
   }

   if (!length($out_buf)) {
      return undef;
   }

   utf8::encode($out_buf);
   return $out_buf;  # Bytes with UTF8=0
}


sub WRITE {
   my ($self, $buf, $fh) = @_;
   our $in_buf; local *in_buf = $self->get_write_buf();  # alias

   my $num_bytes = length($buf);

   utf8::decode($buf);
   $in_buf .= $buf;

   my $out_buf = $self->normalize($in_buf, 1);

   my $rv = print($fh $out_buf);
   return 0 if !$rv;
   return $num_bytes;
}


sub FLUSH {
   my ($self, $fh) = @_;

   our $read_buf;  local *read_buf  = $self->get_read_buf();   # alias
   our $write_buf; local *write_buf = $self->get_write_buf();  # alias

   my $error = 0;

   if (length($write_buf)) {
      print($fh $self->normalize($write_buf, 0))
         or $error = 1;
   }
    
   $read_buf  = '';
   $write_buf = '';
    
   return $error ? -1 : 0;
}


sub new           { my $class = shift;      require Carp; Carp::croak( "$class must implement method 'new'"           ); }
sub get_read_buf  { my $class = ref(shift); require Carp; Carp::croak( "$class must implement method 'get_read_buf'"  ); }
sub get_write_buf { my $class = ref(shift); require Carp; Carp::croak( "$class must implement method 'get_write_buf'" ); }
sub normalize     { my $class = ref(shift); require Carp; Carp::croak( "$class must implement method 'normalize'"     ); }


1;


__END__

=head1 NAME

PerlIO::via::NormalizeRole - Guts for performing Unicode normalization on file handles using PerlIO layers


=head1 VERSION

Version 1.0.0


=head1 SYNOPSIS

    package PerlIO::via::Normalize::Foo;

    use PerlIO::via::NormalizeRole;

    our @ISA = ( ... );
    push @ISA, qw( PerlIO::via::NormalizeRole );

    sub new {
       my ($class) = @_;
       return bless(..., $class);
    }

    sub get_read_buf  { \( shift->... ) }
    sub get_write_buf { \( shift->... ) }

    sub normalize {
       my $self             =  $_[0]
       our $buf; local *buf = \$_[1];  # alias

       ... normalize $buf in-place ...
    }

    ...

    1;


=head1 DESCRIPTION

This module implements a PerlIO layer that provides Unicode normalization
to data read from file handles and written to file handles. The actual
normalization is done with the help of other modules. These modules are:

=over

=item L<PerlIO::via::Normalize::NFD> for Canonical Decomposition form

=item L<PerlIO::via::Normalize::NFC> for Canonical Composition form

=item L<PerlIO::via::Normalize::NFKD> for Compatibility Decomposition form

=item L<PerlIO::via::Normalize::NFKC> for Compatibility Composition form

=item L<PerlIO::via::Normalize::FCD> for Fast C or D form

=item L<PerlIO::via::Normalize::FCC> for Fast C Contiguous form

=item L<PerlIO::via::Normalize::Decomposed> for Canonical Decomposition form

=item L<PerlIO::via::Normalize::Composed> for Canonical Composition form

=back


This layer instructs Perl to push a C<:utf8> layer above itself.
This means that this layer produces decoded text from input handles
and expects decoded text for output handles.

NormalizeRole is a role, meaning it provides an interface and functionality,
and expects certain commitments on the part of the object providing the
interface.

~~~ clean up above


=head2 Functionality Provided by the Role



=head2 Commitments from the Role

=head3 Any or all method listed in L<PerlIO::via>

The role provides all necessary methods to fulfill L<PerlIO::via>'s requirements.
Specifically, it provides the following methods:

=over

=item C<< $class->PUSHED($mode, $fh) >>

=item C<< $self->UTF8($belowFlag, $fh) >>

=item C<< $self->READ($buffer, $len, $fh) >>

=item C<< $self->WRITE($buffer, $fh) >>

=back


=head2 Commitments from the Role Implementor

The class implementing the PerlIO::via::NormalizeRole must import the
methods produced by NormalizeRole, as listed above. This is done most
easily using C<@ISA> as shown in the L</Synopsis> of this document.

The implementor must also commit to provide the following methods.


=head3 C<< my $obj = $class->new() >>

Must return an object which implements this role.


=head3 C<< my $buf_ref = $self->get_read_buf() >>

Must return a reference to a scalar. A given instance of the
implementor must always return a reference to the same scalar.

This scalar will be used to hold partially read characters.
It doesn't need to be initialized.


=head3 C<< my $buf_ref = $self->get_write_buf() >>

Must return a reference to a scalar. A given instance of the
implementor must always return a reference to the same scalar.

This scalar will be used to hold partially written characters.
It doesn't need to be initialized.


=head3 C<< $self->normalize($buf, $partial_ok) >>

This method is given a sequence of Unicode characters in C<$buf>.
It must normalize the characters as desired, and then return the
result in-place.

NormalizeRole ensures this method always gets all the combining
marks that applies to the last character.

~~~[ $partial_ok isn't documented. Make sure previous paragraph is still correct. ]~~~


=head1 EXPORTS

None.


=head1 SEE ALSO

=head2 The other modules of this distribution

=over

=item L<PerlIO::via::Normalize>, a convenient way of loading all the modules in this distribution.

=item L<PerlIO::via::Normalize::NFD>, a PerlIO::via layer that transform to NFD.

=item L<PerlIO::via::Normalize::NFC>, a PerlIO::via layer that transform to NFC.

=item L<PerlIO::via::Normalize::NFKD>, a PerlIO::via layer that transform to NFKD.

=item L<PerlIO::via::Normalize::NFKC>, a PerlIO::via layer that transform to NFKC.

=item L<PerlIO::via::Normalize::FCD>, a PerlIO::via layer that transform to FCD form.

=item L<PerlIO::via::Normalize::FCC>, a PerlIO::via layer that transform to FCC form.

=item L<PerlIO::via::Normalize::Decomposed>, a PerlIO::via layer that transform to NFD.

=item L<PerlIO::via::Normalize::Composed>, a PerlIO::via layer that transform to NFC

=back


=head2 The modules on which this distribution relies

=over

=item L<Unicode::Normalize>

=item L<PerlIO::via>

=back


=head1 BUGS

Please report any bugs or feature requests to C<bug-perlio-via-normalize at rt.cpan.org>,
or through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=PerlIO-via-Normalize>.
I will be notified, and then you'll automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc PerlIO::via::Normalize

You can also look for information at:

=over

=item * Search CPAN

L<http://search.cpan.org/dist/PerlIO-via-Normalize>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=PerlIO-via-Normalize>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/PerlIO-via-Normalize>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/PerlIO-via-Normalize>

=back


=head1 AUTHOR

Eric Brine, C<< <ikegami@adaelis.com> >>


=head1 COPYRIGHT & LICENSE

No rights reserved.

The author has dedicated the work to the Commons by waiving all of his
or her rights to the work worldwide under copyright law and all related or
neighboring legal rights he or she had in the work, to the extent allowable by
law.

Works under CC0 do not require attribution. When citing the work, you should
not imply endorsement by the author.


=cut
