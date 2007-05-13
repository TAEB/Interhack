my $ves = qr/f|ves/;
my $us = qr/us|i/;
my $es = qr/(?:es)?/;
my $ies = qr/y|ies/;

# team a {{{
recolor qr/giant ants?/ => "brown";
recolor qr/killer bees?/ => "yellow";
recolor qr/soldier ants?/ => "blue";
recolor qr/fire ants?/ => "red";
recolor qr/giant beetles?/ => "gray";
recolor qr/queen bees?/ => "purple";
# }}}

# team b {{{
recolor qr/acid blobs?/ => "green";
recolor qr/quivering blobs?/ => "white";
recolor qr/gelatinous cubes?/ => "cyan";
# }}}

# team c {{{
recolor qr/chickatrices?/ => "brown";
recolor qr/cockatrices?/ => "bbrown";
recolor qr/pyrolisks?/ => "red";
# }}}

# team d {{{
recolor qr/(?:were)?jackals?|coyotes?/ => "brown";
recolor qr/(?:were)?wol$ves|wargs?/ => "brown";
recolor qr/foxes?/ => "red";
recolor qr/(?:little|large)? dogs?|dingos?/ => "bwhite";
recolor qr/winter wolf cubs?|winter wol$ves/ => "cyan";
recolor qr/hell hounds?|hell hound pups?/ => "red";
# }}}

# team e {{{
recolor qr/gas spores?/ => "gray";
recolor qr/floating eyes?/ => "bcyan";
recolor qr/freezing spheres?/ => "bwhite";
recolor qr/flaming spheres?/ => "red";
recolor qr/shocking spheres?/ => "bblue";
# }}}

# team f {{{
recolor qr/kittens?|(?:house|large )cats?/ => "bwhite";
recolor qr/jaguars?/ => "brown";
recolor qr/lynxes?/ => "cyan";
recolor qr/panthers?/ => "gray";
recolor qr/tigers?/ => "bbrown";
# {{{

# team g {{{
recolor qr/gremlins?/ => "green";
recolor qr/gargoyles?/ => "brown";
recolor qr/winged gargoyles?/ => "purple";
# }}}

# team h {{{
recolor qr/hobbits?/ => "green";
recolor qr/dwar$ves/ => "red";
recolor qr/bugbears?/ => "brown";
recolor qr/dwarf lords?/ => "blue";
recolor qr/dwarf kings?/ => "purple";
recolor qr/mind flayers?/ => "purple";
recolor qr/master mind flayers?/ => "purple";
# }}}

# team i {{{
recolor qr/manes|imps?/ => "red";
recolor qr/homuncul$us/ => "green";
recolor qr/lemures?/ => "brown";
recolor qr/quasits?/ => "blue";
recolor qr/tengus?/ => "cyan";
# }}}

# team j {{{
recolor qr/blue jellys?/ => "blue";
recolor qr/spotted jellys?/ => "green";
recolor qr/ochre jellys?/ => "brown";
# }}}

# team k {{{
recolor qr/kobolds?/ => "brown";
recolor qr/large kobolds?/ => "red";
recolor qr/kobold lords?/ => "purple";
recolor qr/kobold shamans?/ => "bblue";
# }}}

# team l {{{
recolor qr/leprechauns?/ => "green";
# }}}

# team m {{{
recolor qr/small mimics?/ => "brown";
recolor qr/large mimics?/ => "red";
recolor qr/giant mimics?/ => "purple";
# }}}

# team n {{{
recolor qr/wood nymphs?/ => "green";
recolor qr/water nymphs?/ => "blue";
recolor qr/mountain nymphs?/ => "brown";
# }}}

# team o {{{
recolor qr/goblins?/ => "bgray";
recolor qr/hobgoblins?/ => "brown";
recolor qr/orcs?/ => "red";
recolor qr/hill orcs?/ => "bbrown";
recolor qr/Mordor orcs?/ => "blue";
recolor qr/Uruk-hai/ => "gray";
recolor qr/orc shamans?/ => "bblue";
recolor qr/orc-captains?/ => "purple";
# }}}

# team p {{{
recolor qr/rock piercers?/ => "bgray";
recolor qr/iron piercers?/ => "cyan";
recolor qr/glass piercers?/ => "bwhite";
# }}}

# team q {{{
recolor qr/rothes?/ => "brown";
recolor qr/mumaks?|titanotheres?|baluchitheri(?:um|a)/ => "bgray";
recolor qr/leocrottas?/ => "red";
recolor qr/wumpus$es/ => "cyan";
recolor qr/mastodons?/ => "gray";

# team r {{{
recolor qr/(?:sewer |rabid |giant |were)rats?/ => "brown";
recolor qr/rock moles?/ => "bgray";
recolor qr/woodchucks?/ => "bpurple";
# }}}

# team s {{{
recolor qr/cave spiders?/ => "bgray";
recolor qr/centipedes?/ => "bbrown";
recolor qr/giant spiders?/ => "purple";
recolor qr/scorpions?/ => "red";
# }}}

# team t {{{
recolor qr/lurkers? above/ => "bgray";
recolor qr/trappers?/ => "green";
# }}}

# team u {{{
recolor qr/white unicorns?/ => "white";
recolor qr/gray unicorns?/ => "bgray";
recolor qr/black unicorns?/ => "gray";
recolor qr/pon$ies|(?:war)?horses?/ => "brown";
# }}}

# team v {{{
recolor qr/fog clouds?/ => "bgray";
recolor qr/dust vortex$es/ => "brown";
recolor qr/ice vortex$es/ => "cyan";
recolor qr/energy vortex$es/ => "bblue";
recolor qr/steam vortexs$es/ => "blue";
recolor qr/fire vortexs$es/ => "bbrown";
# }}}

# team w {{{
recolor qr/(?:baby )?long worms?/ => "brown";
recolor qr/(?:baby )?purple worms?/ => "purple";
# }}}

# team x {{{
recolor qr/grid bugs?/ => "purple";
recolor qr/xans?/ => "red";
# }}}

# team y {{{
recolor qr/yellow lights?/ => "bbrown";
recolor qr/black lights?/ => "gray";
# }}}

# team z {{{
recolor qr/zruty$ies/ => "brown";
# }}}

# team A {{{
recolor qr/couatls?/ => "green";
recolor qr/Aleaxs?/ => "bbrown";
recolor qr/Angels?/ => "bwhite";
recolor qr/ki-rins?/ => "bbrown";
recolor qr/Archons?/ => "purple";
# }}}

# team B {{{
recolor qr/bats?/ => "brown";
recolor qr/giant bats?/ => "red";
recolor qr/ravens?/ => "gray";
recolor qr/vampire bats?/ => "gray";
# }}}

# team C {{{
recolor qr/plains centaurs?/ => "brown";
recolor qr/forest centaurs?/ => "green";
recolor qr/mountain centaurs?/ => "cyan";
# }}}

# team D {{{
recolor qr/(?:baby )?gray dragons?/ => "bgray";
recolor qr/(?:baby )?silver dragons?/ => "cyan";
recolor qr/(?:baby )?red dragons?/ => "red";
recolor qr/(?:baby )?white dragons?/ => "bwhite";
recolor qr/(?:baby )?orange dragons?/ => "orange";
recolor qr/(?:baby )?black dragons?/ => "bgray";
recolor qr/(?:baby )?blue dragons?/ => "blue";
recolor qr/(?:baby )?green dragons?/ => "green";
recolor qr/(?:baby )?yellow dragons?/ => "bbrown";
# }}}

# team E {{{
recolor qr/stalkers?/ => "bwhite";
recolor qr/air elementals?/ => "bblue";
recolor qr/fire elementals?/ => "bbrown";
recolor qr/earth elementals?/ => "brown";
recolor qr/water elementals?/ => "blue";
# }}}

# team F {{{
recolor qr/lichens?/ => "bgreen";
recolor qr/brown molds?/ => "brown";
recolor qr/yellow molds?/ => "bbrown";
recolor qr/green molds?/ => "green";
recolor qr/red molds?/ => "red";
recolor qr/shriekers?|violet fung$us/ => "purple";
# }}}

# team G {{{
recolor qr/gnomes?/ => "brown";
recolor qr/gnome lords?/ => "blue";
recolor qr/gnomish wizards?/ => "bblue";
recolor qr/gnome kings?/ => "purple";
# }}}

# team H {{{
recolor qr/giants?/ => "red";
recolor qr/stone giants?/ => "bgray";
recolor qr/hill giants?/ => "cyan";
recolor qr/fire giants?/ => "bbrown";
recolor qr/frost giants?/ => "bwhite";
recolor qr/storm giants?/ => "blue";
recolor qr/ettins?|minotaurs?/ => "brown";
recolor qr/titans?/ => "purple";
# }}}

# team J {{{
recolor qr/jabberwocks?/ => "borange";
# }}}

# team K {{{
recolor qr/Keystone Kops?|Kop Sergeants?/ => "blue";
recolor qr/Kop Lieutenants?/ => "cyan";
recolor qr/Kop Kaptains?/ => "purple";
# }}}

# demons & {{{
recolor qr/Death|Pestilence|Famine/ => "purple";
recolor qr/Orcus|Baalzebub|Asmodeus/ => "purple";
recolor qr/Juiblex/ => "bgreen";
recolor qr/Yeenoghu|Geryon|Dispater|Demogorgon/ => "purple";

recolor qr/djinni?/ => "yellow";
recolor qr/balrogs?|pit fiends?|nalfeshnees?|horned devils?/ => "red";
recolor qr/barbed devils?|mariliths?|vrocks?|hezrous?/ => "red";
recolor qr/(?:suc|in)cub$us|sandestins?|bone devils?/ => "gray";
recolor qr/ice devils?/ => "white";
recolor qr/mail daemons?/ => "bblue";
recolor qr/water demons?/ => "blue";
# }}}

# ghosts and shades X {{{
recolor qr/ghosts?|shades?/ => "white";
# }}}

