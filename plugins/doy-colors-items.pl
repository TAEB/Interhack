# buc {{{
recolor qr/(?<![Uu]n)[Cc]ursed/ => "red";
recolor qr/[Bb]lessed/ => "green";
recolor qr/[Uu]ncursed/ => "brown";
# }}}

# enchantment/charges {{{
recolor qr/\(\d+:\d+\)/ => "cyan";
recolor qr/\(\d+:0\)/ => "darkgray";
recolor qr/\s\+0/ => "brown";
recolor qr/\s\+[1-9]\d*/ => "green";
recolor qr/(?<!AC)\s\-[1-9]\d*/ => "red";
# }}}

# erosion {{{
recolor qr/(very|thoroughly)? ?(rusty|burnt|rotted|corroded)/ => "red";
# }}}

# important items {{{
recolor qr/Amulet of Yendor/ => "magenta";
recolor qr/Bell of Opening/ => "magenta";
recolor qr/silver bell/ => "magenta";
recolor qr/Candelabrum of Invocation/ => "magenta";
recolor qr/candelabrum/ => "magenta";
recolor qr/Book of the Dead/ => "magenta";
recolor qr/papyrus spellbook/ => "magenta";
# }}}

# dangerous items {{{
recolor qr/(?<=wand of )cancellation/ => "bred";
recolor qr/(cock|chick)atrice corpse/ => "bred";
recolor qr/bag of tricks/ => "bred";
recolor qr/vanish(es)?/ => "bred";
# }}}

# gold {{{
recolor qr/\d+ (gold piece|zorkmid)s?/ => "yellow";
# }}}

# water {{{
recolor qr/(?<= of )water/ => "cyan";
recolor qr/(?<!un)holy/ => "blue";
recolor qr/unholy/ => "bred";
# }}}
