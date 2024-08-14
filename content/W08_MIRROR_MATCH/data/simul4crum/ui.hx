addHaxeLibrary('FlxStringUtil', 'flixel.util');
var gauge:FlxSprite;
var gaugePercent:Int = 0; //not a float bc this it dictates the anim but u get it
var gaugeFull:Bool = false;
var splatTimer:FlxSprite;
var splatTimerTxt:FlxText;

function onCreatePost()
{
    game.scoreTxt.font = Paths.font('BlitzMain.otf');
    game.timeBar.y = -999;
    game.timeTxt.y = -999;

    game.healthBar.flipX = true;
    game.healthBarSide = 1;
    game.iconP1.flipX = !game.iconP1.flipX;
    game.iconP2.flipX = !game.iconP2.flipX;

    modManager.setValue("opponentSwap", 0.5);

    gauge = new FlxSprite(1080, 15);
    gauge.frames = Paths.getSparrowAtlas("splatoon/gauge");
    gauge.antialiasing = false;
    gauge.cameras = [game.camHUD];
    gauge.animation.addByPrefix('gauge', 'gauge', 0, false);
    gauge.animation.addByPrefix('specialget', 'specget', 24, false);
    gauge.animation.addByPrefix('special', 'special', 24, true);
    add(gauge);
    gauge.animation.play("gauge");
    gauge.animation.curAnim.curFrame = 0;

    var fuck:FlxSprite = new FlxSprite(game.healthBarBG.x - 7, game.healthBarBG.y - 7);
    fuck.loadGraphic(Paths.image("splatoon/healthbarBG"));
    fuck.antialiasing = false;
    fuck.cameras = [game.camHUD];
    insert(members.indexOf(game.iconP1), fuck);

    splatTimer = new FlxSprite(20, 20);
    splatTimer.loadGraphic(Paths.image("splatoon/timerbackground"));
    splatTimer.antialiasing = false;
    splatTimer.cameras = [game.camHUD];
    add(splatTimer);

    splatTimerTxt = new FlxText();
    splatTimerTxt.setFormat(Paths.font("BlitzMain.otf"), 38, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.NONE);
    splatTimerTxt.alignment = FlxTextAlign.CENTER;
    splatTimerTxt.cameras = [game.camHUD];
    splatTimerTxt.antialiasing = ClientPrefs.globalAntialiasing;
    splatTimerTxt.text = '3:33';
    splatTimerTxt.updateHitbox();
    splatTimerTxt.x = 45;
    splatTimerTxt.y = 16;
    add(splatTimerTxt);

    game.comboOffsetCustom = [1000, 300, 1050, 445];

    for (i in 0...game.opponentStrums.members.length) {
		game.opponentStrums.members[i].visible = false;
	}
}

function onSpawnNotePost(note:Note)
{
    note.visible = note.mustPress;
}

function onUpdate(elapsed) {
    var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
	if(curTime < 0) curTime = 0;
    var songCalc:Float = (game.songLength - curTime);
    var secondsTotal:Int = Math.floor(songCalc / 1000);
	if(secondsTotal < 0) secondsTotal = 0;
    splatTimerTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
    
    if(gauge.animation.curAnim != null && gauge.animation.curAnim.name == 'gauge' && !gaugeFull)
    {
        gauge.animation.curAnim.curFrame = gaugePercent;
    }
    else if(gauge.animation.curAnim != null && gauge.animation.curAnim.name == 'specialget' && gauge.animation.finished && gaugeFull)
    {
        gauge.animation.play("special");
        gauge.offset.set(0, 0);
    }
}

function onBeatHit(){
    if(game.curBeat % 20 == 0 && gaugePercent < 22 && gauge.animation.curAnim != null && gauge.animation.curAnim.name == 'gauge' && !gaugeFull)
    {
        gaugePercent = gaugePercent + 1;
    }
}

function onEvent(name:String, v1:String, v2:String)
{
    if(name == 'Splatoon Events')
    {
        if(v1 == 'Gauge Full')
        {
            gaugeFull = true;
            gauge.animation.play("specialget");
            gauge.offset.set(49, 49);
        }
    }
}