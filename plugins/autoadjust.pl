# adds a new helper function autoadjust
# when you pick up an item matching the regex it'll ask if you want to adjust
# to the specified letter (unless the item is already in that slot)
# it should ignore anything that appears before the item, such as 
# BUC/grease/damage/enchantment etc
# but not anything that appears AFTER the regex/string you specify, such as
# charges
# by Eidolos

# NOTE: due to the way Perl parses this, you need to have either "sub autoadjust;" in your config before any autoadjust statements OR put parens around those statements. looking for a fix.

sub autoadjust
{
    my ($item, $adjust_to) = @_;

    make_tab qr/\e\[H([^$adjust_to]) - (an?|\d+)[^.]*? $item\./
          => sub { "\e#adjust\n$1$adjust_to" };
}

# samples (see *-config for more):
# autoadjust "key" => "k";
# autoadjust "unicorn horn" => "h";
# autoadjust "Magicbane" => "E";
# autoadjust qr/potions? of healing/ => "H";

