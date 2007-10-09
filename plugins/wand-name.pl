# This adds tabs for wand naming based on engrave-messages
# Only works for non-ambiguous engrave messages right now
# Assumes the user is engraving over a previous engraving,
# and only engraves one letter
#
# by toft
#
# $getwand added by Alex, adds support multi-character engravings

my $getwand = sub
{
    for (my $i=-2; $i>=-30; --$i)
    {
        if ((alphakeys($i) eq "y") || (alphakeys($i) eq "n"))
        {
            my $j=$i-2;
            while ((alphakeys($j) eq "?") || (alphakeys($j) eq "*") || (alphakeys($j) eq " "))
            {
                $j--;
            }
            if (alphakeys($j) eq "E")
            {
                return alphakeys($i-1);
            }
        }
    }
    return "-";
};

my $nw = sub
{
    my $name = shift;
    my $sub = sub{my $key = $getwand->(); ($key eq "-" ? "" : " \e#name\nn${key}${name}\n")};
    return $sub;
};

make_tab qr/^The engraving now reads: ".*?"./ => sub{my $key = alphakeys(-1); " \e#name\nn${key}polymorph\n"};
make_tab qr/^The wand unsuccessfully fights your attempt to write!/ => $nw->("striking");
make_tab qr/^A few ice cubes drop from the wand./ => $nw->("cold");
make_tab qr/^The \w+ is riddled by bullet holes!/ => $nw->("magic missile");
make_tab qr/^The bugs on the \w+ slow down!/ => $nw->("slow monster");
make_tab qr/^The bugs on the \w+ speed up!/ => $nw->("speed monster");

