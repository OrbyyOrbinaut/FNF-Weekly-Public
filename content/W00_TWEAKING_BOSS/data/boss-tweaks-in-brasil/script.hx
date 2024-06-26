function onCreatePost(){
    game.iconP2.visible = false;
    game.dad.visible = false;
    game.boyfriend.flipX = !game.boyfriend.flipX;
    game.dad.cameraPosition[0] = 0 - game.dad.cameraPosition[0];
    game.boyfriend.cameraPosition[0] = 400;
    game.snapCamFollowToPos(935, 590);
    game.isCameraOnForcedPos = true;
    modManager.setValue("opponentSwap", 0.5, 0);
    modManager.setValue("transform0X", -1000, 1);
    modManager.setValue("transform1X", -1000, 1);
    modManager.setValue("transform2X", -1000, 1);
    modManager.setValue("transform3X", -1000, 1);
}


function onBeatHit() {
    switch(game.curBeat) {
        case 191:
        game.isCameraOnForcedPos = false;
        case 192:
        game.iconP2.visible = true;
        game.dad.visible = true;
    }
}