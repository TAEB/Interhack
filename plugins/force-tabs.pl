# this sets up some "press tab to continue" prompts for important messages,
# like "You are slowing down."
# by Eidolos and toft (idea by doy)

press_tab qr/\bYou are slowing down\./;
press_tab qr/\bYou don't feel very well\./;
press_tab qr/\bYou faint from lack of food\./;
press_tab qr/\bYou feel deathly sick\./;
press_tab qr/\bYou feel (?:much|even) worse./;
press_tab qr/\bStop eating\?/;
press_tab qr/\bThe [^.!\e]*? swings itself around you!/;
press_tab qr/^Really quit\? \[yn\] \(n\) +$/;

press_tab qr/"So thou thought thou couldst kill me, fool\."/;
press_tab qr/\bDouble Trouble\.\.\./;
