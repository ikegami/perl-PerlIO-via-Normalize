#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 1;

use IO::Handle             qw( );
use PerlIO::via::Normalize qw( );


{
   pipe(my $R, my $W)
      or die("pipe: $!\n");
    
   $W->autoflush(1);
    
   binmode($W, ':encoding(UTF-8)')
      or die("binmode: $!\n");
    
   binmode($R, ':encoding(UTF-8):via(Normalize::NFC)')
      or die("binmode: $!\n");
        
   print($W 'x')
      or die("print: $!\n");
    
   {
      alarm(5);
      my $rv = read($R, my $buf='', 1);
print("foo\n");
      alarm(0);
   }

   close($W)
      or die("close: $!\n");

   {
      my $rv = read($R, my $buf='', 1);
print("bar\n");
   }
}


$TODO = 'Write tests to make sure module doesn\'t block excessively when reading from pipes';
fail('Pipe tests');

1;
