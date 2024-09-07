var norbert:FlxSprite;
var fakestartTimer:FlxTimer;
var squatBF:FlxAnimate;
var bf:FlxSprite;
var allowEnd:Bool = false;

function onLoad() 
{
    game.addCharacterToList('siiva', 0);
    game.addCharacterToList('johnny', 1);
    game.addCharacterToList('retsuko', 0);
    game.addCharacterToList('sunday', 1);

    var bg = new FlxSprite(-1357, -739).loadGraphic(Paths.image('mainmenu/newsSet/bg'));
    bg.antialiasing = ClientPrefs.globalAntialiasing;
    add(bg);

    norbert = new FlxSprite(913, 250.05);
    norbert.frames = Paths.getSparrowAtlas("newsSet/norbert");
    norbert.animation.addByPrefix('idle', 'norbert idlealt0', 24, false);
    norbert.animation.play("idle");
    norbert.antialiasing = ClientPrefs.globalAntialiasing;
    add(norbert);

    var counter = new FlxSprite(223.1, 566.1).loadGraphic(Paths.image('mainmenu/newsSet/counter'));
    counter.antialiasing = ClientPrefs.globalAntialiasing;
    add(counter);

    var lights = new FlxSprite(-1345.15, -852.55).loadGraphic(Paths.image('mainmenu/newsSet/lights'));
    lights.antialiasing = ClientPrefs.globalAntialiasing;
    foreground.add(lights);

    squatBF = new FlxAnimate(1300, 720, 'content/W10_THE_TWEAKING_BOSSFIGHT/images/newsSet/squatbf');
    squatBF.showPivot = false;
    squatBF.anim.addBySymbol('Ouch', 'Ouch',24,false,0,0);
    squatBF.antialiasing = true;

    bf = new FlxSprite(1298, 700); 
    bf.frames = Paths.getSparrowAtlas("characters/BoyFriendflow", 'shared');
    bf.animation.addByPrefix('idle', 'BF idle dance', 24, false);
    bf.animation.play("idle");
    bf.antialiasing = ClientPrefs.globalAntialiasing;
    add(bf);

    black = new FlxSprite(0, 0).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
    black.alpha = 0.001;
    black.cameras = [game.camOther];
    add(black);
}

function onUpdate(elapsed)
{
    if (game.inCutscene) //crash out crash out crash out
    {
        var lerpVal:Float = CoolUtil.boundTo(elapsed * 2.4 * game.cameraSpeed, 0, 1);
	    game.camFollowPos.setPosition(FlxMath.lerp(game.camFollowPos.x, game.camFollow.x, lerpVal), FlxMath.lerp(game.camFollowPos.y, game.camFollow.y, lerpVal));
    }
}

function doStartCountdown()
{
    if(PlayState.isStoryMode)
    {
        return Function_Stop;
        allowEnd = true;
    }
}

if (PlayState.isStoryMode)
{
    function presongCutscene() // Add onto this however needed, just dont mess with the snapcamfollowtopos line please
    {
        game.isCameraOnForcedPos = true;
        game.snapCamFollowToPos(639.5, 359.5);
        game.inCutscene = true;
        game.camHUD.alpha = 0;
        game.defaultCamZoom = 0.7;
        FlxTween.tween(FlxG.camera, {zoom: 0.7}, 2, {ease: FlxEase.smootherStepInOut});
        FlxTween.tween(game.camFollow, {x: 239.5, y: 647}, 1, {ease: FlxEase.smootherStepInOut});
        new FlxTimer().start(2, function(tmr:FlxTimer)
        {
            FlxTween.tween(game.camHUD, {alpha : 1}, 1);
            game.inCutscene = false;
            game.startCountdown();
        });
    }
}

function onCountdownStarted()
{
    game.isCameraOnForcedPos = false;
    fakestartTimer = new FlxTimer().start((Conductor.crotchet / 1000), function(tmr:FlxTimer) //Replicates the way the rest of the character bop during da countdown
    {
        if (tmr.loopsLeft % 2 == 0)
        {
            norbert.animation.play("idle");
        }
    }, 
    5);
}

function onBeatHit()
{
    if (curBeat % 2 == 0) {
        norbert.animation.play("idle", true);
    }
    if (curBeat % 2 == 0) {
        bf.animation.play("idle", true);
    }
}

function onEvent(eventName, value1, value2)
{
    switch(eventName)
    {
        case 'Jolly':
        switch(value1)
        {
            case 'jump':
                game.boyfriendGroup.x = 950;
                game.boyfriend.alpha = 1;
                game.boyfriend.playAnim('splat', true);
                game.boyfriend.specialAnim = true;
            case 'para':
                game.boyfriendCameraOffset[0] = -175;
                iconP1.changeIcon('parappa');
                game.healthBar.createFilledBar(FlxColor.fromRGB(54, 107, 255), FlxColor.fromRGB(195, 117, 66));
                game.healthBar.updateBar();
                bf.alpha = 0;
                add(squatBF);
                squatBF.anim.play('Ouch');
                new FlxTimer().start(1.5, function(tmr:FlxTimer)
                {
                    FlxTween.tween(game.camFollow, {x: 239.5, y: 647}, 5, {ease: FlxEase.smootherStepInOut});
                    new FlxTimer().start(2.5, function(tmr:FlxTimer) // this is lazy but whatever
                    {
                        squatBF.visible = false;
                    });
                });
            case 'jova':
                game.camGame.flash(0xFFFFFFFF, 0.5);
                game.triggerEventNote('Change Character', 'dad', 'johnny');
                game.triggerEventNote('Change Character', 'bf', 'siiva');
                //iconP1.changeIcon('siiva');
                //iconP2.changeIcon('john');
                //game.healthBar.createFilledBar(FlxColor.fromRGB(59, 177, 255), FlxColor.fromRGB(70, 70, 70));
            case 'sunko':
                game.camGame.flash(0xFFFFFFFF, 0.5);
                game.triggerEventNote('Change Character', 'dad', 'sunday');
                game.triggerEventNote('Change Character', 'bf', 'retsuko');
                //iconP1.changeIcon('sunday');
                //iconP2.changeIcon('retsuko');
                //game.healthBar.createFilledBar(FlxColor.fromRGB(102, 153, 153), FlxColor.fromRGB(255, 122, 73));
        }
    }
}

function onCreatePost()
{
    iconP1.changeIcon('bf');
    game.healthBar.createFilledBar(FlxColor.fromRGB(54, 107, 255), FlxColor.fromRGB(49, 176, 209));
    game.healthBar.updateBar();
    game.boyfriend.alpha = 0;

    if(!PlayState.isStoryMode)
    {
        game.defaultCamZoom = 0.7; //idk why its acting weird
        FlxG.camera.zoom = 0.7;
        game.snapCamFollowToPos(639.5, 359.5);
    }
}

function onEndSong()
{
    if (PlayState.isStoryMode)
    {
        black.alpha = 0.5;
        new FlxTimer().start(0.1, function(tmr:FlxTimer)
        {
            black.alpha = 0.1;
        });
        new FlxTimer().start(0.2, function(tmr:FlxTimer)
        {
            black.alpha = 0.5;
        });
        new FlxTimer().start(0.3, function(tmr:FlxTimer)
        {
            black.alpha = 0;
        });
        new FlxTimer().start(0.5, function(tmr:FlxTimer)
        {
            black.alpha = 1;
            camGame.alpha = 0;
        });

        new FlxTimer().start(4, function(tmr:FlxTimer)
        {
            allowEnd = true;
            game.camGame.alpha = 0;
            game.camHUD.alpha = 0;
            game.endSong();
        });
        
        if(!allowEnd)
        {
            FlxG.sound.play(Paths.sound('poweroutage'));
            return Function_Stop;
        }
    }
}

function onGameOverStart() 
{
    setGameOverVideo("syncopation_gameover");
}