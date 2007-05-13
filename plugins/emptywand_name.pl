# Adds a tab that names wands empty if Nothing happens. there are a few false
# positives, but they make no sense, and since they're hard to fix the user can
# just not press tab. (Cursed bell of opening inside of a monster, rubbing
# lamps.)
# By toft

make_tab qr/\e\[HNothing happens\./ => sub{"#name\ny$lastkeys[-1]empty\n"};
