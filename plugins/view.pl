# this plugin lets you view maps of other levels
# the syntax is #view DLVL
# currently somewhat limited because there can only be one map for dlvl 5 even
# though dlvl 5 can describe a main branch level, a mines level, and a Soko
# level
# by Eidolos

our %map;
our $dlvl;

$vt->callback_set("CLEAR", sub
{
    my ($cbvt, $cbtype) = @_;
    return unless $cbtype eq "CLEAR";
    return unless $cbvt->row_plaintext(24) =~ /^(?:Dlvl:|Home )\d+ /;

    $dlvl = $1 if $cbvt->row_plaintext(24) =~ /^Dlvl:(\d+) /;
    $dlvl = "q$1" if $cbvt->row_plaintext(24) =~ /^Home (\d+) /;
    $map{$dlvl} = [map {$cbvt->row_plaintext($_)} 2..22];
});

extended_command "#view"
              => sub
              {
                  my ($cmd, $args) = @_;

                  $args = '' if !defined($args);
                  $args =~ s/(\d+)//;
                  return "Syntax: #view DLVL [or #view FROM-TO]" if !defined($1);

                  my $from = $1;
                  my $to = $1 if $args =~ s/(\d+)//;
                  $to = $from if !defined($to);

                  for my $level ($from..$to)
                  {
                      return "I don't have a map for $level." unless exists $map{$level};

                      print_ttyrec($interhack_handle, "\e[s\e[1;30m\e[2H") if $write_interhack_ttyrec;
                      print "\e[s\e[1;30m\e[2H";
                      for (@{$map{$level}})
                      {
                          local $_ = substr($_, 0, 79) . "\n";
                          print_ttyrec($interhack_handle, $_) if $write_interhack_ttyrec;
                          print;
                      }

                      local $_ = "\e[m\e[HDrawing dlvl $level. Press a key to redraw the screen.--More--";
                      print_ttyrec($interhack_handle, $_) if $write_interhack_ttyrec;
                      print;
                      print {$keys_handle} ReadKey 0;
                  }
                  request_redraw();
                  "If you can read this, you have pretty quick eyes!"
              };

