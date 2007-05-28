# Adds a tab that names wands empty if Nothing happens.
# by toft (but mostly Eidolos)

make_tab qr/Nothing happens\./
    => sub
       {
           return unless alphakeys(-2) eq 'z';
           my $wand_slot = alphakeys(-1);
           "\e#name\ny${wand_slot}empty\n"
       }
