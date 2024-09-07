// I'm so exhausted man

var rainIntensity:Float = 0.2;
var rainShader; // ty base game
var rainTime:Float = 0;
var realSongLength:Float = 0;

var mosaic = newShader("mosaic");
var mosaicStrength:Float = 1;

var bfZoom:Float = 0.6;
var bossZoom:Float = 0.5;

var camCanZoom:Bool = true;
var camZoomOveride:Bool = false;

var shit = null; //array of stuff from da HUD

var intro:PsychVideoSprite;
var emotional:PsychVideoSprite;

var leftpile:FlxSprite;
var rightpile:FlxSprite;
var blackHUD:FlxSprite;
var whiteHUD:FlxSprite;
var titlecard:FlxSprite;

var bossTweak:Float = 0;
var bfTweak:Float = 0;
var iconCanTweak:Bool = true;
var isSpinning:Bool = false;

var heythere:BGSprite;

var videoString:String = 'bnb_gameover';

var lyrics:LyricText;

function onLoad() 
{
    game.skipCountdown = true;
    
    var sky:FlxSprite = new FlxSprite(-491, -800).loadGraphic(Paths.image('bud/sky'));
    sky.antialiasing = ClientPrefs.globalAntialiasing;
    sky.scrollFactor.set(0.5, 0.5);
    add(sky);

    var city:FlxSprite = new FlxSprite(-575, -772).loadGraphic(Paths.image('bud/city'));
    city.antialiasing = ClientPrefs.globalAntialiasing;
    city.scrollFactor.set(0.6, 0.6);
    add(city);

    var fire:FlxSprite = new FlxSprite(-1266, -375);
    fire.antialiasing = ClientPrefs.globalAntialiasing;
    fire.scrollFactor.set(0.95, 0.95);
    fire.frames = Paths.getSparrowAtlas("bud/fire");
    fire.animation.addByPrefix('idle', 'flicker0', 24, true);
    fire.animation.play("idle");
    add(fire);
    
    var mainbg:FlxSprite = new FlxSprite(-1214, -945).loadGraphic(Paths.image('bud/mainbg'));
    mainbg.antialiasing = ClientPrefs.globalAntialiasing;
    add(mainbg);

    leftpile = new FlxSprite(-1350, 126).loadGraphic(Paths.image('bud/leftpile'));
    leftpile.antialiasing = ClientPrefs.globalAntialiasing;
    leftpile.scrollFactor.set(1.1, 1.1);
    foreground.add(leftpile);

    rightpile = new FlxSprite(1574, 138).loadGraphic(Paths.image('bud/rightpile'));
    rightpile.antialiasing = ClientPrefs.globalAntialiasing;
    rightpile.scrollFactor.set(1.1, 1.1);
    foreground.add(rightpile);

    var addlayer:FlxSprite = new FlxSprite(-1207, -929).loadGraphic(Paths.image('bud/add'));
    addlayer.antialiasing = ClientPrefs.globalAntialiasing;
    addlayer.blend = 0;
    addlayer.alpha = 0.5;
    add(addlayer);

    var multiplylayer:FlxSprite = new FlxSprite(-1207, -929).loadGraphic(Paths.image('bud/multiply'));
    multiplylayer.antialiasing = ClientPrefs.globalAntialiasing;
    multiplylayer.blend = 9; // ??????????
    add(multiplylayer);

    blackStage = new FlxSprite(-1000, -750).makeGraphic(FlxG.width * 2.5, FlxG.height * 2.5, FlxColor.BLACK); // this is dumb and gay to have two of these but its ok
    blackStage.visible = false;
    blackStage.alpha = 0.5;
    add(blackStage);

    blackHUD = new FlxSprite(0, 0).makeGraphic(FlxG.width * 1.2, FlxG.height * 1.2, FlxColor.BLACK); // UGHHHHHHH
    blackHUD.cameras = [game.camHUD];
    add(blackHUD);

    whiteHUD = new FlxSprite(0, 0).makeGraphic(FlxG.width * 1.2, FlxG.height * 1.2, FlxColor.WHITE); // UGHHHHHHH
    whiteHUD.alpha = 0;
    whiteHUD.cameras = [game.camHUD];
    add(whiteHUD);

    titlecard = new FlxSprite(0, 0).loadGraphic(Paths.image('bud/introcard')); // UGHHHHHHH
    //blackHUD.alpha = 0;
    titlecard.screenCenter();
    titlecard.cameras = [game.camOther];
    titlecard.alpha = 0;
    add(titlecard);

    heythere = new BGSprite('bud/Hey there', 0, 0);
    heythere.scale.set(0.15, 0.15);
    heythere.cameras = [game.camOther];
    heythere.screenCenter();
    heythere.alpha = 0.001;
    add(heythere);

    rainShader = newShader('rain');
    rainShader.setFloatArray('uScreenResolution', [FlxG.width, FlxG.height]);
    rainShader.setFloat('uTime', 0);
    rainShader.setFloat('uScale', FlxG.height / 300);
    rainShader.setFloat('uIntensity', rainIntensity);
    ExUtils.addShader(rainShader, game.camGame);
    ExUtils.addShader(mosaic, game.camGame);
    mosaic.data.uBlocksize.value = [1, 1];
}

function onCreatePost(){
    game.snapCamFollowToPos(710, 175);
    
    intro = new PsychVideoSprite();
    intro.addCallback('onFormat',()->{
        intro.cameras = [game.camOther];
        intro.setGraphicSize(FlxG.width);
        intro.screenCenter();
    });
    intro.addCallback('onStart',()->{
        for(s in shit){ s.visible = false; }
        modManager.setValue("alpha", 1);
        game.camGame.alpha = 0;
    });
    intro.addCallback('onEnd',()->{
        intro.kill();
        game.camGame.alpha = 1;
        game.camGame.flash(0xFFFFFFFF, 1.0);
        for(s in shit){ s.visible = true; }
        modManager.setValue("alpha", 0);
        blackHUD.alpha = 0;
    });
    intro.load(Paths.video('BudsIntro'), [PsychVideoSprite.muted]);
    intro.antialiasing = true;
    add(intro);

    emotional = new PsychVideoSprite();
    emotional.addCallback('onFormat',()->{
        emotional.cameras = [game.camHUD];
        emotional.setGraphicSize(FlxG.width);
        emotional.screenCenter();
    });
    emotional.load(Paths.video(ClientPrefs.flashing ? 'notsillybilly' : 'notsillybillyNONFLASHING'), [PsychVideoSprite.muted]);
    emotional.antialiasing = true;
    emotional.pauseOverride = true;
    add(emotional);

    lyrics = new LyricText(FlxG.height - 150, FlxColor.YELLOW, 'vcr.ttf', 28);
    lyrics.cameras = [game.camOther];
    lyrics.lyricLoadCallback = function() {
        lyrics.screenCenter(FlxAxes.X);
    }
    add(lyrics);

    shit = [game.scoreTxt, game.timeBar, game.timeBarBG, game.timeTxt, game.healthBarBG, game.healthBar, game.iconP1, game.iconP2];
}

function onMoveCamera(){ 
    if(!camZoomOveride)
    {
        switch(game.whosTurn)
        {
            case 'dad':
                game.defaultCamZoom = bossZoom;
            case 'boyfriend':
                game.defaultCamZoom = bfZoom;
        }
    }
}

function onUpdate(elapsed:Float)
{
    rainTime += elapsed;
    rainTime++; //My stupid way of making da rain faster
    
    rainShader.setFloatArray('uCameraBounds', [game.camGame.scroll.x + game.camGame.viewMarginX, game.camGame.scroll.y + game.camGame.viewMarginY, game.camGame.scroll.x + game.camGame.viewMarginX + game.camGame.width, game.camGame.scroll.y + game.camGame.viewMarginY + game.camGame.height]);
    rainShader.setFloat('uTime', rainTime);
    rainShader.setFloat('uIntensity', rainIntensity);

    game.camZooming = camCanZoom;

    if (isSpinning) {
        game.iconP2.angle += elapsed * (60 / curBpm) * 12000;
    }
}

function onSongStart()
{
    realSongLength = PlayState.instance.songLength;
    PlayState.instance.songLength = 199000;
    intro.play();
    emotional.play(); // This is to prevent the video from desyncing from the song as much as possible
    emotional.pause();
    emotional.visible = false; // Justtt incase
    //trace(realSongLength);
}

function onBeatHit()
{
    // i love you tweaking icons
    if (iconCanTweak) {
        var degreeMult:Float = ((game.curBeat % 2) * 2) - 1;

        FlxTween.angle(game.iconP1, bfTweak * degreeMult, 0, 60 / curBpm, {ease: FlxEase.sineOut});
        FlxTween.angle(game.iconP2, bossTweak * degreeMult, 0, 60 / curBpm, {ease: FlxEase.sineOut});
    }
}

function onEvent(name, v1, v2) 
{
    switch (name)
    {
        case 'Bud Events':
            switch (v1) 
            {
                case 'fade':
                    FlxTween.tween(blackHUD, {alpha: 1}, 0.25);
                case 'fade hud':
                    for(s in shit){ FlxTween.tween(s, {alpha: 0}, 0.25, {ease: FlxEase.quadOut}); }
                    FlxTween.num(0, 1, 0.25, {ease: FlxEase.quadOut, onUpdate: function(hudIn:FlxTween){
                        modManager.setValue("alpha", hudIn.value);
                    }, onComplete: ()->{ modManager.setValue("alpha", 1); }});
                case 'fade in hud':
                    for(s in shit){ FlxTween.tween(s, {alpha: 1}, 0.25, {ease: FlxEase.quadOut}); }
                    FlxTween.num(1, 0, 0.25, {ease: FlxEase.quadOut, onUpdate: function(hudIn:FlxTween){
                        modManager.setValue("alpha", hudIn.value);
                    }, onComplete: ()->{ modManager.setValue("alpha", 0); }});
                case 'norbert video':
                    emotional.restart([PsychVideoSprite.muted]);
                    emotional.visible = true;
                    emotional.pauseOverride = false;
                    emotional.addCallback('onEnd',()->{
                        game.camGame.flash(0xFFFFFFFF, 1.0);
                        blackHUD.alpha = 0;
                        emotional.kill();
                        camCanZoom = true;
                        game.boyfriendCameraOffset[0] = -200;
                        game.boyfriendCameraOffset[1] = -210;
                        game.opponentCameraOffset[0] = 100;
                        game.opponentCameraOffset[1] = -185;
                        videoString = 'OOGITYGOOGAMEOVER';
                        FlxTween.tween(titlecard, {alpha: 1}, 0.5);
                        new FlxTimer().start(1.25, function(tmr:FlxTimer)
                        {
                            FlxTween.tween(titlecard, {alpha: 0}, 0.5);
                        });
                    });
                    game.camHUD.zoom = 1;
                    game.vocals.volume = 1;
                case 'real time':
                    PlayState.instance.songLength = realSongLength;
                case 'hud back':
                    for(s in shit){ FlxTween.tween(s, {alpha: 1}, 1.5, {ease: FlxEase.quadOut}); }
                    FlxTween.num(1, 0, 1.5, {ease: FlxEase.quadOut, onUpdate: function(hudIn:FlxTween){
                        modManager.setValue("alpha", hudIn.value);
                    }, onComplete: ()->{ modManager.setValue("alpha", 0); }});
                case 'cut to black':
                    for(s in shit){ s.alpha = 0; }
                    modManager.setValue("alpha", 1);
                    blackHUD.alpha = 1;
                    game.camGame.alpha = 0; // this because windowed fullscreen has a sinlgle pixel u can see and im not bothered to try to properly fix it fuck my baka life
                    camGame.setFilters([]);
                case 'hey there':
                    FlxTween.tween(heythere, {alpha : 0.1}, (60 / curBpm) * 4, {onComplete: function(twn:FlxTween) {
                        heythere.alpha = 0;
                    }});
                case 'cut in':
                    for(s in shit){ s.alpha = 1; }
                    modManager.setValue("alpha", 0);
                    blackHUD.alpha = 0;
                    game.camGame.alpha = 1;
                    ExUtils.addShader(rainShader, game.camGame);
                    if(v2 == 'flash')
                    {
                        game.camGame.flash(0xFFFFFFFF, 1.0);
                    }
                case 'Camera Zoom Override':
                    switch(v2)
                    {
                        case 'on':
                            camZoomOveride = true;
                        case 'off':
                            camZoomOveride = false;
                    }
                case 'Tense Section':
                    switch(v2)
                    {
                        case 'on':
                            blackStage.visible = true;
                            rightpile.alpha = 0;
                            leftpile.alpha = 0;
                        case 'off':
                            blackStage.visible = false;
                            rightpile.alpha = 1;
                            leftpile.alpha = 1;
                    }
                case 'Set Exact Zoom': // Don't feel like hardcoding this even though I've meant to for weeks
                    var val2:Float = Std.parseFloat(v2);
                    game.defaultCamZoom = val2;
                    trace(val2);
                case 'Mosaic': //fuck my prostate burns
                    FlxTween.num(1, 25, 1.5, {ease: FlxEase.linear, onUpdate: function(strength:FlxTween){
                        mosaic.data.uBlocksize.value = [strength.value, strength.value];
                    }});
                case 'fakeout zoom':
                    camCanZoom = false;
                    FlxTween.tween(FlxG.camera, {zoom: 0.75}, 1.0, {ease: FlxEase.quadOut});
                case 'Clear Mosaic':
                    ExUtils.removeShader(mosaic, game.camGame);
                case 'camera offset': //FUCK THIS IS THE MOST GAY THING EVER be nice.
                    game.boyfriendCameraOffset[0] = -175;
                    game.boyfriendCameraOffset[1] = -100;
                    game.opponentCameraOffset[0] = 75;
                    game.opponentCameraOffset[1] = -75;
                case 'spin dash': // blame mocha
                    iconCanTweak = false;
                    FlxTween.angle(game.iconP2, 0, 360 * 4, (60 / curBpm) * 4, {ease: FlxEase.expoIn, onComplete: function(twn:FlxTween) {
                        isSpinning = true;
                    }});
                case 'end':
                    game.isCameraOnForcedPos = true;
                    camCanZoom = false;
                    FlxTween.tween(game.camFollow, {x: 710, y: -200}, 1.0, {ease: FlxEase.smootherStepInOut});
                    FlxTween.tween(whiteHUD, {alpha: 1}, 0.75, {ease: FlxEase.linear});
                    FlxTween.tween(FlxG.camera, {zoom: 0.45}, 1.0, {ease: FlxEase.smootherStepInOut});
                case 'metadata':
                    trace('fuck my faggot baka life');
                    PlayState.ihatemylifethisisthelastthingthatneedstobecoded = true;
            }
        
        case 'Set Icon Tweak':
            bossTweak = Std.parseFloat(v1);
            bfTweak = Std.parseFloat(v2);

        case 'Bud Lyric Events':
            switch (v1) 
            {
                case 'set':
                    lyrics.loadLyric(v2);

                case 'next':
                    lyrics.nextSlice();

                case 'fade':
                    lyrics.fadeOut();
            }
    }
}

function onGameOverStart() 
{
    setGameOverVideo(videoString);
}

function onDestroy() {
    if (intro != null) intro.destroy();
    if (emotional != null) emotional.destroy();
}