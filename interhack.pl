#!/usr/bin/env perl
use strict;
use lib 'lib';
use Term::ReadKey;
use LWP::Simple;
use File::Temp qw/tempfile/;
use Term::VT102;
use Time::HiRes qw/gettimeofday ualarm/;

# globals {{{
our %servers = (
    ih_server => { server => 'localhost',
                   port   => 9999,
                   name   => 'ih_server',
                   type   => 'ih-server',
                 },
    nao =>       { server => 'nethack.alt.org',
                   port   => 23,
                   name   => 'nao',
                   type   => 'dgl',
                   rc_file => sub { "http://alt.org/nethack/userdata/$_[0]/$_[0].nh343rc" },
                   dgl_line1 => ' nethack.alt.org - http://nethack.alt.org/',
                   dgl_line2 => '',
                 },
    sporkhack => { server => 'sporkhack.nineball.org',
                   port   => 23,
                   name   => 'sporkhack',
                   type   => 'dgl',
                   rc_file => sub { "http://nethack.nineball.org/rcfiles/$_[0].nethackrc" },
                   dgl_line1 => ' Games on this server are recorded for in-progress viewing and playback!',
                   dgl_line2 => '',
                 },
    noway     => { server => 'noway.ratry.ru',
                   port   => 37331,
                   name   => 'noway',
                   type   => 'termcast',
                   rc_file => '',
                 },
);
our $nick = '';
our $pass = '';
our $server = $servers{nao};
our $autologin = 1;
our $ttp;
our $ttyrec;
our $paused = 0;
our $anno_frames = 0;
our %keymap;
our %keyonce;
our @key_queue;
our @lastkeys;
our $lastkeysmaxlen = 100;
our @configmap;
our @colormap;
our @postmap;
our @configonce;
our @coloronce;
our @postonce;
our %extended_command;
our %plugin_loaded;
our $vt = Term::VT102->new(cols => 80, rows => 24);
our @mINC = ("$ENV{HOME}/.interhack/plugins", "plugins");
our $write_normal_ttyrec = 0;
our $write_interhack_ttyrec = 0;
our $write_keys = 1;
our $normal_ttyrec_name = '';
our $interhack_ttyrec_name = '';
our $key_name = '';
our ($normal_handle, $interhack_handle, $keys_handle);
# colormap {{{
our %colormap =
(
  nhblack        => "\e[1;30m", # override to "\e[1;30m" if you want!
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
  orange         => "\e[1;31m",

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
  gray           => "\e[0;37m",
  grey           => "\e[0;37m",
  "bold&white"   => "\e[1;37m",
  "white&bold"   => "\e[1;37m",
);
# }}}
our $tab = "\t";
our $me;
our $at_login = 0;
our $logged_in = 0;
our $postprint = '';
our $annotation_onscreen = 0;
our $stop_sing_pass = 0;
our $keystrokes = 0;
our %intrinsics;
our $in_game = 0;
our $buf = '';
our $topline = '';
our $resting = 0;
our ($curhp, $maxhp, $curpw, $maxpw) = (0, 0, 0, 0);
our $vikeys = 0;
our $show_sl = 0;
our $show_bl = 0;
our $termcast_name = '';
our $termcast_pass = '';
# }}}

# subroutines {{{
sub nick # {{{
{
    $nick = shift;
} # }}}
sub pass # {{{
{
    $pass = shift;
} # }}}
sub server # {{{
{
    my $new_server = shift;
    $server = $servers{$new_server};
} # }}}
sub include # {{{
{
    my @modules = @_;

    if ($modules[0] eq "*")
    {
        for (map {sort <$_/*.p[lm]>} @mINC)
        {
            my ($file) = m{^.*/([^/]+)$};
            next if exists $plugin_loaded{$file};
            $plugin_loaded{$file} = 1;
            do $_;
            die $@ if $@;
        }
        return;
    }

    MODULE: for my $module (@modules)
    {
        $module .= ".pl" unless $module =~ /\.p[lm]$/;
        my $file;

        INC: for (@mINC)
        {
            if (-e "$_/$module")
            {
                $file = "$_/$module";
                last INC;
            }
        }

        if (!defined($file))
        {
            die "Unable to find $module in @mINC";
        }

        next MODULE if exists $plugin_loaded{$module};
        $plugin_loaded{$module} = 1;
        do $file;
        die $@ if $@;
    }
} # }}}
sub exclude # {{{
{
    for (@_)
    {
        my $module = $_;
        $module .= ".pl" unless $module =~ /\.p[lm]$/;
        $plugin_loaded{$module} = 0; # include checks for existence, not truth
    }
} # }}}

{ # request_redraw {{{
    my $lexisock;
    sub request_redraw # {{{
    {
        print {$lexisock} chr(18);
    } # }}}
    sub print_sock # {{{
    {
        print {$lexisock} @_;
    } # }}}
    sub set_lexisock # {{{
    {
        $lexisock = shift;
    } # }}}
} # }}}

sub each_iteration(&;$) # {{{
{
    push @configmap, shift;
} # }}}

sub splitline # {{{
{
  # @lines = splitline($longline, $length);
  my $line   = shift;
  my $length = shift || 70;

  my $chop;
  my @lines;

  $line =~ s/\n+/' ' x $length/eg;
  while (length($line) > $length)
  {
    # Here we just need the effects of the capturing parentheses.
    # We break at the last space possible. If no space, then at $length
    # characters. I could've put ($chop, $line).. in each brace pair, but better
    # to have it just once.

       if ($line =~ /^(.{1,$length}) +(.*)$/os) { }
    elsif ($line =~ /^(.{$length})(.*)$/os)     { }

    ($chop, $line) = ($1, $2);

    # remove any trailing or leading whitespace
    $chop =~ s/^ +//;
    $line =~ s/^ +//;
    $chop =~ s/ +$//;
    $line =~ s/ +$//;

    push @lines, $chop;
  }

  push @lines, $line unless $line =~ /^\s*$/;
  return @lines;
} # }}}
sub pline # {{{
{
    my $text = shift;
    my @lines = splitline($text);
    print_ih_ttyrec("\e7");
    print "\e7";

    while (@lines > 1)
    {
       my $line = shift @lines;
       print_ih_ttyrec("\e[H$line--More--\e[K");
       print "\e[H$line--More--\e[K";
       my $c = ReadKey 0;
       last if $c eq "\e";
    }

    print_ih_ttyrec("\e8");
    print "\e8";
    return $lines[0];
} # }}}
sub show_menu # {{{
{
    my ($regex, $items) = @_;

    each_iteration
    {
        if ($vt->row_plaintext(1) =~ $regex)
        {
            my $longest_length = 0;
            for (values %$items)
            {
                $longest_length = length if length > $longest_length;
            }
            $longest_length++; # extra space at the end

            $postprint .= "\e7\e[1;30m\e[2H";
            for my $k (sort keys %$items)
            {
                my $v = value_of($items->{$k});
                $postprint .= sprintf " %s - %-${longest_length}s\n", $k, $v;
                $v =~ s/\s*#.*//; # remove any comments (for marker charges, eg)
                $keyonce{$k} = $v;
            }
            chomp $postprint; # to fit another item on the menu
            $postprint .= "\e[m\e8";
        }
    }
} # }}}

sub extended_command # {{{
{
    my ($cmd, $result) = @_;
    $cmd =~ s/^#//;
    $extended_command{$cmd} = $result;
} # }}}
sub remap # {{{
{
    my ($key, $result) = @_;
    $keymap{$key} = $result;
} # }}}
sub unmap # {{{
{
    my $key = shift;
    delete $keymap{$key};
} # }}}
sub value_of # {{{
{
    my ($exp, @args) = @_;
    return $exp unless ref($exp);
    return $exp->(@args) if ref($exp) eq "CODE";
    return $exp;
} # }}}

sub each_match # {{{
{
    my $push_to = \@configmap;
    $push_to = shift if ref($_[0]) eq 'ARRAY';

    my $matching = shift;
    my $action = shift;
    my @args = @_;

    if (!ref($matching))
    {
        push @{$push_to}, sub { if (index($topline, $matching) > -1) { $action->(@args)} }
    }
    elsif (ref($matching) eq "Regexp")
    {
        push @{$push_to}, sub { if ($topline =~ $matching) { $action->(@args) } }
    }
    elsif (ref($matching) eq "CODE")
    {
        push @{$push_to}, sub { if ($matching->()) { $action->(@args) } }
    }
    else
    {
        die "Unable to each_match matching object of type " . ref($matching);
    }
} # }}}
sub each_match_row # {{{
{
    my $row = shift;
    return each_match(@_) if $row == 1;

    my $matching = shift;
    my $action = shift;
    my @args = @_;

    if (!ref($matching))
    {
        push @configmap, sub { if (index($vt->row_plaintext($row), $matching) > -1) { $action->(@args)} }
    }
    elsif (ref($matching) eq "Regexp")
    {
        push @configmap, sub { if ($vt->row_plaintext($row) =~ $matching) { $action->(@args) } }
    }
    elsif (ref($matching) eq "CODE")
    {
        push @configmap, sub { if ($matching->()) { $action->(@args) } }
    }
    else
    {
        die "Unable to each_match_row matching object of type " . ref($matching);
    }
} # }}}

sub make_annotation # {{{
{
    my ($matching, $annotation) = @_;
    each_match $matching => sub { annotate($annotation) };
} # }}}
sub annotate # {{{
{
  return unless $show_sl && $show_bl;
  my $annotation = value_of(shift);
  return if $annotation eq '';
  $annotation_onscreen = 1;
  $anno_frames = 5;
  $postprint .= "\e7\e[2H\e[1;30m$annotation\e[0m\e[K\e8";
} # }}}
sub clear_annotation # {{{
{
    if ($annotation_onscreen)
    {
        local $_ = "\e7\e[2H\e[K\e8";
        print_ih_ttyrec($_);
        print;
    }
    $annotation_onscreen = 0;
} # }}}

sub make_tab # {{{
{
    my ($matching, $tabstring) = @_;
    each_match $matching => sub { tab($tabstring) };
} # }}}
sub tab # {{{
{
  return unless $show_sl && $show_bl;
  my $display = value_of(shift);
  return if $display eq '';
  $tab = $display;
  return if @_;
  $display =~ s/\n/\\n/g;
  $display =~ s/\e/\\e/g;
  annotate("Press tab to send the string: $display");
} # }}}

sub force_yn # {{{
{
    return if defined $ttyrec;
    my $msg = shift;
    my $c;

    annotate("\e[1;31m$msg [yn] ");
    print_ih_ttyrec($postprint);
    print $postprint;
    $postprint = '';

    while (1)
    {
        ReadKey(0);
        last if $c eq 'y' || $c eq 'Y' || $c eq 'n' || $c eq 'N';
    }

    clear_annotation();
    return $c eq 'y' || $c eq 'Y' ? 1 : 0;
} # }}}
sub force_tab # {{{
{
    return if defined $ttyrec;
    my $message = shift;
    my $timeout = shift;
    $message .= " " if defined($message);
    annotate("\e[1;31m" . $message . "Press tab to continue!");
    print_ih_ttyrec($postprint);
    print $postprint;
    $postprint = '';

    eval
    {
        # we don't want the tab to stay onscreen for too long
        # this is a problem when watching others
        # so fix this eventually when we get better "am I playing?" detection

        local $SIG{ALRM} = sub { die "alarm\n" };
        if (defined($timeout))
        {
            ualarm $timeout * 1_000_000;
        }
        else
        {
            alarm 10;
        }

        1 until ReadKey(0) eq "\t";
        alarm 0;
    };

    clear_annotation();
} # }}}
sub force_tab_yn # {{{
{
    return if defined $ttyrec;
    my $message = shift;
    $message .= " " if defined($message);
    annotate("\e[1;31m" . $message);
    print_ih_ttyrec($postprint);
    print $postprint;
    $postprint = '';
    my $c;

    eval
    {
        # we don't want the tab to stay onscreen for too long
        # this is a problem when watching others
        # so fix this eventually when we get better "am I playing?" detection

        local $SIG{ALRM} = sub { die "alarm\n" };
        alarm 10;
        $c = ReadKey(0);
        alarm 0;
    };

    clear_annotation();

    if ($c eq "\t")
    {
        return 1;
    }
    return 0;
} # }}}
sub press_tab # {{{
{
    my ($matching, $tabtext, $timeout) = @_;
    each_match \@postmap, $matching => sub { force_tab($tabtext, $timeout) };
} # }}}

sub alphakeys # {{{
{
    my $num = shift;
    if ($num < 0)
    {
        for (my $i = -1; abs($i) <= @lastkeys; --$i)
        {
            local $_ = $lastkeys[$i];
            next unless /\w/;
            return $_ if ++$num >= 0;
        }
    }
    else
    {
        for (@lastkeys)
        {
            next unless /\w/;
            return $_ if --$num < 0;
        }
    }

    return;
} # }}}
sub recolor # {{{
{
    my $matching = shift;
    my $newcolor = shift;
    $newcolor = exists $colormap{$newcolor} ? $colormap{$newcolor} : $newcolor
      unless ref($newcolor) eq 'CODE';

    if (!ref($matching))
    {
        if (!ref($newcolor))
        {
          push @colormap, sub { s/\Q$matching\E/$newcolor$&\e[0m/g }
        }
        else
        {
          push @colormap, sub { s/\Q$matching\E/my $c = $newcolor->(); $c ? "$c$&\e[0m" : $&/eg }
        }
    }
    elsif (ref($matching) eq "Regexp")
    {
        if (!ref($newcolor))
        {
          push @colormap, sub { s/$matching/$newcolor$&\e[0m/g }
        }
        else
        {
          push @colormap, sub { s/$matching/my $c = $newcolor->(); $c ? "$c$&\e[0m" : $&/eg }
        }
    }
    else
    {
        die "Unable to recolor matching object of type " . ref($matching);
    }
} # }}}

sub serialize_time # {{{
{
  my $seconds = int(shift);
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
sub timestamp #{{{
{
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$dst) = localtime();
    $year += 1900;
    $mon++;
    my $d = sprintf("%4d%2.2d%2.2d-", $year, $mon, $mday);
    my $t = sprintf("%2.2d%2.2d%2.2d", $hour, $min, $sec);
    return $d.$t;
}
# }}}

sub print_ttyrec # {{{
{
    my $handle = shift;
    my @text = grep {defined($_) && $_ ne ''} @_;
    return unless @text;
    print {$handle}
          map { pack("VVV", gettimeofday(), length) . $_ }
          @text;
} # }}}
# sub print_ih_ttyrec {{{
our @after_ih_ttyrec;
sub print_ih_ttyrec
{
    return unless $write_interhack_ttyrec;
    print_ttyrec($interhack_handle, $_) for @_;

    for (@after_ih_ttyrec) {
        $_->(@_);
    }
} # }}}
# }}}

# a bit of signal handling {{{
my $tstp = $SIG{TSTP} = sub {
    # if we don't invoke TSTP then we won't be suspended
    $SIG{TSTP} = 'DEFAULT';

    ReadMode 0;

    kill TSTP => $$;
};

$SIG{CONT} = sub {
    $SIG{TSTP} = $tstp;

    ReadMode 3;

    request_redraw;
};
# }}}

# read config {{{
if (-e "$ENV{HOME}/.interhack/servers/$server->{name}/config")
{
    do "$ENV{HOME}/.interhack/servers/$server->{name}/config";
}
elsif (-e "$ENV{HOME}/.interhack/config")
{
    do "$ENV{HOME}/.interhack/config";
}
die $@ if $@;
# }}}
# boot ih-server.pl if applicable {{{
if ($server->{type} eq 'ih-server') {
    if (!fork) {
        { exec 'perl ih-server.pl'; }
        die "Unable to exec ih-server.pl";
    }
    sleep 1;
}
# }}}
# get a socket {{{
our $sock;
if (!defined($ttyrec))
{
    use Interhack::Sock;
    $sock = Interhack::Sock::sock($server->{server}, $server->{port});
    set_lexisock($sock);
}
# }}}

# check for ttyrec passed in {{{
if (@ARGV == 1 && $ARGV[0] =~ /\.ttyrec$/)
{
    $ttyrec = shift;
    $autologin = 0;
    $in_game = 1;
    require Term::TtyRec::Plus;
    $ttp = Term::TtyRec::Plus->new(infile => $ttyrec, time_threshold => 10);
}
# }}}
# check arguments for a nick to autologin {{{
if (@ARGV)
{
  $nick = '';
  for (glob("$ENV{HOME}/.interhack/servers/$server->{name}/passwords/*"))
  {
    local ($_) = m{.*/(\w+)};
    if (index($_, $ARGV[0]) > -1)
    {
      if ($nick ne '')
      {
        die "Ambiguous login name given: $nick, $_";
      }
      else
      {
        $nick = $_;
      }
    }
  }
  $autologin = 0 unless $nick;
}
# }}}

# autologin {{{
if ($autologin && $server->{type} eq "dgl")
{
  $nick = value_of($nick);
  $pass = value_of($pass);
  print {$sock} "l$nick\n";

  if ($pass eq '')
  {
    $pass = do { local @ARGV = "$ENV{HOME}/.interhack/servers/$server->{name}/passwords/$nick"; <> };
    chomp $pass;
  }

  if ($pass ne '')
  {
    print {$sock} "$pass\n";
  }
} # }}}
# get ready to start accepting keypresses {{{
# clear socket buffer (responses to telnet negotiation, name/pass echoes, etc
if (!defined($ttyrec) && $server->{type} eq "dgl" && defined $pass)
{
  my $found = 0;
  while ($found < ($autologin ? 2 : 1))
  {
    next unless defined(recv($sock, $_, 4096, 0));
    last if /There was a problem with your last entry\./;
    if (s/^.*?(\e\[H\e\[2J\e\[1B ##$server->{dgl_line1}..\e\[1B ##\Q$server->{dgl_line2}\E)(.*\e\[H\e\[2J\e\[1B ##$server->{dgl_line1}..\e\[1B ##\Q$server->{dgl_line2}\E)?/$1/s) {
      $found++;
      $found++ if $2;
    }
  }
  print;
}

ReadMode 3;
END { ReadMode 0 }
$|++;
$SIG{INT} = sub {};

if (defined($ttyrec))
{
    $write_normal_ttyrec    =
    $write_interhack_ttyrec =
    $write_keys             = 0;
}

if ($write_normal_ttyrec)
{
    system("mkdir -p $ENV{HOME}/.interhack/ttyrec/normal");
    $normal_ttyrec_name = sprintf '%s/.interhack/ttyrec/normal/%s.ttyrec', $ENV{HOME}, timestamp();
    open $normal_handle, '>', $normal_ttyrec_name
        or die "Unable to open $normal_ttyrec_name for writing: $!";
}

if ($write_interhack_ttyrec)
{
    system("mkdir -p $ENV{HOME}/.interhack/ttyrec/interhack");
    $interhack_ttyrec_name = sprintf '%s/.interhack/ttyrec/interhack/%s.ttyrec', $ENV{HOME}, timestamp();
    open $interhack_handle, '>', $interhack_ttyrec_name
        or die "Unable to open $interhack_ttyrec_name for writing: $!";
}

if ($write_keys)
{
    system("mkdir -p $ENV{HOME}/.interhack/keys");
    $key_name = sprintf '%s/.interhack/keys/%s.txt', $ENV{HOME}, timestamp();
    open $keys_handle, '>', $key_name
        or die "Unable to open $key_name for writing: $!";
}
# }}}
# main loop {{{
ITER:
while (1)
{
  my $c;
  # read from stdin, print to sock {{{
  if (defined($ttyrec))
  {
      if ($paused)
      {
          $c = ReadKey 0;
      }
      else
      {
          $c = ReadKey -1;
      }
      if (defined($c))
      {
          if ($c eq 'p')
          {
              $paused = !$paused;
              next ITER;
          }
          elsif ($c eq 'q')
          {
              last ITER;
          }
      }
  }
  else
  {
      if (@key_queue)
      {
          $c = shift @key_queue;
      }
      else
      {
          $c = ReadKey .05;
          ($resting, $anno_frames, @key_queue) = (0, 0)
              if defined $c;
      }

      if (defined $c)
      {
          if ($c eq "\e" && $vt->row_plaintext(1) =~ /^For what do you wish\? /)
          {
              # force_yn returns 1 if yes, 0 if no
              if (force_yn("Are you sure you want to cancel your wish?") == 0)
              {
                  next;
              }
          }

          if ($c eq "p" && $at_login && $logged_in) { $in_game = 1 }
          if ($c eq "\t" && $at_login && $logged_in)
          {
            print "\e[1;30mPlease wait while I download the existing rcfile.\e[0m";
            my $rc_file = $server->{rc_file};
            $rc_file = $rc_file->($me) if ref($rc_file) eq 'CODE';
            my $nethackrc = get("$rc_file");
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
            $c = $tab if $c eq "\t";
            $tab = "\t";
            %keyonce = ();
          }
          elsif (exists $keyonce{$c})
          {
            my $map = $keyonce{$c};
            %keyonce = ();
            $c = value_of($map, $c);
          }
          elsif (exists $keymap{$c})
          {
            $c = value_of($keymap{$c}, $c);
            %keyonce = ();
          }
          else
          {
            %keyonce = ();
          }

          $keystrokes += length $c;

          push @lastkeys => split //, $c;
          shift @lastkeys if defined($lastkeysmaxlen) && @lastkeys > $lastkeysmaxlen;

          print {$sock} $c;
          print {$keys_handle} $c if $write_keys;
          $at_login = 0;
      }
  }

  if ($anno_frames <= 0)
  {
      clear_annotation();
  }
# }}}
  # read from sock, print to stdout {{{

  if (!defined($ttyrec))
  {
      next ITER
          unless defined(recv($sock, $_, 4096, 0));
      last ITER if length == 0;
  }
  else
  {
      my $frame = $ttp->next_frame();
      last ITER if !defined($frame);
      select undef, undef, undef, $frame->{diff};
      $_ = $frame->{data};
      s/\a//g; # HATE BEEPS
  }

  $anno_frames-- unless $anno_frames == 0;

  $vt->process($_);
  print_ttyrec($normal_handle, $_) if $write_normal_ttyrec;

  if (/ \e \[? [0-9;]* \z /x || m/  [^]* \z /x)
  {
    $buf .= $_;
    next ITER;
  }

  if ($buf ne '')
  {
    $_ = $buf . $_;
    $buf = '';
  }

  $topline = $vt->row_plaintext(1);
  study $topline;

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

  s{\e\[H(\w+) ?([^\e]*?)?: unknown extended command\.(?=\e)}{
      if (exists $extended_command{$1})
      {
        "\e[H" . value_of($extended_command{$1}, $1, $2) . "\e[K"
      }
      else
      {
        $&
      }
  }eg;

  ($resting, @key_queue) = 0
    if (($resting    ) && /\e\[H(?!\e\[\d?K|Count:)/)
    || (($resting & 2) && /(?:\e\[24;\d+H|HP:)(\d+)\(\1\)/)
    || (($resting & 4) && /Pw:(\d+)\(\1\)/);

  if (/\e\[Hr(?:est)?: unknown extended command\./)
  {
    $resting  = 1;
    $resting |= 2 if $curhp != $maxhp;
    $resting |= 4 if $curpw != $maxpw;
  }

  s{\e\[Hr(?:est)?: unknown extended command\.}
   {\e[HTo sleep, perchance to dream.}g;

  if ($resting)
  {
    s/Count: 10//;
    push @key_queue => ($vikeys ? "" : "n") . "10s"
      unless @key_queue;
  }

  {
      local $sock; # hide $sock from plugins
      foreach my $map (@configmap, @configonce, @colormap, @coloronce)
      {
          eval { $map->() }
      }
      @configonce = @coloronce = ();
  }

  print;
  print_ih_ttyrec($_);

  {
      local $sock; # hide $sock from plugins
      foreach my $map (@postmap, @postonce)
      {
          eval { $map->() }
      }
      @postonce = ();
  }

  print_ih_ttyrec($postprint);
  print $postprint and $postprint = ''
    if $postprint ne '';
  # }}}
}
# }}}

print "You typed $keystrokes keystrokes in this session.\n";

