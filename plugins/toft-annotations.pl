# good messages {{{
# resists {{{
make_annotation qr/You feel ((especially )? healthy|hardy)./ => "Gained poison resistance.";
make_annotation qr/You feel (full of hot air|warm)./ => "Gained cold resistance.";
make_annotation qr/You (feel a momentary chill|feel cool|be chillin')./ => "Gained fire resistance.";
make_annotation qr/You feel ((wide )?awake)./ => "Gained sleep resistance.";
make_annotation qr/You feel (very firm|totally together, man)./ => "Gained disintegration resistance.";
make_annotation qr/Your health currently feels amplified!/ => "Gained shock resistance.";
make_annotation qr/You feel (insulated|grounded in reality)/ => "Gained shock resistance.";
# }}}
# other intrinsics {{{
make_annotation qr/You feel (very jumpy|diffuse)./ => "Gained teleportitis.";
make_annotation qr/You feel (in control of yourself|centered in your personal space)./
make_annotation qr/You feel (controlled)/ => "Gained teleport control.";
make_annotation qr/You feel (a strange mental acuity|in touch with the cosmos)./ => "Gained intrinsic telepathy.";
make_annotation qr/You feel hidden./ => "Gained invisibility.";
make_annotation qr/You feel perceptive./ => "Gained searching intrinsic.";
make_annotation qr/You feel stealthy./ => "Gained stealth intrinsic.";
make_annotation qr/You feel sensitive./ => "Gained warning intrinsic.";
make_annotation qr/You feel (very self-conscious|transparent)./ => "Gained see invisible.";
make_annotation qr/You see an image of someone stalking you./ => "Gained see invisible.";
make_annotation qr/Your vision becomes clear./ => "Gained see invisible.";
make_annotation qr/You (seem faster|feel quick)./ => "You are now 'fast'.";
# }}}
# misc {{{
make_annotation qr/You feel (a mild buzz)./ => "Gained 1-3 energy.";
# }}}
# }}}

# dangerous messages {{{
# pet hunger {{{
make_annotation qr/The .*? yowls!/ => "Your pet is hungry!";
# }}}
# negative status effects {{{
make_annotation qr/Oh wow!  Great stuff!/ => "You are now hallucinating.";
make_annotation qr/You reel.../ => "You are now stunned.";
make_annotation qr/You feel somewhat dizzy./ => "You are now confused.";
make_annotation qr/You feel feverish./ => "You are now a werefoo.";
# }}}
# losing resists {{{
make_annotation qr/You feel warmer./ => "Lost fire resistance.";
make_annotation qr/You feel cooler./ => "Lost cold resistance.";
make_annotation qr/You feel a little sick./ => "Lost poison resistance.";
make_annotation qr/You feel tired./ => "Lost sleep resistance.";
make_annotation qr/You feel conductive./ => "Lost shock resistance";
# }}}
# losing intrinsics {{{
make_annotation qr/You seem slower./ => "You are no longer 'fast'.";
make_annotation qr/You feel (slow|slower)./ => "You are no longer 'fast'.";
make_annotation qr/You feel less attractive./ => "Lost aggravate monster intrinsic.";
make_annotation qr/You feel paranoid./ => "Lost invisibility intrinsic.";
make_annotation qr/You feel vulnerable./ => "Lost protection.";
make_annotation qr/You feel clumsy./ => "Lost stealth intrinsic.";
make_annotation qr/You feel less jumpy./ => "Lost teleportitis.";
make_annotation qr/You feel uncontrolled./ => "Lost teleport control.";
make_annotation qr/You (thought you saw something|tawt you taw a puttie tat)./ => "Lost see invisible.";
make_annotation qr/Your senses fail./ => "Lost intrinsic telepathy.";
# }}}
# }}}
