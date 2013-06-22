#provides a function to guess the inventory letter of the last item used via
#a prompt

sub lastinvaction
{
    my $action = shift;
    my $i;

    for $i (reverse -30..-2) { 
        if ($lastkeys[$i] eq $action) 
        {
            my @keys;
            for my $j ($i..-1)
            {
                push @keys, $lastkeys[$j];
            }
            my $keyseq = join '', @keys;
            if ($keyseq =~ qr/[$action](?:[*?] *)?([A-Za-z])/)
            {
                return($1);
            }
            else
            {
                return "";
            }
        }
    }
}
