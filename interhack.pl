#!/usr/bin/perl
use strict;
use lib 'lib';
use Term::ReadKey;
use LWP::Simple;
use File::Temp qw/tempfile/;

our $autologin = !grep {$_ eq "-l"} @ARGV;

# globals {{{
our $nick = '';
our $pass = '';
our $server = 'nethack.alt.org';
our $port = 23;
our %keymap;
our @colormap;
our @repmap;
our @krepmap;
our @annomap;
our @tabmap;
# }}}

# lexical variables {{{
our $responses_so_far = '';
our $response_this_play = 1;
our $tab = "\t";
our $me;
our $at_login = 0;
our $logged_in = 0;
our $postprint = '';
our $annotation_onscreen = 0;
our $stop_sing_pass = 0;
our $keystrokes = 0;
our $in_game = 0;
our $buf = '';
# }}}

sub make_annotation
{
    my ($matching, $annotation) = @_;
    if (!ref($matching))
    {
        push @repmap, sub { if (index($_, $matching) > -1) { annotate($annotation) } }
    }
    elsif (ref($matching) eq "Regexp")
    {
        push @repmap, sub { if (/$matching/) { annotate($annotation) } }
    }
    elsif (ref($matching) eq "CODE")
    {
        push @repmap, sub { if ($matching->()) { annotate($annotation) } }
    }
    else
    {
        die "Unable to make_annotation matching object of type " . ref($matching);
    }
}

sub make_anno
{
    make_annotation(@_);
}

sub recolor
{
    my ($matching, $newcolor) = @_;
    $newcolor = exists $colormap{$newcolor} ? $colormap{$newcolor} : die "Unable to discern the color described by \"$newcolor\"";

    if (!ref($matching))
    {
        push @repmap, sub { s/\Q$matching\E/$newcolor$&\e[0m/g }
    }
    elsif (ref($matching) eq "Regexp")
    {
        push @repmap, sub { s/$matching/$newcolor$&\e[0m/g }
    }
    else
    {
        die "Unable to recolor matching object of type " . ref($matching);
    }
}

sub make_tab
{
    my ($matching, $tabstring) = @_;
    if (!ref($matching))
    {
        push @repmap, sub { if (index($_, $matching) > -1) { tab($tabstring) } }
    }
    elsif (ref($matching) eq "Regexp")
    {
        push @repmap, sub { if (/$matching/) { tab($tabstring) } }
    }
    elsif (ref($matching) eq "CODE")
    {
        push @repmap, sub { if ($matching->()) { tab($tabstring) } }
    }
    else
    {
        die "Unable to make_tab matching object of type " . ref($matching);
    }
}

sub nick
{
    $nick = shift;
}

sub each_iteration(&;$)
{
    push @repmap, shift;
}

sub include
{
    my $module = shift;
    $module .= ".pl" unless $module =~ /\.p[lm]$/;
    my $file;

    if (-e "$ENV{HOME}/.interhack/modules/$module")
    {
        $file = "$ENV{HOME}/.interhack/modules/$module";
    }
    elsif (-e "modules/$module")
    {
        $file = "modules/$module";
    }
    else
    {
        die "Unable to find $module in $ENV{HOME}/.interhack/modules/$module or modules/$module";
    }

    do $file;
    die $@ if $@;
}

sub serialize_time # {{{
{
  my $seconds = shift;
  my $hours = int($seconds / 3600);
  $seconds %= 3600;
  my $minutes = int($seconds / 60);

  if ($hours > 9)
  {
    sprintf '%d:%02d', $hours, $minutes;
  }
  else
  {
    sprintf '%d:%02d:%02d', $hours, $minutes, $seconds % 60;
  }
} # }}}

sub annotate # {{{
{
  my $annotation = shift;
  $annotation_onscreen = 1;
  $postprint .= "\e[s\e[2H\e[1;30m$annotation\e[0m\e[u";
} # }}}

sub tab # {{{
{
  my $string = shift;
  my $msg = @_ ? shift : "Press tab to send the string: ";
  $tab = $string;
  $string =~ s/\n/\\n/g;
  annotate("$msg$string");
} # }}}

# load Interhack modules {{{
use Interhack::Config;
Interhack::Config::run();

use Interhack::Sock;
my $sock = Interhack::Sock::sock($server, $port);
# }}}

# autologin {{{
if ($autologin && $nick ne '')
{
  print {$sock} "l$nick\n";
  if ($pass ne '')
  {
    print {$sock} "$pass\n";
  }
} # }}}

# clear socket buffer (responses to telnet negotiation, name/pass echoes, etc
if ($server =~ /alt\.org/)
{
  until (defined(recv($sock, $_, 1024, 0)) && /zaphod\.alt\.org/) {}
}

ReadMode 3;
END { ReadMode 0 }
$|++;

#for (@repmap) { $_ = eval $_ }
for (@krepmap) { $_ = eval $_ }

ITER:
while (1)
{
  # read from stdin, print to sock {{{
  if (defined(my $c = ReadKey .05))
  {
    if ($c eq "p" && $logged_in) { $in_game = 1 }
    if ($c eq "\t" && $at_login && $logged_in)
    {
      print "\e[1;30mPlease wait while I download the existing rcfile.\e[0m";
      my $nethackrc = get("http://alt.org/nethack/rcfiles/$me.nethackrc");
      my ($fh, $name) = tempfile();
      print {$fh} $nethackrc;
      close $fh;
      my $t = (stat $name)[9];
      $ENV{EDITOR} = 'vi' unless exists $ENV{EDITOR};
      system("$ENV{EDITOR} $name");

      # file wasn't modified, so silently bail
      if ($t == (stat $name)[9])
      {
        print {$sock} ' ';
        next ITER;
      }

      $nethackrc = do { local (@ARGV, $/) = $name; <> };
      if ($nethackrc eq '')
      {
        print "\e[24H\e[1;30mYour nethackrc came out empty, so I'm bailing.--More--\e[0m";
        ReadKey 0;
      }
      else
      {
        print "\e[24H\e[1;30mPlease wait while I update the serverside rcfile.\e[0m";
        chomp $nethackrc;
        print {$sock} "o:0\n1000ddi";
        print {$sock} "$nethackrc\eg";
        until (defined(recv($sock, $_, 1024, 0)) && /\e\[.*?'g' is not implemented/) {}
        print {$sock} ":wq\n";
      }
    }

    if ($tab ne "\t")
    {
      ($responses_so_far, $response_this_play) = ('', 1)
        and next ITER
          if $c eq "'";

      $c = $tab if $c eq "\t";
      $tab = "\t";
      #$c .= chr(18); # refresh screen
    }
    elsif (exists $keymap{$c})
    {
      $c = $keymap{$c};
    }

    $keystrokes += length $c;

    foreach my $map (@krepmap)
    {
      local $_ = $c;
      $map->();
      $c = $_;
    }

    print {$sock} $c;
    print "\e[s\e[2H\e[K\e[u" if $annotation_onscreen;
    $at_login = 0;
    $annotation_onscreen = 0;
  } # }}}

  # read from sock, print to stdout {{{
  my $recv = recv($sock, $_, 1024, 0);
  next ITER if !defined($recv);
  last if length == 0;

  if ($recv =~ / \e (?: \[ [0-9;]* )?$/x)
  {
    $buf .= $recv;
  }

  if ($buf ne '')
  {
    $recv = $buf . $recv;
    $buf = '';
  }

  unless ($stop_sing_pass)
  {
    s/\Q$pass//g;
  }

  if (/\e\[1B ## Send mail to <dtype\@dtype.org> for details or a copy of the source code./)
  {
    $at_login = 1;
  }
  if (/Logged in as: (\w+)/)
  {
    $stop_sing_pass = 1;
    $at_login = 1;
    $logged_in = 1;
    $me = $1;
    $pass = '';
  }

  if ($at_login && $logged_in)
  {
    s/(o\) Edit option file)/$1  \e[1;30mTab) edit options locally\e[0m/g;
  }

  foreach my $map (@repmap)
  {
    $map->();
  }

  foreach my $annomap (@annomap)
  {
    annotate($annomap->[1])
      if $_ =~ $annomap->[0];
  }

  # make floating eyes bright cyan
  s{\e\[(?:0;)?34m((?:\x0f)?e)(?! - )}{\e[1;36m$1}g;

  # mastermind {{{
  if (/\e\[HYou hear (\d) tumblers? click and (\d) gears? turn\./)
  {
    $responses_so_far .= " $2$1";
    $response_this_play = 1;
  }
  elsif (/\e\[HYou hear (\d) tumblers? click\./)
  {
    $responses_so_far .= " 0$1";
    $response_this_play = 1;
  }
  elsif (/\e\[HYou hear (\d) gears? turn\./)
  {
    $responses_so_far .= " ${1}0";
    $response_this_play = 1;
  }
  elsif (/\e\[HWhat tune are you playing\?/)
  {
    $responses_so_far .= " 00" unless $response_this_play;
    $response_this_play = 0;
    my $next = `./c/automastermind $responses_so_far`;
    if ($next =~ 'ACK')
    {
      ($responses_so_far, $response_this_play) = ('', 1);
      annotate("No possible tunes. Resetting.");
    }
    else
    {
      ($next) = $next =~ /^([A-G]{5})/;
      tab("$next\n", "Press ' to reset, tab to send the string: ");
    }
  } # }}}

  for my $tabmap (@tabmap)
  {
    tab($tabmap->[1])
      if $_ =~ $tabmap->[0];
  }

  foreach my $map (@colormap)
  {
    s{$map->[0]}{$map->[1]$&\e[0m}g;
  }

  print;

  print $postprint and $postprint = ''
    if $postprint ne '';
  # }}}
}

print "You typed $keystrokes keystrokes in the game.\n";

