# good messages {{{
# resists {{{
make_annotation qr/\e\[HYou feel (?:(?:especially )? healthy|hardy)./ => "Gained poison resistance.";
make_annotation qr/\e\[HYou feel (?:full of hot air|warm)./ => "Gained cold resistance.";
make_annotation qr/\e\[HYou (?:feel a momentary chill|feel cool|be chillin')./ => "Gained fire resistance.";
make_annotation qr/\e\[HYou feel (?:wide )?awake./ => "Gained sleep resistance.";
make_annotation qr/\e\[HYou feel (?:very firm|totally together, man)./ => "Gained disintegration resistance.";
make_annotation qr/\e\[HYour health currently feels amplified!/ => "Gained shock resistance.";
make_annotation qr/\e\[HYou feel (?:insulated|grounded in reality)/ => "Gained shock resistance.";
# }}}
# other intrinsics {{{
make_annotation qr/\e\[HYou feel (?:very jumpy|diffuse)./ => "Gained teleportitis.";
make_annotation qr/\e\[HYou feel (?:in control of yourself|centered in your personal space)./;
make_annotation qr/\e\[HYou feel controlled/ => "Gained teleport control.";
make_annotation qr/\e\[HYou feel (?:a strange mental acuity|in touch with the cosmos)./ => "Gained intrinsic telepathy.";
make_annotation qr/\e\[HYou feel hidden./ => "Gained invisibility.";
make_annotation qr/\e\[HYou feel perceptive./ => "Gained searching intrinsic.";
make_annotation qr/\e\[HYou feel stealthy./ => "Gained stealth intrinsic.";
make_annotation qr/\e\[HYou feel sensitive./ => "Gained warning intrinsic.";
make_annotation qr/\e\[HYou feel (?:very self-conscious|transparent)./ => "Gained see invisible.";
make_annotation qr/\e\[HYou see an image of someone stalking you./ => "Gained see invisible.";
make_annotation qr/\e\[HYour vision becomes clear./ => "Gained see invisible.";
make_annotation qr/\e\[HYou (?:seem faster|feel quick)./ => "You are now 'fast'.";
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
make_annotation qr/\e\[HYou feel warmer./ => "Lost fire resistance.";
make_annotation qr/\e\[HYou feel cooler./ => "Lost cold resistance.";
make_annotation qr/\e\[HYou feel a little sick./ => "Lost poison resistance.";
make_annotation qr/\e\[HYou feel tired./ => "Lost sleep resistance.";
make_annotation qr/\e\[HYou feel conductive./ => "Lost shock resistance";
# }}}
# losing intrinsics {{{
make_annotation qr/\e\[HYou seem slower./ => "You are no longer 'fast'.";
make_annotation qr/\e\[HYou feel (?:slow|slower)./ => "You are no longer 'fast'.";
make_annotation qr/\e\[HYou feel less attractive./ => "Lost aggravate monster intrinsic.";
make_annotation qr/\e\[HYou feel paranoid./ => "Lost invisibility intrinsic.";
make_annotation qr/\e\[HYou feel vulnerable./ => "Lost protection.";
make_annotation qr/\e\[HYou feel clumsy./ => "Lost stealth intrinsic.";
make_annotation qr/\e\[HYou feel less jumpy./ => "Lost teleportitis.";
make_annotation qr/\e\[HYou feel uncontrolled./ => "Lost teleport control.";
make_annotation qr/\e\[HYou (?:thought you saw something|tawt you taw a puttie tat)./ => "Lost see invisible.";
make_annotation qr/\e\[HYour senses fail./ => "Lost intrinsic telepathy.";
# }}}
# }}}
