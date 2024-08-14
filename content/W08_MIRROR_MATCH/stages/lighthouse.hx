var PREFIX:String = 'siiva/';

var lights:BGSprite;
var fnaf:BGSprite;
var black:FlxSprite;
var fade:FlxSprite;

var colours:Array<FlxColor> = [0xffe64c44, 0xfff3ad52, 0xfff3f163, 0xFF4fed34, 0xFF34edd4, 0xFF61A4F0, 0xFFac34ed, 0xFFed34cb];
var curColour:Int = 0;
var gay:Bool = false;

function onLoad()
{
    game.skipCountdown = true;

    var bg:BGSprite = new BGSprite(PREFIX + 'sky', -600, -300, 0.1, 0.1);
    add(bg);

    var lighthouse:BGSprite = new BGSprite(PREFIX + 'bg', -600, 100, 0.3, 0.3);
    add(lighthouse);

    lights = new BGSprite(PREFIX + 'blammed', -580, 115, 0.3, 0.3);
    add(lights);

    var foreground:BGSprite = new BGSprite(PREFIX + 'ground', -500, 700, 1, 1);
    add(foreground);

    fade = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    fade.cameras = [game.camOther];
    add(fade);

    fnaf = new BGSprite(PREFIX + 'thumbnail', 0, 0);
    fnaf.cameras = [game.camOther];
    fnaf.alpha = 0.001;
    add(fnaf);
}

function onCreatePost()
{
    game.camHUD.alpha = 0;

    black = new FlxSprite(-100, -100).makeGraphic(3000, 3000, FlxColor.BLACK);
    black.alpha = 0;
    game.addBehindBF(black);
}

function onEvent(name:String, v1:String, v2:String)
{
    switch (name) 
    {
        case 'SiIva Events':
            switch (v1) 
            {
                // circus
                case 'hi circus':
                    fnaf.alpha = 1;
                    game.defaultCamZoom = 1.6;

                case 'bye circus':
                    FlxTween.tween(fnaf, {alpha: 0}, 0.3);

                // intro
                case 'hi friends':
                    game.isCameraOnForcedPos = true;
                    game.snapCamFollowToPos(800, 100);
                    FlxTween.tween(fade, {alpha: 0}, 1.2);

                case 'zoom out':
                    var daY:Float = 400;
                    var daEase:FlxEase = FlxEase.quadInOut;

                    FlxTween.tween(game.camFollow, {y : daY}, 0.48 * 12, {ease : daEase});
                    FlxTween.tween(game.camFollowPos, {y : daY}, 0.48 * 12, {ease : daEase});
                    FlxTween.tween(game, {defaultCamZoom : 0.7}, 0.48 * 12, {ease : daEase});
                    
                case 'hud fade in':
                    FlxTween.tween(game.camHUD, {alpha : 1}, 0.48 * 2);

                case 'start gaming':
                    game.defaultCamZoom = 0.8;
                    game.isCameraOnForcedPos = false;
                case 'Lighthouse Flash':
                    gay = ClientPrefs.flashing;
                case 'Stop Flash':
                    gay = false;
                // fake game over
                case 'zoom in':
                    game.isCameraOnForcedPos = true;

                    var daX:Float = game.boyfriend.x + 150;
                    var daY:Float = game.boyfriend.y + 350;
                    var daEase:FlxEase = FlxEase.expoIn;

                    FlxTween.tween(game.camFollow, {x : daX, y : daY}, 0.48 * 2, {ease: daEase});
                    FlxTween.tween(game.camFollowPos, {x : daX, y : daY}, 0.48 * 2, {ease: daEase});
                    FlxTween.tween(FlxG.camera, {zoom : 0.95}, 0.48 * 2, {ease : daEase});

                case 'DIE DIE DIE':
                    game.isCameraOnForcedPos = true;
                    game.camHUD.alpha = 0;
                    black.alpha = 1;
                    game.boyfriend.playAnim('dead');
                    game.boyfriend.animTimer = 999;

                case 'bye friend':
                    FlxTween.tween(game.boyfriend, {alpha : 0}, 0.48 * 4);
            }
    }
}

function onBeatHit()
{
    if (gay) 
    {
        FlxTween.color(lights, 0.3, FlxColor.WHITE, colours[curColour]);
        curColour = (curColour + 1) % colours.length;
    }
    else
    {
        lights.color = FlxColor.WHITE;
    }
}

function onGameOverStart()
{
    setGameOverVideo('siiva');
}