function onCreatePost(){
    game.modManager.queueEase(552, 575, "alpha", 0, 'quadInOut', 1); 
    game.modManager.queueEase(552, 575, "opponentSwap", 1, 'quadInOut'); // WHY CAN'T I JUST DO MODMANAGER AND NOT GAME.MODMANAGER????? whatever bro
}