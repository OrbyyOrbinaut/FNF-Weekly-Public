var bgtile1:FlxSprite;
var bgtile2:FlxSprite;
var bgtile3:FlxSprite;
var walkDown:Bool = false;

function onLoad() {   
    bgtile1 = new FlxSprite(1000, -450);
    bgtile1.loadGraphic(Paths.image("bocchibg"));
    bgtile1.antialiasing = true;
    bgtile1.scale.set(0.75, 0.75);
    bgtile1.updateHitbox();
    add(bgtile1);
    trace(bgtile1.width);

    bgtile2 = new FlxSprite(bgtile1.x - 1810, -450);
    bgtile2.loadGraphic(Paths.image("bocchibg"));
    bgtile2.antialiasing = true;
    bgtile2.scale.set(0.75, 0.75);
    bgtile2.updateHitbox();
    add(bgtile2);

    bgtile3 = new FlxSprite(bgtile2.x - 1810, -450);
    bgtile3.loadGraphic(Paths.image("bocchibg"));
    bgtile3.antialiasing = true;
    bgtile3.scale.set(0.75, 0.75);
    bgtile3.updateHitbox();
    add(bgtile3);
}

function onCreatePost(){
    game.snapCamFollowToPos(1200, 130);
    game.isCameraOnForcedPos = true;
    
    if(ClientPrefs.downScroll)
    {
        game.comboOffsetCustom = [520, 500, 570, 650];
    }
    else
    {
        game.comboOffsetCustom = [520, 100, 570, 250];
    }

    barTop = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(68), FlxColor.BLACK);
    barTop.screenCenter(FlxAxes.X);
    barTop.cameras = [game.camHUD];
    barBottom = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(68), FlxColor.BLACK);
    barBottom.screenCenter(FlxAxes.X);
    barBottom.cameras = [game.camHUD];
    barBottom.y = 652;
    add(barTop);
    add(barBottom);

    game.skipCountdown = true;
}

function onUpdate(elapsed)
{
    bgtile1.x += elapsed * 100;
    bgtile2.x += elapsed * 100;
    bgtile3.x += elapsed * 100;

    if (bgtile1.x > 2810) bgtile1.x = -2620;
    if (bgtile2.x > 2810) bgtile2.x = -2620;
    if (bgtile3.x > 2810) bgtile3.x = -2620;
}

function onBeatHit()
{
    if (curBeat % 2 == 0) 
    {
        walkDown = !walkDown;
        
        if(walkDown)
        {
            game.boyfriendGroup.y = -65;
            game.dadGroup.y = -185;
        }
        else
        {
            game.boyfriendGroup.y = -85;
            game.dadGroup.y = -200;
        }
    }
}

function onGameOverStart() 
{
    setGameOverVideo("bocchi_gameover");
}