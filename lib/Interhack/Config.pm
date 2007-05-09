#!/usr/bin/perl
package Interhack::Config;
use strict;
use warnings;

my %colormap =
(
  black          => "\e[0;30m",
  bblack         => "\e[1;30m",
  "bold&black"   => "\e[1;30m",
  "black&bold"   => "\e[1;30m",
  bblack         => "\e[1;30m",
  darkgray       => "\e[1;30m",
  darkgrey       => "\e[1;30m",

  red            => "\e[0;31m",
  bred           => "\e[1;31m",
  "bold&red"     => "\e[1;31m",
  "red&bold"     => "\e[1;31m",

  green          => "\e[0;32m",
  bgreen         => "\e[1;32m",
  "bold&green"   => "\e[1;32m",
  "green&bold"   => "\e[1;32m",

  brown          => "\e[0;33m",
  bbrown         => "\e[1;33m",
  "bold&brown"   => "\e[1;33m",
  "brown&bold"   => "\e[1;33m",
  yellow         => "\e[1;33m",
  darkyellow     => "\e[1;33m",

  blue           => "\e[0;34m",
  bblue          => "\e[1;34m",
  "bold&blue"    => "\e[1;34m",
  "blue&bold"    => "\e[1;34m",

  purple         => "\e[0;35m",
  bpurple        => "\e[1;35m",
  "bold&purple"  => "\e[1;35m",
  "purple&bold"  => "\e[1;35m",
  magenta        => "\e[0;35m",
  bmagenta       => "\e[1;35m",
  "bold&magenta" => "\e[1;35m",
  "magenta&bold" => "\e[1;35m",

  cyan           => "\e[0;36m",
  bcyan          => "\e[1;36m",
  "bold&cyan"    => "\e[1;36m",
  "cyan&bold"    => "\e[1;36m",

  white          => "\e[0;37m",
  bwhite         => "\e[1;37m",
  gray           => "\e[1;37m",
  grey           => "\e[1;37m",
  "bold&white"   => "\e[1;37m",
  "white&bold"   => "\e[1;37m",
);

sub parse_config_line
{
  my ($line, $number) = @_;
  $line =~ s/\s*(?<!\\)#.*// unless $line =~ /^MENUCOLOR/;
  $line =~ s/^\s*//;
  return if $line eq '';

  $line =~ s/\\#/#/g;

  if ($line =~ /^map\s+(\S+)\s+(\S+)\s*$/i)
  {
    my ($trigger, $action) = ($1, $2);
    $action =~ s/\\n/\n/g;
    $main::keymap{$trigger} = $action;
  }
  elsif ($line =~ m#^s/#)
  {
    push @main::repmap, sub { eval $line };
  }
  elsif ($line =~ /^color\s+([\w&]+)\s+(.+)\s*$/i)
  {
    my ($regex, $color) = (eval("qr/$2/"), lc($1));
    die "config line $number: Unable to parse color '$color'\n"
      unless exists $colormap{$color};

    push @main::colormap, [$regex => $colormap{$color}];
  }
  elsif ($line =~ /^MENUCOLOR\s*=\s*"(.+)"\s*=\s*([\w&]+)\s*(?:#.*)?$/)
  {
    my ($regex, $color) = ($1, lc($2));
    $regex =~ s/\\([()|])/$1/g;

    push @main::colormap, [eval("qr/$regex/") => $colormap{$color}];
  }
  elsif ($line =~ /^nick\s+(\w+)\s*$/i)
  {
    $main::nick = $1;
    if (-e "$ENV{HOME}/.interhack/$1")
    {
      $main::pass = do { local @ARGV = "$ENV{HOME}/.interhack/$1"; <> };
      chomp $main::pass;
    }
  }
  elsif ($main::pass eq '' && $line =~ /^pass\s+(\S+)\s*$/i)
  {
    $main::pass = $1;
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

