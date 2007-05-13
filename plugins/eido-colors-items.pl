# common regexes {{{
my $called = qr/called|of/;
# }}}

# BUC {{{
recolor qr/(?<=named )!C\b/ => "brown";
recolor qr/(?<=named )!B\b/ => "brown";
recolor qr/(?<=named )!UC\b/ => "brown";

recolor qr/\buncursed\b|(?<=named )UC?\b/ => "brown";
recolor qr/\bblessed\b|(?<=named )B\b/ => "cyan";
recolor qr/\bcursed\b|(?<=named )C\b/ => "red";
# }}}

# water sports {{{
recolor qr/\bholy water\b/ => "bcyan";
recolor qr/\bblessed clear potions?\b/ => "bcyan";
recolor qr/\bblessed potions? called water\b/ => "bcyan";
recolor qr/\bclear potions? named \b(?:holy|blessed|B)\b/ => "bcyan";
recolor qr/\bpotions? of water named \b(?:holy|blessed|B)\b/ => "bcyan";
recolor qr/\bpotions? called water named \b(holy|blessed|B)\b/ => "bcyan";

recolor qr/\bunholy water\b/ => "orange";
recolor qr/\bcursed clear potions?\b/ => "orange";
recolor qr/\bcursed potions? called water\b/ => "orange";
recolor qr/\bclear potions? named \b(?:unholy|cursed|C)\b/ => "orange";
recolor qr/\bpotions? of water named \b(?:unholy|cursed|C)\b/ => "orange";
recolor qr/\bpotions? called water named (?:unholy|cursed|C)\b/ => "orange";
# }}}

# food conducts {{{
# vegan {{{
recolor qr/\b(?:food |cram |[KC]-)rations?\b/ => "bgreen";
recolor qr/\btins? (?:called|named|of) spinach/ => "bgreen";
recolor qr/\boranges?(?! dragon| gem)\b/ => "bgreen";
recolor qr/\bpears?\b/ => "bgreen";
recolor qr/\b(?:gunyoki|lembas wafer|melon|carrot|pear|apple|banana|kelp frond|slime mold|brain)s?\b/ => "bgreen";
recolor qr/\bsprigs? of wolfsbane\b/ => "bgreen";
recolor qr/\beucalyptus lea(?:f|ves)\b/ => "bgreen";
recolor qr/\bcloves? of garlic\b/ => "bgreen";
recolor qr/\b(?:tin of )?(?:gelatinous cube|acid blob|quivering blob|lichen|shrieker|violet fungus|(?:blue|spotted|ochre) jelly|(?:brown|yellow|green) mold)(?: corpse)?\b/ => "bgreen";
# }}}

# vegetarian {{{
recolor qr/\b(?:egg|pancake|fortune cookie|candy bar|cream pie)s?\b/ => "green";
recolor qr/\blumps? of royal jelly\b/ => "green";
recolor qr/\b(?:tin of )?(?:brown pudding|gray ooze)(?: corpse)?\b/ => "green";
# }}}
# }}}

# goodies {{{
recolor qr/(?<!cursed )\bbag $called holding\b/ => "magenta";
recolor qr/(?<!cursed )\b(?:stone called )?luck(?:stone)?\b/ => "magenta";
recolor qr/\bwand $called wishing\b/ => "magenta";
recolor qr/\bmagic marker\b/ => "magenta";
recolor qr/\bmagic lamp\b/ => "magenta";
recolor qr/\blamp called magic\b/ => "magenta";
recolor qr/(?<!cursed )\bunicorn horn\b(?!\s+\[)/ => "magenta";
recolor qr/\btinning kit\b/ => "magenta";
recolor qr/\bring $called regen(?:eration)?\b/ => "magenta";
recolor qr/\bring $called conflict\b/ => "magenta";
recolor qr/\bring $called (?:FA|free action)\b/ => "magenta";
recolor qr/\bring $called (?:TC|teleport control)\b/ => "magenta";
recolor qr/\bring $called lev(?:itation)?\b/ => "magenta";
recolor qr/\bamulet $called (?:LS|life ?saving)\b/ => "magenta";
recolor qr/\bamulet $called ref(?:lection)?\b/ => "magenta";
recolor qr/\bc(?:o|hi)ckatrice (?:corpse|egg)\b/ => "magenta";
recolor qr/\begg named cockatrice\b/ => "magenta";
recolor qr/\bstethoscope\b/ => "magenta";

# instruments {{{
recolor qr/\b(?:(?:tooled|fire|frost)? horn)\b/ => "magenta";
recolor qr/\bhorn $called (?:tooled|fire|frost)\b/ => "magenta";
recolor qr/\b(?:magic|wooden) (?:harp|flute)\b/ => "magenta";
recolor qr/\b(?:harp|flute) $called (?:magic|wooden)\b/ => "magenta";
recolor qr/\bbugle\b/ => "magenta";
# }}}
# }}}

# artifacts {{{
recolor qr/\b(?:Dragonbane|Fire Brand|Frost Brand|Ogresmasher|Trollsbane|Werebane)\b/ => "bgreen";

#lawful normal, quest
recolor qr/\b(?:Demonbane|Excalibur|Grayswandir|Snickersnee|Sunsword)\b/ => "bgreen";
recolor qr/\b(?:Orb of Detection|Sceptre of Might|Magic Mirror of Merlin|Mitre of Holiness|Tsurugi of Muramasa)\b/ => "bgreen";

#neutral normal, quest
recolor qr/\b(?:Cleaver|Giantslayer|Magicbane|Mjollnir|Vorpal Blade)\b/ => "bgreen";
recolor qr/\b(?:Heart of Ahriman|Staff of Aesculapius|Eyes of the Overworld|Platinum Yendorian Express Card|Orb of Fate|Eye of the Aethiopica)\b/ => "bgreen";

#chaotic normal, quest
recolor qr/\b(?:Grimtooth|Orcrist|Sting|Stormbringer)\b/ => "bgreen";
recolor qr/\b(?:Longbow of Diana|Master Key of Thievery)\b/ => "bgreen";

#invocation items
recolor qr/(?<!cursed )\b(?:Bell of Opening|silver bell|Candelabrum of Invocation|candelabrum|Book of the Dead|papyrus spellbook)\b/ => "bmagenta";

#raison d'etre
recolor qr/\bAmulet of Yendor(?= named\b)/ => "bmagenta";
# }}}

# cursed goodies {{{
recolor qr/\bcursed bag $called holding\b/ => "bred";
recolor qr/\bcursed (?:stone called )?luck(?:stone)?\b/ => "bred";
recolor qr/\bcursed unicorn horn\b(?!\s+\[)/ => "bred";
recolor qr/\bcursed (?:Bell of Opening|silver bell|Candelabrum of Invocation|candelabrum|Book of the Dead|papyrus spellbook)\b/ => "bred";
# }}}

# bad stuff! {{{
recolor qr/\b(?:stone called )?(?<!your )load(?:stone)?\b/ => "bred";
# }}}

# watch out bag of holding {{{
recolor qr/\bbag $called tricks\b/ => "blue";
recolor qr/\bwand $called [^\e]*(?<!!)canc(?:ellation)?\b/ => "blue";
recolor qr/\bwand $called vanish(?:er)?\b/ => "blue";
# }}}

# shinies {{{
recolor qr/\d+ (?:gold piece|[Zz]orkmid)s?\b/ => "yellow";
recolor qr/\bgems? $called valuable\b(?: \w+\b)?/ => "brown";
recolor qr/\bgems? $called hard\b(?: \w+\b)?/ => "yellow";

# too tired to do this now {{{
#soft gems
#MENUCOLOR=" \([0-9]+\|an?\|gems? .*\) \(uncursed \|cursed \|blessed \)?\(dilithium\|opal\|garnet\|jasper\|agate\|jet\|obsidian\|jade\|citrine\|chrysoberyl\|amber\|amethyst\|fluorite\|turquoise\)\(e?s\)?\( stones?\| gems?\| crystals?\)?\( named .*\)?$"=brown
##hard gems
#MENUCOLOR=" \([0-9]+\|an?\|gems?.*\) \(uncursed \|cursed \|blessed \)?\(diamond\|rub\(y\|ies\)\|jacinth\|sapphire\|black opal\|emerald\|topaz\|aquamarine\)\(e?s\)?\( stones?\| gems?\)?\( named .*\)?$"=yellow
# }}}
# }}}

# interhack-specific stuff {{{
# charges and enchantment (originally from doy) {{{
recolor qr/(?<=\()0(?=:)/       => "cyan";  # 0 recharges
recolor qr/(?<=:)0(?=\))/       => "red";   # 0 charges
recolor qr/(?<=:)\d+(?=\))/     => "cyan";  # many charges
recolor qr/(?<=\()\d+(?=:)/     => "green"; # many recharges

recolor qr/\s\+0/               => "brown";
recolor qr/\s\+[1-3]/           => "green";
recolor qr/\s\+[4-9]\d*/        => "bgreen";
recolor qr/(?<!AC)\s\-[1-9]\d*/ => "red";
# }}}

# empty wands and tools {{{
recolor qr/(?<=named )empty\b/ => "darkgray";
# }}}

# item in use {{{
recolor qr/(?<=\()lit(?=\))/ => "yellow";

# equipment (originally by Stabwound) {{{
recolor qr/ \(weapon in [^)]+\)/ => "brown";
recolor qr/ \(wielded[^)]*\)/ => "brown";
recolor qr/ \(alternate weapon[^)]*\)/ => "brown";
recolor qr/ \(in quiver\)/ => "brown";
recolor qr/ \(being worn\)/ => "brown";
recolor qr/ \(embedded in your skin\)/ => "brown";
recolor qr/ \(on left [^)]+\)/ => "brown";
recolor qr/ \(on right [^)]+\)/ => "brown";
recolor qr/ \(in use\)/ => "brown";
# }}}
# }}}

# pretty useless items {{{
# scrolls {{{
recolor qr/scrolls? (?:called|of) (?:light|confuse monster|stinking cloud|punishment|fire|destroy armor|amnesia|create monster|food detection)\b/ => "darkgray";
# }}}

# potions {{{
recolor qr/potions? (?:called|of) (?:booze|sake|fruit juice|see invisible|sickness|confusion|hallucination|restore ability|sleeping|blindness|invisibility|monster detection|object detection|levitation|polymorph|acid|oil|paralysis)\b/ => "darkgray";
recolor qr/potions? called \w+ 150/ => "darkgray"; # only exception is gain energy and it's ok if we lose that one
# }}}

# rings {{{
recolor qr/ring (?:of|called) (?:adornment|hunger|protection(?: from shape changers)?|stealth|sustain ability|warning|aggravate monster|\w+ resistance|gain \w+|increase \w+|invisibility|see invisible|searching|polymorph(?: control)?)\b/ => "darkgray";
# }}}

# wands {{{
recolor qr/wand (?:called|of) (?:light|nothing|locking|make invisible|opening|probing|secret door detection|\w+ monster|undead turning|create monster)\b/ => "darkgray";
# }}}

# amulets {{{
recolor qr/amulet (?:called|of) (?:versus poison|change|ESP|magical breathing|restful sleep|strangulation|unchanging)\b/ => "darkgray";
recolor qr/amulet versus poison\b/ => "darkgray";
# }}}
# }}}

# unidentified magical armor {{{
recolor qr/(?:mud|buckled|riding|snow|hiking|combat|jungle) boots/ => "green";
recolor qr/piece of cloth|opera cloak|ornamental cope|tattered cape/ => "green";
recolor qr/(?:plumed|etched|crested|visored) helmet/ => "green";
recolor qr/(?:old|riding|padded|fencing) gloves/ => "green";
# }}}
# }}}
