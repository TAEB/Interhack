# This adds tabs for easy gem naming based on hardness
# By toft

make_tab qr/\e\[HYou write in the dust with (?:an?|\d+) (\w+) gems?\./ => sub{" \e#name\nn$lastkeys[-1]soft $1\n"};
make_tab qr/\e\[HYou engrave in the floor with (?:an?|\d+) (\w+) gems?\./ => sub{" \e#name\nn$lastkeys[-1]hard $1\n"};

