# Adds a tab that names a spellbook with the current turncount when reading
make_tab qr/(?:You add .* to your repertoire)|(?:Your knowledge of .* is keener)|(?:You learn.*\.)/
	=> sub
	{
		return unless alphakeys(-2) eq 'r';
		my $book_slot = alphakeys(-1);
		"\e#name\ny${book_slot}T:${turncount}\n";
	}
		
