var floor:BGSprite;
var sky:BGSprite;
var skyScary:FlxSprite;
var tentacle:FlxAnimate;

function onLoad()
{      
    skyScary = new FlxSprite(-3400, -230).loadGraphic(Paths.image('celeste/emotional'));
    skyScary.frames = Paths.getSparrowAtlas('celeste/emotional');
    skyScary.animation.addByPrefix('loop', 'emotional', 24, true);
    skyScary.animation.play('loop');
    skyScary.scrollFactor.set(0.8, 0.8);
    add(skyScary);

    tentacle = new FlxAnimate(500, -400, 'content/W08_MIRROR_MATCH/images/celeste/hair');
    tentacle.showPivot = false;
    tentacle.anim.addBySymbol('loop', 'loop',24,true,0,0);
    tentacle.antialiasing = true;
    add(tentacle);

    sky = new BGSprite('celeste/sky', -570, -230, 0.8, 0.8);
    add(sky);

    floor = new BGSprite('celeste/floor', -600, -50);
    floor.setGraphicSize(2077*1.3, 1151*1.3);
    add(floor);

    overlay = new FlxSprite(0, 0).loadGraphic(Paths.image('celeste/overlay'));
    overlay.scrollFactor.set(0, 0);
    overlay.setGraphicSize(1280*1.25, 720*1.25);
    overlay.alpha = 0.5;
    overlay.blend = BlendMode.ADD;
    foreground.add(overlay);

    game.comboOffsetCustom = [1000, 450, 1050, 550];
}

function onCreatePost()
{
    game.healthBar.flipX = true;
    game.healthBarSide = 1;
    game.iconP1.flipX = !game.iconP1.flipX;
    game.iconP2.flipX = !game.iconP2.flipX;
    game.scoreTxt.font = Paths.font('Renogare.ttf');
    game.timeTxt.font = Paths.font('Renogare.ttf');
    game.timeTxt.y += 4;
    modManager.setValue("opponentSwap", 1);
    game.snapCamFollowToPos(350, 400);
}

var s:Float = 1;
function onUpdate(elapsed){
    s += elapsed;
    game.dad.x = FlxMath.lerp(game.dad.x, game.dad.x + (Math.sin(s) * -7), CoolUtil.boundTo(1, 0, elapsed * 4));
    game.dad.y = FlxMath.lerp(game.dad.y, game.dad.y + (Math.cos(s) * 7), CoolUtil.boundTo(1, 0, elapsed * 4));
}

function onEvent(eventName, value1, value2)
{
    switch(eventName)
    {
        case 'Pink':
        switch(value1)
        {
            case 'dash':
                new FlxTimer().start(0.6, function(tmr:FlxTimer)
                {
                    FlxTween.tween(sky, {alpha : 0}, 1.3, {ease: FlxEase.expoOut});
                    FlxTween.tween(overlay, {alpha : 0}, 1.3, {ease: FlxEase.expoOut});
                    tentacle.anim.play('loop');
                });
        }
    }
}

function onGameOverStart()
{
    {
        setGameOverVideo('demodingaling');
    }
}