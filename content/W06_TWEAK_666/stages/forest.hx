var treeDsp:FlxSprite;
var part1:Array;
var treePaper:FlxSprite;

//var white:FlxSprite; //testing
var dropBG:FlxSprite;
var blackbox:FlxSprite;
var mainBG:FlxSprite;
var shadow:FlxSprite;
var fogBack:FlxSprite;
var fogFront:FlxSprite;
var chrShdw:FlxSprite;
var vign:FlxSprite;
var part2:Array;


var timer:FlxTimer = new FlxTimer();

function onCreate() {
    game.camGame.alpha = 0;
}

function onLoad() {
    white = new FlxSprite(0, 0);
    white.makeGraphic(6000, 3000, FlxColor.WHITE);
    //white.screenCenter();
    //add(white);

    treeDsp = new FlxSprite(0, 0);
    treeDsp.loadGraphic(Paths.image('7OF8/tree1'));
    treeDsp.antialiasing = true;
    //treeDsp.alpha = 0;
    add(treeDsp);
    
    treePaper = new FlxSprite(1280 / 2 - 94, 720 / 2 - 130);
    treePaper.scale.set(0.5, 0.5);
    treePaper.frames = Paths.getSparrowAtlas('7OF8/treee');
    treePaper.animation.addByPrefix('idle', 'paperbg instance ', 24, true);
    treePaper.animation.play('idle');
    treePaper.antialiasing = true;
    treePaper.updateHitbox();
    treePaper.alpha = 0;
    add(treePaper);

    mainBG = new FlxSprite(0, 0);
    mainBG.loadGraphic(Paths.image('7OF8/forest'));
    mainBG.antialiasing = true;
    mainBG.alpha = 0;
    add(mainBG);

    dropBG = new FlxSprite(0, 0);
    dropBG.frames = Paths.getSparrowAtlas('7OF8/static');
    dropBG.animation.addByPrefix('idle', 'static', 24, true);
    dropBG.animation.play('idle');
    dropBG.antialiasing = true;
    dropBG.updateHitbox();
    dropBG.alpha = 0;
    add(dropBG);

    fogBack = new FlxSprite(0, 0);
    fogBack.loadGraphic(Paths.image('7OF8/fogBack'));
    fogBack.antialiasing = true;
    fogBack.alpha = 0;
    add(fogBack);


    chrSdhw = new FlxSprite(0, 0);
    chrSdhw.loadGraphic(Paths.image('7OF8/character_shadow'));
    chrSdhw.alpha = 1;
    add(chrSdhw);

    blackbox = new FlxSprite(0, 0);
    blackbox.makeGraphic(mainBG.width, mainBG.height, FlxColor.BLACK);
    blackbox.alpha = 0;
    blackbox.cameras = [game.camGame];
    foreground.add(blackbox);
    
    fogFront = new FlxSprite(0, 0);
    fogFront.loadGraphic(Paths.image('7OF8/fogFront'));
    fogFront.antialiasing = true;
    fogFront.cameras = [game.camGame];
    fogFront.alpha = 0;
    foreground.add(fogFront);

    shadow = new FlxSprite(0, 0);
    shadow.loadGraphic(Paths.image('7OF8/shadow'));
    shadow.alpha = 1;
    foreground.add(shadow);

    vign = new FlxSprite(0, 0);
    vign.loadGraphic(Paths.image('7OF8/hudVignette'));
    vign.cameras = [game.camOther];
    vign.alpha = 0;
    add(vign);


    timer.start(0.40, initialFade, 4);
    game.camHUD.alpha = 0;
    
    part1 = [treeDsp, treePaper];
    part2 = [mainBG, chrShdw, shadow, fogBack, fogFront, vign];
    part3 = [dropBG];
}

function onCreatePost(){
    
    game.skipCountdown = true;
    game.snapCamFollowToPos(1280 / 2 - 1, 720 / 2 - 1);
    game.isCameraOnForcedPos = true;
    game.boyfriend.alpha = 0;
    game.dad.alpha = 0;
    game.gf.alpha = 0;
    //game.gf.scale.set(0.5, 0.5);
    game.gf.x = (1270 / 2 - 120);
    game.gf.y = (720 / 2 - 165);
    
    
}

function initialFade() {
    game.camGame.alpha += 0.25;

}

function onEvent(eventName, value1, value2) {
    switch(eventName) 
    {
        case 'darkScr':
            switch(value1){
                case 'darken':
                    vign.alpha = 0;
                    FlxG.camera.fade(FlxColor.WHITE, 0, false);
                case 'light':
                    FlxG.camera.fade(FlxColor.WHITE, 0, true);
            }
        case 'tree':
            trace('treeswitch: ' + value1);
            if (Std.int(value1) > 0 && Std.int(value1) < 5) {
                if (Std.int(value1) == 3) {
                    game.camHUD.alpha = 1;
                    game.gf.alpha = 1;
                    treePaper.alpha = 1;
                }
                if (Std.int(value1) == 4) {
                    game.camHUD.alpha = 0;
                    FlxTween.tween(blackbox, {alpha: 1}, 0.5, {ease: FlxEase.expoOut, startDelay: 0.2});
                }
                treeDsp.loadGraphic(Paths.image('7OF8/tree' + value1));
                remove(treeDsp);
                add(treeDsp);
            }
        case 'zoomStuck':
            switch (value1) {
                case 's': 
                    game.isCameraOnForcedPos = false;
                    game.snapCamFollowToPos(1000, 1300);
                    trace('hi slendy');
                    game.defaultCamZoom = 1.2;
                    game.isCameraOnForcedPos = true;
                case 'r': 
                    game.isCameraOnForcedPos = false;
                    game.snapCamFollowToPos(1900, 1300);
                    trace('hi randy');
                    game.defaultCamZoom = 1.2;
                    game.isCameraOnForcedPos = true;
                case 'l':
                    game.isCameraOnForcedPos = false;
                    trace('hi lockoff');
                    game.defaultCamZoom = 1;
            }
        case 'majorswitch':
            switch(value1) {
                case '1':
                    FlxG.camera.zoom = 1.5;
                    FlxTween.tween(FlxG.camera, {zoom:1.2}, 5.0, {ease: FlxEase.expoOut});
                    FlxTween.tween(game.camHUD, {alpha: 1.0}, 0.5, {ease: FlxEase.expoOut});
                    FlxTween.tween(blackbox, {alpha: 0}, 20.0, {ease: FlxEase.expoOut});
                    game.gf.alpha = 0;
                    game.boyfriend.alpha = 1;
                    game.dad.alpha = 1;

                    for (thing in part2) {
                        thing.alpha = 1;
                    }
                    
                    vign.alpha = 0.6;

                    for (thing in part1) {
                        thing.alpha = 0;
                    }
                case '2':
                    game.defaultCamZoom = 0.5;
                    game.snapCamFollowToPos(1500, 950);
                    game.isCameraOnForcedPos = true;

                    for (thing in part2) {
                        thing.alpha = 0;
                    }

                    for (thing in part3) {
                        thing.alpha = 1;
                    }
                case '3':
                    game.defaultCamZoom = 1;
                    game.isCameraOnForcedPos = false;
                    for (thing in part3) {
                        thing.alpha = 0;
                    }

                    for (thing in part2) {
                        thing.alpha = 1;
                    }
                    vign.alpha = 0.25;
                case '4':
                    game.defaultCamZoom = 0.6;
                    game.boyfriendCameraOffset = [0, -200];
                    game.opponentCameraOffset = [-100, 0];
                case '5':
                    game.camHUD.alpha = 0;
                    treeDsp.loadGraphic(Paths.image('7OF8/treeEND'));
                    remove(treeDsp);
                    add(treeDsp);
                    game.snapCamFollowToPos(1280 / 2 - 1, 720 / 2 - 1);
                    game.isCameraOnForcedPos = true;
                    game.boyfriend.alpha = 0;
                    game.dad.alpha = 0;
                    game.gf.alpha = 0;
                    for (thing in part2) {
                        thing.alpha = 0;
                    }
                    for (thing in part1) {
                        thing.alpha = 1;
                    }
                    treePaper.alpha = 0;
                    FlxTween.tween(game.camGame, {alpha: 0}, 0, {ease: FlxEase.expoOut, startDelay: 1});

            }
    }
}

function onGameOverStart() 
{
    setGameOverVideo("slender");
}