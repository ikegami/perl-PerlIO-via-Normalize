#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use PerlIO::via::Normalize qw( );


# In place
sub enhex { $_ = join '+', map sprintf('%04X', ord), split // for @_; }
sub dehex { $_ = join '', map chr hex, split /\+/ for @_; }


sub friendly_is($$;$) {
   my ($x, $y, $name) = @_;
   enhex($x) if defined($x);
   enhex($y) if defined($y);
   return Test::More::is($x, $y, $name);
}

BEGIN {
   no warnings 'redefine';
   *is = \&friendly_is;
}


sub read_test {
   my ($layer, $input) = @_;
   open(my $fh, "<:encoding(UTF-8):via(Normalize::$layer)", \$input)
      or die("open: $!\n");
   local $/;
   return <$fh>;
}


sub read_tests {
   my ($name, $input, $nfd, $nfc, $nfkd, $nfkc, $fcd, $fcc) = @_;
   utf8::encode($input);
   is(read_test('NFD',        $input), $nfd,  "$name NFD read test");
   is(read_test('NFC',        $input), $nfc,  "$name NFC read test");
   is(read_test('NFKD',       $input), $nfkd, "$name NFKD read test");
   is(read_test('NFKC',       $input), $nfkc, "$name NFKC read test");
   is(read_test('FCD',        $input), $fcd,  "$name FCD read test");
   is(read_test('FCC',        $input), $fcc,  "$name FCC read test");
   is(read_test('Decomposed', $input), $nfd,  "$name Decomposed read test");
   is(read_test('Composed',   $input), $nfc,  "$name Composed read test");
}


sub write_test {
   my ($layer, $input) = @_;
   my $got = '';
   open(my $fh, ">:encoding(UTF-8):via(Normalize::$layer)", \$got)
      or die("open: $!\n");
   print($fh $input)
      or die("print: $!\n");
   close($fh)
      or die("close: $!\n");
   return $got;
}


sub write_tests {
   my ($name, $input, $nfd, $nfc, $nfkd, $nfkc, $fcd, $fcc) = @_;
   utf8::encode($_) for $nfd, $nfc, $nfkd, $nfkc, $fcd, $fcc;
   is(write_test('NFD',        $input), $nfd,  "$name NFD write test");
   is(write_test('NFC',        $input), $nfc,  "$name NFC write test");
   is(write_test('NFKD',       $input), $nfkd, "$name NFKD write test");
   is(write_test('NFKC',       $input), $nfkc, "$name NFKC write test");
   is(write_test('FCD',        $input), $fcd,  "$name FCD write test");
   is(write_test('FCC',        $input), $fcc,  "$name FCC write test");
   is(write_test('Decomposed', $input), $nfd,  "$name Decomposed write test");
   is(write_test('Composed',   $input), $nfc,  "$name Composed write test");
}


my @tests = (
   # Test Name                 Input          NFD            NFC       NFKD           NFKC FCD            FCC
   # ------------------        -------------- -------------- --------- -------------- ---- -------------- --------------
   [ 'Decomposed input' => qw( 017F+0323+0307 017F+0323+0307 1E9B+0323 0073+0323+0307 1E69 017F+0323+0307 017F+0323+0307 )],
   [ 'Composed input'   => qw( 1E9B+0323      017F+0323+0307 1E9B+0323 0073+0323+0307 1E69 017F+0323+0307 017F+0323+0307 )],
   [ 'Singleton'        => qw( 212B           0041+030A      00C5      0041+030A      00C5 212B           00C5           )],
);

plan( tests => @tests * 2 * 8 );
for (@tests) {
   dehex(@$_[1..7]);
   read_tests(@$_);
   write_tests(@$_);
}

1;
