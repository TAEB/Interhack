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
our $dlvl = '';
our $au = 0;
our $curhp = 0;
our $maxhp = 0;
our $curpw = 0;
our $maxpw = 0;
our $ac = 0;
our $xlvl = 0;
our $xp = 0;
our $turncount = 0;
our $status = '';

my %aligns = (lawful  => 'Law',
              neutral => 'Neu',
              chaotic => 'Cha',
);

my %sexes = (male   => 'Mal',
             female => 'Fem',
);

my %races = ('dwarven' => 'Dwa',
             'elven'   => 'Elf',
             'human'   => 'Hum',
             'orcish'  => 'Orc',
);

my %roles = (Archeologist => 'Arc',
             Barbarian    => 'Bar',
             Caveman      => 'Cav',
             Cavewoman    => 'Cav',
             Healer       => 'Hea',
             Knight       => 'Kni',
             Monk         => 'Mon',
             Priest       => 'Pri',
             Priestess    => 'Pri',
             Rogue        => 'Rog',
             Ranger       => 'Ran',
             Samurai      => 'Sam',
             Tourist      => 'Tou',
             Valkyrie     => 'Val',
             Wizard       => 'Wiz',
);

# figure out role, race, gender, align
each_iteration
{
    if ($vt->row_plaintext(1) =~ /\w+ (\w+), welcome to NetHack!  You are a (\w+) (\w+) (\w+)(?: (\w+))?\./)
    {
        if (!defined($5)) { $sex = "Fem" }
        else              { $sex = $genders{$3} }

        ($name, $align, $race, $role) = ($1, $aligns{$2}, $races{$4}, $roles{$5})
    }

    ($name, $race, $role) = ($1, $races{$2}, $roles{$3}) if $vt->row_plaintext(1) =~ /\w+ (\w+), the (\w+) (\w+), welcome back to NetHack!/;
}

# figure out stats (strength, score, etc)
each_iteration
{
    return unless /\e\[23(?:;\d+)?H/;

    my @groups = $vt->row_plaintext(23) =~ /St:(\d+(?:\/(?:\*\*|\d+))?) Dx:(\d+) Co:(\d+) In:(\d+) Wi:(\d+) Ch:(\d+)\s*(\w+)(?:\s*S:(\d+))?/;
    return if @groups == 0;
    ($st, $dx, $co, $in, $wi, $ch, $align, $score) = @groups;
    $align = $aligns{lc $align};

    $botl{char} = sprintf "%s: %s%s%s%s", $name,
                                         $role  ? "$role "  : "",
                                         $race  ? "$race "  : "",
                                         $sex   ? "$sex "   : "",
                                         $align ? "$align" : "";
    $botl{stats} = "St:$st Dx:$dx Co:$co In:$in Wi:$wi Ch:$ch";
    $botl{score} = "S:$score" if $score;
}

# parse botl
each_iteration
{
    return unless /\e\[24(?:;\d+)?H/;

    my @groups = $vt->row_plaintext(24) =~ /^(Dlvl:\d+|Home \d+|End Game)\s+\$:(\d+)\s+HP:(\d+)\((\d+)\)\s+Pw:(\d+)\((\d+)\)\s+AC:([0-9-]+)\s+(?:Exp|Xp):(\d+)(?:\/(\d+))?\s+T:(\d+)\s+(.*?)\s*$/;
    return if @groups == 0;
    ($dlvl, $au, $curhp, $maxhp, $curpw, $maxpw, $ac, $xlvl, $xp, $turncount, $status) = @groups;

    $botl{dlvl} = $dlvl;
    $botl{au} = "\$:$au";
    $botl{hp} = "HP:$curhp($maxhp)";
    $botl{pw} = "Pw:$curpw($maxpw)";
    $botl{ac} = "AC:$ac";
    $botl{xp} = sprintf "Xp:$xlvl%s", $xp ? "/$xp" : "";
    $botl{turncount} = "T:$turncount";
    $botl{status} = "$status";
}
