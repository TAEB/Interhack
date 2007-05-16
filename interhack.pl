#!/usr/bin/perl
use strict;
use lib 'lib';
use Term::ReadKey;
use LWP::Simple;
use File::Temp qw/tempfile/;
use Term::VT102;
use Term::TtyRec::Plus;

# globals {{{
our $nick = '';
our $pass = '';
our $server = 'nethack.alt.org';
our $port = 23;
our $autologin = 1;
our $ttp;
our $ttyrec;
our $paused = 0;
our $anno_frames = 0;
our %keymap;
our @key_queue;
our @lastkeys;
our $lastkeysmaxlen = 100;
our @configmap;
our @colormap;
our %extended_command;
our %plugin_loaded;
our @mINC = ("$ENV{HOME}/.interhack/plugins", "plugins");
# colormap {{{
our %colormap =
(
  nhblack        => "\e[0;34m", # override to "\e[1;30m" if you want!
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
our $in_game = 0;
our $buf = '';
our $resting = 0;
our ($curhp, $maxhp, $curpw, $maxpw) = (0, 0, 0, 0);
our $vikeys = 0;
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
    ($server, $port) = @_;
    $port = 23 unless defined $port;
} # }}}
sub include # {{{
{
    my @modules = @_;

    if ($modules[0] eq "*")
    {
        for (map {sort <$_/*.p[lm]>} @mINC)
        {
            my ($file) = m{^.*/([^/]+)$};
            next if $plugin_loaded{$file}++;
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

        next MODULE if $plugin_loaded{$file}++;
        do $file;
        die $@ if $@;
    }
} # }}}
sub exclude_plugins # {{{
{
    for (@_)
    {
        my $module = $_;
        $module .= ".pl" unless $module =~ /\.p[lm]$/;
        $plugin_loaded{$module} = 1;
    }
} # }}}

sub each_iteration(&;$) # {{{
{
    push @configmap, shift;
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
sub value_of # {{{
{
    my ($exp, $args) = @_;
    return $exp unless ref($exp);
    return $exp->($args) if ref($exp) eq "CODE";
    return $exp;
} # }}}

sub make_annotation # {{{
{
    my ($matching, $annotation) = @_;
    if (!ref($matching))
    {
        push @configmap, sub { if (index($_, $matching) > -1) { annotate($annotation) } }
    }
    elsif (ref($matching) eq "Regexp")
    {
        push @configmap, sub { if (/$matching/) { annotate($annotation) } }
    }
    elsif (ref($matching) eq "CODE")
    {
        push @configmap, sub { if ($matching->()) { annotate($annotation) } }
    }
    else
    {
        die "Unable to make_annotation matching object of type " . ref($matching);
    }
} # }}}
sub make_anno # {{{
{
    make_annotation(@_);
} # }}}
sub annotate # {{{
{
  my $annotation = value_of(shift);
  return if $annotation eq '';
  $annotation_onscreen = 1;
  $anno_frames = 5;
  $postprint .= "\e[s\e[2H\e[1;30m$annotation\e[0m\e[u";
} # }}}

sub make_tab # {{{
{
    my ($matching, $tabstring) = @_;
    if (!ref($matching))
    {
        push @configmap, sub { if (index($_, $matching) > -1) { tab($tabstring) } }
    }
    elsif (ref($matching) eq "Regexp")
    {
        push @configmap, sub { if (/$matching/) { tab($tabstring) } }
    }
    elsif (ref($matching) eq "CODE")
    {
        push @configmap, sub { if ($matching->()) { tab($tabstring) } }
    }
    else
    {
        die "Unable to make_tab matching object of type " . ref($matching);
    }
} # }}}
sub tab # {{{
{
  my $display = value_of(shift);
  return if $display eq '';
  $tab = $display;
  return if @_;
  $display =~ s/\n/\\n/g;
  $display =~ s/\e/\\e/g;
  annotate("Press tab to send the string: $display");
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
    $newcolor = exists $colormap{$newcolor} ? $colormap{$newcolor} : die "Unable to discern the color described by \"$newcolor\""
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
# }}}

# check for ttyrec passed in {{{
if (@ARGV == 1 && $ARGV[0] =~ /\.ttyrec$/)
{
    $ttyrec = shift;
    $autologin = 0;
    $in_game = 1;
    $ttp = Term::TtyRec::Plus->new(infile => $ttyrec, time_threshold => 10);
}
# }}}
# check arguments for a nick to autologin {{{
if (@ARGV)
{
  $nick = '';
  for (<$ENV{HOME}/.interhack/passwords/*>)
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
}
# }}}

# read config, get a socket {{{
do "$ENV{HOME}/.interhack/config"
    if -e "$ENV{HOME}/.interhack/config";
die $@ if $@;

our $sock;
if (!defined($ttyrec))
{
    use Interhack::Sock;
    $sock = Interhack::Sock::sock($server, $port);
}

our $vt = Term::VT102->new(cols => 80, rows => 24);
# }}}
# autologin {{{
if ($autologin && $server !~ /noway\.ratry/)
{
  $nick = value_of($nick);
  $pass = value_of($pass);
  print {$sock} "l$nick\n";

  if ($pass eq '')
  {
    $pass = do { local @ARGV = "$ENV{HOME}/.interhack/passwords/$nick"; <> };
    chomp $pass;
  }

  if ($pass ne '')
  {
    print {$sock} "$pass\n";
  }
} # }}}
# get ready to start accepting keypresses {{{
# clear socket buffer (responses to telnet negotiation, name/pass echoes, etc
if (!defined($ttyrec) && $server =~ /alt\.org/)
{
  until (defined(recv($sock, $_, 4096, 0)) && /zaphod\.alt\.org/) {}
}

ReadMode 3;
END { ReadMode 0 }
$|++;
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
          ($resting, @key_queue) = 0
              if defined $c;
      }

      if (defined $c)
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
            $c = $tab if $c eq "\t";
            $tab = "\t";
          }
          elsif (exists $keymap{$c})
          {
            $c = value_of($keymap{$c}, $c);
          }

          $keystrokes += length $c;

          push @lastkeys => split //, $c;
          shift @lastkeys if defined($lastkeysmaxlen) && @lastkeys > $lastkeysmaxlen;

          print {$sock} $c;
          $at_login = 0;
      }
  }

  if ($anno_frames <= 0)
  {
      print "\e[s\e[2H\e[K\e[u" if $annotation_onscreen;
      $annotation_onscreen = 0;
  }
# }}}
  # read from sock, print to stdout {{{

  if (!defined($ttyrec))
  {
      next ITER
          unless defined(recv($sock, $_, 4096, 0));
      last if length == 0;
  }
  else
  {
      my $frame = $ttp->next_frame();
      select undef, undef, undef, $frame->{diff};
      $_ = $frame->{data};
      $anno_frames-- unless $anno_frames == 0;
  }

  $vt->process($_);

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

  s{\e\[H(\w+): unknown extended command\.}{
      if (exists $extended_command{$1})
      {
        "\e[H" . value_of($extended_command{$1}, $1) . "\e[K"
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

  if (/\e\[Hrest: unknown extended command\./)
  {
    $resting  = 1;
    $resting |= 2 if $curhp != $maxhp;
    $resting |= 4 if $curpw != $maxpw;
  }

  s{rest: unknown extended command\.}
   {To sleep, perchance to dream.}g;

  if ($resting)
  {
    s/Count: 10//;
    push @key_queue => ($vikeys ? "" : "n") . "10s"
      unless @key_queue;
  }

  foreach my $map (@configmap, @colormap)
  {
    eval { $map->() }
  }

  print;

  print $postprint and $postprint = ''
    if $postprint ne '';
  # }}}
}
# }}}

print "You typed $keystrokes keystrokes in this session.\n";

