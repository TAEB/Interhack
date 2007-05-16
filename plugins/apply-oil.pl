# sets up a tab to apply new potions to test for oil
# if the potion IS oil the #name will have no real effect
# it really should only match once per potion appearance
# by Eidolos

make_tab qr/\e\[H(.) - (?:an?|\d+)? (?:blessed |uncursed |cursed )?(?!clear)([\w -]+) potions?\./
      => sub { "\ea$1#name\nn$1$2 !oil\n" };

