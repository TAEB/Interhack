# when enabled through #fight, prefixes all movement commands with F, to
# prevent you from wandering off your elbereth tile
# by doy

our $fight_enabled = 0;

sub enable_fight {
    remap h => 'Fh';
    remap j => 'Fj';
    remap k => 'Fk';
    remap l => 'Fl';
    remap y => 'Fy';
    remap u => 'Fu';
    remap b => 'Fb';
    remap n => 'Fn';
}

sub disable_fight {
    unmap 'h';
    unmap 'j';
    unmap 'k';
    unmap 'l';
    unmap 'y';
    unmap 'u';
    unmap 'b';
    unmap 'n';
}

extended_command "#fight"
              => sub
                 {
                   $fight_enabled = not $fight_enabled;
                   if ($fight_enabled) {
                       enable_fight;
                   }
                   else {
                       disable_fight;
                   }
                   "Only Fighting " . ($fight_enabled ? "ON." : "OFF.")
                 };

each_iteration {
    return unless $fight_enabled;

    if ($vt->y == 1) {
        disable_fight;
    }
    else {
        enable_fight;
    }
}
