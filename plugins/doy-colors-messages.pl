# messages to ignore {{{
# boulders {{{
recolor qr/With great effort you move the boulder./ => "darkgray";
recolor qr/You try to move the boulder, but in vain./ => "darkgray";
# }}}
# pets {{{
recolor qr/You displaced your [^.?!]*./ => "darkgray";
recolor qr/You stop[^.?!]*.  Your .*? is in the way!/ => "darkgray";
# }}}
# fountains {{{
recolor qr/You hear water falling on coins./ => "darkgray";
recolor qr/You hear bubbling water./ => "darkgray";
recolor qr/You hear the splashing of a naiad./ => "darkgray";
# }}}
# vaults {{{
recolor qr/You hear someone counting money./ => "darkgray";
recolor qr/You hear the footsteps of a guard on patrol./ => "darkgray";
# }}}
# misc {{{
recolor qr/Unknown command '[^']+'./ => "darkgray";
recolor qr/--More--/ => "darkgray";
# }}}
# }}}

# good messages {{{
# gain ability/level {{{
recolor qr/You feel (?:strong|agile|tough|smart|wise|charismatic)!/ => "purple";
recolor qr/Welcome to experience level \d+./ => "purple";
# }}}
# wishing {{{
recolor qr/For what do you wish\?/ => "purple";
# }}}
# resists {{{
recolor qr/You feel (?:(?:especially )?healthy|hardy)./ => "green";
recolor qr/You feel (?:full of hot air|warm)./ => "green";
recolor qr/You (?:feel a momentary chill|feel cool|be chillin')./ => "green";
recolor qr/You feel (?:wide )?awake./ => "green";
recolor qr/You feel (?:very firm|totally together, man)./ => "green";
recolor qr/Your health currently feels amplified!/ => "green";
recolor qr/You feel (?:insulated|grounded in reality)./ => "green";
# }}}
# other intrinsics {{{
recolor qr/You feel (?:very jumpy|diffuse)./ => "blue";
recolor qr/You feel (?:in control of yourself|centered in your personal space)./ => "blue";
recolor qr/You feel controlled/ => "blue";
recolor qr/You feel (?:a strange mental acuity|in touch with the cosmos)./ => "blue";
recolor qr/You feel (?:hidden|perceptive|stealthy|sensitive)./ => "blue";
recolor qr/You feel (?:very self-conscious|transparent)./ => "blue";
recolor qr/You see an image of someone stalking you./ => "blue";
recolor qr/Your vision becomes clear./ => "blue";
recolor qr/You (?:seem faster|feel quick)./ => "blue";
# }}}
# skills {{{
recolor qr/You feel more confident in your.*? skills./ => "cyan";
recolor qr/You feel you could be more dangerous!/ => "cyan";
# }}}
# misc {{{
recolor qr/You feel a mild buzz./ => "bblue";
# }}}
# }}}

# dangerous messages {{{
# attack effects {{{
recolor qr/Goodbye level \d+./ => "red";
recolor qr/The [^.!\e]*? grabs you./ => "red";
# }}}
# pets {{{
recolor qr/The .*? yowls!/ => "red";
recolor qr/You have a (?:sad|peculiar) feeling for a moment, then it passes\./ => "red";
# }}}
# negative status effects {{{
recolor qr/Oh wow!  Great stuff!/ => "red";
recolor qr/You reel.../ => "red";
recolor qr/You feel somewhat dizzy./ => "red";
recolor qr/You feel feverish./ => "red";
recolor qr/You can't see in here./ => "red";
recolor qr/Everything suddenly goes dark./ => "red";
recolor qr/The world spins and goes dark./ => "red";
# }}}
# losing resists {{{
recolor qr/You feel (?:warmer|a little sick|cooler|tired|conductive)./ => "red";
# }}}
# losing intrinsics {{{
recolor qr/You seem slower./ => "red";
recolor qr/You feel (?:slow|slower)./ => "red";
recolor qr/You feel (?:less attractive|paranoid|vulnerable|clumsy)./ => "red";
recolor qr/You feel (?:uncontrolled|less jumpy)./ => "red";
recolor qr/You (?:thought you saw something|tawt you taw a puttie tat)./ => "red";
recolor qr/Your senses fail./ => "red";
# }}}
# hunger {{{
recolor qr/You are beginning to feel hungry./ => "red";
recolor qr/You are beginning to feel weak./ => "red";
recolor qr/(?:Wizard|Valkyrie|Elf) needs food, badly!/ => "red";
# }}}
# encumbrance {{{
recolor qr/Your movements are slowed slightly because of your load\./ => "red";
recolor qr/You rebalance your load\.  Movement is difficult\./ => "bred";
recolor qr/You stagger under your heavy load\.  Movement is very hard\./ => "bred";
recolor qr/You can barely move a handspan with this load!/ => "bred";
recolor qr/You can't even move a handspan with this load!/ => "bred";
# }}}
# serious life threatening issues {{{
recolor qr/You faint from lack of food./ => "bred";
recolor qr/Stop eating\?/ => "bred";
recolor qr/You are slowing down./ => "bred";
recolor qr/Your limbs are stiffening./ => "bred";
recolor qr/You (?:don't feel very well|are turning a little green)./ => "bred";
recolor qr/Your (?:limbs are getting oozy|skin begins to peel away)./ => "bred";
recolor qr/You are turning into a green slime./ => "bred";
recolor qr/You feel deathly sick./ => "bred";
recolor qr/You feel (?:much|even) worse./ => "bred";
recolor qr/The .*? swings itself around you!/ => "bred";
recolor qr/Really quit\?/ => "bred";
# }}}
# }}}

# useful messages {{{
# shops {{{
recolor qr/You hear someone cursing shoplifters./ => "yellow";
recolor qr/You hear the chime of a cash register./ => "yellow";
# }}}
# }}}

# plot {{{
recolor qr/[Tt]he high priest(?:ess)? of (?!Moloch)\S+/ => "yellow";
recolor qr/You feel a strange vibration [^.?!]*./ => "yellow";
# }}}

# misc {{{
recolor  qr/Elbereth/i => "purple";
# }}}
