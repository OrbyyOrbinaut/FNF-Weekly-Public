var lyrics:FlxText;
var isLooking:Bool = false;
var fade:FlxSprite;
var intro:PsychVideoSprite;
var watchingCutscene:Bool = false;
var hasWatchedCutscene:Bool = false;
var skip:FlxText;

function onLoad()
{
    game.addCharacterToList('disabled-looking');
    game.skipCountdown = true;

    lyrics = new FlxText().setFormat(Paths.font('vcr.ttf'), 32, 0xFFFFFFFF, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
    lyrics.text = '';
    lyrics.antialiasing = true;
    lyrics.borderSize = 2;

    lyrics.cameras = [game.camHUD];
    lyrics.screenCenter();
    lyrics.y += (ClientPrefs.downScroll ? -200 : 200);
    lyrics.updateHitbox();

    skip = new FlxText(10, 10).setFormat(Paths.font('vcr.ttf'), 24, 0xFFFFFFFF, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, 0xFF000000);
    skip.text = 'Click to skip';
    skip.alpha = 0.75;
    skip.cameras = [game.camOther];

    fade = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    fade.cameras = [game.camOther];
    add(fade);
}

function onCreatePost()
{
    game.add(lyrics);

    game.comboOffsetCustom = [200, 300, 250, 420];

    for (i in [game.timeTxt, game.timeBar, game.timeBarBG]) i.visible = false;
    game.scoreTxt.y = game.timeTxt.y;
    if (ClientPrefs.downScroll) game.scoreTxt.y += 10;

    game.dad.scrollFactor.set(0.7, 0.7);
    game.dad.visible = false;
    game.iconP2.alpha = 0.001;
}

function doStartCountdown()
{
    return Function_Stop;
}

function presongCutscene() // didn't know nv had this, neat
{
    FlxG.mouse.visible = true;

    watchingCutscene = true;
    game.inCutscene = true;
    game.camHUD.visible = false;
    intro = new PsychVideoSprite();
    intro.addCallback('onFormat',()->{
        intro.setGraphicSize(FlxG.width,FlxG.height);
        intro.updateHitbox();
        intro.screenCenter();
        intro.antialiasing = true;
        intro.cameras = [game.camOther];
    });
    intro.addCallback('onEnd',()->{
        endIntro();
    });
    intro.load(Paths.video('trade'));
    intro.play();
    add(intro);

    game.add(skip);
}

function endIntro() {
    trace('hi friend');
    intro.stop();
    intro.destroy();
    watchingCutscene = false;
    game.inCutscene = false;
    game.camHUD.visible = true;
    hasWatchedCutscene = true;
    FlxG.mouse.visible = false;
    skip.destroy();
    game.startCountdown();
}

function onUpdatePost(elapsed:Float)
{
    if (FlxG.mouse.justPressed) endIntro();
}

function onEvent(name:String, v1:String, v2:String)
{
    switch (name)
    {
        case 'Lyrics':
            lyrics.text = v1;
            lyrics.screenCenter(FlxAxes.X);
            lyrics.updateHitbox();

            lyrics.color = FlxColor.fromString(v2);

        case 'Pokepasta Events':
            switch (v1) 
            {
                case 'Toggle Black': 
                    fade.visible = !fade.visible;
                case 'hey there friend':
                    game.dad.playAnim('intro');
                    game.dad.visible = true;
                    game.dad.animTimer = 0.6;

                    FlxTween.tween(game.iconP2, {alpha: 1}, 0.6);

                case 'sad gold':
                    game.dad.playAnim('tweak');
                    game.dad.animTimer = 999;

                case 'No More':
                    game.dad.animTimer = 0;
                    game.dad.playAnim('no more');
                    game.dad.animTimer = 999;

                case 'reset to idle':
                    game.dad.animTimer = 0;
                    game.dad.dance();
                    
                case 'Look Up':
                    game.triggerEventNote('Change Character', 'bf', 'disabled-looking');
                    game.boyfriend.playAnim('look');
                    game.boyfriend.animTimer = 1.25;
            }
    }
}

function onMoveCamera() 
{
    switch (game.whosTurn)
    {
        case 'dad':
            game.defaultCamZoom = 1.3;
        default:
            game.defaultCamZoom = 1;
    }
}

function onGameOverStart()
{
    setGameOverVideo('bisabled');
}
