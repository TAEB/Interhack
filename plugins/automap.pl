# attempts to draw certain levelmaps
# adds a bunch of extended commands, one for each level
# the Gazetteer ought to help
# by Eidolos

sub read_map
{
    my $file = shift;
    my @output;

    open(my $handle, '<', $file)
      or return undef;

    while (<$handle>)
    {
        chomp;

        if ($. == 1 && /^\s*(\d+)\s*(\d+)\s*$/)
        {
            ($y, $x) = ($1, $2);
            push @output, [$y, $x];
            next;
        }

        push @output, $_;
    }

    return \@output;
}

# helper function to print out Interhack goodness
sub p {
    local $_ = shift;
    print_ttyrec($interhack_handle, $_) if $write_interhack_ttyrec;
    print;
}

sub draw_map
{
    my $mapfile = shift;
    sub
    {
        if (!-e "plugins/automap/$mapfile.txt")
        {
            return "Sorry, plugins/automap/$mapfile.txt doesn't exist";
        }

        my $map = read_map("plugins/automap/$mapfile.txt");

        if (!defined($map) || @$map == 0)
        {
            return "Sorry, can't read plugins/automap/$mapfile.txt";
        }

        my ($y, $X) = @{ shift @$map };

        p "\e[1;30m";

        for my $row (@$map) {
            p "\e[$y;${X}H";
            ++$y;
            my $x = $X;
            for my $tile (split '', $row) {
                ++$x;

                # skip if tile is empty
                if ($tile eq ' ') {
                    p "\e[C";
                }
                # skip if there's already something on the map
                elsif (substr($vt->row_plaintext($y-1), $x-2, 1) ne ' ') {
                    p "\e[C";
                }
                # otherwise add it, my good man
                else {
                   p $tile;
                }
            }
        }

        p "\e[m";

        "Drawing at (y$y, x$X). Press ^R to redraw the screen."
    }
}

for (qw/frontier townsquare alley college grotto bustling bazaar
        oracle ludios castle valley sanctum
        cellar catacombs mimic
        bigplus bigoval bigtie
        samfill
        medusa1 medusa2
        asmodeus baalzebub juiblex orcus
        wiztop wizmid wizbot
        vladtop vladmid vladbot
        fakewiz
        earth air fire astral
       /, map {("${_}home", "${_}loc", "${_}goal")}
          qw/arc bar cav hea kni mon pri ran rog sam tou val wiz/)
{
    extended_command $_ => draw_map($_);
}

