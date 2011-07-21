#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use Encode                 qw( encode );
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
   my ($layer, $enc_layer, $input) = @_;
   open(my $fh, "<$enc_layer:via(Normalize::$layer)", \$input)
      or die("open: $!\n");
   local $/;
   return <$fh>;
}


sub read_tests {
   my ($input, $nfd, $nfc, $nfkd, $nfkc) = @_;
   $input = encode('iso-8859-1', $input);

   for (
      [ 'UTF8=1', ':encoding(iso-8859-1)' ],
      [ 'UTF8=0', ''                      ],
   ) {
      my ($name, $enc_layer) = @$_;

      is(read_test('NFD',        $enc_layer, $input), $nfd,  "$name NFD read test");
      is(read_test('NFC',        $enc_layer, $input), $nfc,  "$name NFC read test");
      is(read_test('NFKD',       $enc_layer, $input), $nfkd, "$name NFKD read test");
      is(read_test('NFKC',       $enc_layer, $input), $nfkc, "$name NFKC read test");
      is(read_test('Decomposed', $enc_layer, $input), $nfd,  "$name Decomposed read test");
      is(read_test('Composed',   $enc_layer, $input), $nfc,  "$name Composed read test");
   }
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
   my ($input, $nfd, $nfc, $nfkd, $nfkc) = @_;
   utf8::encode($_) for $nfd, $nfc, $nfkd, $nfkc;

   for (
      [ 'UTF8=1', \&utf8::upgrade   ],
      [ 'UTF8=0', \&utf8::downgrade ],
   ) {
      my ($name, $encoder) = @$_;

      $encoder->($input);

      is(write_test('NFD',        $input), $nfd,  "$name NFD write test");
      is(write_test('NFC',        $input), $nfc,  "$name NFC write test");
      is(write_test('NFKD',       $input), $nfkd, "$name NFKD write test");
      is(write_test('NFKC',       $input), $nfkc, "$name NFKC write test");
      is(write_test('Decomposed', $input), $nfd,  "$name Decomposed write test");
      is(write_test('Composed',   $input), $nfc,  "$name Composed write test");
   }
}


#              Input NFD       NFC  NFKD      NFKC
#              ----- --------- ---- --------- ----
my @test = qw( 00E9  0065+0301 00E9 0065+0301 00E9 );

plan( tests => 2 * 2 * 6 );
dehex(@test);
read_tests(@test);
write_tests(@test);

1;
