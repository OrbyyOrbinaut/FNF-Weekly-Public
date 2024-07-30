var bgtile1:FlxSprite;
var bgtile2:FlxSprite;
var bgtile3:FlxSprite;
var cg1:FlxSprite;
var cg2:FlxSprite;
var blackScreen:FlxSprite;
var moveTween:FlxTween;
var opTween:FlxTween;
var walkDown:Bool = false; //this is dumb
var bgCanMove:Bool = false; //this is dumb
var cameoString:Array<String> = ['aoi', 'toko', 'leonn', 'nagito'];
var cameo:FlxSprite;
var cameoIsActive:Bool = false;

function onLoad() {
    bgtile1 = new FlxSprite(-75, -450);
    bgtile1.loadGraphic(Paths.image("box24/ronpa_tile"));
    bgtile1.antialiasing = true;
    bgtile1.scale.set(0.75, 0.75);
    bgtile1.updateHitbox();
    add(bgtile1);

    bgtile2 = new FlxSprite(bgtile1.width - 75, -450);
    bgtile2.loadGraphic(Paths.image("box24/ronpa_tile"));
    bgtile2.antialiasing = true;
    bgtile2.scale.set(0.75, 0.75);
    bgtile2.updateHitbox();
    add(bgtile2);

    bgtile3 = new FlxSprite(2136 + 75, -450);
    bgtile3.loadGraphic(Paths.image("box24/ronpa_tile"));
    bgtile3.antialiasing = true;
    bgtile3.scale.set(0.75, 0.75);
    bgtile3.updateHitbox();
    add(bgtile3);

    cameo = new FlxSprite(1500,265);
    cameo.loadGraphic(Paths.image("box24/cameos/toko"));
    cameo.antialiasing = true;
    add(cameo);

    blackScreen = new FlxSprite().makeGraphic(1, 1, 0xFF000000);
    blackScreen.scale.set(FlxG.width * 2,FlxG.height * 2);
    blackScreen.updateHitbox();
    blackScreen.scrollFactor.set();
    blackScreen.screenCenter();
    blackScreen.cameras = [game.camOther];
    add(blackScreen);

    cg1 = new FlxSprite(0, 0);
    cg1.loadGraphic(Paths.image("box24/danganweeklycg1"));
    cg1.antialiasing = true;
    cg1.cameras = [game.camOther];
    cg1.alpha = 0;
    add(cg1);

    cg2 = new FlxSprite(0, 0);
    cg2.loadGraphic(Paths.image("box24/danganweeklycg2"));
    cg2.antialiasing = true;
    cg2.cameras = [game.camOther];
    cg2.alpha = 0;
    add(cg2);

    game.skipCountdown = true;
}

function onCreatePost(){
    game.snapCamFollowToPos(1280 / 2 - 1, 720 / 2 - 1 - 200);
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
    game.scoreTxt.font = Paths.font('goodbyeDespair.ttf');
    game.timeTxt.font = Paths.font('goodbyeDespair.ttf');
}

function onUpdate(elapsed)
{
    if(bgCanMove)
    { 
        bgtile1.x -= elapsed * 100;
        bgtile2.x -= elapsed * 100;
        bgtile3.x -= elapsed * 100;

        if (bgtile1.x < -1400) bgtile1.x += bgtile1.width * 3;
        if (bgtile2.x < -1400) bgtile2.x += bgtile2.width * 3;
        if (bgtile3.x < -1400) bgtile3.x += bgtile3.width * 3;

        if(cameoIsActive)
        {
            cameo.x -= elapsed * 110;
            
            if (cameo.x < -1400)
            {
                deactivateCameo();
            }
        }
    }
}

function onBeatHit() // I could've just done this w the character json im ngl but weekly crunch does things to u + it makes this look wayy more impressive than it actually is
{
    if(game.boyfriend.animation.curAnim.name == 'idle')
    {
        if(game.boyfriendGroup.x != 675)
        {
            game.boyfriendGroup.x = 675;
        } 

        if(walkDown && bgCanMove)
        {
            game.boyfriendGroup.y = -130;
        }
        else if(bgCanMove)
        {
            game.boyfriendGroup.y = -140;
        }
    }

    if(walkDown && bgCanMove)
    {
        game.dadGroup.y = -75;
    }
    else if(bgCanMove)
    {
        game.dadGroup.y = -85;
    }

    walkDown = !walkDown;
}

function onSectionHit()
{
    if(!cameoIsActive && FlxG.random.bool(35))
    {
        spawnCameo();
        trace('cameo spawned');
    }
}

function goodNoteHit(note)
{
    if(moveTween != null)
    {
        moveTween.cancel();
        game.boyfriendGroup.x = 675;
        game.boyfriendGroup.y = -140;
    }
    switch(note.noteData) // this fucking sucks kill me bro
    {
        case 0:
            game.boyfriendGroup.y = -140;
            if(!note.isSustainNote)
            {
                game.boyfriendGroup.x = 625;
                moveTween = FlxTween.tween(game.boyfriendGroup, {x: 675}, 0.3, {ease: FlxEase.expoOut});
            }
        case 1:
            game.boyfriendGroup.x = 675;
            if(!note.isSustainNote)
            {
                game.boyfriendGroup.y = -115;
                moveTween = FlxTween.tween(game.boyfriendGroup, {y: -140}, 0.3, {ease: FlxEase.expoOut}); 
            }
        case 2:
            game.boyfriendGroup.x = 675;
            if(!note.isSustainNote)
            {
                game.boyfriendGroup.y = -190;
                moveTween = FlxTween.tween(game.boyfriendGroup, {y: -140}, 0.3, {ease: FlxEase.expoOut}); 
            }
        case 3:
            game.boyfriendGroup.y = -140;
            if(!note.isSustainNote)
            {
                game.boyfriendGroup.x = 725;
                moveTween = FlxTween.tween(game.boyfriendGroup, {x: 675}, 0.3, {ease: FlxEase.expoOut});
            }
    }
}

function onEvent(eventName, value1, value2)
{
    switch(eventName)
    {
        case 'Box CG':
        switch(value1)
        {
            case '1':
                FlxTween.tween(cg1, {alpha: 1}, 0.5, {ease: FlxEase.expoOut}); 
            case '2':
                FlxTween.tween(cg2, {alpha: 1}, 0.5, {ease: FlxEase.expoOut}); 
            case 'off':
                FlxTween.tween(blackScreen, {alpha: 0}, 7.5, {ease: FlxEase.expoOut}); 
                FlxTween.tween(game.camFollow, {y: 720 / 2 - 1}, 5.5, {ease: FlxEase.smootherStepInOut});
                cg1.visible = false;
                cg2.visible = false;
                bgCanMove = true;
            case 'fade':
            FlxTween.tween(blackScreen, {alpha: 1}, 7.5, {ease: FlxEase.expoOut});
        }
        case 'Black':
        switch(value1)
        {
            case 'on':
                blackScreen.visible = true;
            case 'off': 
                blackScreen.visible = false;
        }
    }
}

var cameoNum:Int = 0;
function spawnCameo()
{
    if(cameo > 3)
    {
        cameo = 0;
    }
    
    if(FlxG.random.bool(25))
    {
        cameo.loadGraphic(Paths.image("box24/cameos/" + cameoString[3]));
        trace('run.');
    }
    else
    {
        cameo.loadGraphic(Paths.image("box24/cameos/" + cameoString[cameoNum]));
        trace('normal cameo');
    }
    cameoIsActive = true;
    cameoNum = cameoNum + 1;
}

function deactivateCameo() //This is prob dumb but its ok
{
    cameoIsActive = false;
    cameo.x = 1500;
}

function onGameOverStart() 
{
    setGameOverVideo("dangan_gameover");
}