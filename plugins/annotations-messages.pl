my %add_annotation_for =
(
    cold => "Gained cold resistance.",
    disintegration => "Gained disintegration resistance.",
    fast => "You are now 'fast'.",
    fire => "Gained fire resistance.",
    invis => "Gained invisibility.",
    poison => "Gained poison resistance.",
    searching => "Gained searching intrinsic.",
    'see invis' => "Gained see invisible.",
    shock => "Gained shock resistance.",
    sleep => "Gained sleep resistance.",
    stealth => "Gained stealth intrinsic.",
    TC => "Gained teleport control.",
    telepathy => "Gained intrinsic telepathy.",
    tpitis => "Gained teleportitis.",
    warning => "Gained warning intrinsic.",
);

my %del_annotation_for =
(
    cold => "Lost cold resistance.",
    fast => "You are no longer 'fast'.",
    fire => "Lost fire resistance.",
    invis => "Lost invisibility intrinsic.",
    poison => "Lost poison resistance.",
    'see invis' => "Lost see invisible.",
    shock => "Lost shock resistance",
    sleep => "Lost sleep resistance.",
    stealth => "Lost stealth intrinsic.",
    tc => "Lost teleport control.",
    telepathy => "Lost intrinsic telepathy.",
    tpitis => "Lost teleportitis.",
);

sub annotate_add_intrinsic
{
    my $intrinsic = shift;
    annotate($add_annotation_for{$intrinsic}) if $add_annotation_for{$intrinsic}):

}

sub annotate_del_intrinsic
{
    my $intrinsic = shift;
    annotate($del_annotation_for{$intrinsic}) if $del_annotation_for{$intrinsic}):

}


make_annotation qr/\e\[HYou feel a mild buzz./ => "Gained 1-3 energy.";
make_annotation qr/\e\[HYou feel less attractive./ => sub{"Lost aggravate monster intrinsic."};
make_annotation qr/\e\[HYou feel vulnerable./ => sub{"Lost protection."};


make_annotation qr/\e\[HThe .*? yowls!/ => "Your pet is hungry!";
make_annotation qr/\e\[HOh wow!  Great stuff!/ => "You are now hallucinating.";
make_annotation qr/\e\[HYou reel.../ => "You are now stunned.";
make_annotation qr/\e\[HYou feel somewhat dizzy./ => "You are now confused.";
make_annotation qr/\e\[HYou feel feverish./ => "You are now a werefoo.";
