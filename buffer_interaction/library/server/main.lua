addEvent('matar >> player', true);
addEventHandler('matar >> player', root, function(element)

	setElementHealth(element, 0);
	outputChatBox('Você matou '..getPlayerName(element), client);

end)