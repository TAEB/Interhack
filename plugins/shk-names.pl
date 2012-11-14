# adds a annotations for Shopkeepers 
# sometimes helpful if found via telepathy 
# by Sec (shopkeepernames from the nethack wiki)

my %shopkeepers =
(
	"Potions" => 	[qw(Njezjin Tsjernigof Ossipewsk Gorlowka Gomel Konosja Weliki Oestjoeg Syktywkar Sablja Narodnaja Kyzyl Walbrzych Swidnica Klodzko Raciborz Gliwice Brzeg Krnov Hradec Kralove Leuk Brig Brienz Thun Sarnen Burglen Elm Flims Vals Schuls Zum Loch)],
	"Spellbooks" =>	[qw(Skibbereen Kanturk Rath Luirc Ennistymon Lahinch Kinnegad Lugnaquillia Enniscorthy Gweebarra Kittamagh Nenagh Sneem Ballingeary Kilgarvan CahersiveenGlenbeigh Kilmihil Kiltamagh Droichead Atha Inniscrone Clonegal Lisnaskea Culdaff Dunfanaghy Inishbofin Kesh)],
	"Armor" => 		[qw(Demirci Kalecik Boyabai Yildizeli Gaziantep Siirt Akhalataki Tirebolu Aksaray Ermenak Iskenderun Kadirli Siverek Pervari Malasgirt Bayburt Ayancik Zonguldak Balya Tefenni Artvin Kars Makharadze Malazgirt Midyat Birecik Kirikkale Alaca Polatli Nallihan)],
	"Wands" =>		[qw(Yr Wyddgrug Trallwng Mallwyd Pontarfynach Rhaeader Llandrindod Llanfair-ym-muallt Y-Fenni Maesteg Rhydaman Beddgelert Curig Llanrwst Llanerchymedd Caergybi Nairn Turriff Inverurie Braemar Lochnagar Kerloch Beinn a Ghlo Drumnadrochit Morven Uist Storr Sgurr na Ciche Cannich Gairloch Kyleakin Dunvegan)],
	"Rings" =>		[qw(Feyfer Flugi Gheel Havic Haynin Hoboken Imbyze Juyn Kinsky Massis Matray Moy Olycan Sadelin Svaving Tapper Terwen Wirix Ypey Rastegaisa Varjag Njarga Kautekeino Abisko Enontekis Rovaniemi Avasaksa Haparanda Lulea Gellivare Oeloe Kajaani Fauske)],
	"Food" =>		[qw(Djasinga Tjibarusa Tjiwidej Pengalengan Bandjar Parbalingga Bojolali Sarangan Ngebel Djombang Ardjawinangun Berbek Papar Baliga Tjisolok Siboga Banjoewangi Trenggalek Karangkobar Njalindoeng Pasawahan Pameunpeuk Patjitan Kediri Pemboeang Tringanoe Makin Tipor Semai Berhala Tegal Samoe)],
	"Weapons" => 	[qw(Voulgezac Rouffiac Lerignac Touverac Guizengeard Melac Neuvicq Vanzac Picq Urignac Corignac Fleac Lonzac Vergt Queyssac Liorac Echourgnac Cazelon Eypau Carignan Monbazillac Jonzac Pons Jumilhac Fenouilledes Laguiolet Saujon Eymoutiers Eygurande Eauze Labouheyre)],
	"Tools" =>		[qw(Ymla Eed-morra Cubask Nieb Bnowr Falr Telloc Cyaj Sperc Noskcirdneh Yawolloh Hyeghu Niskal Trahnil Htargcm Enrobwem Kachzi Rellim Regien Donmyar Yelpur Nosnehpets Stewe Renrut Zlaw Nosalnef Rewuorb Rellenk Yad Cire Htims Y-crad Nenilukah Corsh Aned Lechaim Lexa Niod)],
	"Light (minetown)" =>		[qw(Izchak)],
	"General" =>	[qw(Hebiwerie Possogroenoe Asidonhopo Manlobbi Adjama Pakka Pakka Kabalebo Wonotobo Akalapi Sipaliwini Annootok Upernavik Angmagssalik Aklavik Inuvik Tuktoyaktuk Chicoutimi Ouiatchouane Chibougamau Matagami Kipawa Kinojevis Abitibi Maganasipi Akureyri Kopasker Budereyri Akranes Bordeyri Holmavik)],
	"Light" =>		[qw(Zarnesti Slanic Nehoiasu Ludus Sighisoara Nisipitu Razboieni Bicaz Dorohoi Vaslui Fetesti Tirgu Neamt Babadag Zimnicea Zlatna Jiu Eforie Mamaia Silistra Tulovo Panagyuritshte Smolyan Kirklareli Pernik Lom Haskovo Dobrinishte Varvara Oryahovo Troyan Lovech Sliven)], #SLASHEM only
);

for my $shop (keys %shopkeepers)
{
	for my $name (@{$shopkeepers{$shop}}){
    	make_annotation qr/peaceful $name/ => "Shoptype: $shop";
	};
}
