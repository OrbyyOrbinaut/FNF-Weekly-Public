var mainBG:FlxSprite;
var floor:FlxSprite;
var thelight:FlxSprite;
var thedark:FlxSprite;
var border:FlxSprite;
var coolSection:Bool = false;

function onLoad() {
    mainBG = new FlxSprite(-100, -150);
    mainBG.loadGraphic(Paths.image("fakepizze/wall"));
    mainBG.antialiasing = ClientPrefs.globalAntialiasing;
    add(mainBG);
    
    floor = new FlxSprite(-100, -150);
    floor.loadGraphic(Paths.image("fakepizze/floor"));
    floor.antialiasing = ClientPrefs.globalAntialiasing;
    add(floor);

    thelight = new FlxSprite(-100, -150);
    thelight.loadGraphic(Paths.image("fakepizze/light"));
    thelight.blend = 8;
    thelight.antialiasing = ClientPrefs.globalAntialiasing;
    foreground.add(thelight);
    
    thedark = new FlxSprite(-100, -150);
    thedark.loadGraphic(Paths.image("fakepizze/shade"));
    thedark.blend = 9;
    thedark.antialiasing = ClientPrefs.globalAntialiasing;
    foreground.add(thedark);

    border = new FlxSprite(-100, -150);
    border.loadGraphic(Paths.image("fakepizze/border"));
    border.antialiasing = ClientPrefs.globalAntialiasing;
    foreground.add(border); 
}

function onCreatePost() {
    game.snapCamFollowToPos(1900, 775);
    game.healthBar.angle = 180;
    game.healthBarSide = 1;
    game.iconP1.flipX = true;
    game.iconP2.flipX = true;
    modManager.setValue("opponentSwap", 1);
    game.comboOffsetCustom = [1000, 300, 1050, 445];
    game.camZooming = true;
}

function onBeatHit() 
{
    if (game.camZooming && ClientPrefs.camZooms && coolSection)
    {
        FlxG.camera.zoom += 0.015 * game.camZoomingMult;
        game.camHUD.zoom += 0.03 * game.camZoomingMult;
    }
}

function onEvent(eventName, value1, value2)
{
    if (eventName == 'Beat Bop') 
    {
        switch(value1)
        {
            case 'on':
            coolSection = true;
            case 'off':    
            coolSection = false;
        }
    }
    else if(eventName == 'Middle')
    {
        switch(value1)
        {
            case 'on':
                game.camFollow.set(1900, 1200);
                game.isCameraOnForcedPos = true;
            case 'off':    
                game.isCameraOnForcedPos = false;
        }
    }
}   

function onGameOverStart() 
{
    setGameOverVideo("peppino");
}