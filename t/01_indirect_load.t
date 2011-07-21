#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use PerlIO::via::Normalize qw( );

my @normalizers = qw(
   NFD
   NFC
   NFKD
   NFKC
   FCD
   FCC
   Decomposed
   Composed
);

plan( tests => 0+@normalizers );

ok( $INC{"PerlIO/via/Normalize/$_.pm"}, "PerlIO::via::Normalize::$_ loaded via PerlIO::via::Normalize" )
   for @normalizers;

1;
