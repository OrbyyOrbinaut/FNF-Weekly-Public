var FILE_PREFIX:String = 'doctor/';

var dayBG:BGSprite;
var nightBG:BGSprite;
var white:FlxSprite;
var bar:Bar;
var sign:FlxSprite;
var signPibby:FlxSprite;
var heart:BGSprite;
var heartRad:Float = 0;
var rainIntensity:Float = 0.1;
var rainShader; // ty base game
var isRaining:Bool = false;
var coolSection:Bool = false;

function onLoad()
{
    dayBG = new BGSprite(FILE_PREFIX + 'Stadium_day', 0, 0);
    dayBG.setGraphicSize(FlxG.width + 2, FlxG.height + 2);
    add(dayBG);

    nightBG = new BGSprite(FILE_PREFIX + 'Stadium_night', 0, 0);
    nightBG.setGraphicSize(FlxG.width + 2, FlxG.height + 2);
    add(nightBG);

    sign = new FlxSprite(623, 167);
    sign.frames = Paths.getSparrowAtlas(FILE_PREFIX + 'text');
    sign.animation.addByPrefix('texts', 'text0', 1, true);
    sign.antialiasing = ClientPrefs.globalAntialiasing;
    add(sign);
    sign.animation.play('texts', false);

    signPibby = new FlxSprite(623, 115);
    signPibby.frames = Paths.getSparrowAtlas(FILE_PREFIX + 'textglitch');
    signPibby.animation.addByPrefix('texts', 'textglitch0', 24, true);
    signPibby.antialiasing = ClientPrefs.globalAntialiasing;
    signPibby.visible = false;
    add(signPibby);
    signPibby.animation.play('texts', false);

    bar = new Bar(155, 340, FILE_PREFIX + 'rdhealthBarBG', function() return game.health, 0, 2);
    bar.rightBar.loadGraphic(Paths.image(FILE_PREFIX + 'rdhealthBar'));
    bar.leftBar.loadGraphic(Paths.image(FILE_PREFIX + 'rdhealthBar'));
    bar.setColors(FlxColor.LIME, FlxColor.YELLOW);
    add(bar);

    heart = new BGSprite(FILE_PREFIX + 'heart', 1050, 290);
    heart.updateHitbox();
    add(heart);

    white = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
    white.cameras = [game.camHUD];
    white.alpha = 0;
    add(white);

    rainShader = newShader('rain');
    rainShader.setFloatArray('uScreenResolution', [FlxG.width, FlxG.height]);
    rainShader.setFloat('uTime', 0);
    rainShader.setFloat('uScale', FlxG.height / 200);
    rainShader.setFloat('uIntensity', rainIntensity);
}

function onCreatePost()
{
    for (i in [game.iconP1, game.iconP2, game.timeTxt, game.timeBar, game.timeBarBG, game.healthBar, game.healthBarBG]) {
        i.visible = false;
    }

    game.scoreTxt.y = 15;

    nightBG.alpha = 0;

    game.snapCamFollowToPos(1280 / 2, 720 / 2);
    game.isCameraOnForcedPos = true;
}

function onUpdatePost(elapsed:Float)
{
    heartRad += elapsed;
    heart.angle = 20 * Math.sin(heartRad * 0.5) + 10;

    var mult:Float = FlxMath.lerp(0.75, heart.scale.x, CoolUtil.boundTo(0.75 - (elapsed * 9), 0, 0.75));
    heart.scale.set(mult, mult);
    heart.updateHitbox();

    if (isRaining) 
    {
        rainShader.setFloatArray('uCameraBounds', [game.camGame.scroll.x + game.camGame.viewMarginX, game.camGame.scroll.y + game.camGame.viewMarginY, game.camGame.scroll.x + game.camGame.viewMarginX + game.camGame.width, game.camGame.scroll.y + game.camGame.viewMarginY + game.camGame.height]);
        rainShader.setFloat('uTime', heartRad);
        rainShader.setFloat('uIntensity', rainIntensity);
        rainIntensity += 0.000025;
    }
}

function onBeatHit()
{
    if (curBeat % 2 == 0) 
    {
        heart.scale.set(0.9, 0.9);
    }

    if (game.camZooming && ClientPrefs.camZooms && coolSection && curBeat % 2 == 0)
    {
        FlxG.camera.zoom += 0.015 * game.camZoomingMult;
        game.camHUD.zoom += 0.03 * game.camZoomingMult;
    }
}

function onGhostTap()
{
    if (ClientPrefs.ghostTapping) {
        FlxG.sound.play(Paths.sound('pop'), 0.6);
        game.boyfriend.playAnim('press', true);
    }
}

function onEvent(name:String, v1:String, v2:String) //Leth im gonna kill u for writing it like this
{
    if (name == 'Rhythm Doctor Events') 
    {
        switch (v1) {
            case 'Zoom On Lucky':
                game.defaultCamZoom = 1.8;
                game.isCameraOnForcedPos = false;

            case 'Fade':
                FlxTween.tween(white, {alpha : 1}, 0.3636 * 2, {onComplete: 
                    function(twn:FlxTween) {
                        FlxTween.tween(white, {alpha : 0}, 0.3636 * 2);
                }});

            case 'Night':
                game.defaultCamZoom = 1;
                game.snapCamFollowToPos(1280 / 2, 720 / 2);
                game.isCameraOnForcedPos = true;

                dayBG.alpha = 0;
                nightBG.alpha = 1;
                sign.alpha = false;
                signPibby.visible = true;

                isRaining = true;
                ExUtils.addShader(rainShader, game.camGame);
        }
    }
    else if (name == 'Beat Bop')
    switch(v1)
    {
        case 'on':
        coolSection = true;
        case 'off':    
        coolSection = false;
    }
}

function onGameOverStart() 
{
    setGameOverVideo('otc_gameover');
}