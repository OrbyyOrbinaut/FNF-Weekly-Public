var blackScreen:FlxSprite;
var house:FlxSprite;
function onLoad() {
    var BG:FlxSprite = new FlxSprite(0, 0);
    BG.loadGraphic(Paths.image("oni/hallway"));
    BG.scale.set(3, 3);
    BG.updateHitbox();
    BG.antialiasing = false;
    add(BG);
    
    blackScreen = new FlxSprite().makeGraphic(1, 1, 0xFF000000);
    blackScreen.scale.set(BG.width, BG.height);
    blackScreen.updateHitbox();
    //blackScreen.alpha = 0.5;
    foreground.add(blackScreen);

    house = new FlxSprite(0, 0);
    house.loadGraphic(Paths.image("oni/house"));
    house.scrollFactor.set(0, 0);
    house.screenCenter();
    house.antialiasing = true;
    house.cameras = [game.camOther];
    add(house);

    game.camHUD.alpha = 0;
    game.skipCountdown = true;
}

function onSpawnNotePost(note:Note)
{
    note.visible = note.mustPress;
}

function onCreatePost() {
    game.snapCamFollowToPos(185, 478);
    game.isCameraOnForcedPos = true;
    for (i in 0...game.opponentStrums.members.length) {
		game.opponentStrums.members[i].visible = false;
	}    
    game.iconP1.visible = false;
    game.iconP2.visible = false;
    modManager.setValue("opponentSwap", 0.5);
    game.comboOffsetCustom = [1000, 300, 1050, 445];
}

function onEvent(name:String, v1:String, v2:String)
{
    switch (name) 
    {
        case 'Ao Oni':
            switch (v1) 
            {
                case 'fadein':
                    FlxTween.tween(house, {alpha: 0}, 3, {ease: FlxEase.linear, startDelay: 3});
                case 'start':
                    blackScreen.alpha = 0.5;
                    FlxTween.tween(game.camHUD, {alpha: 1}, 0.5, {ease: FlxEase.linear});
                case 'going dark':
                    FlxTween.tween(blackScreen, {alpha: 1}, 0.5, {ease: FlxEase.linear});
                case 'suddenly back':
                    blackScreen.alpha = 0.5;
            }
    }
}

function onGameOverStart() 
{
    setGameOverVideo("oni");
}