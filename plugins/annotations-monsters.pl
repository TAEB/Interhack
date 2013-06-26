# Adds annotations for monsters queried via far-look
# uses data parsed from mon1-343.txt, as found on http://www.spod-central.org/~psmith/nh/mon1-343.txt
# --joc

my $attack_prefix = qr/[BEGHMSWX]/;
my $attack_roll = qr/[0-9]+(?:d[0-9]+)?/;
my $attack_suffix = qr/[ACDEFHMPRSVbcdehimrstwxz.+\-"&<#\$*@]|![CDI]/;
my $attack = qr/(?:[\[(])?$attack_prefix?$attack_roll$attack_suffix?(?:[\])])?/;

my $species = qr/[A-Za-z '@&;:]/;

my %passive_attack_str = (
	"[" => "pass.", # when killed
	"(" => "pass."  # when hit in melee
);

my %attack_types = (
	"B" => "breath",
	"E" => "engulf",
	"G" => "gaze",
	"H" => "hug",
	"M" => "spell",
	"S" => "spit",
	"W" => "weapon",
	"X" => "explode",
);

my %damage_types = (
	"A" => "acid",
	"C" => "cold",
	"D" => "disint.",
	"E" => "shock",
	"F" => "fire",
	"H" => "heal",
	"M" => "missiles",
	"P" => "Poison",
	"R" => "erode metal",
	"S" => "sleep",
	"V" => "drain lev",
	"b" => "blind",
	"c" => "confuse",
	"d" => "digest",
	"e" => "drain pw",
	"h" => "hallu",
	"i" => "steal intrinsic",
	"m" => "stick",
	"r" => "rot organics",
	"s" => "stun",
	"t" => "teleport",
	"w" => "wrap and drown",
	"x" => "prick legs",
	"z" => "special",
	"." => "paralyse",
	"+" => "spell",
	"-" => "steal",
	"\"" => "disenchant",
	"&" => "disrobe",
	"<" => "slow",
	"!C" => "drain con",
	"!D" => "drain dex",
	"!I" => "drain int",
	"#" => "disease",
	"\$" => "steal \$",
	"*" => "stone",
	"@" => "lycanthropy/slime",
);

my %resist_types = (
	"f" => "fire",
	"c" => "cold",
	"s" => "sleep",
	"d" => "disint.",
	"e" => "shock",
	"p" => "poison",
	"a" => "acid",
	"*" => "stoning",
);


#the following is parsed from mon1-343.txt

my %mondata = (
	"rope golem" => {
		"lev" => "4",
		"spd" => "9",
		"ac" => "8",
		"mr" => "0",
		"resists" => "sp",
		"attacks" => "1d4 1d4 H6d1"
	},
	"ape" => {
		"lev" => "4",
		"spd" => "12",
		"ac" => "6",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d3 1d3 1d6"
	},
	"trapper" => {
		"lev" => "12",
		"spd" => "3",
		"ac" => "3",
		"mr" => "0",
		"resists" => "",
		"attacks" => "E1d10d"
	},
	"yeti" => {
		"lev" => "5",
		"spd" => "15",
		"ac" => "6",
		"mr" => "0",
		"resists" => "C",
		"attacks" => "1d6 1d6 1d4"
	},
	"werewolf" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "10",
		"mr" => "20",
		"resists" => "p",
		"attacks" => "W2d4"
	},
	"wood nymph" => {
		"lev" => "3",
		"spd" => "12",
		"ac" => "9",
		"mr" => "20",
		"resists" => "",
		"attacks" => "0d0- 0d0-"
	},
	"fog cloud" => {
		"lev" => "3",
		"spd" => "1",
		"ac" => "0",
		"mr" => "0",
		"resists" => "sp*",
		"attacks" => "E1d6"
	},
	"iron golem" => {
		"lev" => "18",
		"spd" => "6",
		"ac" => "3",
		"mr" => "60",
		"resists" => "fcsep",
		"attacks" => "W4d10 B4d6P"
	},
	"aligned priest" => {
		"lev" => "12",
		"spd" => "12",
		"ac" => "10",
		"mr" => "50",
		"resists" => "e",
		"attacks" => "W4d10 1d4 M0d0+"
	},
	"orc mummy" => {
		"lev" => "5",
		"spd" => "10",
		"ac" => "5",
		"mr" => "20",
		"resists" => "csp",
		"attacks" => "1d6"
	},
	"brown mold" => {
		"lev" => "1",
		"spd" => "0",
		"ac" => "9",
		"mr" => "0",
		"resists" => "CP",
		"attacks" => "(0d6C)"
	},
	"soldier" => {
		"lev" => "6",
		"spd" => "10",
		"ac" => "10",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W1d8"
	},
	"wumpus" => {
		"lev" => "8",
		"spd" => "3",
		"ac" => "2",
		"mr" => "10",
		"resists" => "",
		"attacks" => "3d6"
	},
	"apprentice" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "10",
		"mr" => "30",
		"resists" => "",
		"attacks" => "W1d6 M0d0+"
	},
	"lich" => {
		"lev" => "11",
		"spd" => "6",
		"ac" => "0",
		"mr" => "30",
		"resists" => "Csp",
		"attacks" => "1d10C M0d0+"
	},
	"large dog" => {
		"lev" => "6",
		"spd" => "15",
		"ac" => "4",
		"mr" => "0",
		"resists" => "",
		"attacks" => "2d4"
	},
	"large mimic" => {
		"lev" => "8",
		"spd" => "3",
		"ac" => "7",
		"mr" => "10",
		"resists" => "a",
		"attacks" => "3d4m"
	},
	"kobold" => {
		"lev" => "0",
		"spd" => "6",
		"ac" => "10",
		"mr" => "0",
		"resists" => "p",
		"attacks" => "W1d4"
	},
	"chieftain" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "10",
		"mr" => "10",
		"resists" => "p",
		"attacks" => "W1d6"
	},
	"ice vortex" => {
		"lev" => "5",
		"spd" => "20",
		"ac" => "2",
		"mr" => "30",
		"resists" => "csp*",
		"attacks" => "E1d6C"
	},
	"baby white dragon" => {
		"lev" => "12",
		"spd" => "9",
		"ac" => "2",
		"mr" => "10",
		"resists" => "c",
		"attacks" => "2d6"
	},
	"captain" => {
		"lev" => "12",
		"spd" => "10",
		"ac" => "10",
		"mr" => "15",
		"resists" => "",
		"attacks" => "W4d4 W4d4"
	},
	"black light" => {
		"lev" => "5",
		"spd" => "15",
		"ac" => "0",
		"mr" => "0",
		"resists" => "fcsdepa*",
		"attacks" => "X10d12h"
	},
	"newt" => {
		"lev" => "0",
		"spd" => "6",
		"ac" => "8",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d2"
	},
	"arch-lich" => {
		"lev" => "25",
		"spd" => "9",
		"ac" => "-6",
		"mr" => "90",
		"resists" => "FCsep",
		"attacks" => "5d6C M0d0+"
	},
	"hobbit" => {
		"lev" => "1",
		"spd" => "9",
		"ac" => "10",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W1d6"
	},
	"baby red dragon" => {
		"lev" => "12",
		"spd" => "9",
		"ac" => "2",
		"mr" => "10",
		"resists" => "f",
		"attacks" => "2d6"
	},
	"couatl" => {
		"lev" => "8",
		"spd" => "10",
		"ac" => "5",
		"mr" => "30",
		"resists" => "p",
		"attacks" => "2d4P 1d3 H2d4w"
	},
	"gray dragon" => {
		"lev" => "15",
		"spd" => "9",
		"ac" => "-1",
		"mr" => "20",
		"resists" => "",
		"attacks" => "B4d6M 3d8 1d4 1d4"
	},
	"baby blue dragon" => {
		"lev" => "12",
		"spd" => "9",
		"ac" => "2",
		"mr" => "10",
		"resists" => "e",
		"attacks" => "2d6"
	},
	"freezing sphere" => {
		"lev" => "6",
		"spd" => "13",
		"ac" => "4",
		"mr" => "0",
		"resists" => "C",
		"attacks" => "X4d6C"
	},
	"baby purple worm" => {
		"lev" => "8",
		"spd" => "3",
		"ac" => "5",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d6"
	},
	"rock troll" => {
		"lev" => "9",
		"spd" => "12",
		"ac" => "0",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W3d6 2d8 2d6"
	},
	"forest centaur" => {
		"lev" => "5",
		"spd" => "18",
		"ac" => "3",
		"mr" => "10",
		"resists" => "",
		"attacks" => "W1d8 1d6"
	},
	"quivering blob" => {
		"lev" => "5",
		"spd" => "1",
		"ac" => "8",
		"mr" => "0",
		"resists" => "sP",
		"attacks" => "1d8"
	},
	"minotaur" => {
		"lev" => "15",
		"spd" => "15",
		"ac" => "6",
		"mr" => "0",
		"resists" => "",
		"attacks" => "3d10 3d10 2d8"
	},
	"red naga hatchling" => {
		"lev" => "3",
		"spd" => "10",
		"ac" => "6",
		"mr" => "0",
		"resists" => "FP",
		"attacks" => "1d4"
	},
	"blue jelly" => {
		"lev" => "4",
		"spd" => "0",
		"ac" => "8",
		"mr" => "10",
		"resists" => "CP",
		"attacks" => "(0d6C)"
	},
	"Twoflower" => {
		"lev" => "20",
		"spd" => "12",
		"ac" => "10",
		"mr" => "20",
		"resists" => "",
		"attacks" => "W1d6 W1d6"
	},
	"pyrolisk" => {
		"lev" => "6",
		"spd" => "6",
		"ac" => "6",
		"mr" => "30",
		"resists" => "FP",
		"attacks" => "G2d6F"
	},
	"priest" => {
		"lev" => "10",
		"spd" => "12",
		"ac" => "10",
		"mr" => "2",
		"resists" => "",
		"attacks" => "W1d6"
	},
	"ki-rin" => {
		"lev" => "16",
		"spd" => "18",
		"ac" => "-5",
		"mr" => "90",
		"resists" => "",
		"attacks" => "2d4 2d4 3d6 M2d6+"
	},
	"steam vortex" => {
		"lev" => "7",
		"spd" => "22",
		"ac" => "2",
		"mr" => "30",
		"resists" => "fsp*",
		"attacks" => "E1d8F"
	},
	"caveman" => {
		"lev" => "10",
		"spd" => "12",
		"ac" => "10",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W2d4"
	},
	"warg" => {
		"lev" => "7",
		"spd" => "12",
		"ac" => "4",
		"mr" => "0",
		"resists" => "",
		"attacks" => "2d6"
	},
	"purple worm" => {
		"lev" => "15",
		"spd" => "9",
		"ac" => "6",
		"mr" => "20",
		"resists" => "",
		"attacks" => "2d8 E1d10d"
	},
	"frost giant" => {
		"lev" => "10",
		"spd" => "12",
		"ac" => "3",
		"mr" => "10",
		"resists" => "C",
		"attacks" => "W2d12"
	},
	"Juiblex" => {
		"lev" => "50",
		"spd" => "3",
		"ac" => "-7",
		"mr" => "65",
		"resists" => "fpa*",
		"attacks" => "E4d10# S3d6A"
	},
	"marilith" => {
		"lev" => "7",
		"spd" => "12",
		"ac" => "-6",
		"mr" => "80",
		"resists" => "fp",
		"attacks" => "W2d4 W2d4 2d4 2d4 2d4 2d4"
	},
	"floating eye" => {
		"lev" => "2",
		"spd" => "1",
		"ac" => "9",
		"mr" => "10",
		"resists" => "",
		"attacks" => "(0d70.)"
	},
	"paper golem" => {
		"lev" => "3",
		"spd" => "12",
		"ac" => "10",
		"mr" => "0",
		"resists" => "sp",
		"attacks" => "1d3"
	},
	"kitten" => {
		"lev" => "2",
		"spd" => "18",
		"ac" => "6",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d6"
	},
	"Orion" => {
		"lev" => "20",
		"spd" => "12",
		"ac" => "0",
		"mr" => "30",
		"resists" => "",
		"attacks" => "W1d6"
	},
	"ogre king" => {
		"lev" => "9",
		"spd" => "14",
		"ac" => "4",
		"mr" => "60",
		"resists" => "",
		"attacks" => "W3d5"
	},
	"gnome king" => {
		"lev" => "5",
		"spd" => "10",
		"ac" => "10",
		"mr" => "20",
		"resists" => "",
		"attacks" => "W2d6"
	},
	"baby gray dragon" => {
		"lev" => "12",
		"spd" => "9",
		"ac" => "2",
		"mr" => "10",
		"resists" => "",
		"attacks" => "2d6"
	},
	"human" => {
		"lev" => "0",
		"spd" => "12",
		"ac" => "10",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W1d6"
	},
	"lichen" => {
		"lev" => "0",
		"spd" => "1",
		"ac" => "9",
		"mr" => "0",
		"resists" => "",
		"attacks" => "0d0m"
	},
	"dwarf zombie" => {
		"lev" => "2",
		"spd" => "6",
		"ac" => "9",
		"mr" => "0",
		"resists" => "csp",
		"attacks" => "1d6"
	},
	"mountain nymph" => {
		"lev" => "3",
		"spd" => "12",
		"ac" => "9",
		"mr" => "20",
		"resists" => "",
		"attacks" => "0d0- 0d0-"
	},
	"Hippocrates" => {
		"lev" => "20",
		"spd" => "12",
		"ac" => "0",
		"mr" => "40",
		"resists" => "p",
		"attacks" => "W1d6"
	},
	"Pestilence" => {
		"lev" => "30",
		"spd" => "12",
		"ac" => "-5",
		"mr" => "100",
		"resists" => "fcsep*",
		"attacks" => "8d8z 8d8z"
	},
	"quasit" => {
		"lev" => "3",
		"spd" => "15",
		"ac" => "2",
		"mr" => "20",
		"resists" => "P",
		"attacks" => "1d2!D 1d2!D 1d4"
	},
	"skeleton" => {
		"lev" => "12",
		"spd" => "8",
		"ac" => "4",
		"mr" => "0",
		"resists" => "csp*",
		"attacks" => "W2d6 1d6<"
	},
	"Uruk-hai" => {
		"lev" => "3",
		"spd" => "7",
		"ac" => "10",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W1d8"
	},
	"knight" => {
		"lev" => "10",
		"spd" => "12",
		"ac" => "10",
		"mr" => "1",
		"resists" => "",
		"attacks" => "W1d6 W1d6"
	},
	"Baalzebub" => {
		"lev" => "89",
		"spd" => "9",
		"ac" => "-5",
		"mr" => "85",
		"resists" => "fp",
		"attacks" => "2d6P G2d6s"
	},
	"Kop Kaptain" => {
		"lev" => "4",
		"spd" => "12",
		"ac" => "10",
		"mr" => "20",
		"resists" => "",
		"attacks" => "W2d6"
	},
	"guardian naga" => {
		"lev" => "12",
		"spd" => "16",
		"ac" => "0",
		"mr" => "50",
		"resists" => "P",
		"attacks" => "1d6. S1d6P H2d4"
	},
	"golden naga hatchlin" => {
		"lev" => "3",
		"spd" => "10",
		"ac" => "6",
		"mr" => "0",
		"resists" => "P",
		"attacks" => "1d4"
	},
	"abbot" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "10",
		"mr" => "20",
		"resists" => "",
		"attacks" => "8d2 3d2s M0d0+"
	},
	"xorn" => {
		"lev" => "8",
		"spd" => "9",
		"ac" => "-2",
		"mr" => "20",
		"resists" => "fc*",
		"attacks" => "1d3 1d3 1d3 4d6"
	},
	"wolf" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "4",
		"mr" => "0",
		"resists" => "",
		"attacks" => "2d4"
	},
	"yellow light" => {
		"lev" => "3",
		"spd" => "15",
		"ac" => "0",
		"mr" => "0",
		"resists" => "fcsdepa*",
		"attacks" => "X10d20b"
	},
	"black pudding" => {
		"lev" => "10",
		"spd" => "6",
		"ac" => "6",
		"mr" => "0",
		"resists" => "CEPa*",
		"attacks" => "3d8R (0d0R)"
	},
	"Keystone Kop" => {
		"lev" => "1",
		"spd" => "6",
		"ac" => "10",
		"mr" => "10",
		"resists" => "",
		"attacks" => "W1d4"
	},
	"hill giant" => {
		"lev" => "8",
		"spd" => "10",
		"ac" => "6",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W2d8"
	},
	"dust vortex" => {
		"lev" => "4",
		"spd" => "20",
		"ac" => "2",
		"mr" => "30",
		"resists" => "sp*",
		"attacks" => "E2d8b"
	},
	"giant beetle" => {
		"lev" => "5",
		"spd" => "6",
		"ac" => "4",
		"mr" => "0",
		"resists" => "P",
		"attacks" => "3d6"
	},
	"Neferet the Green" => {
		"lev" => "20",
		"spd" => "12",
		"ac" => "0",
		"mr" => "60",
		"resists" => "",
		"attacks" => "W1d6 M2d8+"
	},
	"gray unicorn" => {
		"lev" => "4",
		"spd" => "24",
		"ac" => "2",
		"mr" => "70",
		"resists" => "P",
		"attacks" => "1d12 1d6"
	},
	"acid blob" => {
		"lev" => "1",
		"spd" => "3",
		"ac" => "8",
		"mr" => "0",
		"resists" => "spa*",
		"attacks" => "(1d8A)"
	},
	"giant ant" => {
		"lev" => "2",
		"spd" => "18",
		"ac" => "3",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d4"
	},
	"large kobold" => {
		"lev" => "1",
		"spd" => "6",
		"ac" => "10",
		"mr" => "0",
		"resists" => "p",
		"attacks" => "W1d6"
	},
	"yellow mold" => {
		"lev" => "1",
		"spd" => "0",
		"ac" => "9",
		"mr" => "0",
		"resists" => "P",
		"attacks" => "(0d4s)"
	},
	"long worm" => {
		"lev" => "8",
		"spd" => "3",
		"ac" => "5",
		"mr" => "10",
		"resists" => "",
		"attacks" => "1d4"
	},
	"Thoth Amon" => {
		"lev" => "16",
		"spd" => "12",
		"ac" => "0",
		"mr" => "10",
		"resists" => "p*",
		"attacks" => "W1d6 M0d0+ M0d0+ 1d4-"
	},
	"red mold" => {
		"lev" => "1",
		"spd" => "0",
		"ac" => "9",
		"mr" => "0",
		"resists" => "FP",
		"attacks" => "(0d4F)"
	},
	"erinys" => {
		"lev" => "7",
		"spd" => "12",
		"ac" => "2",
		"mr" => "30",
		"resists" => "fp",
		"attacks" => "W2d4P"
	},
	"bat" => {
		"lev" => "0",
		"spd" => "22",
		"ac" => "8",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d4"
	},
	"elf mummy" => {
		"lev" => "6",
		"spd" => "12",
		"ac" => "4",
		"mr" => "30",
		"resists" => "csp",
		"attacks" => "2d4"
	},
	"elf-lord" => {
		"lev" => "8",
		"spd" => "12",
		"ac" => "10",
		"mr" => "20",
		"resists" => "S",
		"attacks" => "W2d4 W2d4"
	},
	"gas spore" => {
		"lev" => "1",
		"spd" => "3",
		"ac" => "10",
		"mr" => "0",
		"resists" => "",
		"attacks" => "[X4d6]"
	},
	"giant bat" => {
		"lev" => "2",
		"spd" => "22",
		"ac" => "7",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d6"
	},
	"Dark One" => {
		"lev" => "15",
		"spd" => "12",
		"ac" => "0",
		"mr" => "80",
		"resists" => "*",
		"attacks" => "W1d6 W1d6 1d4- M0d0+"
	},
	"panther" => {
		"lev" => "5",
		"spd" => "15",
		"ac" => "6",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d6 1d6 1d10"
	},
	"rust monster" => {
		"lev" => "5",
		"spd" => "18",
		"ac" => "2",
		"mr" => "0",
		"resists" => "",
		"attacks" => "0d0R 0d0R (0d0R)"
	},
	"fox" => {
		"lev" => "0",
		"spd" => "15",
		"ac" => "7",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d3"
	},
	"giant eel" => {
		"lev" => "5",
		"spd" => "9",
		"ac" => "-1",
		"mr" => "0",
		"resists" => "",
		"attacks" => "3d6 0d0w"
	},
	"leocrotta" => {
		"lev" => "6",
		"spd" => "18",
		"ac" => "4",
		"mr" => "10",
		"resists" => "",
		"attacks" => "2d6 2d6 2d6"
	},
	"gnome zombie" => {
		"lev" => "1",
		"spd" => "6",
		"ac" => "10",
		"mr" => "0",
		"resists" => "csp",
		"attacks" => "1d5"
	},
	"Nazgul" => {
		"lev" => "13",
		"spd" => "12",
		"ac" => "0",
		"mr" => "25",
		"resists" => "csp",
		"attacks" => "W1d4V B2d25S"
	},
	"baby long worm" => {
		"lev" => "8",
		"spd" => "3",
		"ac" => "5",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d6"
	},
	"human mummy" => {
		"lev" => "6",
		"spd" => "12",
		"ac" => "4",
		"mr" => "30",
		"resists" => "csp",
		"attacks" => "2d4 2d4"
	},
	"pit fiend" => {
		"lev" => "13",
		"spd" => "6",
		"ac" => "-3",
		"mr" => "65",
		"resists" => "fp",
		"attacks" => "W4d2 W4d2 H2d4"
	},
	"vampire lord" => {
		"lev" => "12",
		"spd" => "14",
		"ac" => "0",
		"mr" => "50",
		"resists" => "sp",
		"attacks" => "1d8 1d8V"
	},
	"guard" => {
		"lev" => "12",
		"spd" => "12",
		"ac" => "10",
		"mr" => "40",
		"resists" => "",
		"attacks" => "W4d10"
	},
	"shopkeeper" => {
		"lev" => "12",
		"spd" => "18",
		"ac" => "0",
		"mr" => "50",
		"resists" => "",
		"attacks" => "W4d4 W4d4"
	},
	"Olog-hai" => {
		"lev" => "13",
		"spd" => "12",
		"ac" => "-4",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W3d6 2d8 2d6"
	},
	"hobgoblin" => {
		"lev" => "1",
		"spd" => "9",
		"ac" => "10",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W1d6"
	},
	"succubus" => {
		"lev" => "6",
		"spd" => "12",
		"ac" => "0",
		"mr" => "70",
		"resists" => "fp",
		"attacks" => "0d0& 1d3 1d3"
	},
	"woodchuck" => {
		"lev" => "3",
		"spd" => "3",
		"ac" => "0",
		"mr" => "20",
		"resists" => "",
		"attacks" => "1d6"
	},
	"winter wolf cub" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "4",
		"mr" => "0",
		"resists" => "C",
		"attacks" => "1d8 B1d8C"
	},
	"Angel" => {
		"lev" => "14",
		"spd" => "10",
		"ac" => "-4",
		"mr" => "55",
		"resists" => "csep",
		"attacks" => "W1d6 W1d6 1d4 M2d6M"
	},
	"human zombie" => {
		"lev" => "4",
		"spd" => "6",
		"ac" => "8",
		"mr" => "0",
		"resists" => "csp",
		"attacks" => "1d8"
	},
	"golden naga" => {
		"lev" => "10",
		"spd" => "14",
		"ac" => "2",
		"mr" => "70",
		"resists" => "P",
		"attacks" => "2d6 M4d6+"
	},
	"baby yellow dragon" => {
		"lev" => "12",
		"spd" => "9",
		"ac" => "2",
		"mr" => "10",
		"resists" => "a*",
		"attacks" => "2d6"
	},
	"Arch Priest" => {
		"lev" => "25",
		"spd" => "12",
		"ac" => "7",
		"mr" => "70",
		"resists" => "fsep",
		"attacks" => "W4d10 2d8 M2d8+ M2d8+"
	},
	"winged gargoyle" => {
		"lev" => "9",
		"spd" => "15",
		"ac" => "-2",
		"mr" => "0",
		"resists" => "*",
		"attacks" => "3d6 3d6 3d4"
	},
	"black naga" => {
		"lev" => "8",
		"spd" => "14",
		"ac" => "2",
		"mr" => "10",
		"resists" => "Pa*",
		"attacks" => "2d6 S0d0A"
	},
	"fire giant" => {
		"lev" => "9",
		"spd" => "12",
		"ac" => "4",
		"mr" => "5",
		"resists" => "F",
		"attacks" => "W2d10"
	},
	"orc" => {
		"lev" => "1",
		"spd" => "9",
		"ac" => "10",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W1d8"
	},
	"hezrou" => {
		"lev" => "9",
		"spd" => "6",
		"ac" => "-2",
		"mr" => "55",
		"resists" => "fp",
		"attacks" => "1d3 1d3 4d4"
	},
	"winter wolf" => {
		"lev" => "7",
		"spd" => "12",
		"ac" => "4",
		"mr" => "20",
		"resists" => "C",
		"attacks" => "2d6 B2d6C"
	},
	"mountain centaur" => {
		"lev" => "6",
		"spd" => "20",
		"ac" => "2",
		"mr" => "10",
		"resists" => "",
		"attacks" => "W1d10 1d6 1d6"
	},
	"baluchitherium" => {
		"lev" => "14",
		"spd" => "12",
		"ac" => "5",
		"mr" => "0",
		"resists" => "",
		"attacks" => "5d4 5d4"
	},
	"tourist" => {
		"lev" => "10",
		"spd" => "12",
		"ac" => "10",
		"mr" => "1",
		"resists" => "",
		"attacks" => "W1d6 W1d6"
	},
	"giant mummy" => {
		"lev" => "8",
		"spd" => "14",
		"ac" => "3",
		"mr" => "30",
		"resists" => "csp",
		"attacks" => "3d4 3d4"
	},
	"chickatrice" => {
		"lev" => "4",
		"spd" => "4",
		"ac" => "8",
		"mr" => "30",
		"resists" => "P*",
		"attacks" => "1d2 0d0* (0d0*)"
	},
	"ninja" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "10",
		"mr" => "10",
		"resists" => "",
		"attacks" => "W1d8 W1d8"
	},
	"chameleon" => {
		"lev" => "6",
		"spd" => "5",
		"ac" => "6",
		"mr" => "10",
		"resists" => "",
		"attacks" => "4d2"
	},
	"ettin" => {
		"lev" => "10",
		"spd" => "12",
		"ac" => "3",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W2d8 W3d6"
	},
	"baby orange dragon" => {
		"lev" => "12",
		"spd" => "9",
		"ac" => "2",
		"mr" => "10",
		"resists" => "s",
		"attacks" => "2d6"
	},
	"fire ant" => {
		"lev" => "3",
		"spd" => "18",
		"ac" => "3",
		"mr" => "10",
		"resists" => "F",
		"attacks" => "2d4 2d4F"
	},
	"Cyclops" => {
		"lev" => "18",
		"spd" => "12",
		"ac" => "0",
		"mr" => "0",
		"resists" => "*",
		"attacks" => "W4d8 W4d8 2d6-"
	},
	"baby green dragon" => {
		"lev" => "12",
		"spd" => "9",
		"ac" => "2",
		"mr" => "10",
		"resists" => "p",
		"attacks" => "2d6"
	},
	"python" => {
		"lev" => "6",
		"spd" => "3",
		"ac" => "5",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d4 0d0 H1d4w H2d4"
	},
	"black naga hatchling" => {
		"lev" => "3",
		"spd" => "10",
		"ac" => "6",
		"mr" => "0",
		"resists" => "Pa*",
		"attacks" => "1d4"
	},
	"Scorpius" => {
		"lev" => "15",
		"spd" => "12",
		"ac" => "10",
		"mr" => "0",
		"resists" => "P*",
		"attacks" => "2d6 2d6- 1d4#"
	},
	"water demon" => {
		"lev" => "8",
		"spd" => "12",
		"ac" => "-4",
		"mr" => "30",
		"resists" => "fp",
		"attacks" => "W1d3 1d3 1d3"
	},
	"disenchanter" => {
		"lev" => "12",
		"spd" => "12",
		"ac" => "-10",
		"mr" => "0",
		"resists" => "",
		"attacks" => "4d4\" (0d0\")"
	},
	"quantum mechanic" => {
		"lev" => "7",
		"spd" => "12",
		"ac" => "3",
		"mr" => "10",
		"resists" => "p",
		"attacks" => "1d4t"
	},
	"wood golem" => {
		"lev" => "7",
		"spd" => "3",
		"ac" => "4",
		"mr" => "0",
		"resists" => "sp",
		"attacks" => "3d4"
	},
	"owlbear" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "5",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d6 1d6 H2d8"
	},
	"water troll" => {
		"lev" => "11",
		"spd" => "14",
		"ac" => "4",
		"mr" => "40",
		"resists" => "",
		"attacks" => "W2d8 2d8 2d6"
	},
	"homunculus" => {
		"lev" => "2",
		"spd" => "12",
		"ac" => "6",
		"mr" => "10",
		"resists" => "SP",
		"attacks" => "1d3S"
	},
	"warhorse" => {
		"lev" => "7",
		"spd" => "24",
		"ac" => "4",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d10 1d4"
	},
	"monk" => {
		"lev" => "10",
		"spd" => "12",
		"ac" => "10",
		"mr" => "2",
		"resists" => "",
		"attacks" => "1d8 1d8"
	},
	"water moccasin" => {
		"lev" => "4",
		"spd" => "15",
		"ac" => "3",
		"mr" => "0",
		"resists" => "P",
		"attacks" => "1d6P"
	},
	"hill orc" => {
		"lev" => "2",
		"spd" => "9",
		"ac" => "10",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W1d6"
	},
	"priestess" => {
		"lev" => "10",
		"spd" => "12",
		"ac" => "10",
		"mr" => "2",
		"resists" => "",
		"attacks" => "W1d6"
	},
	"small mimic" => {
		"lev" => "7",
		"spd" => "3",
		"ac" => "7",
		"mr" => "0",
		"resists" => "a",
		"attacks" => "3d4"
	},
	"tiger" => {
		"lev" => "6",
		"spd" => "12",
		"ac" => "6",
		"mr" => "0",
		"resists" => "",
		"attacks" => "2d4 2d4 1d10"
	},
	"Lord Surtur" => {
		"lev" => "15",
		"spd" => "12",
		"ac" => "2",
		"mr" => "50",
		"resists" => "F*",
		"attacks" => "W2d10 W2d10 2d6-"
	},
	"kobold lord" => {
		"lev" => "2",
		"spd" => "6",
		"ac" => "10",
		"mr" => "0",
		"resists" => "p",
		"attacks" => "W2d4"
	},
	"werejackal" => {
		"lev" => "2",
		"spd" => "12",
		"ac" => "10",
		"mr" => "10",
		"resists" => "p",
		"attacks" => "W2d4"
	},
	"cobra" => {
		"lev" => "6",
		"spd" => "18",
		"ac" => "2",
		"mr" => "0",
		"resists" => "P",
		"attacks" => "2d4P S0d0b"
	},
	"rock piercer" => {
		"lev" => "3",
		"spd" => "1",
		"ac" => "3",
		"mr" => "0",
		"resists" => "",
		"attacks" => "2d6"
	},
	"titan" => {
		"lev" => "16",
		"spd" => "18",
		"ac" => "-3",
		"mr" => "70",
		"resists" => "",
		"attacks" => "W2d8 M0d0+"
	},
	"white dragon" => {
		"lev" => "15",
		"spd" => "9",
		"ac" => "-1",
		"mr" => "20",
		"resists" => "C",
		"attacks" => "B4d6C 3d8 1d4 1d4"
	},
	"brown pudding" => {
		"lev" => "5",
		"spd" => "3",
		"ac" => "8",
		"mr" => "0",
		"resists" => "CEPa*",
		"attacks" => "0d0r"
	},
	"gnome" => {
		"lev" => "1",
		"spd" => "6",
		"ac" => "10",
		"mr" => "4",
		"resists" => "",
		"attacks" => "W1d6"
	},
	"warrior" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "10",
		"mr" => "10",
		"resists" => "",
		"attacks" => "W1d8 W1d8"
	},
	"electric eel" => {
		"lev" => "7",
		"spd" => "10",
		"ac" => "-3",
		"mr" => "0",
		"resists" => "E",
		"attacks" => "4d6E 0d0w"
	},
	"stone golem" => {
		"lev" => "14",
		"spd" => "6",
		"ac" => "5",
		"mr" => "50",
		"resists" => "sp*",
		"attacks" => "3d8"
	},
	"storm giant" => {
		"lev" => "16",
		"spd" => "12",
		"ac" => "3",
		"mr" => "10",
		"resists" => "E",
		"attacks" => "W2d12"
	},
	"gold golem" => {
		"lev" => "5",
		"spd" => "9",
		"ac" => "6",
		"mr" => "0",
		"resists" => "spa",
		"attacks" => "2d3 2d3"
	},
	"hunter" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "10",
		"mr" => "10",
		"resists" => "",
		"attacks" => "W1d4"
	},
	"zruty" => {
		"lev" => "9",
		"spd" => "8",
		"ac" => "3",
		"mr" => "0",
		"resists" => "",
		"attacks" => "3d4 3d4 3d6"
	},
	"sasquatch" => {
		"lev" => "7",
		"spd" => "15",
		"ac" => "6",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d6 1d6 1d8"
	},
	"jaguar" => {
		"lev" => "4",
		"spd" => "15",
		"ac" => "6",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d4 1d4 1d8"
	},
	"nurse" => {
		"lev" => "11",
		"spd" => "6",
		"ac" => "0",
		"mr" => "0",
		"resists" => "P",
		"attacks" => "2d6H"
	},
	"Grand Master" => {
		"lev" => "25",
		"spd" => "12",
		"ac" => "0",
		"mr" => "70",
		"resists" => "fsep",
		"attacks" => "4d10 2d8 M2d8+ M2d8+"
	},
	"ranger" => {
		"lev" => "10",
		"spd" => "12",
		"ac" => "10",
		"mr" => "2",
		"resists" => "",
		"attacks" => "W1d4"
	},
	"stalker" => {
		"lev" => "8",
		"spd" => "12",
		"ac" => "3",
		"mr" => "0",
		"resists" => "",
		"attacks" => "4d4"
	},
	"soldier ant" => {
		"lev" => "3",
		"spd" => "18",
		"ac" => "3",
		"mr" => "0",
		"resists" => "P",
		"attacks" => "2d4 3d4P"
	},
	"titanothere" => {
		"lev" => "12",
		"spd" => "12",
		"ac" => "6",
		"mr" => "0",
		"resists" => "",
		"attacks" => "2d8"
	},
	"jabberwock" => {
		"lev" => "15",
		"spd" => "12",
		"ac" => "-2",
		"mr" => "50",
		"resists" => "",
		"attacks" => "2d10 2d10 2d10 2d10"
	},
	"archeologist" => {
		"lev" => "10",
		"spd" => "12",
		"ac" => "10",
		"mr" => "1",
		"resists" => "",
		"attacks" => "W1d6 W1d6"
	},
	"baby crocodile" => {
		"lev" => "3",
		"spd" => "6",
		"ac" => "7",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d4"
	},
	"glass piercer" => {
		"lev" => "7",
		"spd" => "1",
		"ac" => "0",
		"mr" => "0",
		"resists" => "a",
		"attacks" => "4d6"
	},
	"watchman" => {
		"lev" => "6",
		"spd" => "10",
		"ac" => "10",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W1d8"
	},
	"stone giant" => {
		"lev" => "6",
		"spd" => "6",
		"ac" => "0",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W2d10"
	},
	"gremlin" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "2",
		"mr" => "25",
		"resists" => "P",
		"attacks" => "1d6 1d6 1d4 0d0i"
	},
	"black dragon" => {
		"lev" => "15",
		"spd" => "9",
		"ac" => "-1",
		"mr" => "20",
		"resists" => "D",
		"attacks" => "B4d10D 3d8 1d4 1d4"
	},
	"Nalzok" => {
		"lev" => "16",
		"spd" => "12",
		"ac" => "-2",
		"mr" => "85",
		"resists" => "fp*",
		"attacks" => "W8d4 W4d6 M0d0+ 2d6-"
	},
	"elf" => {
		"lev" => "10",
		"spd" => "12",
		"ac" => "10",
		"mr" => "2",
		"resists" => "S",
		"attacks" => "W1d8"
	},
	"giant spider" => {
		"lev" => "5",
		"spd" => "15",
		"ac" => "4",
		"mr" => "0",
		"resists" => "P",
		"attacks" => "2d4P"
	},
	"crocodile" => {
		"lev" => "6",
		"spd" => "9",
		"ac" => "5",
		"mr" => "0",
		"resists" => "",
		"attacks" => "4d2 1d12"
	},
	"Green-elf" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "10",
		"mr" => "10",
		"resists" => "S",
		"attacks" => "W2d4"
	},
	"Woodland-elf" => {
		"lev" => "4",
		"spd" => "12",
		"ac" => "10",
		"mr" => "10",
		"resists" => "S",
		"attacks" => "W2d4"
	},
	"flesh golem" => {
		"lev" => "9",
		"spd" => "8",
		"ac" => "9",
		"mr" => "30",
		"resists" => "FCSEP",
		"attacks" => "2d8 2d8"
	},
	"Kop Sergeant" => {
		"lev" => "2",
		"spd" => "8",
		"ac" => "10",
		"mr" => "10",
		"resists" => "",
		"attacks" => "W1d6"
	},
	"King Arthur" => {
		"lev" => "20",
		"spd" => "12",
		"ac" => "0",
		"mr" => "40",
		"resists" => "",
		"attacks" => "W1d6 W1d6"
	},
	"attendant" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "10",
		"mr" => "10",
		"resists" => "p",
		"attacks" => "W1d6"
	},
	"Ashikaga Takauji" => {
		"lev" => "15",
		"spd" => "12",
		"ac" => "0",
		"mr" => "40",
		"resists" => "*",
		"attacks" => "W2d6 W2d6 2d6-"
	},
	"flaming sphere" => {
		"lev" => "6",
		"spd" => "13",
		"ac" => "4",
		"mr" => "0",
		"resists" => "F",
		"attacks" => "X4d6F"
	},
	"kobold shaman" => {
		"lev" => "2",
		"spd" => "6",
		"ac" => "6",
		"mr" => "10",
		"resists" => "p",
		"attacks" => "M0d0+"
	},
	"energy vortex" => {
		"lev" => "6",
		"spd" => "20",
		"ac" => "2",
		"mr" => "30",
		"resists" => "sdep*",
		"attacks" => "E1d6E E0d0e (0d4E)"
	},
	"gnomish wizard" => {
		"lev" => "3",
		"spd" => "10",
		"ac" => "4",
		"mr" => "10",
		"resists" => "",
		"attacks" => "M0d0+"
	},
	"gnome mummy" => {
		"lev" => "4",
		"spd" => "10",
		"ac" => "6",
		"mr" => "20",
		"resists" => "csp",
		"attacks" => "1d6"
	},
	"hell hound" => {
		"lev" => "12",
		"spd" => "14",
		"ac" => "2",
		"mr" => "20",
		"resists" => "F",
		"attacks" => "3d6 B3d6F"
	},
	"leprechaun" => {
		"lev" => "5",
		"spd" => "15",
		"ac" => "8",
		"mr" => "20",
		"resists" => "",
		"attacks" => "1d2\$"
	},
	"orc shaman" => {
		"lev" => "3",
		"spd" => "9",
		"ac" => "5",
		"mr" => "10",
		"resists" => "",
		"attacks" => "M0d0+"
	},
	"manes" => {
		"lev" => "1",
		"spd" => "3",
		"ac" => "7",
		"mr" => "0",
		"resists" => "sp",
		"attacks" => "1d3 1d3 1d4"
	},
	"orc-captain" => {
		"lev" => "5",
		"spd" => "5",
		"ac" => "10",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W2d4 W2d4"
	},
	"dwarf king" => {
		"lev" => "6",
		"spd" => "6",
		"ac" => "10",
		"mr" => "20",
		"resists" => "",
		"attacks" => "W2d6 W2d6"
	},
	"wererat" => {
		"lev" => "2",
		"spd" => "12",
		"ac" => "10",
		"mr" => "10",
		"resists" => "p",
		"attacks" => "W2d4"
	},
	"plains centaur" => {
		"lev" => "4",
		"spd" => "18",
		"ac" => "4",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W1d6 1d6"
	},
	"ice devil" => {
		"lev" => "11",
		"spd" => "6",
		"ac" => "-4",
		"mr" => "55",
		"resists" => "fcp",
		"attacks" => "1d4 1d4 2d4 3d4C"
	},
	"lynx" => {
		"lev" => "5",
		"spd" => "15",
		"ac" => "6",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d4 1d4 1d10"
	},
	"jackal" => {
		"lev" => "0",
		"spd" => "12",
		"ac" => "7",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d2"
	},
	"Aleax" => {
		"lev" => "10",
		"spd" => "8",
		"ac" => "0",
		"mr" => "30",
		"resists" => "csep",
		"attacks" => "W1d6 W1d6 1d4"
	},
	"thug" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "10",
		"mr" => "10",
		"resists" => "",
		"attacks" => "W1d6 W1d6"
	},
	"green dragon" => {
		"lev" => "15",
		"spd" => "9",
		"ac" => "-1",
		"mr" => "20",
		"resists" => "P",
		"attacks" => "B4d6P 3d8 1d4 1d4"
	},
	"ettin mummy" => {
		"lev" => "7",
		"spd" => "12",
		"ac" => "4",
		"mr" => "30",
		"resists" => "csp",
		"attacks" => "2d6 2d6"
	},
	"Pelias" => {
		"lev" => "20",
		"spd" => "12",
		"ac" => "0",
		"mr" => "30",
		"resists" => "p",
		"attacks" => "W1d6"
	},
	"ice troll" => {
		"lev" => "9",
		"spd" => "10",
		"ac" => "2",
		"mr" => "20",
		"resists" => "C",
		"attacks" => "W2d6 2d6C 2d6"
	},
	"ochre jelly" => {
		"lev" => "6",
		"spd" => "3",
		"ac" => "8",
		"mr" => "20",
		"resists" => "a*",
		"attacks" => "E3d6A (3d6A)"
	},
	"monkey" => {
		"lev" => "2",
		"spd" => "12",
		"ac" => "6",
		"mr" => "0",
		"resists" => "",
		"attacks" => "0d0- 1d3"
	},
	"vampire bat" => {
		"lev" => "5",
		"spd" => "20",
		"ac" => "6",
		"mr" => "0",
		"resists" => "sp",
		"attacks" => "1d6 0d0P"
	},
	"Orcus" => {
		"lev" => "66",
		"spd" => "9",
		"ac" => "-6",
		"mr" => "85",
		"resists" => "fp",
		"attacks" => "W3d6 3d4 3d4 M8d6+ 2d4P"
	},
	"master mind flayer" => {
		"lev" => "13",
		"spd" => "12",
		"ac" => "0",
		"mr" => "90",
		"resists" => "",
		"attacks" => "W1d8 2!I 2!I 2!I 2!I 2!I"
	},
	"air elemental" => {
		"lev" => "8",
		"spd" => "36",
		"ac" => "2",
		"mr" => "30",
		"resists" => "p*",
		"attacks" => "E1d10"
	},
	"gargoyle" => {
		"lev" => "6",
		"spd" => "10",
		"ac" => "-4",
		"mr" => "0",
		"resists" => "*",
		"attacks" => "2d6 2d6 2d4"
	},
	"kobold zombie" => {
		"lev" => "0",
		"spd" => "6",
		"ac" => "10",
		"mr" => "0",
		"resists" => "csp",
		"attacks" => "1d4"
	},
	"ogre lord" => {
		"lev" => "7",
		"spd" => "12",
		"ac" => "3",
		"mr" => "30",
		"resists" => "",
		"attacks" => "W2d6"
	},
	"Medusa" => {
		"lev" => "20",
		"spd" => "12",
		"ac" => "2",
		"mr" => "50",
		"resists" => "P*",
		"attacks" => "W2d4 1d8 G0d0* 1d6P"
	},
	"Yeenoghu" => {
		"lev" => "56",
		"spd" => "18",
		"ac" => "-5",
		"mr" => "80",
		"resists" => "fp",
		"attacks" => "W3d6 W2d8c 1d6. M2d6M"
	},
	"baby black dragon" => {
		"lev" => "12",
		"spd" => "9",
		"ac" => "2",
		"mr" => "10",
		"resists" => "d",
		"attacks" => "2d6"
	},
	"Vlad the Impaler" => {
		"lev" => "14",
		"spd" => "18",
		"ac" => "-3",
		"mr" => "80",
		"resists" => "sp",
		"attacks" => "W1d10 1d10V"
	},
	"incubus" => {
		"lev" => "6",
		"spd" => "12",
		"ac" => "0",
		"mr" => "70",
		"resists" => "fp",
		"attacks" => "0d0& 1d3 1d3"
	},
	"killer bee" => {
		"lev" => "1",
		"spd" => "18",
		"ac" => "-1",
		"mr" => "0",
		"resists" => "P",
		"attacks" => "1d3P"
	},
	"ghost" => {
		"lev" => "10",
		"spd" => "3",
		"ac" => "-5",
		"mr" => "50",
		"resists" => "csdp*",
		"attacks" => "1d1"
	},
	"raven" => {
		"lev" => "4",
		"spd" => "20",
		"ac" => "6",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d6 1d6b"
	},
	"Famine" => {
		"lev" => "30",
		"spd" => "12",
		"ac" => "-5",
		"mr" => "100",
		"resists" => "fcsep*",
		"attacks" => "8d8z 8d8z"
	},
	"green slime" => {
		"lev" => "6",
		"spd" => "6",
		"ac" => "6",
		"mr" => "0",
		"resists" => "cepa*",
		"attacks" => "1d4@ (0d0@)"
	},
	"lieutenant" => {
		"lev" => "10",
		"spd" => "10",
		"ac" => "10",
		"mr" => "15",
		"resists" => "",
		"attacks" => "W3d4 W3d4"
	},
	"grid bug" => {
		"lev" => "0",
		"spd" => "12",
		"ac" => "9",
		"mr" => "0",
		"resists" => "ep",
		"attacks" => "1d1E"
	},
	"pit viper" => {
		"lev" => "6",
		"spd" => "15",
		"ac" => "2",
		"mr" => "0",
		"resists" => "P",
		"attacks" => "1d4P 1d4P"
	},
	"iguana" => {
		"lev" => "2",
		"spd" => "6",
		"ac" => "7",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d4"
	},
	"dog" => {
		"lev" => "4",
		"spd" => "16",
		"ac" => "5",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d6"
	},
	"water nymph" => {
		"lev" => "3",
		"spd" => "12",
		"ac" => "9",
		"mr" => "20",
		"resists" => "",
		"attacks" => "0d0- 0d0-"
	},
	"housecat" => {
		"lev" => "4",
		"spd" => "16",
		"ac" => "5",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d6"
	},
	"Chromatic Dragon" => {
		"lev" => "16",
		"spd" => "12",
		"ac" => "0",
		"mr" => "30",
		"resists" => "FCSDEPa*",
		"attacks" => "B6d8z M0d0+ 2d8- 4d8 4d8 1d6"
	},
	"orc zombie" => {
		"lev" => "2",
		"spd" => "6",
		"ac" => "9",
		"mr" => "0",
		"resists" => "csp",
		"attacks" => "1d6"
	},
	"Grey-elf" => {
		"lev" => "6",
		"spd" => "12",
		"ac" => "10",
		"mr" => "10",
		"resists" => "S",
		"attacks" => "W2d4"
	},
	"Archon" => {
		"lev" => "19",
		"spd" => "16",
		"ac" => "-6",
		"mr" => "80",
		"resists" => "fcsep",
		"attacks" => "W2d4 W2d4 G2d6b 1d8 M4d6+"
	},
	"djinni" => {
		"lev" => "7",
		"spd" => "12",
		"ac" => "4",
		"mr" => "30",
		"resists" => "p*",
		"attacks" => "W2d8"
	},
	"white unicorn" => {
		"lev" => "4",
		"spd" => "24",
		"ac" => "2",
		"mr" => "70",
		"resists" => "P",
		"attacks" => "1d12 1d6"
	},
	"horse" => {
		"lev" => "5",
		"spd" => "20",
		"ac" => "5",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d8 1d3"
	},
	"coyote" => {
		"lev" => "1",
		"spd" => "12",
		"ac" => "7",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d4"
	},
	"mastodon" => {
		"lev" => "20",
		"spd" => "12",
		"ac" => "5",
		"mr" => "0",
		"resists" => "",
		"attacks" => "4d8 4d8"
	},
	"vampire" => {
		"lev" => "10",
		"spd" => "12",
		"ac" => "1",
		"mr" => "25",
		"resists" => "sp",
		"attacks" => "1d6 1d6V"
	},
	"red naga" => {
		"lev" => "6",
		"spd" => "12",
		"ac" => "4",
		"mr" => "0",
		"resists" => "FP",
		"attacks" => "2d4 B2d6F"
	},
	"mind flayer" => {
		"lev" => "9",
		"spd" => "12",
		"ac" => "5",
		"mr" => "90",
		"resists" => "",
		"attacks" => "W1d4 2!I 2!I 2!I"
	},
	"black unicorn" => {
		"lev" => "4",
		"spd" => "24",
		"ac" => "2",
		"mr" => "70",
		"resists" => "P",
		"attacks" => "1d12 1d6"
	},
	"kraken" => {
		"lev" => "20",
		"spd" => "3",
		"ac" => "6",
		"mr" => "0",
		"resists" => "",
		"attacks" => "2d4 2d4 H2d6w 5d4"
	},
	"roshi" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "10",
		"mr" => "10",
		"resists" => "",
		"attacks" => "W1d8 W1d8"
	},
	"Wizard of Yendor" => {
		"lev" => "30",
		"spd" => "12",
		"ac" => "-8",
		"mr" => "100",
		"resists" => "FP",
		"attacks" => "2d12- M0d0+"
	},
	"guide" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "10",
		"mr" => "20",
		"resists" => "",
		"attacks" => "W1d6 M0d0+"
	},
	"lurker above" => {
		"lev" => "10",
		"spd" => "3",
		"ac" => "3",
		"mr" => "0",
		"resists" => "",
		"attacks" => "E1d8d"
	},
	"Master Assassin" => {
		"lev" => "15",
		"spd" => "12",
		"ac" => "0",
		"mr" => "30",
		"resists" => "*",
		"attacks" => "W2d6P W2d8 2d6-"
	},
	"healer" => {
		"lev" => "10",
		"spd" => "12",
		"ac" => "10",
		"mr" => "1",
		"resists" => "p",
		"attacks" => "W1d6"
	},
	"Elvenking" => {
		"lev" => "9",
		"spd" => "12",
		"ac" => "10",
		"mr" => "25",
		"resists" => "S",
		"attacks" => "W2d4 W2d4"
	},
	"cockatrice" => {
		"lev" => "5",
		"spd" => "6",
		"ac" => "6",
		"mr" => "30",
		"resists" => "P*",
		"attacks" => "1d3 0d0* (0d0*)"
	},
	"carnivorous ape" => {
		"lev" => "6",
		"spd" => "12",
		"ac" => "6",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d4 1d4 H1d8"
	},
	"fire elemental" => {
		"lev" => "8",
		"spd" => "12",
		"ac" => "2",
		"mr" => "30",
		"resists" => "fp*",
		"attacks" => "3d6F (0d4F)"
	},
	"jellyfish" => {
		"lev" => "3",
		"spd" => "3",
		"ac" => "6",
		"mr" => "0",
		"resists" => "P",
		"attacks" => "3d3P"
	},
	"demilich" => {
		"lev" => "14",
		"spd" => "9",
		"ac" => "-2",
		"mr" => "60",
		"resists" => "Csp",
		"attacks" => "3d4C M0d0+"
	},
	"master lich" => {
		"lev" => "17",
		"spd" => "9",
		"ac" => "-4",
		"mr" => "90",
		"resists" => "FCsp",
		"attacks" => "3d6C M0d0+"
	},
	"rogue" => {
		"lev" => "10",
		"spd" => "12",
		"ac" => "10",
		"mr" => "1",
		"resists" => "",
		"attacks" => "W1d6 W1d6"
	},
	"yellow dragon" => {
		"lev" => "15",
		"spd" => "9",
		"ac" => "-1",
		"mr" => "20",
		"resists" => "a*",
		"attacks" => "B4d6A 3d8 1d4 1d4"
	},
	"cave spider" => {
		"lev" => "1",
		"spd" => "12",
		"ac" => "3",
		"mr" => "0",
		"resists" => "P",
		"attacks" => "1d2"
	},
	"red dragon" => {
		"lev" => "15",
		"spd" => "9",
		"ac" => "-1",
		"mr" => "20",
		"resists" => "F",
		"attacks" => "B6d6F 3d8 1d4 1d4"
	},
	"Ixoth" => {
		"lev" => "15",
		"spd" => "12",
		"ac" => "-1",
		"mr" => "20",
		"resists" => "F*",
		"attacks" => "B8d6F 4d8 M0d0+ 2d4 2d4-"
	},
	"silver dragon" => {
		"lev" => "15",
		"spd" => "9",
		"ac" => "-1",
		"mr" => "20",
		"resists" => "c",
		"attacks" => "B4d6C 3d8 1d4 1d4"
	},
	"iron piercer" => {
		"lev" => "5",
		"spd" => "1",
		"ac" => "0",
		"mr" => "0",
		"resists" => "",
		"attacks" => "3d6"
	},
	"rabid rat" => {
		"lev" => "2",
		"spd" => "12",
		"ac" => "6",
		"mr" => "0",
		"resists" => "p",
		"attacks" => "2d4!C"
	},
	"prisoner" => {
		"lev" => "12",
		"spd" => "12",
		"ac" => "10",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W1d6"
	},
	"garter snake" => {
		"lev" => "1",
		"spd" => "8",
		"ac" => "8",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d2"
	},
	"water elemental" => {
		"lev" => "8",
		"spd" => "6",
		"ac" => "2",
		"mr" => "30",
		"resists" => "p*",
		"attacks" => "5d6"
	},
	"Oracle" => {
		"lev" => "12",
		"spd" => "0",
		"ac" => "0",
		"mr" => "50",
		"resists" => "",
		"attacks" => "(0d4M)"
	},
	"gecko" => {
		"lev" => "1",
		"spd" => "6",
		"ac" => "8",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d3"
	},
	"high priest" => {
		"lev" => "25",
		"spd" => "15",
		"ac" => "7",
		"mr" => "70",
		"resists" => "fsep",
		"attacks" => "W4d10 2d8 M2d8+ M2d8+"
	},
	"barrow wight" => {
		"lev" => "3",
		"spd" => "12",
		"ac" => "5",
		"mr" => "5",
		"resists" => "csp",
		"attacks" => "W0d0V M0d0+ 1d4"
	},
	"Asmodeus" => {
		"lev" => "105",
		"spd" => "12",
		"ac" => "-7",
		"mr" => "90",
		"resists" => "fcp",
		"attacks" => "4d4 M6d6C"
	},
	"gelatinous cube" => {
		"lev" => "6",
		"spd" => "6",
		"ac" => "8",
		"mr" => "0",
		"resists" => "FCSEpa*",
		"attacks" => "2d4. (1d4.)"
	},
	"barbed devil" => {
		"lev" => "8",
		"spd" => "12",
		"ac" => "0",
		"mr" => "35",
		"resists" => "fp",
		"attacks" => "2d4 2d4 3d4"
	},
	"hell hound pup" => {
		"lev" => "7",
		"spd" => "12",
		"ac" => "4",
		"mr" => "20",
		"resists" => "F",
		"attacks" => "2d6 B2d6F"
	},
	"Kop Lieutenant" => {
		"lev" => "3",
		"spd" => "10",
		"ac" => "10",
		"mr" => "20",
		"resists" => "",
		"attacks" => "W1d8"
	},
	"bugbear" => {
		"lev" => "3",
		"spd" => "9",
		"ac" => "5",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W2d4"
	},
	"earth elemental" => {
		"lev" => "8",
		"spd" => "6",
		"ac" => "2",
		"mr" => "30",
		"resists" => "fcp*",
		"attacks" => "4d6"
	},
	"lizard" => {
		"lev" => "5",
		"spd" => "6",
		"ac" => "6",
		"mr" => "10",
		"resists" => "*",
		"attacks" => "1d6"
	},
	"tengu" => {
		"lev" => "6",
		"spd" => "13",
		"ac" => "5",
		"mr" => "30",
		"resists" => "P",
		"attacks" => "1d7"
	},
	"sandestin" => {
		"lev" => "13",
		"spd" => "12",
		"ac" => "4",
		"mr" => "60",
		"resists" => "*",
		"attacks" => "W2d6 W2d6"
	},
	"Dispater" => {
		"lev" => "78",
		"spd" => "15",
		"ac" => "-2",
		"mr" => "80",
		"resists" => "fp",
		"attacks" => "W4d6 M6d6+"
	},
	"barbarian" => {
		"lev" => "10",
		"spd" => "12",
		"ac" => "10",
		"mr" => "1",
		"resists" => "p",
		"attacks" => "W1d6 W1d6"
	},
	"Master Kaen" => {
		"lev" => "25",
		"spd" => "12",
		"ac" => "-10",
		"mr" => "10",
		"resists" => "P*",
		"attacks" => "16d2 16d2 M0d0+ 1d4-"
	},
	"Croesus" => {
		"lev" => "20",
		"spd" => "15",
		"ac" => "0",
		"mr" => "40",
		"resists" => "",
		"attacks" => "W4d10"
	},
	"shocking sphere" => {
		"lev" => "6",
		"spd" => "13",
		"ac" => "4",
		"mr" => "0",
		"resists" => "E",
		"attacks" => "X4d6E"
	},
	"Lord Sato" => {
		"lev" => "20",
		"spd" => "12",
		"ac" => "0",
		"mr" => "30",
		"resists" => "",
		"attacks" => "W1d8 W1d6"
	},
	"giant mimic" => {
		"lev" => "9",
		"spd" => "3",
		"ac" => "7",
		"mr" => "20",
		"resists" => "a",
		"attacks" => "3d6m 3d6m"
	},
	"dwarf lord" => {
		"lev" => "4",
		"spd" => "6",
		"ac" => "10",
		"mr" => "10",
		"resists" => "",
		"attacks" => "W2d4 W2d4"
	},
	"gray ooze" => {
		"lev" => "3",
		"spd" => "1",
		"ac" => "8",
		"mr" => "0",
		"resists" => "FCPa*",
		"attacks" => "2d8R"
	},
	"dingo" => {
		"lev" => "4",
		"spd" => "16",
		"ac" => "5",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d6"
	},
	"vrock" => {
		"lev" => "8",
		"spd" => "12",
		"ac" => "0",
		"mr" => "50",
		"resists" => "fp",
		"attacks" => "1d4 1d4 1d8 1d8 1d6"
	},
	"ettin zombie" => {
		"lev" => "6",
		"spd" => "8",
		"ac" => "6",
		"mr" => "0",
		"resists" => "csp",
		"attacks" => "1d10 1d10"
	},
	"baby silver dragon" => {
		"lev" => "12",
		"spd" => "9",
		"ac" => "2",
		"mr" => "10",
		"resists" => "",
		"attacks" => "2d6"
	},
	"Geryon" => {
		"lev" => "72",
		"spd" => "3",
		"ac" => "-3",
		"mr" => "75",
		"resists" => "fp",
		"attacks" => "3d6 3d6 2d4P"
	},
	"wraith" => {
		"lev" => "6",
		"spd" => "12",
		"ac" => "4",
		"mr" => "15",
		"resists" => "csp*",
		"attacks" => "1d6V"
	},
	"centipede" => {
		"lev" => "2",
		"spd" => "4",
		"ac" => "3",
		"mr" => "0",
		"resists" => "P",
		"attacks" => "1d3P"
	},
	"scorpion" => {
		"lev" => "5",
		"spd" => "15",
		"ac" => "3",
		"mr" => "0",
		"resists" => "P",
		"attacks" => "1d2 1d2 1d4P"
	},
	"goblin" => {
		"lev" => "0",
		"spd" => "6",
		"ac" => "10",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W1d4"
	},
	"acolyte" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "10",
		"mr" => "20",
		"resists" => "",
		"attacks" => "W1d6 M0d0+"
	},
	"elf zombie" => {
		"lev" => "3",
		"spd" => "6",
		"ac" => "9",
		"mr" => "0",
		"resists" => "csp",
		"attacks" => "1d7"
	},
	"salamander" => {
		"lev" => "8",
		"spd" => "12",
		"ac" => "-1",
		"mr" => "0",
		"resists" => "Fs",
		"attacks" => "W2d8 1d6F H2d6 H3d6F"
	},
	"shade" => {
		"lev" => "12",
		"spd" => "10",
		"ac" => "10",
		"mr" => "0",
		"resists" => "csdp*",
		"attacks" => "2d6. 1d6<"
	},
	"pony" => {
		"lev" => "3",
		"spd" => "16",
		"ac" => "6",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d6 1d2"
	},
	"student" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "10",
		"mr" => "10",
		"resists" => "",
		"attacks" => "W1d6"
	},
	"giant zombie" => {
		"lev" => "8",
		"spd" => "8",
		"ac" => "6",
		"mr" => "0",
		"resists" => "csp",
		"attacks" => "2d8 2d8"
	},
	"cavewoman" => {
		"lev" => "10",
		"spd" => "12",
		"ac" => "10",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W2d4"
	},
	"spotted jelly" => {
		"lev" => "5",
		"spd" => "0",
		"ac" => "8",
		"mr" => "10",
		"resists" => "a*",
		"attacks" => "(0d6A)"
	},
	"neanderthal" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "10",
		"mr" => "10",
		"resists" => "",
		"attacks" => "W2d4"
	},
	"horned devil" => {
		"lev" => "6",
		"spd" => "9",
		"ac" => "-5",
		"mr" => "50",
		"resists" => "fp",
		"attacks" => "W1d4 1d4 2d3 1d3"
	},
	"balrog" => {
		"lev" => "16",
		"spd" => "5",
		"ac" => "-2",
		"mr" => "75",
		"resists" => "fp",
		"attacks" => "W8d4 W4d6"
	},
	"dwarf mummy" => {
		"lev" => "5",
		"spd" => "10",
		"ac" => "5",
		"mr" => "20",
		"resists" => "csp",
		"attacks" => "1d6"
	},
	"large cat" => {
		"lev" => "6",
		"spd" => "15",
		"ac" => "4",
		"mr" => "0",
		"resists" => "",
		"attacks" => "2d4"
	},
	"dwarf" => {
		"lev" => "2",
		"spd" => "6",
		"ac" => "10",
		"mr" => "10",
		"resists" => "",
		"attacks" => "W1d8"
	},
	"giant" => {
		"lev" => "6",
		"spd" => "6",
		"ac" => "0",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W2d10"
	},
	"straw golem" => {
		"lev" => "3",
		"spd" => "12",
		"ac" => "10",
		"mr" => "0",
		"resists" => "sp",
		"attacks" => "1d2 1d2"
	},
	"sergeant" => {
		"lev" => "8",
		"spd" => "10",
		"ac" => "10",
		"mr" => "5",
		"resists" => "",
		"attacks" => "W2d6"
	},
	"glass golem" => {
		"lev" => "16",
		"spd" => "6",
		"ac" => "1",
		"mr" => "50",
		"resists" => "spa",
		"attacks" => "2d8 2d8"
	},
	"Lord Carnarvon" => {
		"lev" => "20",
		"spd" => "12",
		"ac" => "0",
		"mr" => "30",
		"resists" => "",
		"attacks" => "W1d6"
	},
	"page" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "10",
		"mr" => "10",
		"resists" => "",
		"attacks" => "W1d6 W1d6"
	},
	"snake" => {
		"lev" => "4",
		"spd" => "15",
		"ac" => "3",
		"mr" => "0",
		"resists" => "P",
		"attacks" => "1d6P"
	},
	"ghoul" => {
		"lev" => "3",
		"spd" => "6",
		"ac" => "10",
		"mr" => "0",
		"resists" => "csp",
		"attacks" => "1d2. 1d3"
	},
	"shark" => {
		"lev" => "7",
		"spd" => "12",
		"ac" => "2",
		"mr" => "0",
		"resists" => "",
		"attacks" => "5d6"
	},
	"nalfeshnee" => {
		"lev" => "11",
		"spd" => "9",
		"ac" => "-1",
		"mr" => "65",
		"resists" => "fp",
		"attacks" => "1d4 1d4 2d4 M0d0+"
	},
	"imp" => {
		"lev" => "3",
		"spd" => "12",
		"ac" => "2",
		"mr" => "20",
		"resists" => "",
		"attacks" => "1d4"
	},
	"rothe" => {
		"lev" => "2",
		"spd" => "9",
		"ac" => "7",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d3 1d3 1d8"
	},
	"mumak" => {
		"lev" => "5",
		"spd" => "9",
		"ac" => "0",
		"mr" => "0",
		"resists" => "",
		"attacks" => "4d12 2d6"
	},
	"Norn" => {
		"lev" => "20",
		"spd" => "12",
		"ac" => "0",
		"mr" => "80",
		"resists" => "c",
		"attacks" => "W1d8 W1d6"
	},
	"orange dragon" => {
		"lev" => "15",
		"spd" => "9",
		"ac" => "-1",
		"mr" => "20",
		"resists" => "S",
		"attacks" => "B4d25S 3d8 1d4 1d4"
	},
	"Minion of Huhetotl" => {
		"lev" => "16",
		"spd" => "12",
		"ac" => "-2",
		"mr" => "75",
		"resists" => "fp*",
		"attacks" => "W8d4 W4d6 M0d0+ 2d6-"
	},
	"fire vortex" => {
		"lev" => "8",
		"spd" => "22",
		"ac" => "2",
		"mr" => "30",
		"resists" => "fsp*",
		"attacks" => "E1d10F (0d4F)"
	},
	"little dog" => {
		"lev" => "2",
		"spd" => "18",
		"ac" => "6",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d6"
	},
	"rock mole" => {
		"lev" => "3",
		"spd" => "3",
		"ac" => "0",
		"mr" => "20",
		"resists" => "",
		"attacks" => "1d6"
	},
	"guardian naga hatchl" => {
		"lev" => "3",
		"spd" => "10",
		"ac" => "6",
		"mr" => "0",
		"resists" => "P",
		"attacks" => "1d4"
	},
	"Shaman Karnov" => {
		"lev" => "20",
		"spd" => "12",
		"ac" => "0",
		"mr" => "30",
		"resists" => "",
		"attacks" => "W2d4"
	},
	"giant rat" => {
		"lev" => "1",
		"spd" => "10",
		"ac" => "7",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d3"
	},
	"green mold" => {
		"lev" => "1",
		"spd" => "0",
		"ac" => "9",
		"mr" => "0",
		"resists" => "a*",
		"attacks" => "(0d4A)"
	},
	"leather golem" => {
		"lev" => "6",
		"spd" => "6",
		"ac" => "6",
		"mr" => "0",
		"resists" => "sp",
		"attacks" => "1d6 1d6"
	},
	"queen bee" => {
		"lev" => "9",
		"spd" => "24",
		"ac" => "-4",
		"mr" => "0",
		"resists" => "P",
		"attacks" => "1d8P"
	},
	"ogre" => {
		"lev" => "5",
		"spd" => "10",
		"ac" => "5",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W2d5"
	},
	"clay golem" => {
		"lev" => "11",
		"spd" => "7",
		"ac" => "7",
		"mr" => "40",
		"resists" => "sp",
		"attacks" => "3d10"
	},
	"gnome lord" => {
		"lev" => "3",
		"spd" => "8",
		"ac" => "10",
		"mr" => "4",
		"resists" => "",
		"attacks" => "W1d8"
	},
	"violet fungus" => {
		"lev" => "3",
		"spd" => "1",
		"ac" => "7",
		"mr" => "0",
		"resists" => "P",
		"attacks" => "1d4 0d0m"
	},
	"Demogorgon" => {
		"lev" => "106",
		"spd" => "15",
		"ac" => "-8",
		"mr" => "95",
		"resists" => "fp",
		"attacks" => "M8d6+ 1d4V 1d6# 1d6#"
	},
	"kobold mummy" => {
		"lev" => "3",
		"spd" => "8",
		"ac" => "6",
		"mr" => "20",
		"resists" => "csp",
		"attacks" => "1d4"
	},
	"umber hulk" => {
		"lev" => "9",
		"spd" => "6",
		"ac" => "2",
		"mr" => "25",
		"resists" => "",
		"attacks" => "3d4 3d4 2d5 G0d0c"
	},
	"lemure" => {
		"lev" => "3",
		"spd" => "3",
		"ac" => "7",
		"mr" => "0",
		"resists" => "Sp",
		"attacks" => "1d3"
	},
	"blue dragon" => {
		"lev" => "15",
		"spd" => "9",
		"ac" => "-1",
		"mr" => "20",
		"resists" => "E",
		"attacks" => "B4d6E 3d8 1d4 1d4"
	},
	"watch captain" => {
		"lev" => "10",
		"spd" => "10",
		"ac" => "10",
		"mr" => "15",
		"resists" => "",
		"attacks" => "W3d4 W3d4"
	},
	"Death" => {
		"lev" => "30",
		"spd" => "12",
		"ac" => "-5",
		"mr" => "100",
		"resists" => "fcsep*",
		"attacks" => "8d8z 8d8z"
	},
	"xan" => {
		"lev" => "7",
		"spd" => "18",
		"ac" => "-4",
		"mr" => "0",
		"resists" => "P",
		"attacks" => "1d4x"
	},
	"wizard" => {
		"lev" => "10",
		"spd" => "12",
		"ac" => "10",
		"mr" => "3",
		"resists" => "",
		"attacks" => "W1d6"
	},
	"piranha" => {
		"lev" => "5",
		"spd" => "12",
		"ac" => "4",
		"mr" => "0",
		"resists" => "",
		"attacks" => "2d6"
	},
	"sewer rat" => {
		"lev" => "0",
		"spd" => "12",
		"ac" => "7",
		"mr" => "0",
		"resists" => "",
		"attacks" => "1d3"
	},
	"samurai" => {
		"lev" => "10",
		"spd" => "12",
		"ac" => "10",
		"mr" => "1",
		"resists" => "",
		"attacks" => "W1d8 W1d8"
	},
	"Mordor orc" => {
		"lev" => "3",
		"spd" => "5",
		"ac" => "10",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W1d6"
	},
	"troll" => {
		"lev" => "7",
		"spd" => "12",
		"ac" => "4",
		"mr" => "0",
		"resists" => "",
		"attacks" => "W4d2 4d2 2d6"
	},
	"Master of Thieves" => {
		"lev" => "20",
		"spd" => "12",
		"ac" => "0",
		"mr" => "30",
		"resists" => "*",
		"attacks" => "W2d6 W2d6 2d4-"
	},
	"doppelganger" => {
		"lev" => "9",
		"spd" => "12",
		"ac" => "5",
		"mr" => "20",
		"resists" => "s",
		"attacks" => "W1d12"
	},
	"valkyrie" => {
		"lev" => "10",
		"spd" => "12",
		"ac" => "10",
		"mr" => "1",
		"resists" => "c",
		"attacks" => "W1d8 W1d8"
	},
	"bone devil" => {
		"lev" => "9",
		"spd" => "15",
		"ac" => "-1",
		"mr" => "40",
		"resists" => "fp",
		"attacks" => "W3d4 2d4P"
	},
);

sub format_attacks
{
	my $a = shift;
	my $result = "";
	my $first = 1;
	foreach (split / /, $a)
	{
		my ($passive, $kind, $roll, $dmgtype) = $_ =~ /([\[(])?($attack_prefix)?($attack_roll)($attack_suffix)?/;
		my $typestr = "";
		$typestr .= "(" if ($dmgtype or $passive);
		$typestr .= $damage_types{$dmgtype} if $dmgtype;
		$typestr .= ", " if ($dmgtype and $passive);
		$typestr .= $passive_attack_str{$passive} if $passive;
		$typestr .= ")" if ($dmgtype or $passive);

		if (!$first) { $result .= ", "; }
		$result .= "$attack_types{$kind} " if $kind;
		$result .= $roll;
		$result .= " $typestr" if $typestr;
		if ($first) { $first = 0; }
	}
	return $result;
};

sub format_monster_annotation
{
	my $name = shift;
	my $s = "spd: $mondata{$name}{'spd'}; AC$mondata{$name}{'ac'}";
    	$s .= "; MR: $mondata{$name}{'mr'}" if $mondata{$name}{'mr'} > 0;
	if ($mondata{$name}{'resists'})
	{
		$s .= "; resists ";
		my $first = 1;
		for my $r (split //, $mondata{$name}{'resists'})
		{
			if (!$first) { $s .= ", "; }
			$s .= $resist_types{lc $r};
			if ($first) { $first = 0; }
		}
	}

	if ($mondata{$name}{'attacks'})
	{
		$s .= "; attacks: " . format_attacks($mondata{$name}{'attacks'});
	}
	return $s;
};
		
for my $monster (keys %mondata)
{
	my $escaped_name = $monster;
 	$escaped_name =~ s/ /\\ /g;
	my $re = qr/
		^(?:$species|~)
		[^\(]+
		\(
		(?:peaceful\ |tame\ |invisible\ |tail\ of\ a\ )?
		$escaped_name
		(?:\ called [\w\s]+)?
		(?:, [\w\s]+)?     # "holding you", "leashed to you" etc.
		\)
		\s+(?:\[seen:[^\]]+\]\s+)?$
		/x;
	make_annotation $re => format_monster_annotation($monster);
}
