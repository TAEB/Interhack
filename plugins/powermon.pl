# adds color to the power display
# by Eidolos

each_iteration
{
    s{Pw:((-?\d+)\((-?\d+)\))}{
        my $color = '';

           if ($2     >= $3) {                     }
        elsif ($2 * 2 >= $3) { $color = "\e[1;36m" }
        elsif ($2 * 3 >= $3) { $color = "\e[1;35m" }
        else                 { $color = "\e[0;35m" }

        "Pw:$color$1\e[0m"
    }eg;
}

