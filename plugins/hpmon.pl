# better color the HP display
# prayer-safe HP is colored as dark gray
# it also doesn't "miss" like the real hpmon
# by Eidolos

include "stats";

each_iteration
{
  $botl{hp} =~ s{(HP:)(\d+\(\d+\))}{
    my $color = '';

       if ($curhp * 7 <= $maxhp || $curhp <= 6) { $color = "\e[1;30m" }
    elsif ($curhp     >= $maxhp)            {                     }
    elsif ($curhp * 2 >= $maxhp)            { $color = "\e[1;32m" }
    elsif ($curhp * 3 >= $maxhp)            { $color = "\e[1;33m" }
    elsif ($curhp * 4 >= $maxhp)            { $color = "\e[0;31m" }
    elsif ($curhp * 5 >= $maxhp)            { $color = "\e[1;31m" }

    "$1$color$2\e[0m"
  }eg;
}

