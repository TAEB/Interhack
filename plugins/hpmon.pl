# better color the HP display
# prayer-safe HP is colored as dark gray
# it also doesn't "miss" like the real hpmon
# by Eidolos

each_iteration
{
  s{(\e\[24;\d+H|HP:)((\d+)\((\d+)\))}{
    my $color = '';

       if ($3 * 7 <= $4 || $3 <= 6) { $color = "\e[1;30m" }
    elsif ($3     >= $4)            {                     }
    elsif ($3 * 2 >= $4)            { $color = "\e[1;32m" }
    elsif ($3 * 3 >= $4)            { $color = "\e[1;33m" }
    elsif ($3 * 4 >= $4)            { $color = "\e[0;31m" }
    elsif ($3 * 5 >= $4)            { $color = "\e[1;31m" }

    "$1$color$2\e[0m"
  }eg;
}

