# Adds a tab that names lamps empty appropriately
# by toft

make_tab qr/\e\[HThis (?:oil )?lamp .*? has no oil\./ => sub{" \e#name\ny$lastkeys[-1]empty\n"};
make_tab qr/\e\[HYour lamp .*? has run out of power\./ => sub{" \e#name\ny$lastkeys[-1]empty\n"};
