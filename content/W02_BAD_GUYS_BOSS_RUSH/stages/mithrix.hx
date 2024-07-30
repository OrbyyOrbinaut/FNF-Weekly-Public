addHaxeLibrary('FlxStringUtil', 'flixel.util');
var emotional:FlxAnimate;
var scoreROR2:FlxText;
var missesROR2:FlxText;
var comboROR2:FlxText;
var accuracyROR2:FlxText;
var timeTxtROR2:FlxText;
var item:FlxSprite;
var healthdrain:Bool = false;

function onLoad() {
    var fg:FlxSprite = new FlxSprite(0, 0);
    fg.loadGraphic(Paths.image("mithrix/foreground"));
    fg.antialiasing = false;
	add(fg); 

    emotional = new FlxAnimate(1417, 1054, 'content/W02_BAD_GUYS_BOSS_RUSH/images/mithrix/mithrixanim'); //Gulp
    emotional.showPivot = false;
    emotional.anim.addBySymbol('itemsteal', 'itemsteal',0,0,24);
    emotional.antialiasing = false;
    emotional.visible = false;
    add(emotional);

    var rorhud:FlxSprite = new FlxSprite(0, 0);
    rorhud.loadGraphic(Paths.image("mithrix/rorhud"));
    rorhud.antialiasing = false;
    rorhud.cameras = [game.camHUD];
	add(rorhud);

    scoreROR2 = new FlxText();
    scoreROR2.alignment = FlxTextAlign.LEFT;
    scoreROR2.setFormat(Paths.font("bombardier.regular.ttf"), 32, 0xffDBC75B, FlxTextAlign.LEFT, FlxTextBorderStyle.SHADOW, 0xFF7C6D1D);
    scoreROR2.cameras = [PlayState.instance.camHUD];
    scoreROR2.antialiasing = ClientPrefs.globalAntialiasing;
    scoreROR2.text = 'Score:';
    scoreROR2.x = 25;
    scoreROR2.borderSize = 2;
    scoreROR2.updateHitbox();
    scoreROR2.y = 30;
    add(scoreROR2);

    accuracyROR2 = new FlxText();
    accuracyROR2.alignment = FlxTextAlign.LEFT;
    accuracyROR2.setFormat(Paths.font("bombardier.regular.ttf"), 32, 0xffB7C9D9, FlxTextAlign.LEFT, FlxTextBorderStyle.SHADOW, 0xFF444E56);
    accuracyROR2.cameras = [PlayState.instance.camHUD];
    accuracyROR2.antialiasing = ClientPrefs.globalAntialiasing;
    accuracyROR2.text = 'Accuracy:';
    accuracyROR2.x = 25;
    accuracyROR2.borderSize = 2;
    accuracyROR2.updateHitbox();
    accuracyROR2.y = 108;
    add(accuracyROR2);

    missesROR2 = new FlxText();
    missesROR2.alignment = FlxTextAlign.LEFT;
    missesROR2.setFormat(Paths.font("bombardier.regular.ttf"), 32, 0xffEF2E2B, FlxTextAlign.LEFT, FlxTextBorderStyle.SHADOW, 0xFF961B1B);
    missesROR2.cameras = [PlayState.instance.camHUD];
    missesROR2.antialiasing = ClientPrefs.globalAntialiasing;
    missesROR2.text = 'Misses:';
    missesROR2.x = 25;
    missesROR2.borderSize = 2;
    missesROR2.updateHitbox();
    missesROR2.y = 188;
    add(missesROR2);

    comboROR2 = new FlxText();
    comboROR2.alignment = FlxTextAlign.LEFT;
    comboROR2.setFormat(Paths.font("bombardier.regular.ttf"), 48, 0xff000000, FlxTextAlign.LEFT, FlxTextBorderStyle.NONE, 0xFF961B1B);
    comboROR2.cameras = [PlayState.instance.camHUD];
    comboROR2.antialiasing = ClientPrefs.globalAntialiasing;
    comboROR2.text = 'Combo: 0';
    comboROR2.x = 25;
    comboROR2.borderSize = 0;
    comboROR2.updateHitbox();
    comboROR2.y = 560;
    add(comboROR2);

    var timeROR2:FlxText = new FlxText();
    timeROR2.alignment = FlxTextAlign.LEFT;
    timeROR2.setFormat(Paths.font("bombardier.regular.ttf"), 48, 0xff000000, FlxTextAlign.LEFT, FlxTextBorderStyle.NONE, 0xFF961B1B);
    timeROR2.cameras = [PlayState.instance.camHUD];
    timeROR2.antialiasing = ClientPrefs.globalAntialiasing;
    timeROR2.text = 'time';
    timeROR2.x = 1075;
    timeROR2.borderSize = 0;
    timeROR2.updateHitbox();
    timeROR2.y = 25;
    add(timeROR2);

    timeTxtROR2 = new FlxText();
    timeTxtROR2.setFormat(Paths.font("bombardier.regular.ttf"), 48, 0xff000000, FlxTextAlign.CENTER, FlxTextBorderStyle.NONE, 0xFF961B1B);
    timeTxtROR2.alignment = FlxTextAlign.CENTER;
    timeTxtROR2.cameras = [PlayState.instance.camHUD];
    timeTxtROR2.antialiasing = ClientPrefs.globalAntialiasing;
    timeTxtROR2.text = '0:00';
    timeTxtROR2.x = 1075;
    timeTxtROR2.borderSize = 0;
    timeTxtROR2.updateHitbox();
    timeTxtROR2.y = 70;
    add(timeTxtROR2);

    game.skipCountdown = true;
}

function onCreatePost()
{
    item = new FlxSprite(2150, 1075);
    item.loadGraphic(Paths.image("mithrix/hat_item"));
    item.antialiasing = true;
    item.visible = false;
	game.insert(members.indexOf(game.boyfriendGroup), item);

    for (i in 0...game.opponentStrums.members.length) {
        game.opponentStrums.members[i].alpha = 0.001;
    }
    modManager.setValue("opponentSwap", 0.5, 0);
    timeBar.y = -1000;
    scoreTxt.y = -1000;
    timeTxt.y = -1000;
    healthBar.x = 25;
    game.healthBar.angle = 180;
    healthBar.y = 618;
    healthBar.scale.x = 0.6;
    healthBar.scale.y = 1.15;
    healthBarBG.scale.x = 0.6;
    healthBarBG.scale.y = 1.15;
    healthBar.updateHitbox();
    healthBarBG.updateHitbox();
    game.showRating = false;
    game.showCombo = false;
}  
 
function onUpdatePost(elasped)
{
    var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
	if(curTime < 0) curTime = 0;
    var songCalc:Float = (game.songLength - curTime);
    var secondsTotal:Int = Math.floor(songCalc / 1000);
	if(secondsTotal < 0) secondsTotal = 0;
    
    scoreROR2.text = 'Score: ' + game.songScore;
    accuracyROR2.text = 'Accuracy: ' + Math.ffloor(game.ratingPercent * 100) + '%';
    missesROR2.text = 'Misses: ' + game.songMisses;
    timeTxtROR2.text = FlxStringUtil.formatTime(secondsTotal, false);
}

function goodNoteHit(note){
    var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition + ClientPrefs.ratingOffset);
    var daRating:Rating = Conductor.judgeNote(note, noteDiff);
    if(!note.isSustainNote)
    {
        comboROR2.text = 'Combo: ' + daRating.image.charAt(0).toUpperCase() + daRating.image.substr(1).toLowerCase() + ' ' + game.combo;
    }
}

function opponentNoteHit(note){
    if (healthdrain)
    {
        if (game.healthBar.percent > 20 && !note.isSustainNote)
        {
            game.health -= 0.007;
        }
    }
}

function noteMiss(note){
    comboROR2.text = 'Combo: ' + game.combo;
}

function onSpawnNotePost(note:Note)
{
    note.visible = note.mustPress;
}

var allowedToZ:Bool = true;
function onMoveCamera(){ if(allowedToZ){
    switch(game.whosTurn){
        case 'dad':
            game.defaultCamZoom = 0.9;
        case 'boyfriend':
            game.defaultCamZoom = 0.8;
    }
}}

function onEvent(eventName, value1, value2){
    if(eventName == 'mithrixshit'){
        switch(value1){
            case 'sillystyle':
                allowedToZ = false;
                game.defaultCamZoom = 0.95;
                game.dad.visible = false;
                emotional.visible = true;
                game.camFollow.set(1355, 1110);
                emotional.anim.play('itemsteal');
                game.isCameraOnForcedPos = true;
                game.triggerEventNote('Alt Idle Animation', '', '-alt');
                game.triggerEventNote('Alt Idle Animation', 'bf', '-alt');
                FlxTween.tween(item, {x: 1375, y: 800}, 1.25, {ease: FlxEase.expoOut, startDelay: 2.2, onComplete:
                    function (twn:FlxTween)
                    {
                        item.visible = false;
                    }
                    ,onStart:
                    function (twn:FlxTween)
                    {
                        item.visible = true;
                        healthdrain = true;
                        game.healthGain = false;
                    }});
            case 'animend' :
                allowedToZ = true;
                game.isCameraOnForcedPos = false;
                game.dad.visible = true;
                emotional.visible = false;
        }
    }
}

function onGameOverStart() 
{
    setGameOverVideo("ror_gameover");
}