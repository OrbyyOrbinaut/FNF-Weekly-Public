var hpBar:FlxSprite;
var defeat:Int = 5;
var themes:Array<String> = ['dad', 'gang', 'salad', 'tank', 'tricky'];
var text:FlxText;
var notesHit:Int = 0;
var kid1:FlxSprite;
var kid2:FlxSprite;
var kid3:FlxSprite;
function onLoad() {
    game.skipCountdown = true;

    text = new FlxText();
    text.cameras = [game.camHUD];
    text.setFormat(Paths.font("arialbd.ttf"), 18, 0xffffffff, FlxTextAlign.CENTER);
    text.text = '00000';
    text.color = 0xFFFFFFFF;
    text.antialiasing = true;
    text.borderSize = 2;
    text.updateHitbox();
    text.x = 892;
    text.y = 568;
    add(text);

    var bgb:FlxSprite = new FlxSprite(275, 141);
    bgb.loadGraphic(Paths.image("pico/room"));
    bgb.antialiasing = ClientPrefs.globalAntialiasing;
	add(bgb); 

    var chairs:FlxSprite = new FlxSprite(275, 141);
    chairs.loadGraphic(Paths.image("pico/chairs"));
    chairs.antialiasing = ClientPrefs.globalAntialiasing;
	add(chairs); 

    kid1 = new FlxSprite(835, 400);
    kid1.loadGraphic(Paths.image("pico/kid1"));
    kid1.antialiasing = ClientPrefs.globalAntialiasing;
	add(kid1);

    kid2 = new FlxSprite(365, 250);
    kid2.loadGraphic(Paths.image("pico/kid2"));
    kid2.antialiasing = ClientPrefs.globalAntialiasing;
	add(kid2);

    kid3 = new FlxSprite(710, 265);
    kid3.loadGraphic(Paths.image("pico/kid3"));
    kid3.antialiasing = ClientPrefs.globalAntialiasing;
    foreground.add(kid3);

    var ui:FlxSprite = new FlxSprite(275, 139).loadGraphic(Paths.image("pico/ui"), true, 260, 464);
    ui.animation.add('bum', [0, 1, 2, 3, 4], 0, false);
    ui.animation.play('bum');
    ui.animation.curAnim.curFrame = ClientPrefs.downScroll ? 0 : 1;
    ui.antialiasing = ClientPrefs.globalAntialiasing;
    ui.cameras = [game.camOther];
    add(ui);

    var map:FlxSprite = new FlxSprite(781, 139).loadGraphic(Paths.image("pico/map"), true, 222, 102);
    map.animation.add('bum', [0, 0, 1, 1,], 6, true);
    map.animation.play('bum');
    map.antialiasing = ClientPrefs.globalAntialiasing;
    map.cameras = [game.camOther];
    add(map);

    hpBar = new FlxSprite(888, 569).loadGraphic(Paths.image("pico/hpSheet"), true, 116, 37);
    hpBar.animation.add('bar', [0, 1, 2, 3, 4], 0, false);
    hpBar.animation.play('bar');
    hpBar.animation.curAnim.curFrame = 4;
    hpBar.antialiasing = ClientPrefs.globalAntialiasing;
    add(hpBar);
    trace("DICK");
}

function onSpawnNotePost(note:Note)
{
    note.visible = note.mustPress;

    if (note.mustPress == true) {
        note.noteSplashDisabled = true;
    }
}

var s:Float = 1;
function onUpdatePost(elapsed) {
    s += elapsed;
    kid1.y = FlxMath.lerp(kid1.y, 400 - 5 + (Math.cos(s) * 15), CoolUtil.boundTo(1, 0, elapsed * 4));
    kid2.y = FlxMath.lerp(kid2.y, 250 - 5 + (Math.cos(s) * 35), CoolUtil.boundTo(1, 0, elapsed * 4));
    kid3.y = FlxMath.lerp(kid3.y, 265 - 5 + (Math.cos(s) * 25), CoolUtil.boundTo(1, 0, elapsed * 4));
    game.camZooming = false;
    if(defeat <= 0) { game.health = -2; return; }
    hpBar.animation.curAnim.curFrame = defeat - 1;
    text.text = game.songScore;
}

function goodNoteHit(note)
{
    if(defeat < 5 && !note.isSustainNote)
    {
        notesHit = notesHit + 1;

        if(notesHit == 10)
        {
            notesHit = 0;
            
            if(defeat < 5)
            {
                defeat = defeat + 1;
            }
        }
    }

    trace(defeat);
    trace('Note hit is' + notesHit);
}

function noteMiss(note:Note)
{
    defeat = defeat - 1;
    notesHit = 0;
}

function onCreatePost() {
    var noteBG:FlxSprite = new FlxSprite(260, 140).makeGraphic(275, 470, FlxColor.BLACK);
    noteBG.alpha = 0.25;
    noteBG.cameras = [game.camHUD];
    add(noteBG);
    
    game.healthGain = 0;
    game.healthLoss = 0;

    var removes = [game.iconP1, game.iconP2, game.scoreTxt, game.timeTxt, game.healthBar, game.healthBarBG, game.timeBarBG];
    for(obj in removes){ remove(obj); }

    for (i in 0...game.opponentStrums.members.length) {
		game.opponentStrums.members[i].visible = false;
	}

    game.snapCamFollowToPos(1280 / 2 - 1, 720 / 2 - 1);
    game.isCameraOnForcedPos = true;

    modManager.setValue("opponentSwap", 1);
    modManager.setValue("transform0X", 156, 0);
    modManager.setValue("transform1X", 111, 0);
    modManager.setValue("transform2X", 66, 0);
    modManager.setValue("transform3X", 21, 0);

    if(ClientPrefs.downScroll)
    {
        modManager.setValue("transform0Y", -85, 0);
        modManager.setValue("transform1Y", -85, 0);
        modManager.setValue("transform2Y", -85, 0);
        modManager.setValue("transform3Y", -85, 0);
    }
    else
    {
        modManager.setValue("transform0Y", 95, 0);
        modManager.setValue("transform1Y", 95, 0);
        modManager.setValue("transform2Y", 95, 0);
        modManager.setValue("transform3Y", 95, 0);
    }

    modManager.setValue("miniX", 0.4);
    modManager.setValue("miniY", 0.4);

    var th:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("pico/themes/" + themes[FlxG.random.int(0, 4)]));
    th.antialiasing = ClientPrefs.globalAntialiasing;
    th.cameras = [game.camOther];
    add(th);

    var bg:FlxSprite = new FlxSprite(0, 0);
    bg.loadGraphic(Paths.image("pico/site"));
    bg.antialiasing = ClientPrefs.globalAntialiasing;
    bg.cameras = [game.camOther];
	add(bg); 

    game.comboOffsetCustom = [850, 275, 850, 350];
}

function onGameOverStart() 
{
    setGameOverVideo('pico_gameover');
}