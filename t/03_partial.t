#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use IO::Handle             qw( );
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
   my ($name, $layer, $input, $read_sz, $expected) = @_;

   my $got = '';
   my @read_lens;

   open(my $fh, "<:encoding(UTF-8):via(Normalize::$layer)", \$input)
      or die("open: $!\n");
   
   for (;;) {
     my $rv = read($fh, $got, $read_sz, length($got));
     die("read: $!\n") if !defined($rv);
     push @read_lens, $rv;
     last if !$rv;
     $read_sz = 4096;
   }

   close($fh)
      or die("close: $!\n");

   is($got, $expected, $name)
      or diag("$name read sizes: @read_lens");
}


sub read_tests {
   my ($name, $input, $read_sz, $nfd, $nfc, $nfkd, $nfkc, $fcd, $fcc) = @_;
   utf8::encode($input);
   read_test( "Split $name character NFD read test",        'NFD',        $input, $read_sz, $nfd  );
   read_test( "Split $name character NFC read test",        'NFC',        $input, $read_sz, $nfc  );
   read_test( "Split $name character NFKD read test",       'NFKD',       $input, $read_sz, $nfkd );
   read_test( "Split $name character NFKC read test",       'NFKC',       $input, $read_sz, $nfkc );
   read_test( "Split $name character FCD read test",        'FCD',        $input, $read_sz, $fcd  );
   read_test( "Split $name character FCC read test",        'FCC',        $input, $read_sz, $fcc  );
   read_test( "Split $name character Decomposed read test", 'Decomposed', $input, $read_sz, $nfd  );
   read_test( "Split $name character Composed read test",   'Composed',   $input, $read_sz, $nfc  );
}


sub write_test {
   my ($name, $layer, $input, $write_sz, $expected) = @_;

   my $got = '';

   open(my $fh, ">:encoding(UTF-8):via(Normalize::$layer)", \$got)
      or die("open: $!\n");

   print($fh substr($input, 0, $write_sz))
      or die("print: $!\n");
   print($fh substr($input, $write_sz))
      or die("print: $!\n");

   close($fh)
      or die("close: $!\n");

   is($got, $expected, $name);
}


sub write_tests {
   my ($name, $input, $write_sz, $nfd, $nfc, $nfkd, $nfkc, $fcd, $fcc) = @_;
   utf8::encode($_) for $nfd, $nfc, $nfkd, $nfkc, $fcd, $fcc;
   write_test( "Split $name character NFD write test",        'NFD',        $input, $write_sz, $nfd  );
   write_test( "Split $name character NFC write test",        'NFC',        $input, $write_sz, $nfc  );
   write_test( "Split $name character NFKD write test",       'NFKD',       $input, $write_sz, $nfkd );
   write_test( "Split $name character NFKC write test",       'NFKC',       $input, $write_sz, $nfkc );
   write_test( "Split $name character FCD write test",        'FCD',        $input, $write_sz, $fcd  );
   write_test( "Split $name character FCC write test",        'FCC',        $input, $write_sz, $fcc  );
   write_test( "Split $name character Decomposed write test", 'Decomposed', $input, $write_sz, $nfd  );
   write_test( "Split $name character Composed write test",   'Composed',   $input, $write_sz, $nfc  );
}


my @tests = (
   # Test Name                   Input     Break after NFD            NFC       NFKD           NFKC      FCD            FCC 
   # --------------------        --------- ----------- -------------- --------- -------------- --------- -------------- --------- 
   [ 'starter-nonstarter' => qw( 1E0B+0323 1           0064+0323+0307 1E0D+0307 0064+0323+0307 1E0D+0307 0064+0323+0307 1E0D+0307 )],
   [ 'starter-starter'    => qw( 1100+1161 1           1100+1161      AC00      1100+1161      AC00      1100+1161      AC00      )],
);                                                                                                                

plan( tests => @tests * 2 * 8 );
for (@tests) {
   dehex(@$_[1,3..8]);
   read_tests(@$_);
   write_tests(@$_);
}

1;
