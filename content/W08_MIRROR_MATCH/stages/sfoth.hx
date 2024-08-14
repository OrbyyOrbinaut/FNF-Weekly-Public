var PREFIX:String = 'Guest/';
var v0:FNFSprite;

var bg:BGSprite;
var sky:BGSprite;
var loadingScreen:FlxSprite;
var wheel:FlxSprite;
var loadingText:FlxSprite;

// THIS CODE IS BAD I KNOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

function onLoad()
{
    var sky:BGSprite = new BGSprite('guest/Sky', -600, -50, 0.8, 0.8);
    add(sky);

    var bg:BGSprite = new BGSprite('guest/BG', -900, -200);
    bg.setGraphicSize(1280*1.7, 720*1.7);
    add(bg);

    black = new FlxSprite(-300, -300).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
    black.scrollFactor.set(0, 0);
    black.alpha = 0;
    add(black);

    v0 = new FNFSprite(50, -600);
    v0.loadFromJson('zero', true);
    v0.playAnim('idle', true);
    add(v0);

    loadingScreen = new FlxSprite(0,0).loadGraphic(Paths.image('guest/LoadingScreen'));
    loadingScreen.cameras = [game.camOther];
    add(loadingScreen);

    wheel = new FlxSprite(1128,565).loadGraphic(Paths.image('guest/Wheel'));
    wheel.cameras = [game.camOther];
    add(wheel);

    loadingText = new FlxSprite(1150,614).loadGraphic(Paths.image('guest/LoadingText'));
    loadingText.frames = Paths.getSparrowAtlas('guest/LoadingText');
    loadingText.animation.addByPrefix('load', 'Loading', 24, true);
    loadingText.cameras = [game.camOther];
    loadingText.animation.play('load');
    add(loadingText);

    overlay = new FlxSprite(0, 0).loadGraphic(Paths.image('guest/overlay'));
    overlay.scrollFactor.set(0, 0);
    overlay.setGraphicSize(1280*1.25, 720*1.25);
    overlay.alpha = 0.08;
    overlay.blend = BlendMode.ADD;
    foreground.add(overlay);

    game.defaultCamZoom = 1.1;

    //game.comboOffsetCustom = [30, 550, 40, 600];
}

function onCreatePost()
{
    game.skipCountdown = true;
    game.dad.playAnim('scarystart', true);
    game.scoreTxt.font = Paths.font('Boblox.ttf');
    game.timeTxt.font = Paths.font('Boblox.ttf');
    game.timeTxt.y -= 7;
}

var s:Float = 1;
var v0X:Float = 0;
var v0Y:Float = 0;
function onUpdate(elapsed){
    s += elapsed;
    v0.x = FlxMath.lerp(v0.x, v0.x + (Math.sin(s) * -5), CoolUtil.boundTo(1, 0, elapsed * 4));
    v0.y = FlxMath.lerp(v0.y, v0.y + (Math.cos(s) * 5), CoolUtil.boundTo(1, 0, elapsed * 4));

    wheel.angle += 1;
}

function doStartCountdown()
{
    return Function_Stop;
}

function presongCutscene()
{
    game.inCutscene = true;
    game.camHUD.alpha = 0.001;
    game.snapCamFollowToPos(700, 500);
    new FlxTimer().start(2, function(tmr:FlxTimer) 
        {
            FlxTween.tween(loadingScreen, {alpha : 0}, 1);
            FlxTween.tween(wheel, {alpha : 0}, 1);
            FlxTween.tween(loadingText, {alpha : 0}, 1);
            game.inCutscene = false;
            game.startCountdown();
        });
}

function onSpawnNotePost(note){
    if(note.noteType == 'Female666') note.noAnimation = true;
}

function opponentNoteHit(note){
    if(note.noteType == 'Female666' ||  note.noteType == 'Duet'){
        v0.playAnim(game.singAnimations[note.noteData], true);
        v0.holdTimer = 0;
    } 

    if(note.noteType == 'Female666' && !mustHitSection)
    {
        game.camFollow.set(v0.getMidpoint().x - 10, v0.getMidpoint().y + 250);
        game.isCameraOnForcedPos = true;

        switch(note.noteData)
        {
            case 0:
                game.camFollow.set(v0.getMidpoint().x - 25, v0.getMidpoint().y + 250);
            case 1:
                game.camFollow.set(v0.getMidpoint().x - 10, v0.getMidpoint().y + 265);
            case 2:
                game.camFollow.set(v0.getMidpoint().x - 10, v0.getMidpoint().y + 235);
            case 3:
                game.camFollow.set(v0.getMidpoint().x + 5, v0.getMidpoint().y + 250);
        }
    }
    else {
        game.isCameraOnForcedPos = false;
    }
}

function goodNoteHit(note){
    if(note.noteType == 'Duet'){
        game.gf.playAnim(game.singAnimations[note.noteData], true);
        game.gf.holdTimer = 0;
    }
    if(note.noteType != 'GF Sing' && mustHitSection)
    {
        game.isCameraOnForcedPos = false;
    }
    if(note.noteType == 'GF Sing' && mustHitSection)
    {
        game.camFollow.set(gf.getMidpoint().x - 100, gf.getMidpoint().y + 250);
        game.isCameraOnForcedPos = true;

        switch(note.noteData)
        {
            case 0:
                game.camFollow.set(gf.getMidpoint().x - 115, gf.getMidpoint().y + 250);
            case 1:
                game.camFollow.set(gf.getMidpoint().x - 100, gf.getMidpoint().y + 265);
            case 2:
                game.camFollow.set(gf.getMidpoint().x - 100, gf.getMidpoint().y + 235);
            case 3:
                game.camFollow.set(gf.getMidpoint().x - 85, gf.getMidpoint().y + 250);
        }
    }
}

function onBeatHit(){
    if(v0.canResetIdle && game.curBeat % 2 == 0) v0.playAnim('idle', true);
}

function onEvent(eventName, value1, value2)
{
    switch(eventName)
    {
        case 'Guest':
        switch(value1)
        {
            case 'v0':
                FlxTween.tween(v0, {y: -10}, 4, {ease: FlxEase.expoOut});
                iconP2.changeIcon('doppelbloxxers');
            case "betty":
                FlxTween.tween(game.gf, {x: 530}, 4, {ease: FlxEase.linear,
                onComplete: function(tween:FlxTween) {
                    game.gf.playAnim('danceLeft', true);
                    iconP1.changeIcon('bloxxers');
                }});
            case "flash":
                FlxTween.tween(black, {alpha : value2}, 0.4, {ease: FlxEase.expoOut});
            case "unflash":
                FlxTween.tween(black, {alpha : 0}, 0.4, {ease: FlxEase.expoOut});
            case "start":
                game.camHUD.alpha = 1;
                game.defaultCamZoom = 0.9;
                FlxTween.tween(black, {alpha : 0}, 0.6, {ease: FlxEase.expoOut});
            case "friend":
                FlxTween.tween(black, {alpha : 0.3}, 1.5, {ease: FlxEase.linear});
        }
    }
}

function onGameOverStart()
{
    if(FlxG.random.bool(3))
    {
        setGameOverVideo('robloxfriend');
    }
    else
    {
        setGameOverVideo('scarygameover');
    }
}