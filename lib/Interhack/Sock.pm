#!/usr/bin/env perl
package Interhack::Sock;
use strict;
use warnings;
use IO::Socket;

sub sock
{
  my ($server, $port) = @_;
  my $sock = new IO::Socket::INET(PeerAddr => $server,
                                  PeerPort => $port,
                                  Proto => 'tcp');
  die "Could not create socket: $!\n" unless $sock;
  $sock->blocking(0);
  $sock->autoflush(1);

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

  if ($server =~ /localhost/) { }
  elsif ($server =~ /noway\.ratry\.ru/)
  {
    print {$sock}"$IAC$DO$ECHO"
                ."$IAC$DO$GOAHEAD"
  }
  else
  {
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
  }
  return $sock;
}

1;

