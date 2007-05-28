# Adds a tab that names wands empty if Nothing happens.
# by toft (but mostly Eidolos)

each_match_vt 1, qr/^Nothing happens\./
    => sub
       {
           my $wand_slot = alphakeys(-1);
           tab("#name\ny${wand_slot}empty\n") if alphakeys(-2) eq 'z';
       };

