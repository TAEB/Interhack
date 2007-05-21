# adds a little menu for easy wishing
# it intentionally doesn't send the \n for you so you can check or back up
# known issues: max of 23 items available (not enforced)
#               screws up the display (mildly fixable)
# by Eidolos

our $wish_quantity = 2 unless defined $wish_quantity;
our $wish_enchantment = 3 unless defined $wish_enchantment;

our %wishes =
(
    A => sub { "$wish_quantity blessed scrolls of charging" },
    B => 'uncursed fixed greased magic marker',
    C => sub { "blessed fixed greased +$wish_enchantment silver dragon scale mail" },
    D => 'blessed fixed greased +3 helm of brilliance',
    E => 'blessed fixed greased ring of conflict',
    F => 'blessed fixed greased ring of levitation',
);

each_iteration
{
    if ($vt->row_plaintext(1) =~ /^For what do you wish\? +$/)
    {
        $postprint .= "\e[s\e[1;30m\e[2H";
        for my $k (sort keys %wishes)
        {
            my $v = value_of($wishes{$k});
            $keyonce{$k} = "$v";
            $postprint .= " $k - $v \n";
        }
        $postprint .= "\e[m\e[u";
    }
}

