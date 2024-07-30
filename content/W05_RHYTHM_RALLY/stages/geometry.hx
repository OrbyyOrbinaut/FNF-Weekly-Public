var achievement:FlxSprite;
var coolSection:Bool = false;
var stage:FlxSprite;
var stage2:FlxSprite;
var farbg:FlxSprite;
var farbg2:FlxSprite;
function onLoad() {
    farbg = new FlxSprite(-325, -1575);
    farbg.loadGraphic(Paths.image("gd/backwall"));
    farbg.antialiasing = true;
    farbg.scrollFactor.set(0.5, 0.5);
	add(farbg);

    farbg2 = new FlxSprite(farbg.width - 325, -1575);
    farbg2.loadGraphic(Paths.image("gd/backwall"));
    farbg2.antialiasing = true;
    farbg2.scrollFactor.set(0.5, 0.5);
	add(farbg2);

    stage = new FlxSprite(-50, -295);
    stage.loadGraphic(Paths.image("gd/stereo"));
    stage.antialiasing = false;
    stage.scrollFactor.set(0.55, 0.55);
    add(stage);

    stage2 = new FlxSprite(stage.width - 50, -295);
    stage2.loadGraphic(Paths.image("gd/stereo"));
    stage2.antialiasing = false;
    stage2.scrollFactor.set(0.55, 0.55);
    add(stage2);

    var bg:FlxSprite = new FlxSprite(0, -180);
    bg.loadGraphic(Paths.image("gd/background"));
    bg.antialiasing = true;
    bg.scrollFactor.set(0.8, 0.8);
	add(bg);

    var ground:FlxSprite = new FlxSprite(0, 0);
    ground.loadGraphic(Paths.image("gd/ground"));
    ground.antialiasing = true;
	add(ground);
}

function onCreatePost(){
    game.snapCamFollowToPos(1720, -300);
    achievement = new FlxSprite(0, -200);
    achievement.loadGraphic(Paths.image("gd/achievement"));
    achievement.antialiasing = true;
    achievement.cameras = [game.camHUD];
    achievement.scale.set(0.5, 0.5);
    achievement.updateHitbox();
    achievement.screenCenter(FlxAxes.X);
    insert(members.indexOf(game.botplayTxt), achievement); //Really dumb but it works
}

function onUpdate(elapsed){
    stage.x -= elapsed * 100;
    stage2.x -= elapsed * 100;

    if (stage.x < -5500) stage.x += stage.width * 2;
    if (stage2.x < -5500) stage2.x += stage2.width * 2;

    farbg.x -= elapsed * 25;
    farbg2.x -= elapsed * 25;

    if (farbg.x < -5000) farbg.x += farbg.width * 2;
    if (farbg2.x < -5000) farbg2.x += farbg2.width * 2;
}

function onBeatHit()
{
    if (game.camZooming && ClientPrefs.camZooms && coolSection)
    {
        FlxG.camera.zoom += 0.015 * game.camZoomingMult;
        game.camHUD.zoom += 0.03 * game.camZoomingMult;
    }
}

function opponentNoteHit(note){ 
    if(note.noteData == 2 && !game.dad.voicelining && note.noteType != 'Alt Animation') //NGL I didn't want to do it like this but im left with no choice
    {
        game.dad.voicelining = true;
        game.dad.animation.finishCallback = function (){
            game.dad.voicelining = false;
        }
    }
}

function goodNoteHit(note){
    if(note.noteData == 2 && !game.boyfriend.voicelining && note.noteType != 'Alt Animation')
    {
        game.boyfriend.voicelining = true;
        game.boyfriend.animation.finishCallback = function (){
            game.boyfriend.voicelining = false;
        }
    }
}

function onEvent(eventName, value1, value2)
{
    switch (eventName) 
    {
        case 'Achievement':
        FlxTween.tween(achievement, {y: 0}, 1.5, {ease: FlxEase.expoOut, onComplete:
        function (twn:FlxTween)
        {
            FlxTween.tween(achievement, {y: -200}, 1.5, {startDelay: 1.5, ease: FlxEase.expoOut});
        }});
        case 'Duet':
        switch(value1)
        {
            case 'on':
            game.camFollow.set(1730, -210);
            game.isCameraOnForcedPos = true;
            case 'off':    
            game.isCameraOnForcedPos = false;
        }
        case 'Beat Bop':
        switch(value1)
        {
            case 'on':
            coolSection = true;
            case 'off':    
            coolSection = false;
        }
    }
}

function onGameOverStart() 
{
    setGameOverVideo("gd_gameover");
}