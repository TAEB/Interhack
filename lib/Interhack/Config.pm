#!/usr/bin/perl
package Interhack::Config;
use strict;
use warnings;


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
  elsif ($line =~ m#^s/# || $line =~ s/^eval\s+//)
  {
    push @main::repmap, "no strict; sub { $line }";
  }
  elsif ($line =~ s/^keval\s+//)
  {
    push @main::krepmap, "no strict; sub { $line }";
  }
  elsif ($line =~ /^annotate\s+(.)(.*?)\1\s*(.+)\s*/)
  {
    push @main::annomap, [qr/$2/ => $3];
  }
  elsif ($line =~ /^tab\s+(.)(.*?)\1\s*(.+)\s*/)
  {
    my ($regex, $tab) = (qr/$2/, $3);
    $tab =~ s/\\n/\n/g;
    push @main::tabmap, [$regex => $tab];
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

