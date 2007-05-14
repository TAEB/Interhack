# provides a shortcut for donating xl * 400 gold to priests
# if you want clairvoyance, just divide by 2 >_>
# by Eidolos (idea by toft)

make_tab qr/\e\[HHow much will you offer\?/
      => sub { $level * 400 . "\n" };

