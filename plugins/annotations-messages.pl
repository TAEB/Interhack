extended_command "#intrinsics"
    => sub
    {
        my $annotation;
        for my $key (keys %intrinsics)
        {
           $annotation .= "$key " if exists($intrinsics{$key});
        }
        annotate($annotation)
    };
# good messages {{{
# resists {{{
make_annotation qr/\e\[HYou feel (?:(?:especially )?healthy|hardy)./ => sub{$intrinsics{poison} = 1; "Gained poison resistance."};
make_annotation qr/\e\[HYou feel (?:full of hot air|warm)./ => sub{$intrinsics{cold} = 1; "Gained cold resistance."};
make_annotation qr/\e\[HYou (?:feel a momentary chill|feel cool|be chillin')./ => sub{$intrinsics{fire} = 1; "Gained fire resistance."};
make_annotation qr/\e\[HYou feel (?:wide )?awake./ => sub{$intrinsics{sleep} = 1; "Gained sleep resistance."};
make_annotation qr/\e\[HYou feel (?:very firm|totally together, man)./ => sub{$intrinsics{disintegration} = 1; "Gained disintegration resistance."};
make_annotation qr/\e\[HYour health currently feels amplified!/ => sub{$intrinsics{shock} = 1; "Gained shock resistance."};
make_annotation qr/\e\[HYou feel (?:insulated|grounded in reality)/ => sub{$intrinsics{shock} = 1; "Gained shock resistance."};
# }}}
# other intrinsics {{{
make_annotation qr/\e\[HYou feel (?:very jumpy|diffuse)./ => sub{$intrinsics{tpitis} = 1; "Gained teleportitis."};
make_annotation qr/\e\[HYou feel (?:in control of yourself|centered in your personal space)./ => sub{$intrinsics{TC} = 1; "Gained teleport control."};
make_annotation qr/\e\[HYou feel controlled/ => sub{$intrinsics{TC} = 1; "Gained teleport control."};
make_annotation qr/\e\[HYou feel (?:a strange mental acuity|in touch with the cosmos)./ => sub{$intrinsics{telepathy} = 1; "Gained intrinsic telepathy."};
make_annotation qr/\e\[HYou feel hidden./ => sub{$intrinsics{invis} = 1; "Gained invisibility."};
make_annotation qr/\e\[HYou feel perceptive./ => sub{$intrinsics{searching} = 1; "Gained searching intrinsic."};
make_annotation qr/\e\[HYou feel stealthy./ => sub{$intrinsics{stealth} = 1; "Gained stealth intrinsic."};
make_annotation qr/\e\[HYou feel sensitive./ => sub{$intrinsics{warning} = 1; "Gained warning intrinsic."};
make_annotation qr/\e\[HYou feel (?:very self-conscious|transparent)./ => sub{$intrinsics{'see invis'} = 1; "Gained see invisible."};
make_annotation qr/\e\[HYou see an image of someone stalking you./ => sub{$intrinsics{'see invis'} = 1; "Gained see invisible."};
make_annotation qr/\e\[HYour vision becomes clear./ => sub{$intrinsics{'see invis'} = 1; "Gained see invisible."};
make_annotation qr/\e\[HYou (?:seem faster|feel quick)./ => sub{$intrinsics{fast} = 1; "You are now 'fast'."};
# }}}
# misc {{{
make_annotation qr/\e\[HYou feel a mild buzz./ => "Gained 1-3 energy.";
# }}}
# }}}

# dangerous messages {{{
# pet hunger {{{
make_annotation qr/\e\[HThe .*? yowls!/ => "Your pet is hungry!";
# }}}
# negative status effects {{{
make_annotation qr/\e\[HOh wow!  Great stuff!/ => "You are now hallucinating.";
make_annotation qr/\e\[HYou reel.../ => "You are now stunned.";
make_annotation qr/\e\[HYou feel somewhat dizzy./ => "You are now confused.";
make_annotation qr/\e\[HYou feel feverish./ => "You are now a werefoo.";
# }}}
# losing resists {{{
make_annotation qr/\e\[HYou feel warmer./ => sub{$intrinsics{fire} = 0; "Lost fire resistance."};
make_annotation qr/\e\[HYou feel cooler./ => sub{$intrinsics{cold} = 0; "Lost cold resistance."};
make_annotation qr/\e\[HYou feel a little sick./ => sub{$intrinsics{poison} = 0; "Lost poison resistance."};
make_annotation qr/\e\[HYou feel tired./ => sub{$intrinsics{sleep} = 0; "Lost sleep resistance."};
make_annotation qr/\e\[HYou feel conductive./ => sub{$intrinsics{shock} = 0; "Lost shock resistance"};
# }}}
# losing intrinsics {{{
make_annotation qr/\e\[HYou seem slower./ => sub{$intrinsics{fast} = 0; "You are no longer 'fast'."};
make_annotation qr/\e\[HYou feel (?:slow|slower)./ => sub{$intrinsics{fast} = 0; "You are no longer 'fast'."};
make_annotation qr/\e\[HYou feel less attractive./ => sub{"Lost aggravate monster intrinsic."};
make_annotation qr/\e\[HYou feel paranoid./ => sub{$intrinsics{invis} = 0; "Lost invisibility intrinsic."};
make_annotation qr/\e\[HYou feel vulnerable./ => sub{"Lost protection."};
make_annotation qr/\e\[HYou feel clumsy./ => sub{$intrinsics{stealth} = 0; "Lost stealth intrinsic."};
make_annotation qr/\e\[HYou feel less jumpy./ => sub{$intrinsics{tpitis} = 0; "Lost teleportitis."};
make_annotation qr/\e\[HYou feel uncontrolled./ => sub{$intrinsics{TC} = 0; "Lost teleport control."};
make_annotation qr/\e\[HYou (?:thought you saw something|tawt you taw a puttie tat)./ => sub{$intrinsics{'see invis'} = 0; "Lost see invisible."};
make_annotation qr/\e\[HYour senses fail./ => sub{$intrinsics{telepathy} = 0; "Lost intrinsic telepathy."};
# }}}
# }}}
