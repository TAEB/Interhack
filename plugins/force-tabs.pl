# this sets up a "press tab to continue" handler that you must press to
# acknowledge some important message, like "You are slowing down."
# by Eidolos (idea by doy)

press_tab qr/\bYou are slowing down\./;
press_tab qr/\bYou don't feel very well\./;
press_tab qr/\bYou faint from lack of food\./;
press_tab qr/\bYou feel deathly sick\./;
press_tab qr/\bYou feel (?:much|even) worse./;
press_tab qr/\bStop eating\?/;
press_tab qr/\bThe [^.!\e]*? swings itself around you!/;
press_tab qr/\bReally quit\?/;

