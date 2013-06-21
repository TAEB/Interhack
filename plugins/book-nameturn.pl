# Adds a tab that names a spellbook with the current turncount when reading

include "last-inventoryaction";

make_tab qr/(?:You add .* to your repertoire)|(?:Your knowledge of .* is keener)|(?:You learn.*\.)/
	=> sub
	{
		my $book_slot = lastinvaction("r");
		return unless $book_slot;
		"\e#name\ny${book_slot}T:${turncount}\n";
	}
		
