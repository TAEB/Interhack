#!/usr/bin/perl
use strict;
use warnings;
use Term::ReadKey;
use IO::Socket;

# CONFIG
my $nick = 'Interhack';
my $pass = 'kool'; # zomg!
my $killswitch = "\t"; # automatically kills the script, Just In Case
# END CONFIG

my $server = 'nethack.alt.org';

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

# autologin
print {$sock} "l$nick\n$pass\n";

ReadMode 3;
END { ReadMode 0 }
$|++;

my $buf;

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

while (1)
{
  # read from stdin, print to sock
  if (defined(my $c = ReadKey -1))
  {
    last if $c eq $killswitch;
    print {$sock} $c;
  }

  # read from sock, print to stdout
  if (defined(recv($sock, $buf, 1024, 0)))
  {
    # make floating eyes bright cyan
    $buf =~ s{\e\[(?:0;)?34me}{\e[0;36me}g;

    # display Xp needed for next level
    $buf =~ s{Xp:(\d+)\/(\d+)}{xp_str($1, $2)}eg;

    # highlight "high priest of Foo" except when Foo = Moloch
    $buf =~ s{high priest of (?!Moloch)\S+}{\e[1;31m$&\e[0m}g;

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

