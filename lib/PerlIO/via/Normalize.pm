
package PerlIO::via::Normalize;

use strict;
use warnings;

use version; our $VERSION = qv('v1.0.0');

use PerlIO::via::Normalize::NFD        qw( );
use PerlIO::via::Normalize::NFC        qw( );
use PerlIO::via::Normalize::NFKD       qw( );
use PerlIO::via::Normalize::NFKC       qw( );
use PerlIO::via::Normalize::FCD        qw( );
use PerlIO::via::Normalize::FCC        qw( );
use PerlIO::via::Normalize::Decomposed qw( );
use PerlIO::via::Normalize::Composed   qw( );

1;


__END__

=head1 NAME

PerlIO::via::Normalize - Perform Unicode normalization on file handles using PerlIO layers


=head1 VERSION

Version 1.0.0


=head1 SYNOPSIS

    use PerlIO::via::Normalize;

    open(my $in_fh, '<:encoding(UTF-8):via(Normalize::NFD)', $in_qfn)
       or die("Can't open input file $in_qfn: $!\n");

    open(my $out_fh, '>:encoding(UTF-8):via(Normalize::NFC)', $out_qfn)
       or die("Can't create output file $out_qfn: $!\n");

    binmode $fh, ':encoding(UTF-16le):via(Normalize::NFC)';


=head1 DESCRIPTION

This module simply loads a number of modules for your convenience.
They are:

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

This makes C<use PerlIO::via::Normalize;> sufficient to use any of the above modules
using C<:via(Normalize::I<FORM>)> or C<:via(PerlIO::via::Normalize::I<FORM>)>.


=head1 EXPORTS

None.


=head1 SEE ALSO

=head2 The other modules of this distribution

=over

=item L<PerlIO::via::NormalizeRole>, which implements the guts of the modules of this distribution.

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

Please report any bugs or feature requests to C<bug-PerlIO-via-Normalize at rt.cpan.org>,
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
