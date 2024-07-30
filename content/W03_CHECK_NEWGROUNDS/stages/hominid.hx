var FILE_PREFIX:String = 'hominid/';

// stage
var helicopter:FlxSprite;
var daScale:Float = 1.75;
var helicameo:Int;
var helitrigger:Int;

function onLoad()
{
    var bg:BGSprite = new BGSprite(FILE_PREFIX + 'sky', 0, -300, 0.5, 0.5);
    bg.scale.set(daScale, daScale);
    bg.active = false;
    add(bg);

    var bg:BGSprite = new BGSprite(FILE_PREFIX + 'distand_buildings', 100, -350, 0.8, 0.8);
    bg.scale.set(daScale, daScale);
    bg.active = false;
    add(bg);

    helicopter = new FlxSprite(-725, -100);
    helicopter.frames = Paths.getSparrowAtlas(FILE_PREFIX + 'helicopters');
    helicopter.antialiasing = true;
    helicopter.animation.addByPrefix('1', 'helicopter_tweak', 24, true);
    helicopter.animation.addByPrefix('2', 'helicopter_funny', 24, true);
    helicopter.animation.addByPrefix('3', 'helicopter_badguy', 24, true);
    helicopter.scrollFactor.set(0.85, 0.85);
	add(helicopter);
    
    var bg:BGSprite = new BGSprite(FILE_PREFIX + 'side_building_1', -500, -250, 0.9, 0.9);
    bg.scale.set(daScale, daScale);
    bg.active = false;
    add(bg);

    var bg:BGSprite = new BGSprite(FILE_PREFIX + 'side_building_2', 1500, -250, 0.9, 0.9);
    bg.scale.set(daScale, daScale);
    bg.active = false;
    add(bg);

    var bg:BGSprite = new BGSprite(FILE_PREFIX + 'rooftop', 50, 700, 1, 1);
    bg.scale.set(daScale, daScale);
    bg.active = false;
    add(bg);

    helicameo = FlxG.random.int(1, 3);
    helitrigger = FlxG.random.int(100, 251);
}

function onCreatePost() 
{
    game.snapCamFollowToPos(675, 375);
}

function onBeatHit()
{
    if(game.curBeat == helitrigger)
    {
        game.triggerEventNote('Hominid Events', 'heli cameo', '');
        trace('heli triggered');
    }
}

function onEvent(name, v1, v2)
{
    if (name == 'Hominid Events') {
        switch (v1) {
            case 'snap hominid':
                game.isCameraOnForcedPos = true;
                game.snapCamFollowToPos(game.dad.getMidpoint().x, game.dad.getMidpoint().y);
            case 'snap pico':
                game.isCameraOnForcedPos = true;
                game.snapCamFollowToPos(game.boyfriend.getMidpoint().x - 150, game.boyfriend.getMidpoint().y - 50);
            case 'end snap':
                game.isCameraOnForcedPos = false;
            case 'heli cameo':
                FlxTween.tween(helicopter, {x: 1475}, 5.0, {ease: FlxEase.linear});
                helicopter.animation.play("" + helicameo);
        }
    }
}

function onGameOverStart() 
{
    setGameOverVideo("alien");
}