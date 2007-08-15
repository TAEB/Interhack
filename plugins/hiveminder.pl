# allows you to interact with Hiveminder's IM system with an extended command
# the extended command it adds is "#c", short for "create task".
# usage: "#c dingos should be yellow, not white"

# Hiveminder is an enterprise web 2.0 todo list tracker made by Eidolos'
# company, Best Practical. it's what he spends most of his time working on

# this plugin uses AIM to interact with Hiveminder. sign up an AIM account (or
# use an existing one.. better to get a new one though :)) and put the username
# and pass in ~/.interhack/aim. One-line only, separate the user and pass with
# a colon (so "screenname:password").

# make a Hiveminder account and go to http://hiveminder.com/prefs/im and follow
# the instructions to link your HM account with your IM SN

use strict;
use warnings;
use Net::OSCAR;

my $oscar;
my $msg;
my $error;
my $current;

sub extended_command;
extended_command "#c" => sub
{
    my ($command, $args) = @_;

    return "OSCAR previously had an error, refusing to try again." if $error;

    undef $msg;
    undef $error;

    eval
    {
        $SIG{ALRM} = sub { die "alarm\n" };
        alarm 10;

        if (!defined($oscar))
        {
            $current = "signing on";
            my $ret = init_oscar();
            $current = "checking \$ret";
            return "init_oscar error: $ret" if defined $ret;
            $current = "fi";
        }

        $current = "sending IM";
        $oscar->send_im("hmtasks", "create $args");
        $current = "sent IM";
        return "error: $error" if $error;
        return $msg if $msg;

        $current = "waiting for response";

        while (1)
        {
            $oscar->do_one_loop();

            return "error: $error" if $error;
            return $msg if $msg;
            return "interrupted" if defined ReadKey -1;
        }

        alarm 0;
    };
    alarm 0;

    if ($@)
    {
        return "timed out while $current" if $@ eq "alarm\n";
        return "perl-level error: $@";
    }
    if ($!)
    {
        return "system-level error: $!";
    }

    return "error: $error" if $error;
    return $msg if $msg;
    return "fell off the sub. current was: $current";
};

sub init_oscar
{
    $current = "signing on :: getting credentials";
    open my $aim, '<', "$ENV{HOME}/.interhack/aim" or return "unable to open $ENV{HOME}/.interhack/aim for reading: $!";
    my $credentials = <$aim>;
    chomp $credentials;

    my ($screenname, $password) = split ':', $credentials;
    return "bad credentials file, sn or pass missing"
        if $screenname eq '' || $password eq '';

    $current = "signing on :: initializing oscar";
    $oscar = Net::OSCAR->new();
    $oscar->loglevel(0);

    $current = "signing on :: error callback";
    $oscar->set_callback_error(sub {
        my ($self, $connecton, $errnum, $description, $fatal) = @_;

        $error = ($fatal ? 'fatal' : 'nonfatal') . " error: $description";
        undef $oscar;
    });

    $current = "signing on :: IM callback";
    $oscar->set_callback_im_in(sub {
        my ($self, $sender, $message, $is_away) = @_;

        $sender =~ s/\s+//g;
        $sender = lc $sender;

        if ($sender eq 'hmtasks')
        {
            $msg = $message;
            $msg =~ s/<.*?>//g;
        }
    });

    my $signedon = 0;

    $current = "signing on :: setting signon callback";
    $oscar->set_callback_signon_done( sub { $signedon = 1 } );

    $current = "signing on :: signon method";
    $oscar->signon(screenname => $screenname,
                   password   => $password);

    $current = "signing on :: waiting for callback";
    while (1)
    {
        $oscar->do_one_loop();
        return "error: $error" if $error;
        return $msg if $msg;
        return if $signedon;
        return "interrupted" if defined ReadKey -1;
    }

    return;
}

