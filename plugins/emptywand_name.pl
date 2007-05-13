# Adds a tab that names wands empty if Nothing happens.
# by toft (but mostly Eidolos)

each_iteration
{
  if (/\e\[HNothing happens\./)
  {
    my $skip = 1;
    my $cmdkey;
    for my $c (reverse @lastkeys)
    {
      next unless --$skip < 0;
      $cmdkey = $c, last if $c =~ /[a-zA-Z]/;
    }
    annotate($cmdkey);
    if ($cmdkey eq 'z')
    {
      tab("#name\ny$lastkeys[-1]empty\n");
    }
  }
}

