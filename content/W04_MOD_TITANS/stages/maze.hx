function onLoad() {
    var sky:FlxSprite = new FlxSprite(-650, -650);
    sky.loadGraphic(Paths.image("zardy/sky"));
    sky.antialiasing = false;
    sky.scrollFactor.set(0.5, 0.5);
	add(sky);

    var moon:FlxSprite = new FlxSprite(-650, -650);
    moon.loadGraphic(Paths.image("zardy/moon"));
    moon.scrollFactor.set(0.5, 0.5);
	add(moon);

    var farBackplants:FlxSprite = new FlxSprite(-50, -50);
    farBackplants.loadGraphic(Paths.image("zardy/backbackPlants"));
    farBackplants.scrollFactor.set(0.9, 0.9);
	add(farBackplants);
    
    var backplants:FlxSprite = new FlxSprite(0, 0);
    backplants.loadGraphic(Paths.image("zardy/backPlants"));
    backplants.antialiasing = false;
    backplants.scrollFactor.set(0.95, 0.95);
	add(backplants);

    var cablecrow:FlxSprite = new FlxSprite(615,1150);
    cablecrow.frames = Paths.getSparrowAtlas('zardy/cablecrow');
    cablecrow.animation.addByPrefix('idle', 'cablecrow', 24, true);
    cablecrow.animation.play('idle');
    cablecrow.antialiasing = true;
    add(cablecrow);

    var ground:FlxSprite = new FlxSprite(0, 0);
    ground.loadGraphic(Paths.image("zardy/ground"));
    ground.antialiasing = false;
	add(ground);

    var fgfence:FlxSprite = new FlxSprite(0, 0);
    fgfence.loadGraphic(Paths.image("zardy/frontFence"));
    fgfence.antialiasing = true;
	foreground.add(fgfence);

    var fgplants:FlxSprite = new FlxSprite(50, 100);
    fgplants.loadGraphic(Paths.image("zardy/frontPlants"));
    fgplants.antialiasing = true;
    fgplants.scrollFactor.set(1.1, 1.1);
	foreground.add(fgplants);

    var gradient:FlxSprite = new FlxSprite(0, 0);
    gradient.loadGraphic(Paths.image("zardy/gradientMULTIPLY"));
    gradient.antialiasing = true;
    gradient.blend = 9;
	foreground.add(gradient);

    var moonlight:FlxSprite = new FlxSprite(-650, -650);
    moonlight.loadGraphic(Paths.image("zardy/moonlightSCREEN"));
    moonlight.antialiasing = true;
    moonlight.scrollFactor.set(0.5, 0.5);
    moonlight.blend = 12;
	foreground.add(moonlight);

    blackScreen = new FlxSprite().makeGraphic(1, 1, 0xFF000000);
    blackScreen.scale.set(FlxG.width * 2,FlxG.height * 2);
    blackScreen.updateHitbox();
    blackScreen.scrollFactor.set();
    blackScreen.screenCenter();
    blackScreen.cameras = [game.camOther];
    add(blackScreen);
    game.skipCountdown = true;
}

function onCreatePost(){
    game.snapCamFollowToPos(1525, 1400);
}

function onEvent(eventName, value1, value2){
    if(eventName == 'zardyevents'){
        switch(value1){
            case 'intro':
            FlxTween.tween(blackScreen, {alpha: 0}, 20, {ease: FlxEase.expoOut});
            case 'zardyfadein':
            FlxTween.tween(game.dad, {alpha: 1}, 2.5, {ease: FlxEase.expoOut});  
            FlxTween.tween(game.opponentStrums, {alpha: 1}, 2.5, {ease: FlxEase.expoOut});
            FlxTween.tween(game.iconP2, {alpha: 1}, 2.5, {ease: FlxEase.expoOut});  
            case 'coolthing':   
            FlxTween.tween(game.dad, {alpha: 0.5}, 2.5, {ease: FlxEase.expoOut});      
        }
    }
}

function onGameOverStart() 
{
    setGameOverVideo("zardy");
}