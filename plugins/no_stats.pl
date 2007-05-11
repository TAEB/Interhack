# avoids adding stats to botl to make room for other more important things
# stats are still available through new #stats ext-cmd
# by Eidolos

my $stats = '';

extended_command "#stats"
              => sub { $stats };

each_iteration
{
  $stats = $&
    if s/\bSt:\d+.*?Ch:\d+/' ' x length $&/eg;
}

