var barleft:FlxSprite; 
var barRight:FlxSprite; 
var tik:FlxSprite; 
var pee:FlxSprite;
var bee:FlxSprite;

function onCreatePost(){
    barleft = new FlxSprite(0,0).loadGraphic(Paths.image('YALLGONNAHATEMEFORTHIS'));
    barleft.cameras = [game.camOther];
    barleft.alpha = 0.0001;
	add(barleft); 
    
    barRight = new FlxSprite(843,0).loadGraphic(Paths.image('YALLGONNAHATEMEFORTHIS'));
    barRight.cameras = [game.camOther];
    barRight.alpha = 0.0001;
	add(barRight); 

    tik = new FlxSprite(683, 655).loadGraphic(Paths.image('sussyfunk'));
    tik.cameras = [game.camOther];
    tik.alpha = 0.0001;
    tik.antialiasing = true;
	add(tik); 

    pee = new FlxSprite(0, 0).loadGraphic(Paths.image('fuck'));
    pee.cameras = [game.camOther];
    pee.alpha = 0.0001;
    pee.setGraphicSize(1280, 720);
    pee.updateHitbox();
    pee.antialiasing = true;
	add(pee); 

    bee = new FlxSprite(0, 0).loadGraphic(Paths.image('quote'));
    bee.cameras = [game.camOther];
    bee.alpha = 0.0001;
    bee.setGraphicSize(1280, 720);
    bee.updateHitbox();
    bee.antialiasing = true;
	add(bee); 
}

function onStepHit() {
    switch(game.curStep) {
        case 130:
        middleshit(true);
        case 176:
        middleshit(false);
        case 510:
        pee.alpha = 1;
        case 517:
        FlxTween.tween(bee, {alpha: 1}, 2);	
    }
}


function middleshit(mid:Bool = false){
    if(mid == true)
    {
        game.cameraSpeed = 15;
        tik.alpha = 1;
        barleft.alpha = 1;
        barRight.alpha = 1;
        game.timeBar.alpha = 0.0001;
        game.healthBarBG.alpha = 0.0001;
        game.healthBar.alpha = 0.0001;
        game.timeTxt.alpha = 0.0001;
        game.iconP1.alpha = 0.0001;
        game.iconP2.alpha = 0.0001;
        game.scoreTxt.alpha = 0.0001;
        modManager.setValue("opponentSwap", 0.5, 0);
        modManager.setValue("transform3X", -1000, 1);
        for (i in 0...game.opponentStrums.members.length) {
            game.opponentStrums.members[i].alpha = 0.0001;
        }
    }
    else
    {
        FlxG.camera.flash(FlxColor.WHITE, 1);
        game.cameraSpeed = 1;
        tik.alpha = 0;
        barleft.alpha = 0;
        barRight.alpha = 0;
        game.timeBar.alpha = 1;
        game.healthBarBG.alpha = 1;
        game.healthBar.alpha = 1;
        game.timeTxt.alpha = 1;
        game.iconP1.alpha = 1;
        game.iconP2.alpha = 1;
        game.scoreTxt.alpha = 1;
        modManager.setValue("opponentSwap", 0, 0);
        modManager.setValue("transform3X", 0, 1);
        for (i in 0...game.opponentStrums.members.length) {
            game.opponentStrums.members[i].alpha = 1;
        }
    }
}