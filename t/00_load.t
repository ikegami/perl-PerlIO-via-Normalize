#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 10;

BEGIN { require_ok( 'PerlIO::via::NormalizeRole'         ); }
BEGIN { require_ok( 'PerlIO::via::Normalize::NFD'        ); }
BEGIN { require_ok( 'PerlIO::via::Normalize::NFC'        ); }
BEGIN { require_ok( 'PerlIO::via::Normalize::NFKD'       ); }
BEGIN { require_ok( 'PerlIO::via::Normalize::NFKC'       ); }
BEGIN { require_ok( 'PerlIO::via::Normalize::FCD'        ); }
BEGIN { require_ok( 'PerlIO::via::Normalize::FCC'        ); }
BEGIN { require_ok( 'PerlIO::via::Normalize::Decomposed' ); }
BEGIN { require_ok( 'PerlIO::via::Normalize::Composed'   ); }
BEGIN { require_ok( 'PerlIO::via::Normalize'             ); }

diag( "Testing PerlIO::via::Normalize             $PerlIO::via::Normalize::VERSION"             );
diag( "Testing PerlIO::via::NormalizeRole         $PerlIO::via::NormalizeRole::VERSION"         );
diag( "Testing PerlIO::via::Normalize::NFD        $PerlIO::via::Normalize::NFD::VERSION"        );
diag( "Testing PerlIO::via::Normalize::NFC        $PerlIO::via::Normalize::NFC::VERSION"        );
diag( "Testing PerlIO::via::Normalize::NFKD       $PerlIO::via::Normalize::NFKD::VERSION"       );
diag( "Testing PerlIO::via::Normalize::NFKC       $PerlIO::via::Normalize::NFKC::VERSION"       );
diag( "Testing PerlIO::via::Normalize::FCD        $PerlIO::via::Normalize::FCD::VERSION"        );
diag( "Testing PerlIO::via::Normalize::FCC        $PerlIO::via::Normalize::FCC::VERSION"        );
diag( "Testing PerlIO::via::Normalize::Decomposed $PerlIO::via::Normalize::Decomposed::VERSION" );
diag( "Testing PerlIO::via::Normalize::Composed   $PerlIO::via::Normalize::Composed::VERSION"   );
diag( "Using Perl $]" );
diag( "Using Unicode::Normalize $Unicode::Normalize::VERSION" );

1;
