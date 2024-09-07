var backdebris:FlxSprite;
var camandmic:FlxSprite;
var miku:FlxAnimate;
var black:FlxSprite;
var black2:FlxSprite;
var black3:FlxSprite;
var logo:FlxSprite;
var lyrics:FlxText;
var grad:GradientBumpSprite;
var shit = [];
var textShit = createTypedGroup();

var skipIntro:Bool = false;

function onLoad() {
    var space:FlxSprite = new FlxSprite(-900, -400);
    space.loadGraphic(Paths.image("genrenull/space"));
    space.antialiasing = true;
    space.scrollFactor.set(0.5, 0.5);
	add(space);

    miku = new FlxAnimate(3350, 300, 'content/W10_THE_TWEAKING_BOSSFIGHT/images/genrenull/miku'); //Gulp
    miku.showPivot = false;
    miku.anim.addBySymbol('miki', 'miki',0,0,24);
    miku.antialiasing = true;
    miku.anim.play('miki');
    miku.scrollFactor.set(0.7, 0.7);
    //miku.alpha = 0.75;
    add(miku);

    backdebris = new FlxSprite(3400, 1850);
    backdebris.loadGraphic(Paths.image("genrenull/backdebris"));
    backdebris.antialiasing = true;
    backdebris.scrollFactor.set(0.75, 0.75);
	add(backdebris);

    grad = new GradientBumpSprite(-700, 3300);
    grad.originalHeight = 1300;
    grad.color = FlxColor.RED;
    add(grad);

    fullstage = new FlxSprite(2000, 1850);
    fullstage.loadGraphic(Paths.image("genrenull/fullstage"));
    fullstage.antialiasing = true;
	add(fullstage);

    camandmic = new FlxSprite(2000, 3250);
    camandmic.loadGraphic(Paths.image("genrenull/camandmic"));
    camandmic.antialiasing = true;
    camandmic.scrollFactor.set(1.1, 1.1);
    foreground.add(camandmic);
	//add(camandmic);

    black2 = new FlxSprite().makeGraphic(FlxG.width * 5, FlxG.height * 6, FlxColor.WHITE);
    black2.color = FlxColor.BLACK;
    black2.camera = game.camGame;
    black2.alpha = 0;
    black2.x += 2000;
    black2.y += 1800;
    add(black2);

    black3 = new FlxSprite().makeGraphic(FlxG.width * 5, FlxG.height * 6, FlxColor.WHITE);
    black3.color = FlxColor.BLACK;
    black3.camera = game.camGame;
    black3.alpha = 0;
    black3.x += 2000;
    black3.y += 1300;
    foreground.add(black3);
}

function onCreatePost(){
    black = new FlxSprite().makeGraphic(1280, 720, FlxColor.WHITE);
    black.color = FlxColor.BLACK;
    black.camera = game.camHUD;
    black.alpha = 0;
    add(black);


    // game.addBehindGF(black2);

    // foreground.add(textShit);

    logo = new FlxSprite().loadGraphic(Paths.image("genrenull/logo"));
    logo.camera = game.camHUD;
    logo.scale.set(0.5, 0.5);
    logo.updateHitbox();
    logo.screenCenter();
    logo.alpha = 0;
    add(logo);

    shit = [game.scoreTxt, game.timeBar, game.timeBarBG, game.timeTxt, game.healthBarBG, game.healthBar, game.iconP1, game.iconP2];

    if(!skipIntro){
        game.skipCountdown = true;

        for(m in game.stage.members) m.alpha = 0;
        for(m in game.stage.foreground.members) m.alpha = 0;
        game.boyfriend.alpha = 0;
        game.dad.alpha = 0;
        for(s in shit) s.alpha = 0;

        black.alpha = 1;

        modManager.setValue("alpha", 1);        
    }

    lyrics = new FlxText(0,0,600, "", 32);
    lyrics.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    lyrics.cameras = [game.camOther];
    lyrics.screenCenter(FlxAxes.X);
    lyrics.y = FlxG.height - 100;
    lyrics.alpha = 1;
    add(lyrics);

}

function onSongStart(){
    if(!skipIntro){
        for(s in shit) s.alpha = 0;
        var time:Float = 10;
        FlxTween.tween(black, {alpha: 0}, time, {ease: FlxEase.quadInOut});
        miku.alpha = 1;
        game.isCameraOnForcedPos = true;
        game.snapCamFollowToPos(5250, 1800);
    
    
        game.camZooming = false;
        game.camGame.zoom = 1.5;
        FlxTween.num(game.camGame.zoom, 0.5, time, {ease: FlxEase.quadInOut, onUpdate: (s)->{
            game.camGame.zoom = s.value;
        }});
    
        modManager.queueFuncOnce(138, (s,s2)->{
            black.color = FlxColor.WHITE;
            FlxTween.tween(black, {alpha: 1}, 2, {ease: FlxEase.quadInOut});
        });
    
        var by:Float = 1/16;
        modManager.queueFuncOnce(176, (s,s2)->{
    
            modManager.queueSet(176, "centered", 1);
            modManager.queueSet(176, "opponentSwap", 0.5);
    
            var int = 16;
            for(step in 176...192){
                int -= 1;
                modManager.queueSet(step, "alpha", int / 16);
                for(i in 0...4){
                    for(j in 0...2){
                        modManager.queueSet(step, "transform" + i + "X", FlxG.random.int(-500, 500), j);
                        modManager.queueSet(step, "transform"+ i + "Y", FlxG.random.int(-500, 500), j);
                        modManager.queueSet(step, "transform" + i + "Z", FlxG.random.int(-0.25, 0.25), j);
                        modManager.queueSet(step, "confusion" + i, FlxG.random.int(-360, 360), j);
                    }
                }
            }
        });
    
        modManager.queueFuncOnce(192, (s,s2)->{
            FlxTween.tween(black, {alpha: 0}, 1, {ease: FlxEase.quadOut});
    
            // FlxG.camera.flash(FlxColor.WHITE, 1);
            modManager.queueSet(s, "centered", 0);
            modManager.queueSet(s, "opponentSwap", 0);
            modManager.queueSet(s, "alpha", 0);
            for(i in 0...4){
                for(j in 0...2){
                    modManager.queueSet(s, "transform" + i + "X", 0, j);
                    modManager.queueSet(s, "transform"+ i + "Y", 0, j);
                    modManager.queueSet(s, "transform" + i + "Z", 0, j);
                    modManager.queueSet(s, "confusion" + i, 0, j);
                }
            }
            game.isCameraOnForcedPos = false;
            for(m in game.stage.members) m.alpha = 1;
            for(m in game.stage.foreground.members) m.alpha = 1;
            black3.alpha = 0;
            black2.alpha = 0;
            game.boyfriend.alpha = 1;
            game.dad.alpha = 1;
            for(s in shit) s.alpha = 1;
            game.defaultCamZoom = 0.5;

            logo.y -= 100;
            FlxTween.tween(logo, {alpha: 1, y: logo.y + 100}, 0.5, {ease: FlxEase.expoOut});
            new FlxTimer().start(3, (t)->{
                FlxTween.tween(logo, {alpha: 0}, 0.5, {onComplete: (s)->{
                    remove(logo);
                }});
            });
        });
    }

    modManager.queueFuncOnce(792, (s,s2)->{
        modManager.queueEase(792, 800, "alpha", 1, 'quadOut', 1);
        for(s in shit) FlxTween.tween(s, {alpha: 0}, 1.5, {ease: FlxEase.quadOut});

        FlxTween.tween(black2, {alpha: 0.4}, 4, {ease: FlxEase.quadInOut});
    });

    modManager.queueEase(920, 924, "alpha", 0, 'quadOut', 1);
    modManager.queueFuncOnce(932, (s,s2)->{
        for(s in shit) s.alpha = 1;
        game.camHUD.flash(FlxColor.WHITE, 1);
        black2.alpha = 0;
    });

    modManager.queueFuncOnce(3056, (s,s2)->{
        for(s in shit) FlxTween.tween(s, {alpha: 0}, 1.5, {ease: FlxEase.quadOut});
        modManager.queueEase(3056, 3064, "alpha", 1, "quadOut", 1);
    });
    modManager.queueEase(3312, 3320, "alpha", 0, 'quadOut', 1);
}

var s:Float = 1;
var skY:Float = 1850;
var camandmicY:Float = 3000;
function onUpdate(elapsed){
    // trace(game.camFollowPos);
    // grad.update(elapsed);
    s += elapsed;
        backdebris.y = FlxMath.lerp(backdebris.y, skY + (Math.cos(s - 5) * 65), CoolUtil.boundTo(1, 0, elapsed * 4));
        camandmic.y = FlxMath.lerp(camandmic.y, camandmicY + (Math.cos(s) * 65), CoolUtil.boundTo(1, 0, elapsed * 4));  
}


function onGameOverStart() 
{
    setGameOverVideo('genre_gameover');
}

var specialTexts = [];
var lol:Int = -1;
function onEventPush(event){
    if(event.event == 'Lyric Special'){
        var text = new FlxText();
        text.setFormat(Paths.font("vcr.ttf"), 64, 0xFF0eeadf, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
        text.updateHitbox();
        text.text = event.value1;
        trace(text.text);
        text.x = (fullstage.width - text.width) / 2;
        text.x += 2100;
        text.y = 4600;
        text.alpha = 0;
        add(text);
        specialTexts.push(text);
    }
}

function onEvent(eventName, value1, value2){
    switch(eventName){
        // im just using this i dont feel like making a new event
        case 'Change Scary':
            switch(value1){
                case 'Camera Flash':
                    FlxG.camera.flash(FlxColor.WHITE, 0.5);
                case 'bg black':
                    FlxTween.tween(black2, {alpha: Std.parseFloat(value2)}, 0.5, {ease: FlxEase.quadOut});
                case 'fg black':
                    FlxTween.cancelTweensOf(black3);
                    FlxTween.tween(black3, {alpha: value2}, 0.25, {ease: FlxEase.quadOut});
                    trace(black3.alpha);
                case 'lone bop':
                    for(m in game.stage.members) m.visible = false;
                    for(m in game.stage.foreground.members) m.visible = false;
                    game.boyfriend.visible = false;
                    game.dad.visible = false;
                    for(s in shit) s.visible = false;
                    grad.visible = true;
                    grad.bop();
                    game.defaultCamZoom = 1;
                case 'bop':
                    grad.bop();
                case 'fade':
                    modManager.queueEase(game.curStep, game.curStep + 8, "alpha", 1);
                    for(s in shit) FlxTween.tween(s, {alpha: 0}, 2, {ease: FlxEase.quadOut});
                    FlxTween.tween(black3, {alpha: 1}, 2, {ease: FlxEase.quadOut});
                case 'reappear':
                    modManager.setValue("alpha", 0);
                    // game.camHUD.alpha = 1;
                    for(m in game.stage.members) m.visible = true;
                    for(m in game.stage.foreground.members) m.visible = true;
                    game.boyfriend.visible = true;
                    game.dad.visible = true;
                    for(s in shit){
                        s.visible = true;
                        s.alpha = 1;
                    }
                    black2.alpha = 0;
                    black3.alpha = 0;   
                    game.camHUD.flash(FlxColor.WHITE, 1);
                    game.defaultCamZoom = 0.6;
                    for(t in specialTexts) t.alpha = 0;
            }
        case 'Lyric Special':
            lol ++;
            var t = specialTexts[lol];
            FlxTween.tween(t, {alpha: 1}, 1, {ease: FlxEase.quadOut});
            FlxTween.tween(t, {y: 0}, 10, {ease: FlxEase.linear});
            trace(t.text);
        case 'lyric':
            if(value1 != '' || value1 != ' '){
                lyrics.visible = true;
                lyrics.alpha = 0;
                lyrics.y = FlxG.height - 125;
                FlxTween.tween(lyrics, {alpha: 1, y: FlxG.height - 100}, 0.25, {ease: FlxEase.expoOut});
    
                lyrics.text = value1;
                trace(lyrics.text);
                lyrics.screenCenter(FlxAxes.X);
            }else{
                FlxTween.tween(lyrics, {alpha: 0}, 0.25, {ease: FlxEase.expoOut});
            }

        case 'snap cam':
            var curCharacter:Character = game.boyfriend;
            switch(value1){
                case 'bf':
                    curCharacter = game.boyfriend;
                case 'dad':
                    curCharacter = game.dad;
            }
            var desiredPos = game.getCharacterCameraPos(curCharacter);
            var displacement = curCharacter.returnDisplacePoint();
            game.snapCamFollowToPos(desiredPos.x + displacement.x, desiredPos.y + displacement.y);
            displacement.put();
            desiredPos.put();
            game.isCameraOnForcedPos = true;

        case 'Set Camera Zoom':
            if(value2 == 'on'){
                game.isCameraOnForcedPos = true;
                game.camFollow.x = 5050;
                game.camFollow.y = 3400;
                // game.snapCamFollowToPos(5250, 3500);
            }else
                game.isCameraOnForcedPos = false;


            trace(value1);
            game.camZooming = true;
            game.defaultCamZoom = value1;
    }
}