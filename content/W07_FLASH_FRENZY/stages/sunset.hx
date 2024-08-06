addHaxeLibrary('Lib', 'openfl');
var cameras = [game.camGame, game.camHUD, game.camOther];
var actualBar:FlxBar;
var blackScreen:FlxSprite;
var supersonic:Bool = false;

function onLoad()
{
    game.addCharacterToList('supersonic');
    
    var bg:FlxSprite = new FlxSprite(-50, -100);
    bg.frames = Paths.getSparrowAtlas("ffsonic/bg");
    bg.antialiasing = true;
    bg.animation.addByPrefix('idle', 'bg', 24, true);
    bg.animation.play("idle");
    bg.scale.set(5, 5);
    bg.updateHitbox();
    bg.scrollFactor.set(0,0);
	add(bg); 
    
    var trees:FlxSprite = new FlxSprite(0, -125);
    trees.loadGraphic(Paths.image("ffsonic/trees"));
    trees.antialiasing = true;
    trees.scale.set(5, 5);
    trees.updateHitbox();
    trees.scrollFactor.set(0.1,0.1);
    add(trees); 

    var fg:FlxSprite = new FlxSprite(-300, 700);
    fg.loadGraphic(Paths.image("ffsonic/fg"));
    fg.antialiasing = false;
    fg.scale.set(4, 4);
    fg.updateHitbox();
	add(fg); 

    blackScreen = new FlxSprite().makeGraphic(1, 1, 0xFF000000);
    blackScreen.scale.set(FlxG.width * 2,FlxG.height * 2);
    blackScreen.updateHitbox();
    blackScreen.scrollFactor.set();
    blackScreen.screenCenter();
    blackScreen.cameras = [game.camOther];
    add(blackScreen);

    game.divider = '-';
}

function onCreatePost()
{   
    game.comboOffsetCustom = [500, 300, 500, 450];
    
    var newWidth:Float = 1100;
    var newHeight:Float = 800; 

    for(camera in cameras){
        camera.width = newWidth;
        camera.height = newHeight;
    }
    FlxG.resizeWindow(newWidth, newHeight);
    FlxG.scaleMode.width = newWidth;
    FlxG.scaleMode.height = newHeight;

    var bars:FlxSprite = new FlxSprite(0, 0);
    bars.loadGraphic(Paths.image("ffsonic/ui/baroverlay"));
    bars.antialiasing = false;
    bars.cameras = [game.camHUD];
    bars.scale.set(2, 2);
    bars.updateHitbox();
	add(bars); 

    var removes = [game.healthBar, game.healthBarBG, game.iconP1, game.iconP2];
    for(obj in removes){ remove(obj); }
 
    actualBar = new FlxBar(0, ClientPrefs.downScroll ? 95 : 740, LEFT_TO_RIGHT, 908, 18);
    actualBar.cameras = [game.camHUD];
    actualBar.createGradientBar([0xFFFFFFFF, 0xFFFF0000], [0xFF48FF48, 0xFFFFFFFF], 1, 0);
    actualBar.updateBar();
    actualBar.screenCenter(FlxAxes.X);
    insert(members.indexOf(game.notes), actualBar);

    var barbg:FlxSprite = new FlxSprite(actualBar.x - 4, actualBar.y - 4);
    barbg.loadGraphic(Paths.image("ffsonic/ui/healthbar_BG"));
    barbg.antialiasing = false;
    barbg.cameras = [game.camHUD];
    barbg.scale.set(2, 2);
    barbg.updateHitbox();
	insert(members.indexOf(game.notes), barbg);

    var sonic_icon:FlxSprite = new FlxSprite(6, ClientPrefs.downScroll ? 8 : 654);
    sonic_icon.loadGraphic(Paths.image("ffsonic/ui/sonic_icon"));
    sonic_icon.antialiasing = true;
    sonic_icon.cameras = [game.camHUD];
    sonic_icon.scale.set(2, 2);
    sonic_icon.updateHitbox();
	insert(members.indexOf(game.notes), sonic_icon);

    var aeon_icon:FlxSprite = new FlxSprite(966, ClientPrefs.downScroll ? 8 : 654);
    aeon_icon.loadGraphic(Paths.image("ffsonic/ui/aeon_icon"));
    aeon_icon.antialiasing = true;
    aeon_icon.cameras = [game.camHUD];
    aeon_icon.scale.set(2, 2);
    aeon_icon.updateHitbox();
	insert(members.indexOf(game.notes), aeon_icon);

    game.scoreTxt.screenCenter(FlxAxes.X);
    game.scoreAllowedToBop = false;
    game.scoreTxt.y = ClientPrefs.downScroll ? 50 : 700;
    game.scoreTxt.font = Paths.font('maverick.ttf');
    game.scoreTxt.antialiasing = false;
    game.scoreTxt.borderSize = 0;
    game.timeBar.y = -999;
    game.timeTxt.y = -999;
    game.snapCamFollowToPos(1100 / 2 - 1, 800 / 2 - 1);
    modManager.setValue("opponentSwap", 1);
    game.skipCountdown = true;

    modManager.setValue("transform0X", -25, 0);
    modManager.setValue("transform1X", -25, 0);
    modManager.setValue("transform2X", -25, 0);
    modManager.setValue("transform3X", -25, 0);
    modManager.setValue("transform0X", 25, 1);
    modManager.setValue("transform1X", 25, 1);
    modManager.setValue("transform2X", 25, 1);
    modManager.setValue("transform3X", 25, 1);
}

var s:Float = 1;
function onUpdate(elapsed){
    actualBar.percent = (game.health / 2) * 100;
    FlxG.watch.addQuick('percent', actualBar.percent);
    game.camZooming = false;
    s += elapsed;
    if(supersonic)
    {
        game.boyfriendGroup.y = FlxMath.lerp(game.boyfriendGroup.y, -180 + (Math.cos(s) * 35), CoolUtil.boundTo(1, 0, elapsed * 4));
    }
}

function onUpdatePost(elasped)
{
    game.scoreTxt.text = game.scoreTxt.text.toUpperCase();
}

function onEvent(eventName, value1, value2)
{
    switch(eventName)
    {
        case 'Sonic Events':
        switch(value1)
        {
            case 'transform':
                boyfriend.playAnim('transform', true);
                boyfriend.specialAnim = true;
                FlxTween.tween(game.boyfriendGroup, {y: game.boyfriendGroup.y - 90}, 0.35, {ease: FlxEase.quartOut}); 
            case 'super sonic':
                game.camGame.flash(0xFFFFFFFF, 1.0);
                game.triggerEventNote('Change Character', 'BF', 'supersonic');
                supersonic = true;
            case 'blackscreen fade':
                FlxTween.tween(blackScreen, {alpha: 0}, 10, {ease: FlxEase.linear}); 
            case 'blackscreen in':
                game.camGame.alpha = 0;
            case 'blackscreen out':
                game.camGame.alpha = 1;
            case 'black':
                blackScreen.alpha = 1;
            case 'middle':
                switch(value2)
                {
                    case 'on':
                        game.camFollow.set(675, 450);
                        game.isCameraOnForcedPos = true;
                    case 'off':
                        game.isCameraOnForcedPos = false;
                }

        }
    }
}

function onDestroy()
{
    FlxG.scaleMode.width = 1280; 
    FlxG.scaleMode.height = 720;   
    FlxG.camera.width = 1280;  
    FlxG.camera.height = 720; 
    FlxG.resizeWindow(1280, 720);
}

function onGameOverStart() 
{
    setGameOverVideo('FFSonic_Gameover');
}