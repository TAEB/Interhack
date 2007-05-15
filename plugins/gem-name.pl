# This adds tabs for easy gem naming based on hardness
# by toft

my %hardgems = (
    white             => 'diamond',
    red               => 'ruby',
    orange            => 'jacinth',
    blue              => 'sapphire/aquamarine',
    black             => 'black opal',
    green             => 'emerald/aquamarine',
    'yellowish brown' => 'topaz',
);

make_tab qr/\e\[HYou write in the dust with (?:an?|\d+) ([\w ]+) gems?(?: \(unpaid, \d+ zorkmids?\))?\./ => sub{" \e#name\nn$lastkeys[-1]soft $1\n"};
make_tab qr/\e\[HYou engrave in the floor with (?:an?|\d+) ([\w ]+) gems?(?: \(unpaid, \d+ zorkmids?\))?\./ => sub{my $name = exists($hardgems{$1}) ? $hardgems{$1} : "hard $1"; " \e#name\nn$lastkeys[-1]$name\n"};

# adds "scritch scritch" sensing (useless? XXX)
make_tab qr/\e\[H"scritch, scritch"/ => sub{my $keys = join('', reverse @lastkeys); $keys =~ /\W*(.)/; " \e#name\nn${1}touchstone\n"};
