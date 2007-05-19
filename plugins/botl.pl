our %botl;

include "stats";
include "hpmon";
include "powermon";
include "eido-colors-status";
include "exp-2nl";

our $statusline = sub { "$botl{score}" };
our $botl = sub { "$botl{dlvl} $botl{au} $botl{hp} $botl{pw} $botl{ac} $botl{xp} $botl{turncount} $botl{status}" };

for my $item (qw/char stats score dlvl gold hp pw ac xp turncount status/)
{
    extended_command $item => sub { "$botl{$item}" };
}

each_iteration
{
    for (2..24) {
        return if $vt->row_plaintext($_) =~ /\((?:end|\d+ of \d+)\)/;
    }
    my $sl = $statusline->();
    my $bl = $botl->();
    $postprint .= "\e[s\e[23;1H\e[0m$sl\e[K\e[u";
    $postprint .= "\e[s\e[24;1H\e[0m$bl\e[K\e[u";
}
