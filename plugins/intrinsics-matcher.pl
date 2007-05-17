my $tracker_path = 'intrinsic-tracker.pl';
my $annotations_path = 'annotations-messages.pl';
my $add = sub
{
    my $intrinsic = shift;
    add_intrinsic($intrinsic) if $plugins_loaded{$tracker_path};
    annotate_add_intrinsic($intrinsic) if $plugins_loaded{$annotations_path};
}

my $del = sub
{
    my $intrinsic = shift;
    del_intrinsic($intrinsic) if $plugins_loaded{$tracker_path};
    annotate_del_intrinsic($intrinsic) if $plugins_loaded{$annotations_path};
}

# good messages {{{
# resists {{{



each_match qr/\e\[HYou feel (?:(?:especially )?healthy|hardy)./ => $add, "poison";
each_match qr/\e\[HYou feel (?:full of hot air|warm)./ => $add, "cold";
each_match qr/\e\[HYou (?:feel a momentary chill|feel cool|be chillin')./ => $add, "fire";
each_match qr/\e\[HYou feel (?:wide )?awake./ => $add, "sleep";
each_match qr/\e\[HYou feel (?:very firm|totally together, man)./ => $add, "disintegration";
each_match qr/\e\[HYour health currently feels amplified!/ => $add, "shock";
each_match qr/\e\[HYou feel (?:insulated|grounded in reality)/ => $add, "shock";
# }}}
# other intrinsics {{{
each_match qr/\e\[HYou feel (?:very jumpy|diffuse)./ => $add, "tpitis";
each_match qr/\e\[HYou feel (?:in control of yourself|centered in your personal space)./ => $add, "tc";
each_match qr/\e\[HYou feel controlled/ => $add, "tc";
each_match qr/\e\[HYou feel (?:a strange mental acuity|in touch with the cosmos)./ => $add, "telepathy";
each_match qr/\e\[HYou feel hidden./ => $add, "invis";
each_match qr/\e\[HYou feel perceptive./ => $add, "searching";
each_match qr/\e\[HYou feel stealthy./ => $add, "stealth";
each_match qr/\e\[HYou feel sensitive./ => $add, "warning";
each_match qr/\e\[HYou feel (?:very self-conscious|transparent)./ => $add, "see invis";
each_match qr/\e\[HYou see an image of someone stalking you./ => $add, "see invis";
each_match qr/\e\[HYour vision becomes clear./ => $add, "see invis";
each_match qr/\e\[HYou (?:seem faster|feel quick)./ => $add, "fast";
# }}}
# }}}

# dangerous messages {{{
# losing resists {{{
each_match qr/\e\[HYou feel warmer./ => $del, "fire";
each_match qr/\e\[HYou feel cooler./ => $del, "cold";
each_match qr/\e\[HYou feel a little sick./ => $del, "poison";
each_match qr/\e\[HYou feel tired./ => $del, "sleep";
each_match qr/\e\[HYou feel conductive./ => $del, "shock";
# }}}
# losing intrinsics {{{
each_match qr/\e\[HYou seem slower./ => $del, "fast";
each_match qr/\e\[HYou feel (?:slow|slower)./ => $del, "fast";
each_match qr/\e\[HYou feel paranoid./ => $del, "invis";
each_match qr/\e\[HYou feel clumsy./ => $del, "stealth";
each_match qr/\e\[HYou feel less jumpy./ => $del, "tpitis";
each_match qr/\e\[HYou feel uncontrolled./ => $del, "tc";
each_match qr/\e\[HYou (?:thought you saw something|tawt you taw a puttie tat)./ => $add, "see invis";
each_match qr/\e\[HYour senses fail./ => $del, "telepathy";
# }}}
# }}}
