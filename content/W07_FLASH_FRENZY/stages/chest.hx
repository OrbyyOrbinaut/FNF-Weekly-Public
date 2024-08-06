var PREFIX:String = 'isaac/';
var white:FlxSprite;
var sketch:FlxSprite;
var intro:FlxAnimate;

var tweakFolder:String = 'W07_FLASH_FRENZY'; // CHANGE THIS ON RELEASE

function onLoad()
{
    game.skipCountdown = true;

    var bg:BGSprite = new BGSprite(PREFIX + 'bg', 480, 140);
    bg.scale.set(1.1, 1.1);
    add(bg);

    sketch = new FlxSprite(320, 80);
    sketch.frames = Paths.getSparrowAtlas(PREFIX + 'doodle');
    sketch.animation.addByPrefix('loop', 'doodle0', 24, true);
    sketch.antialiasing = ClientPrefs.globalAntialiasing;
    sketch.blend = BlendMode.ADD;
    sketch.alpha = 0.001;
    add(sketch);
    sketch.animation.play('loop', false);

    white = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
    white.cameras = [game.camHUD];
    white.alpha = 0;
    add(white);

    intro = new FlxAnimate(560, 190, 'content/' + tweakFolder + '/images/' + PREFIX + 'intro');
    intro.showPivot = false;
    intro.anim.addBySymbol('intro', 'intro', 24, true, 0, 0);
    intro.antialiasing = ClientPrefs.globalAntialiasing;
    intro.alpha = 0.001;
    add(intro);

    game.precacheList.set('isaacIntro', 'sound');
    game.precacheList.set('isaachurt0', 'sound');
    game.precacheList.set('isaachurt1', 'sound');
    game.precacheList.set('isaachurt2', 'sound');
}

function onCreatePost()
{
    var floorback:BGSprite = new BGSprite(PREFIX + 'floorback', game.dad.x - 130, game.dad.y + 220);
    add(floorback);

    var floorfront:BGSprite = new BGSprite(PREFIX + 'floorfront', game.boyfriend.x - 190, game.boyfriend.y + 350);
    add(floorfront);

    game.healthBar.flipX = true;
    game.healthBarSide = 1;
    game.iconP1.flipX = !game.iconP1.flipX;
    game.iconP2.flipX = !game.iconP2.flipX;
}

function onEvent(name:String, v1:String, v2:String)
{
    if (name == 'Isaac Events') // hi orbyy 
    {
        switch (v1) 
        {
            case 'bye bye':
                game.camGame.visible = false;
            
            case 'Fade In':
                FlxTween.tween(white, {alpha : 1}, 0.4286 * 2);
            
            case 'Fade Out':
                FlxTween.tween(white, {alpha : 0}, 0.4286 * 2);
                game.camGame.visible = true;
                sketch.alpha = 1;
        }
    }
}

function onSongStart()
{
    //intro.anim.play('intro');
}

function doStartCountdown()
{
    return Function_Stop;
}

function presongCutscene()
{
    game.inCutscene = true;
    game.camHUD.alpha = 0.001;
    game.snapCamFollowToPos(1100, 500);
    FlxG.sound.play(Paths.sound('isaacIntro'));
    intro.alpha = 1;
    intro.anim.play('intro');
    new FlxTimer().start(3.5, function(tmr:FlxTimer) 
        {
            FlxTween.tween(game.camHUD, {alpha : 1}, 1);
            FlxTween.tween(intro, {alpha : 0}, 0.5);
            FlxTween.tween(FlxG.camera, {zoom : 1.2}, 1, {ease: FlxEase.sineInOut});
            game.inCutscene = false;
            game.startCountdown();
            modManager.setValue("opponentSwap", 1);
        });
}

function onMoveCamera()
{
    switch (game.whosTurn)
    {
        case 'dad':
            game.defaultCamZoom = 1.2;
        default:
            game.defaultCamZoom = 1.1;
    }
}

function noteMiss(note:Note)
{
    var thisAnim:String = game.boyfriend.animation.curAnim.name;
    if (thisAnim != 'miss') {
        FlxG.sound.play(Paths.soundRandom('isaachurt', 0, 2), 1);
    }
    game.boyfriend.playAnim('miss', false);
}

function onGameOverStart()
{
    setGameOverVideo('sexbluekiller');
}