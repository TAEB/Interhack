# parse all kinds of info about your character (score, stats, align, etc) so
# that other modules have access to this information
# also clears the penultimate line to allow for other information to be placed
# there
# by Eidolos and doy

our $st = 0;
our $dx = 0;
our $co = 0;
our $in = 0;
our $wi = 0;
our $ch = 0;
our $name = '';
our $align = '';
our $sex = '';
our $race = '';
our $role = '';

our $statusline = sub { "S:$score" };

my %races = ('dwarven' => 'dwarf',
             'elven'   => 'elf',
             'human'   => 'human',
             'orcish'  => 'orc'
);

extended_command "#stats"
    => sub { "St:$st Dx:$dx Co:$co In:$in Wi:$wi Ch:$ch" };
extended_command "#score"
    => sub { "S:$score" };
extended_command "#char"
    => sub { sprintf "%s: %s%s%s%s", $name,
                                     $role  ? "$role "  : "",
                                     $race  ? "$race "  : "",
                                     $sex   ? "$sex "   : "",
                                     $align ? "$align " : "" };

each_iteration
{
    ($name, $align, $sex, $race, $role) = ($1, $2, $3, $races{$4}, lc $5) if $vt->row_plaintext(1) =~ /\w+ (\w+), welcome to NetHack! You are a (\w+) (\w+) (\w+) (\w+)\./;
    ($name, $race, $role) = ($1, $races{$2}, lc $3) if $vt->row_plaintext(1) =~ /\w+ (\w+), the (\w+) (\w+), welcome back to NetHack!/;

    return unless /\e\[23(?:;\d+)?H/;

    my @groups = $vt->row_plaintext(23) =~ /St:(\d+(?:\/(?:\*\*|\d+))?) Dx:(\d+) Co:(\d+) In:(\d+) Wi:(\d+) Ch:(\d+)\s*(\w+)\s*S:(\d+)/;
    return if @groups == 0;
    ($st, $dx, $co, $in, $wi, $ch, $align, $score) = @groups;

    my $sl = $statusline->();
    $postprint .= "\e[s\e[23;1H\e[0m$sl\e[K\e[u";
}
