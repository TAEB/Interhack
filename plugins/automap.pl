# attempts to draw certain levelmaps
# adds a bunch of extended commands, one for each level
# the Gazetteer ought to help
# by Eidolos

sub draw_map
{
    sub
    {
        print "\e[1;30m"
            . `./plugins/automap/draw_map.pl plugins/automap/$_[0].txt`
            . "\e[0m";
        "Press ^L to redraw the screen."
    }
}

extended_command "#townsquare"
              => draw_map("town_square");

extended_command "#castle"
              => draw_map("castle");

