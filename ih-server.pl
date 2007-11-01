#!/usr/bin/perl
use strict;
use warnings;
use IO::Pty::Easy;
use IO::Socket::INET;
use Time::HiRes 'sleep';

# XXX THIS IS ONE HUGE HACK.

# this is a server that acts much like Interhack. it acts as a filter between a socket and a pseudo-tty. in essence, you do the following:

# start the server: ./ih-server.pl
# change interhack.pl's default server from nao to ih_server:
# the line looks like the following:
# our $server = $servers{nao};
# change it to
# our $server = $servers{ih_server};

# then run interhack: ./interhack.pl

# it'll open up a new shell where you can ssh nethack.devnull.net or whatever

my $port = 9999;

my $socket = IO::Socket::INET->new(
    LocalPort => $port,
    Type      => SOCK_STREAM,
    Listen    => 5,
    ReuseAddr => 1,
    Proto     => 'tcp',
) or die $!;

warn "Waiting for a connection on port $port.";
$socket = $socket->accept;
warn "A client has connected.";

$socket->blocking(0);
$socket->autoflush(1);

my $pty = IO::Pty::Easy->new;
$pty->spawn($ENV{SHELL} || 'bash');

while (1) {
    sleep 0.03;

    my $input = read_socket();
    if (defined $input) {
        my $chars = $pty->write($input, 0);
        die "Unable to write to pty." if (defined $chars) && $chars == 0;
    }

    my $output = $pty->read(0);
    if (defined $output) {
        die "Unable to read from pty." if $output eq '';
        print_socket($output);
    }
}

sub print_socket # {{{
{
    my $txt = shift;
    $socket->print($txt);
} # }}}
sub read_socket # {{{
{
    return
        unless defined(recv($socket, $_, 4096, 0));

    die "The connection has closed."
        unless length;

    return $_;
} # }}}

