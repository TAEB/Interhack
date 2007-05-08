#!/usr/bin/perl
use strict;
use lib 'lib';
use Term::ReadKey;
use IO::Socket;

# CONFIG
our $nick = '';
our $pass = '';
our $server = 'nethack.alt.org';
# END CONFIG

our $autologin = !grep {$_ eq "-l"} @ARGV;
our %keymap;
our @colormap;

use Interhack::Config;
Interhack::Config::run();

my $sock = new IO::Socket::INET(PeerAddr => $server,
                                PeerPort => 23,
                                Proto => 'tcp');
die "Could not create socket: $!\n" unless $sock;
$sock->blocking(0);

my $IAC = chr(255);
my $SB = chr(250);
my $SE = chr(240);
my $WILL = chr(251);
my $WONT = chr(252);
my $DO = chr(253);
my $DONT = chr(254);
my $TTYPE = chr(24);
my $TSPEED = chr(32);
my $XDISPLOC = chr(35);
my $NEWENVIRON = chr(39);
my $IS = chr(0);
my $GOAHEAD = chr(3);
my $ECHO = chr(1);
my $NAWS = chr(31);
my $STATUS = chr(5);
my $LFLOW = chr(33);
my $LINEMODE = chr(34);

print {$sock}"$IAC$WILL$TTYPE"
            ."$IAC$SB$TTYPE${IS}xterm-color$IAC$SE"
            ."$IAC$WONT$TSPEED"
            ."$IAC$WONT$XDISPLOC"
            ."$IAC$WONT$NEWENVIRON"
            ."$IAC$DONT$GOAHEAD"
            ."$IAC$WILL$ECHO"
            ."$IAC$DO$STATUS"
            ."$IAC$WILL$LFLOW"
            ."$IAC$WILL$NAWS"
            ."$IAC$SB$NAWS$IS".chr(80).$IS.chr(24)."$IAC$SE";

my $last = "zaphod.alt.org";

# autologin
if ($autologin && $nick ne '')
{
  print {$sock} "l$nick\n";
  $last = $nick;
  if ($pass ne '')
  {
    print {$sock} "$pass\n";
    $last = $pass;
  }
}

ReadMode 3;
END { ReadMode 0 }
$|++;

my $buf;

# clear socket buffer (responses to telnet negotiation, name/pass echoes, etc
until (defined(recv($sock, $buf, 1024, 0)) && ($buf =~ $last)) {}

sub xp_str
{
  my ($level, $total_exp) = @_;
  my $length = length $total_exp;

  my $exp_needed = $level < 11 ? 10     * 2 ** $level
                 : $level < 21 ? 10_000 * 2 ** $level
                 : 10_000_000 * ($level - 19);

  $exp_needed -= $total_exp;


  if (length($exp_needed)-1 > $length)
  {
    return "Xp:$level!$total_exp";
  }
  else
  {
    $length++;
    return sprintf "X:%dn%-${length}s", $level, $exp_needed;
  }
}

sub hpmon
{
  my ($pre, $text, $cur, $max) = @_;
  my $color = '';

  # prayer point
  if ($cur * 7 <= $max || $cur <= 6)
  {
    $color = "\e[1;30m";
  }
  elsif ($cur >= $max) { }
  elsif ($cur * 2 >= $max)
  {
    $color = "\e[1;32m";
  }
  elsif ($cur * 3 >= $max)
  {
    $color = "\e[1;33m";
  }
  elsif ($cur * 4 >= $max)
  {
    $color = "\e[0;31m";
  }
  elsif ($cur * 5 >= $max)
  {
    $color = "\e[1;31m";
  }

  "$pre$color$text\e[0m"
}

my $responses_so_far = '';
my $response_this_play = 1;
my $tab = "\t";

ITER:
while (1)
{
  # read from stdin, print to sock
  if (defined(my $c = ReadKey -1))
  {
    if ($tab ne "\t")
    {
      ($responses_so_far, $response_this_play) = ('', 1)
        and next ITER
          if $c eq "'";

      $c = $tab if $c eq "\t";
      $tab = "\t";
      #$c .= chr(18); # refresh screen
      print "\e[s\e[2H\e[K\e[u";
    }
    elsif (exists $keymap{$c})
    {
      $c = $keymap{$c};
    }
    print {$sock} $c;
  }

  # read from sock, print to stdout
  if (defined(recv($sock, $buf, 1024, 0)))
  {
    study $buf;

    # make floating eyes bright cyan
    $buf =~ s{\e\[(?:0;)?34m((?:\x0f)?e)(?! - )}{\e[1;36m$1}g;

    if ($buf =~ /\e\[HYou hear (\d) tumblers? click and (\d) gears? turn\./)
    {
      $responses_so_far .= " $2$1";
      $response_this_play = 1;
    }
    elsif ($buf =~ /\e\[HYou hear (\d) tumblers? click\./)
    {
      $responses_so_far .= " 0$1";
      $response_this_play = 1;
    }
    elsif ($buf =~ /\e\[HYou hear (\d) gears? turn\./)
    {
      $responses_so_far .= " ${1}0";
      $response_this_play = 1;
    }
    elsif ($buf =~ /\e\[HWhat tune are you playing\?/)
    {
      $responses_so_far .= " 00" unless $response_this_play;
      $response_this_play = 0;
      my $next = `./automastermind $responses_so_far`;
      if ($next =~ 'ACK')
      {
        print "\e[s\e[2H\e[1;30mNo possible tunes. Resetting.\e[0m\e[u";
        ($responses_so_far, $response_this_play) = ('', 1);
        $tab = "";
      }
      else
      {
        ($next) = $next =~ /^([A-G]{5})/;
        print "\e[s\e[2H\e[1;30mPress ' to reset, tab to send the string: $next\\n\e[0m\e[u";
        $tab = "$next\n";
      }
    }

    foreach my $map (@colormap)
    {
      $buf =~ s{$map->[0]}{$map->[1]$&\e[0m}g;
    }

    # display Xp needed for next level
    $buf =~ s{Xp:(\d+)\/(\d+)}{xp_str($1, $2)}eg;

    # highlight "high priest of Foo" except when Foo = Moloch
    $buf =~ s{high priest of (?!Moloch)\S+}{\e[1;31m$&\e[0m}g;

    # HPmon done right
    $buf =~ s{(\e\[24;\d+H)((\d+)\((\d+)\))}{hpmon($1, $2, $3, $4)}eg;
    $buf =~ s{HP:((-?\d+)\((-?\d+)\))}{hpmon("HP:", $1, $2, $3)}eg;

    # power colors!
    $buf =~ s{Pw:((-?\d+)\((-?\d+)\))}{
      my $color = '';

      if ($2 >= $3) { }
      elsif ($2 * 2 >= $3)
      {
        $color = "\e[1;36m";
      }
      elsif ($2 * 3 >= $3)
      {
        $color = "\e[1;35m";
      }
      else
      {
        $color = "\e[0;35m";
      }

      "Pw:$color$1\e[0m"
      }eg;
    print $buf;
  }
}

