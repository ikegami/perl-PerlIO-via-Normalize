#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 1;

BEGIN { require_ok( 'PerlIO::via::Normalize' ); }

diag( "Testing PerlIO::via::Normalize $PerlIO::via::Normalize::VERSION" );
diag( "Using Perl $]" );
