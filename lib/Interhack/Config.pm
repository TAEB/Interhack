#!/usr/bin/perl
package Interhack::Config;
use strict;
use warnings;

sub parse_config_line
{
  my ($line, $number) = @_;
  $line =~ s/\s*(?<!\\)#.*//;
  $line =~ s/^\s*//;
  return if $line eq '';

  $line =~ s/\\#/#/g;

  if ($line =~ /^map\s+(\S+)\s+(\S+)\s*$/i)
  {
    my ($trigger, $action) = ($1, $2);
    $action =~ s/\\n/\n/g;
    $main::keymap{$trigger} = $action;
  }
  elsif ($line =~ /^color\s+(\w+)\s+(.+)\s*$/i)
  {
    my ($regex, $color) = (eval("qr/$2/"), lc($1));

    $color = "\e[0;31m" if $color eq "red";
    $color = "\e[1;31m" if $color eq "bred";

    $color = "\e[0;32m" if $color eq "green";
    $color = "\e[1;32m" if $color eq "bgreen";

    $color = "\e[0;33m" if $color eq "brown";
    $color = "\e[1;33m" if $color eq "yellow";

    $color = "\e[0;34m" if $color eq "blue";
    $color = "\e[1;34m" if $color eq "bblue";

    $color = "\e[0;35m" if $color eq "magenta" || $color eq "purple";
    $color = "\e[1;35m" if $color eq "bmagenta" || $color eq "bpurple";

    $color = "\e[0;36m" if $color eq "cyan";
    $color = "\e[1;36m" if $color eq "bcyan";

    $color = "\e[0;37m" if $color eq "white";
    $color = "\e[1;37m" if $color eq "bwhite";

    push @main::colormap, [$regex => $color];
  }
  elsif ($line =~ /^nick\s+(\S+)\s*$/i)
  {
    $main::nick = $1;
  }
  else
  {
    die "Unable to parse line $number: $line\n";
  }
}

sub parse_config_file
{
}

sub run
{
  open my $handle, '<', "$ENV{HOME}/.interhack/config"
    or return;
  my $line_num = 0;

  while (my $line = <$handle>)
  {
    ++$line_num;
    while ($line =~ /\\$/)
    {
      chomp $line;
      chop $line;
      ++$line_num;
      $line .= <$handle>;
    }
    chomp $line;
    parse_config_line($line, $line_num);
  }
}

1;

