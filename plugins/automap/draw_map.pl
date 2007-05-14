#!/usr/bin/perl
use strict;
use warnings;

while (<>)
{
  chomp;

  if ($. == 1 && /^\s*(\d+)\s*(\d+)\s*$/)
  {
    print "\e[$1;$2H";
    next;
  }

  my $length = length;
  s/(\.+)/"\e[".length($1).'C'/eg;
  print "$_\e[B\e[${length}D";
}

