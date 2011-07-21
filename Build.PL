
use strict;
use warnings;

use Module::Build qw( );

my $build = Module::Build->new(
   module_name => 'PerlIO::via::Normalize',
   dist_author => 'Eric Brine <ikegami@adaelis.com>',
   license     => 'CC0_1_0',
   configure_requires => {
      'Module::Build'              => 0.36_14,
      'Software::License::CC0_1_0' => 0,
   },
   build_requires => {
      # For testing only
      # ----------------
      'Encode'               => 0,
      'IO::Handle'           => 0,
      #'Pod::Coverage'       => 0.18,      # Optional.
      'Test::More'           => 0,
      #'Test::Pod'           => 1.22,      # Optional.

      # For developer tests only
      # (Activated with env var DEVEL_TESTS)
      # ------------------------
      #'Test::Pod::Coverage' => 1.08,      # Optional.
   },
   requires => {
      'perl'               => 'v5.8.0',
      'Carp'               => 0,
      'constant'           => 1.03,
      'PerlIO::via'        => 0,
      'Unicode::Normalize' => 0,
      'version'            => 0,
   },
   add_to_cleanup => [ 'PerlIO-via-Normalize-*' ],
);

$build->create_build_script();
