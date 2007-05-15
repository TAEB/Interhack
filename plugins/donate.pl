# provides a shortcut for donating xl * 400 gold to priests
# if you want clairvoyance, just divide by 2 >_>
# by Eidolos and toft (idea by toft)

extended_command "#donate"
      => sub
      {
          "clairvoyance: \$" . $level * 200 . ", protection: \$" . $level * 400 . "\n"
      };
make_tab qr/\e\[HHow much will you offer\?/
      => sub { $level * 400 . "\n" };
