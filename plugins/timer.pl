# adds a game clock to the right side of the penultimate line
# also adds an extended command #time
# by Eidolos

our $start_time = time;

each_iteration
{
  if ($in_game)
  {
    my $time = serialize_time(time - $start_time);
    s/(?:real)?timer?: unknown extended command/$time\e[K/g;

    my $col = 81 - length $time;
    my $bottom = $vt->row_text(24);

    $postprint .= "\e[s\e[23;${col}H\e[1;30m$time\e[0m\e[u"
      unless $bottom =~ /\(\d+ of \d+\)/ || $bottom =~ /\(end\)/;
  }
}

