# Adds a tab that names wands empty if Nothing happens.
# by toft (but mostly Eidolos)

include "last-inventoryaction";

our $empty ||= "empty";

make_tab "Nothing happens."
    => sub
       {
           my $wand_slot = lastinvaction("z");
           return if $wand_slot eq "";
           "\e#name\ny${wand_slot}$empty\n"
       }
