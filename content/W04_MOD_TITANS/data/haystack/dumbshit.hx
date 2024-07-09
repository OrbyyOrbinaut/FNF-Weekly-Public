function onCreatePost(){
    game.opponentStrums.alpha = 0;
    game.dad.alpha = 0;
    game.iconP2.alpha = 0;
    modManager.setValue("opponentSwap", 0.5, 0);
    modManager.setValue("opponentSwap", 0.5, 1);
    modManager.queueEase(112, 128, "opponentSwap", 0, 'quadInOut', 0);
    modManager.queueEase(112, 128, "opponentSwap", 0, 'quadInOut', 1);
    modManager.queueEase(1856, 1856, "tipsy", 0.25, 'expoInOut');
    modManager.queueSet(1856, "tipsySpeed", 2);
}