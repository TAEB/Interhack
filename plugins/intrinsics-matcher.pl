my $tracker_path = 'intrinsics-tracker.pl';
my $annotations_path = 'annotations-messages.pl';

# the "or return"s are to avoid making annotations if there was no change
my $add = sub
{
    my $intrinsic = shift;

    add_intrinsic($intrinsic) or return if $plugin_loaded{$tracker_path};
    annotate_add_intrinsic($intrinsic) if $plugin_loaded{$annotations_path};
};

my $del = sub
{
    my $intrinsic = shift;
    del_intrinsic($intrinsic) or return if $plugin_loaded{$tracker_path};
    annotate_del_intrinsic($intrinsic) if $plugin_loaded{$annotations_path};
};

# good messages {{{
# resists {{{
each_match qr/\e\[(?:1;\d+)?HYou feel (?:(?:especially )?healthy|hardy)\./ => $add, "poison";
each_match qr/\e\[(?:1;\d+)?HYou feel (?:full of hot air|warm)\./ => $add, "cold";
each_match qr/\e\[(?:1;\d+)?HYou (?:feel a momentary chill|feel cool(?!er)|be chillin')\./ => $add, "fire";
each_match qr/\e\[(?:1;\d+)?HYou feel (?:wide )?awake\./ => $add, "sleep";
each_match qr/\e\[(?:1;\d+)?HYou feel (?:very firm|totally together, man)\./ => $add, "disintegration";
each_match qr/\e\[(?:1;\d+)?HYour health currently feels amplified!/ => $add, "shock";
each_match qr/\e\[(?:1;\d+)?HYou feel (?:insulated|grounded in reality)/ => $add, "shock";
# }}}
# other intrinsics {{{
each_match qr/\e\[(?:1;\d+)?HYou feel (?:very jumpy|diffuse)\./ => $add, "tpitis";
each_match qr/\e\[(?:1;\d+)?HYou feel (?:in control of yourself|centered in your personal space)\./ => $add, "tc";
each_match qr/\e\[(?:1;\d+)?HYou feel controlled\./ => $add, "tc";
each_match qr/\e\[(?:1;\d+)?HYou feel (?:a strange mental acuity|in touch with the cosmos)\./ => $add, "telepathy";
each_match qr/\e\[(?:1;\d+)?HYou feel hidden\./ => $add, "invis";
each_match qr/\e\[(?:1;\d+)?HYou feel perceptive\./ => $add, "searching";
each_match qr/\e\[(?:1;\d+)?HYou feel stealthy\./ => $add, "stealth";
each_match qr/\e\[(?:1;\d+)?HYou feel sensitive\./ => $add, "warning";
each_match qr/\e\[(?:1;\d+)?HYou feel (?:very self-conscious|transparent)\./ => $add, "see invis";
each_match qr/\e\[(?:1;\d+)?HYou see an image of someone stalking you\./ => $add, "see invis";
each_match qr/\e\[(?:1;\d+)?HYour vision becomes clear\./ => $add, "see invis";
each_match qr/\e\[(?:1;\d+)?HYou (?:seem faster|feel quick)\./ => $add, "fast";
# }}}
# notices that we still have a resistance {{{
each_match qr/\e\[(?:1;\d+)?HYou seem unaffected by the poison\./ => $add, "poison";
each_match qr/\e\[(?:1;\d+)?HThe poison doesn't seem to affect you\./ => $add, "poison";
each_match qr/\e\[(?:1;\d+)?HThe fire doesn't feel hot!/ => $add, "fire";
each_match qr/\e\[(?:1;\d+)?HThe feel mildly hot\./ => $add, "fire";
each_match qr/\e\[(?:1;\d+)?HYou don't feel cold\.\./ => $add, "cold";
each_match qr/\e\[(?:1;\d+)?HYou feel mildly chilly\./ => $add, "cold";
each_match qr/\e\[(?:1;\d+)?HYou feel a mild tingle\./ => $add, "shock";
each_match qr/\e\[(?:1;\d+)?HYou seem unhurt\./ => $add, "shock";
each_match qr/\e\[(?:1;\d+)?HYou are not disintegrated\./ => $add, "disintegration";
# }}}
# }}}

# dangerous messages {{{
# losing resists {{{
each_match qr/\e\[(?:1;\d+)?HYou feel warmer\./ => $del, "fire";
each_match qr/\e\[(?:1;\d+)?HYou feel cooler\./ => $del, "cold";
each_match qr/\e\[(?:1;\d+)?HYou feel a little sick\./ => $del, "poison";
each_match qr/\e\[(?:1;\d+)?HYou feel tired\./ => $del, "sleep";
each_match qr/\e\[(?:1;\d+)?HYou feel conductive\./ => $del, "shock";
# }}}
# losing intrinsics {{{
each_match qr/\e\[(?:1;\d+)?HYou seem slower\./ => $del, "fast";
each_match qr/\e\[(?:1;\d+)?HYou feel (?:slow|slower)\./ => $del, "fast";
each_match qr/\e\[(?:1;\d+)?HYou feel paranoid\./ => $del, "invis";
each_match qr/\e\[(?:1;\d+)?HYou feel clumsy\./ => $del, "stealth";
each_match qr/\e\[(?:1;\d+)?HYou feel less jumpy\./ => $del, "tpitis";
each_match qr/\e\[(?:1;\d+)?HYou feel uncontrolled\./ => $del, "tc";
each_match qr/\e\[(?:1;\d+)?HYou (?:thought you saw something|tawt you taw a puttie tat)\./ => $add, "see invis";
each_match qr/\e\[(?:1;\d+)?HYour senses fail\./ => $del, "telepathy";
# }}}
# }}}
