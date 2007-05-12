# adds a game clock to the right side of the penultimate line
# also adds an extended command #time
# by Eidolos

our $start_time = time;

each_iteration
{
  if ($in_game)
  {
    my $time = serialize_time(time - $start_time);
    my $col = 81 - length $time;
    $postprint .= "\e[s\e[23;${col}H\e[1;30m$time\e[0m\e[u";
    s/(?:real)?timer?: unknown extended command/$time\e[K/g;
  }
}

