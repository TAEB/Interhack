# attempts to draw certain levelmaps
# adds a bunch of extended commands, one for each level
# the Gazetteer ought to help
# by Eidolos

my %maps;

sub read_map
{
    my $name = shift;
    return $maps{$name} if exists $maps{$name};

    my @output;

    my $file = "plugins/automap/$name.txt";

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

    $maps{$name} = \@output
        if @output > 2;
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
    if (!-e "plugins/automap/$mapfile.txt")
    {
        return "Sorry, plugins/automap/$mapfile.txt doesn't exist";
    }

    my $map = read_map($mapfile);

    if (!defined($map) || @$map == 0)
    {
        return "Sorry, can't read plugins/automap/$mapfile.txt";
    }

    my ($y, $X);

    p "\e[1;30m";

    for my $row (@$map) {
        if (ref($row) eq 'ARRAY') {
            ($y, $X) = @$row;
            next;
        }

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

    "Drawing $mapfile at (y$y, x$X). Press ^R to redraw the screen."
}

my @maps = qw/frontier townsquare alley college grotto bustling bazaar
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
                qw/arc bar cav hea kni mon pri ran rog sam tou val wiz/;

for my $name (@maps)
{
    extended_command $name => sub { draw_map($name) };
}

extended_command 'map' => sub { guess_and_draw_map(\@maps) };

sub guess_and_draw_map
{
    my $available = shift;
    my @best = (0);
    for my $name (@$available) {
        my $map = read_map($name);
        my ($correct, $checked) = match_map($vt, $map);

        next if $checked < 10;

        my $match = int(100 * $correct / $checked);

        @best = ($match, $name, $correct, $checked)
            if $match > $best[0];

        next if $match < 95;

        draw_map($name);
        return "The $name map matched your current level: "
             . "$match% ($correct/$checked)";
    }

    return "You need to explore more of the map." if $best[0] == 0;
    return "No map matched your level. "
         . "The best was $best[1] with $best[0]% ($best[2]/$best[3]).";
}

sub match_map
{
    my $vt = shift;
    my $map = shift;

    my $correct = 0;
    my $checked = 0;

    my ($X, $y);

    for (@$map) {
        my $row = $_;

        if (ref($row) eq 'ARRAY') {
            ($y, $X) = @$row;
            next;
        }

        ++$y;
        my $x = $X;

        # replace all monsters and items with .
        $row =~ s{[a-zA-Z~!@\$%^&*()+=<>/\[\]"':;\\]}{.}g;

        # replace walls and corridors
        $row =~ y/-|#/ww./;

        for my $tile (split '', $row) {
            ++$x;

            my $visible = substr($vt->row_plaintext($y-1), $x-2, 1);

            # haven't explored this spot or it's not part of the defined map
            if ($visible eq ' ' || $tile eq ' ') {
                next;
            }

            # replace all monsters and items with .
            $visible =~ s{[a-zA-Z~!@\$%^&*()+=<>/\[\]"':;\\]}{.}g;

            # replace walls and corridors
            $visible =~ y/-|#/ww./;

            ++$checked;
            if ($visible eq $tile) {
                ++$correct;
            }
        }
    }

    return ($correct, $checked);
}

