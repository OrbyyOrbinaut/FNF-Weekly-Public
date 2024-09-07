var PREFIX:String = 'dragon_ball/';
var TWEAK_NAME:String = 'W09_ANIME';

var inSpace:Bool = false;
var radians:Float = 0;
var bfY:Float = 0;
var dadY:Float = 0;

// intro
var intro:PsychVideoSprite;
var black:FlxSprite;

// first bg
var sky:BGSprite;
var clouds:Array<BGSprite> = [];
var cloudTimer:Float = 0;

// second bg
var trans:BGSprite;
var scream:FlxAnimate;
var stars:BGSprite;
var planet:BGSprite;
var blackHUD:FlxSprite;

// ending
var grab:BGSprite;
var zoomOut:BGSprite;

function onLoad()
{
    game.skipCountdown = true;
    game.ghostsAllowed = true;

    sky = new BGSprite(PREFIX + 'sky', 0, 0, 0, 0);
    sky.setGraphicSize(FlxG.width * 2, FlxG.height * 2);
    add(sky);

    stars = new BGSprite(PREFIX + 'gggg', -400, -300, 0, 0);
    stars.setGraphicSize(FlxG.width * 3, FlxG.height * 3);
    stars.alpha = 0.001;
    add(stars);

    planet = new BGSprite(PREFIX + 'planet', -400, -200, 0.1, 0.1);
    planet.setGraphicSize(FlxG.width * 3, FlxG.height * 3);
    planet.alpha = 0.001;
    add(planet);

    trans = new BGSprite(PREFIX + 'bigcloud', 0, -2000);
    trans.cameras = [game.camHUD];
    add(trans);

    grab = new BGSprite(PREFIX + 'handgrab', 0, 0);
    grab.cameras = [game.camOther];
    grab.setGraphicSize(FlxG.width, FlxG.height);
    grab.screenCenter();
    grab.alpha = 0.001;
    add(grab);

    zoomOut = new BGSprite(PREFIX + 'fellaend', 0, 0);
    zoomOut.cameras = [game.camOther];
    zoomOut.setGraphicSize(FlxG.width, FlxG.height);
    zoomOut.screenCenter();
    zoomOut.alpha = 0.001;
    add(zoomOut);

    black = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    black.cameras = [game.camOther];
    add(black);

    blackHUD = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    blackHUD.cameras = [game.camHUD];
    blackHUD.alpha = 0;
    add(blackHUD);
}

function onCreatePost() 
{
    game.scoreTxt.font = Paths.font('dragonfont.ttf');
    game.scoreTxt.antialiasing = ClientPrefs.globalAntialiasing;
    game.timeTxt.font = Paths.font('dragonfont.ttf');
    game.timeTxt.antialiasing = ClientPrefs.globalAntialiasing;

    // ty termina
    intro = new PsychVideoSprite();
    intro.addCallback('onFormat',()->{
        intro.cameras = [game.camOther];
        intro.setGraphicSize(FlxG.width);
        intro.screenCenter();
    });
    intro.addCallback('onEnd',()->{
        game.camHUD.alpha = 1;
        game.camGame.flash(0xFFFFFFFF, 1.0);
        intro.kill();
        black.alpha = 0;

        game.isCameraOnForcedPos = true;
        game.boyfriend.y = 1000;
        FlxTween.tween(game.boyfriend, {y: bfY}, 0.8, {ease: FlxEase.sineOut, onComplete: function(twn:FlxTween) {
            game.isCameraOnForcedPos = false;
        }});
    });
    intro.load(Paths.video('db_intro'), [PsychVideoSprite.muted]);
    intro.antialiasing = true;
    add(intro);

    scream = new FlxAnimate(game.boyfriend.x - 15, game.boyfriend.y, 'content/' + TWEAK_NAME + '/images/' + PREFIX + 'scream');
    scream.showPivot = false;
    scream.anim.addBySymbol('scream', 'trans', 0, 0, 24);
    scream.antialiasing = ClientPrefs.globalAntialiasing;
    scream.alpha = 0.001;
    add(scream);

    bfY = game.boyfriend.y;
    dadY = game.dad.y;
}

function onSongStart()
{
    intro.play();
}

function spawnCloud() 
{
    // math !
    var cloud:BGSprite = new BGSprite(PREFIX + 'cloud_' + FlxG.random.int(1, 6), FlxG.random.float(game.dad.x - 1400, game.boyfriend.x + 1400), -1400, 0.7, 0.7);
    cloud.alpha = FlxG.random.float(0.3, 1);
    if (FlxG.random.int(1, 10) == 10) {
        cloud.setGraphicSize(cloud.width * 4, cloud.height * 4);
        cloud.scrollFactor.x = 1.2;
        cloud.scrollFactor.y = 1.2;
        game.add(cloud);
    }
    else {
        cloud.setGraphicSize(cloud.width * 2, cloud.height * 2);
        add(cloud);
    }
    clouds.push(cloud);

    FlxTween.tween(cloud, {y : 2000}, 0.8, {onComplete: function(twn:FlxTween) {
        clouds.remove(cloud);
        cloud.kill();
        cloud.destroy();
    }});
}

function onEvent(name, v1, v2)
{
    switch (name) 
    {
        case 'Dragon Ball Events':
            switch (v1)
            {
                case 'transition':
                    FlxTween.tween(trans, {y : 2000}, 1.3);
                    new FlxTimer().start(0.6, ()->{
                        inSpace = true;
                        for (cloud in clouds) {
                            cloud.kill();
                            cloud.destroy();
                        }
                        sky.visible = false;

                        stars.alpha = 1;
                        planet.alpha = 1;

                        game.dad.x -= 200;
                        game.boyfriend.x += 200;

                        game.defaultCamZoom = 0.4;
                    });

                case 'emotional':
                    blackHUD.alpha = 1;

                case 'emotional 2':
                    FlxTween.tween(blackHUD, {alpha : 0}, 2.5);

                case 'godku':
                    game.triggerEventNote('Change Character', 'bf', 'godku');

                    game.boyfriend.alpha = 0.001;
                    scream.alpha = 1;
                    scream.anim.play('scream');
                    new FlxTimer().start(2.9, ()->{
                        scream.alpha = 0;
                        game.boyfriend.alpha = 1;
                    });

                case 'ending':
                    game.boyfriend.playAnim('sleepyhead');
                    game.boyfriend.animTimer = 999;
                    new FlxTimer().start(0.4, ()->{
                        FlxTween.tween(game.dad, {x : dad.x + 300}, 0.4, {ease: FlxEase.sineIn, onComplete: function(twn:FlxTween){
                            FlxG.sound.play(Paths.sound('grab'));
                            grab.alpha = 1;
                            new FlxTimer().start(2, ()->{
                                FlxG.sound.play(Paths.sound('yap'));
                                FlxTween.tween(zoomOut, {alpha : 1}, 3);
                            });
                        }});
                    });
            }
    }
}

function onUpdatePost(elapsed:Float)
{
    radians += elapsed;
    cloudTimer += elapsed;

    if (!inSpace) {
        if (cloudTimer > 0.3) {
            spawnCloud();
            cloudTimer = 0;
        }
    }

    game.dad.y = 40 * Math.cos(radians + 1) + dadY;
}

function onGameOverStart()
{
    setGameOverVideo('db_gameover'); // these bitches gay! good for them, good for them
}

function onDestroy() {
    if (intro != null) intro.destroy();
}