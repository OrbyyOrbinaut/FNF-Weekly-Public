addHaxeLibrary('FlxFlicker', 'flixel.effects'); // This lets me do the flicker thing.
var barTop:FlxSprite;
var barBottom:FlxSprite;
var black:FlxSprite;
var prostate:FlxText;
var kinoTween:FlxTween;

function onLoad() 
{
    var bg:FlxSprite = new FlxSprite(300, 300);
    bg.loadGraphic(Paths.image("backgroundweeklymix"));
    bg.setGraphicSize(bg.width * 1.75);
    bg.antialiasing = true;
    add(bg);

    prostate = new FlxText(1280, 100);
    prostate.cameras = [game.camOther];
    prostate.setFormat(Paths.font("vcr.ttf"), 48, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
    prostate.text = 'kino.lua ACTIVATED';
    prostate.color = 0xFFFFFFFF;
    prostate.width = 100;
    prostate.antialiasing = false;
    prostate.updateHitbox();
    prostate.screenCenter();
    prostate.borderSize = 3;
    prostate.visible = false;
    add(prostate);
}

function onCreatePost()
{
    if(PlayState.SONG.song.toLowerCase() == 'goo-weekly-mix')
    {
        game.skipCountdown = true;
        game.gf.visible = false;
    }

    barTop = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(68), FlxColor.BLACK);
    barTop.screenCenter(FlxAxes.X);
    barTop.cameras = [game.camHUD];
    barTop.y = 0 - barTop.height;
    barBottom = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(68), FlxColor.BLACK);
    barBottom.screenCenter(FlxAxes.X);
    barBottom.cameras = [game.camHUD];
    barBottom.y = 652 + barBottom.height; //652
    add(barTop);
    add(barBottom);

    black = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    black.cameras = [game.camOther];
    black.alpha = 0;
    add(black); 

    game.snapCamFollowToPos(700, 500);
}

function onSongStart()
{
    if(PlayState.SONG.song.toLowerCase() == 'goo-weekly-mix')
    {
        game.ghostsAllowed = true;
        game.camHUD.alpha = 0;
        black.alpha = 1;
        FlxTween.tween(black, {alpha: 0}, 7.75, {ease: FlxEase.linear});   
    }
}

function onEvent(eventName, value1, value2)
{
    if (eventName == 'goo shit') 
    {
        switch(value1)
        {
            case 'black bars':
                switch(value2)
                {
                    case 'on':
                        FlxTween.tween(barTop, {y: 0}, 1, {ease: FlxEase.expoOut});
                        FlxTween.tween(barBottom, {y: 652}, 1, {ease: FlxEase.expoOut});
                        prostate.visible = true;
                        FlxFlicker.flicker(prostate, 2, 0.25, false);
                    case 'off':
                        FlxTween.tween(barTop, {y: 0 - 68}, 1, {ease: FlxEase.expoOut});
                        FlxTween.tween(barBottom, {y: 652 + 68}, 1, {ease: FlxEase.expoOut});
                }
        }
    }
}