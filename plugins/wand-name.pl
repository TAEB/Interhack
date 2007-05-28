# This adds tabs for wand naming based on engrave-messages
# Only works for non-ambiguous engrave messages right now
# Assumes the user is engraving over a previous engraving,
# and only engraves one letter
#
# by toft

my $nw = sub
{
    my $name = shift;
    my $sub = sub{my $key = alphakeys(-3); " \e#name\nn${key}${name}\n"};
    return $sub;
};

make_tab_vt qr/^The engraving now reads: ".*?"./ => sub{my $key = alphakeys(-1); " \e#name\nn${key}polymorph\n"};
make_tab_vt qr/^The wand unsuccessfully fights your attempt to write!/ => $nw->("striking");
make_tab_vt qr/^A few ice cubes drop from the wand./ => $nw->("cold");
make_tab_vt qr/^The \w+ is riddled by bullet holes!/ => $nw->("magic missile");
make_tab_vt qr/^The bugs on the \w+ slow down!/ => $nw->("slow monster");
make_tab_vt qr/^The bugs on the \w+ speed up!/ => $nw->("speed monster");

