# Adds an extended command to show the time since the last prayer and a rough
# estimate of prayer safety.
# The plugin notes crowning, but also provides an extended command to toggle
# crowning manually.
# This only really works when InterHack has seen your last prayer
#
# joc

my $praytime = 0;
my $crowned = 0;

my $law_crown = "I crown thee...  The Hand of Elbereth!";
my $neu_crown = "Thou shalt be my Envoy of Balance!";
my $cha_crown = "Thou art chosen to (?:take lives)|(?:steal soles) for My Glory!";

each_match "You begin praying to" => sub { $praytime = $turncount; };

each_match qr/$law_crown|$neu_crown|$cha_crown/ => sub { $crowned = 1; };

extended_command "crown" => sub 
	{ 
		$crowned = !$crowned; "Crowned now " .  ($crowned ? "ON" : "OFF") 
	};

extended_command "praytime" => sub
	{
		my $timeout = $turncount - $praytime;
		my $confidence_threshold = $crowned ? 3980 : 1229;
		my $safe_msg = "$colormap{green} 95% safe assuming normal timeout\e[0m";
		my $unsafe_msg = "$colormap{brown} confidence < 95%\e[0m";

		my $response = "The last prayer was $timeout turns ago.";
		if ($timeout >= $confidence_threshold) { $response .= $safe_msg; }
		else { $response .= $unsafe_msg; }

		return $response
	}
