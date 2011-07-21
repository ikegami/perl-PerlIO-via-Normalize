
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
      'Test::More' => 0,
   },
   requires => {
      'version' => 0,
      '~~~'     => 0,
   },
   add_to_cleanup => [ 'PerlIO-via-Normalize-*' ],
);

$build->create_build_script();
