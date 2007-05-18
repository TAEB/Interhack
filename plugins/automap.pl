# attempts to draw certain levelmaps
# adds a bunch of extended commands, one for each level
# the Gazetteer ought to help
# by Eidolos

our ($x, $y) = (0, 0);

sub read_map
{
    my $file = shift;
    my $output;

    open(my $handle, '<', $file)
      or return undef;

    while (<$handle>)
    {
        chomp;

        if ($. == 1 && /^\s*(\d+)\s*(\d+)\s*$/)
        {
            ($y, $x) = ($1, $2);
            annotate("OK, y$y x$x");
            next;
        }

        my $length = length;
        s/([. +S]+)/"\e[".length($1).'C'/eg;
        $output .= "$_\e[B\e[${length}D";
    }

    return $output;
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
        if (!defined($map) || $map eq '')
        {
            return "Sorry, can't read plugins/automap/$mapfile.txt";
        }

        print "\e[1;30m\e[$y;${x}H$map\e[0m";
        "Drawing at (y$y, x$x). Press ^R to redraw the screen."
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

