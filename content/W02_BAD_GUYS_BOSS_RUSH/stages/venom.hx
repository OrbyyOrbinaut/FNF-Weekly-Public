var tween1:FlxTween;
var tween2:FlxTween;
var allowEnd:Bool = false;
var vicvideo:PsychVideoSprite;
var hit:Int = 0;
var oldhit:Int = 1;
var moveTween:FlxTween;
var opTween:FlxTween;
var ending:FlxSprite;
var black:FlxSprite;
var punch:Bool = false;

//THIS CODE IS REALLY BAD

function onLoad(){
    var venvid = new PsychVideoSprite();
    venvid.addCallback('onFormat',()->{
        venvid.setGraphicSize(FlxG.width + 1,FlxG.height + 1);
        venvid.updateHitbox();
        venvid.screenCenter();
        venvid.antialiasing = true;
        venvid.x += 217;
        venvid.y += 530;
    });
    venvid.load(Paths.video("venombg"), [PsychVideoSprite.muted]);
    venvid.play();
    add(venvid);

    var bars1:FlxSprite = new FlxSprite(0, 0);
    bars1.makeGraphic(Std.int(FlxG.width * 2), 68, FlxColor.BLACK);
    bars1.antialiasing = true;
    bars1.screenCenter();
    bars1.x += 217;
    bars1.y += (530 - (FlxG.height/2) + 34);
	foreground.add(bars1);

    var bars2:FlxSprite = new FlxSprite(0, 0);
    bars2.makeGraphic(Std.int(FlxG.width * 2), 68, FlxColor.BLACK);
    bars2.antialiasing = true;
    bars2.screenCenter();
    bars2.x += 217;
    bars2.y += (530 + (FlxG.height/2) - 33);
	foreground.add(bars2);
}

function onCreatePost(){
    game.snapCamFollowToPos(217 + FlxG.width/2, 530 + FlxG.height/2);
    game.isCameraOnForcedPos = true;

    game.comboOffsetCustom = [525, 350, 565, 500];
    //635
    //950
    //220
    //560
    //trace(game.dad.y);
}


function onEvent(eventName, value1, value2)
{
    switch (eventName)
    {
        case 'Punch':
            punch = true;
            if (!tween1 == null)
            {
                tween1.cancel();
            }
            if (!tween2 == null)
            {
                tween2.cancel();
            }
            if (moveTween != null)
            {
                moveTween.cancel();
            }
           FlxTween.tween(game.boyfriend, {x: game.boyfriend.x + 200}, 0.35, {ease: FlxEase.expoOut, 
            onComplete: function(tween:FlxTween) {
                FlxTween.tween(game.boyfriend, {x: game.boyfriend.x - 700}, 0.6, {ease: FlxEase.expoIn});
            }});

        case 'Climaxing':
            var black:FlxSprite = new FlxSprite(0,0);
            black.makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
            black.antialiasing = true;
            black.screenCenter();
            black.cameras = [game.camOther];
            add(black);

            var ending:FlxSprite = new FlxSprite(0,0);
            ending.loadGraphic(Paths.image("venom/spidersting"));
            ending.antialiasing = true;
            ending.screenCenter();
            ending.cameras = [game.camOther];
            add(ending);

            var flash:FlxSprite = new FlxSprite(0,0);
            flash.makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
            flash.antialiasing = true;
            flash.screenCenter();
            flash.cameras = [game.camOther];
            flash.alpha = 0.8;
            add(flash);
            FlxTween.tween(flash, {alpha: 0}, 0.6, {ease: FlxEase.expoOut});
            FlxTween.tween(ending, {alpha: 0}, 4);
    }
}

function onBeatHit()
{
    if(tween1 != null)
    {
        tween1.cancel();
    }
    if(tween2 != null)
    {
        tween2.cancel();
    }
    if(game.boyfriend.animation.curAnim.name == 'idle')
    {
        if(game.boyfriend.x != 950)
        {
            game.boyfriend.x = 950;
        }   
        game.boyfriend.y = 635 - 25;
        tween1 = FlxTween.tween(game.boyfriend, {y: 635}, 0.3, {ease: FlxEase.expoOut});
    }
    if(game.dad.animation.curAnim.name == 'idle')
    {
        if(game.dad.x != 220)
        {
            game.dad.x = 220;
        } 
        game.dad.y = 560 - 25;
        tween2 = FlxTween.tween(game.dad, {y: 560}, 0.3, {ease: FlxEase.expoOut});
    }
}

function onDestroy() 
{
    ClientPrefs.comboOffset[0] =  ogComboOffset[0];
	ClientPrefs.comboOffset[1] =  ogComboOffset[1];
    ClientPrefs.comboOffset[2] =  ogComboOffset[2];
	ClientPrefs.comboOffset[3] =  ogComboOffset[3];
}

function onGameOverStart() 
{
    setGameOverVideo("venom_gameover");
}

function onEndSong()
{
    vicvideo = new PsychVideoSprite();
    vicvideo.addCallback('onFormat',()->{
        vicvideo.setGraphicSize(0,FlxG.height);
        vicvideo.updateHitbox();
        vicvideo.screenCenter();
        vicvideo.cameras = [game.camOther];
        vicvideo.antialiasing = true;
    });
    vicvideo.addCallback('onEnd',()->{
        allowEnd = true;
        game.endSong();
    });
    vicvideo.load(Paths.video("spiderman_victory"));
    
    if(!allowEnd)
    {
        vicvideo.play();
        add(vicvideo);
        return Function_Stop;
    }
}

function opponentNoteHit(note){ 
    if(opTween != null)
    {
        opTween.cancel();
        game.dad.x = 220;
        game.dad.y = 560;
    }

    switch(note.noteData)
    {
        case 0:
            game.dad.x = 200;
            game.dad.y = 560;
            if(!note.isSustainNote)
            {
                opTween = FlxTween.tween(game.dad, {x: 220}, 0.3, {ease: FlxEase.expoOut});
            }
            else
            {
                game.dad.x = 220;
            }
        case 1:
            game.dad.y = 590;
            game.dad.x = 220;
            if(!note.isSustainNote)
            {
                opTween = FlxTween.tween(game.dad, {y: 560}, 0.3, {ease: FlxEase.expoOut});
            }
            else
            {
                game.dad.y = 560;
            }
        case 2:
            game.dad.y = 540;
            game.dad.x = 220;
            if(!note.isSustainNote)
            {
                opTween = FlxTween.tween(game.dad, {y: 560}, 0.3, {ease: FlxEase.expoOut});
            }
            else
            {
                game.dad.y = 560;
            }
        case 3:
            game.dad.x = 260;
            game.dad.y = 560;
            if(!note.isSustainNote)
            {
                opTween = FlxTween.tween(game.dad, {x: 220}, 0.3, {ease: FlxEase.expoOut});
            }
            else
            {
                game.dad.x = 220;
            }
    }
}

function goodNoteHit(note){
    if(moveTween != null)
    {
        moveTween.cancel();
        game.boyfriend.x = 950;
        game.boyfriend.y = 635;
    }
    if(punch == false)
    {
        switch(note.noteData) // this fucking sucks kill me bro
        {
            case 0:
                game.boyfriend.x = 880;
                game.boyfriend.y = 635;
                if(!note.isSustainNote)
                {
                    moveTween = FlxTween.tween(game.boyfriend, {x: 950}, 0.3, {ease: FlxEase.expoOut});
                }
                else
                {
                    game.boyfriend.x = 950;
                }
            case 1:
                game.boyfriend.y = 705;
                game.boyfriend.x = 950;
                if(!note.isSustainNote)
                {
                    moveTween = FlxTween.tween(game.boyfriend, {y: 635}, 0.3, {ease: FlxEase.expoOut}); 
                }
                else
                {
                    game.boyfriend.y = 635;
                }
            case 2:
                game.boyfriend.y = 605;
                game.boyfriend.x = 950;
                if(!note.isSustainNote)
                {
                    moveTween = FlxTween.tween(game.boyfriend, {y: 635}, 0.3, {ease: FlxEase.expoOut}); 
                }
                else
                {
                    game.boyfriend.y = 635;
                }
            case 3:
                game.boyfriend.x = 980;
                game.boyfriend.y = 635;
                if(!note.isSustainNote)
                {
                    moveTween = FlxTween.tween(game.boyfriend, {x: 950}, 0.3, {ease: FlxEase.expoOut});
                }
                else
                {
                    game.boyfriend.x = 950;
                }
        }
    }
}

var time:Float = 0;
function onUpdate(elapsed){
    hit = 0;
}