# this plugin lets you quickly write the kind of scroll/spellbook you want to
# write with a magic marker
# by Eidolos

our %spellbooks =
(
  A => 'force bolt',
  B => 'drain life',
  C => 'magic missile',
  D => 'cone of cold',
  E => 'fireball',
  F => 'finger of death',
  G => 'healing',
  H => 'cure blindness',
  I => 'cure sickness',
  J => 'extra healing',
  K => 'stone to flesh',
  L => 'restore ability',
  M => 'detect monsters',
  N => 'light',
  O => 'detect food',
  P => 'clairvoyance',
  Q => 'detect unseen',
  R => 'identify',
  S => 'detect treasure',
  T => 'magic mapping',
  U => 'sleep',
  V => 'confuse monster',
  W => 'slow monster',
  X => 'cause fear',
  Y => 'charm monster',
  Z => 'protection',
  a => 'create monster',
  b => 'remove curse',
  c => 'create familiar',
  d => 'turn undead',
  e => 'jumping',
  f => 'haste self',
  g => 'invisibility',
  h => 'levitation',
  i => 'teleport away',
  j => 'knock',
  k => 'wizard lock',
  l => 'dig',
  m => 'polymorph',
  n => 'cancellation',
);

our %scrolls =
(
  A => 'charging',
  B => 'enchant armor',
  C => 'enchant weapon',
  D => 'genocide',
  E => 'identify',
  F => 'remove curse',
  G => 'magic mapping',
  H => 'gold detection',
  I => 'taming',
  J => 'scare monster',
  K => 'teleportation',
  L => 'earth',
  M => 'create monster',
  N => 'light',
  O => 'confuse monster',
  P => 'destroy armor',
  Q => 'fire',
  R => 'food detection',
  S => 'amnesia',
  T => 'punishment',
  U => 'stinking cloud',
);

show_menu qr/^What type of scroll do you want to write\? +$/ => \%scrolls;
#show_menu qr/^What type of spellbook do you want to write\? +$/ => \%spellbooks;

