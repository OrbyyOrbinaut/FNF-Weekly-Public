addHaxeLibrary('FlxFlicker', 'flixel.effects'); // This lets me do the flicker thing.
var blackScreen:FlxSprite;
var grunt:FlxAnimate;
var gruntTriggerAmount:Int;
var gruntTrigger1:Int;
var gruntTrigger2:Int;
var gruntTrigger3:Int;
var somewhere:FlxSprite;
var play:FlxSprite;
var intropico:FlxSprite;
var introhank:FlxSprite;

function onLoad() {
    var bg:FlxSprite = new FlxSprite(-855, -825);
    bg.loadGraphic(Paths.image("nevada/sky"));
    bg.antialiasing = true;
    bg.scrollFactor.set(0.85, 0.85);
	add(bg);

    var mountain:FlxSprite = new FlxSprite(284, 303);
    mountain.loadGraphic(Paths.image("nevada/mountains"));
    mountain.antialiasing = true;
    mountain.scrollFactor.set(0.9, 0.9);
	add(mountain);

    var bgbuilding:FlxSprite = new FlxSprite(-115, -411);
    bgbuilding.loadGraphic(Paths.image("nevada/buildings"));
    bgbuilding.antialiasing = true;
    bgbuilding.scrollFactor.set(0.95, 1.0);
	add(bgbuilding);

    var floor:FlxSprite = new FlxSprite(-811.2, -24.8);
    floor.loadGraphic(Paths.image("nevada/floor"));
    floor.antialiasing = true;
	add(floor);

    grunt = new FlxAnimate(-225, 258, 'content/W03_CHECK_NEWGROUNDS/images/nevada/grunt');
    grunt.showPivot = false;
    grunt.anim.addBySymbol('gruntwalking', 'gruntwalking',24,true,0,0);
    grunt.anim.addBySymbol('grunthi', 'grunthi',24,true,0,0);
    grunt.anim.addBySymbol('gruntwalkingfast', 'gruntwalkingfast',24,true,0,0);
    grunt.antialiasing = true;
    add(grunt);

    var fgbuilding:FlxSprite = new FlxSprite(-844.3, -559.45);
    fgbuilding.loadGraphic(Paths.image("nevada/building_hole"));
    fgbuilding.antialiasing = true;
	add(fgbuilding);
    
    blackScreen = new FlxSprite().makeGraphic(1, 1, 0xFF000000);
    blackScreen.scale.set(FlxG.width * 2,FlxG.height * 2);
    blackScreen.updateHitbox();
    blackScreen.scrollFactor.set();
    blackScreen.screenCenter();
    blackScreen.cameras = [game.camOther];
    add(blackScreen);

    somewhere = new FlxSprite(0, 0);
    somewhere.loadGraphic(Paths.image("nevada/somewhere"));
    somewhere.antialiasing = true;
    somewhere.screenCenter();
    somewhere.cameras = [game.camOther];
    somewhere.alpha = 0.00001;
	add(somewhere);

    intropico = new FlxSprite(1280, 0);
    intropico.loadGraphic(Paths.image("nevada/Intro_Pico"));
    intropico.antialiasing = true;
    intropico.cameras = [game.camHUD];
	add(intropico);

    introhank = new FlxSprite(-1280, 0);
    introhank.loadGraphic(Paths.image("nevada/Intro_Hank"));
    introhank.antialiasing = true;
    introhank.cameras = [game.camHUD];
	add(introhank);

    play = new FlxSprite(0, 0);
    play.loadGraphic(Paths.image("nevada/play"));
    play.antialiasing = true;
    play.cameras = [game.camOther];
    play.visible = false;
	add(play);

    game.skipCountdown = true;
}

function onCreatePost(){
    game.snapCamFollowToPos(600, -1250);
    FlxG.camera.zoom = 0.6;
    game.isCameraOnForcedPos = true;
    game.camHUD.alpha = 0;
    gruntTriggerAmount = FlxG.random.int(1, 3);
    gruntTrigger1 = FlxG.random.int(90, 125);
    gruntTrigger2 = FlxG.random.int(186, 213);
    gruntTrigger3 = FlxG.random.int(290, 326);
    trace(gruntTriggerAmount);
}

function onBeatHit()
{
    if(game.curBeat == gruntTrigger1)
    {
        game.triggerEventNote('crimsonfogevents', 'triggergrunt', 'Right');
        trace('grunt 1 triggered');
    }
    if(game.curBeat == gruntTrigger2 && gruntTriggerAmount >= 2)
    {
        game.triggerEventNote('crimsonfogevents', 'triggergrunt', 'Left');
        trace('grunt 2 triggered');
    }
    if(game.curBeat == gruntTrigger3 && gruntTriggerAmount == 3)
    {
        game.triggerEventNote('crimsonfogevents', 'triggergrunt', 'Right');
        trace('grunt 3 triggered');
    }
}

function onEvent(eventName, value1, value2){
    if(eventName == 'crimsonfogevents'){
        switch(value1){
            case 'intro':
            FlxTween.tween(game.camFollow, {y: 200}, 5.5, {ease: FlxEase.smootherStepInOut, 
                onComplete: function(tween:FlxTween) {
                    game.isCameraOnForcedPos = false;
                    FlxTween.tween(game.camHUD, {alpha: 1.0}, 2.0, {ease: FlxEase.expoOut});
                    FlxTween.tween(FlxG.camera, {zoom: 0.7}, 2.0, {ease: FlxEase.expoOut});
                }});
            FlxTween.tween(blackScreen, {alpha: 0}, 5.0, {ease: FlxEase.expoOut, startDelay: 1.75});          
            case 'triggergrunt':
                switch(value2){
                    case 'Left':
                    grunt.x = 2000;
                    grunt.flipX = true;
                    grunt.anim.play('gruntwalkingfast');
                    FlxTween.tween(grunt, {x: -225}, 2.0, {ease: FlxEase.linear});
                    case 'Right':
                    grunt.x = -225;
                    grunt.flipX = false;
                    grunt.anim.play('gruntwalking');
                    FlxTween.tween(grunt, {x: 640}, 3.5, {ease: FlxEase.linear, 
                    onComplete: function(tween:FlxTween) {
                        grunt.anim.play('grunthi');
                        new FlxTimer().start(1, function(tmr:FlxTimer)
                        {
                            FlxTween.tween(grunt, {x: 2000}, 1.5, {ease: FlxEase.linear});
                            grunt.anim.play('gruntwalkingfast');
                        });
                    }});
                }
            case 'text shit':
            FlxTween.tween(somewhere, {alpha: 1}, 1.0, {ease: FlxEase.linear, 
                onComplete: function(tween:FlxTween) {
                    new FlxTimer().start(6, function(tmr:FlxTimer)
                    {
                        FlxTween.tween(somewhere, {alpha: 0}, 1.0, {ease: FlxEase.linear});
                    });
                }});
            case 'play text':
            play.visible = true;
            FlxFlicker.flicker(play, 8, 1.0, false);
            case 'cool part':
                switch(value2){
                    case 'hank':
                    FlxTween.tween(introhank, {x: 0}, 1.5, {ease: FlxEase.expoOut});
                    case 'pico':
                    FlxTween.tween(intropico, {x: 0}, 1.5, {ease: FlxEase.expoOut});
                    case 'flash':
                    game.camHUD.flash(0xFFFFFFFF, 1.0);
                    FlxTween.tween(intropico, {x: 1280}, 1.5, {ease: FlxEase.expoOut});
                    FlxTween.tween(introhank, {x: -1280}, 1.5, {ease: FlxEase.expoOut});
                }
            case 'duet':
                game.isCameraOnForcedPos = true;
                game.camFollow.set(675, 300);
            case 'duet off':
                game.isCameraOnForcedPos = false;
        }
    }
}

function onGameOverStart() 
{
    setGameOverVideo("hank_gameover");
}