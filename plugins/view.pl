# this plugin lets you view maps of other levels
# the syntax is #view DLVL
# currently somewhat limited because there can only be one map for dlvl 5 even
# though dlvl 5 can describe a main branch level, a mines level, and a Soko
# level
# by Eidolos

our %map;
our $dlvl;

each_iteration
{
    $dlvl = $1 if $vt->row_plaintext(24) =~ /^Dlvl:(\d+) /;
    if ($keystrokes & 16)
    {
        $map{$dlvl} = [map {$vt->row_plaintext($_)} 2..22];
    }
}

extended_command "#view"
              => sub
              {
                  my ($cmd, $args) = @_;
                  return "Syntax: #view DLVL" if !defined($args) || $args eq '';
                  my @args = split ' ', $args;
                  my $level = $args[0];
                  return "I don't have a map for $level." unless exists $map{$level};
                  print "\e[s\e[1;30m\e[2H";
                  for (@{$map{$level}})
                  {
                      print substr($_, 0, 79), "\n";
                  }

                  print "\e[m\e[HDrawing dlvl $level. Press a key to redraw the screen.--More--";
                  ReadKey 0;
                  request_redraw();
                  "If you can read this, you have pretty quick eyes!"
              };

