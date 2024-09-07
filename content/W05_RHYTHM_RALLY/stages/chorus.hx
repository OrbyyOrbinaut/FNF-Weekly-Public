var perfectTxt:FlxSprite;
var rank:String = 'PERFECT';
var allowEnd:Bool = false;

function onLoad() {
    var bg:FlxSprite = new FlxSprite(0, 0);
    bg.loadGraphic(Paths.image("tengoku/chorus_bg"));
    bg.antialiasing = true;
	add(bg);

    var conductor:FlxSprite = new FlxSprite(88, 391);
    conductor.frames = Paths.getSparrowAtlas('tengoku/conductor');
    conductor.animation.addByPrefix('idle', 'lion_fuck', 24, true);
    conductor.animation.play('idle');
    conductor.antialiasing = true;
	foreground.add(conductor);

    perfectTxt = new FlxSprite(25, 0);
    perfectTxt.loadGraphic(Paths.image("tengoku/perfect"));
    perfectTxt.antialiasing = false;
    perfectTxt.scale.set(3, 3);
	perfectTxt.updateHitbox();
    perfectTxt.cameras = [game.camHUD];
	add(perfectTxt);

    game.skipCountdown = true;
}

function onCreatePost(){
    GameOverSubstate.endSoundName = "empty";
    GameOverSubstate.deathSoundName = "empty";
    GameOverSubstate.loopSoundName = "empty";

    game.healthGain = 0; // Should've done it this way from the start
    game.healthLoss = 0;
    
    var youtxt:FlxSprite = new FlxSprite(0, 0);
    youtxt.loadGraphic(Paths.image("tengoku/you"));
    youtxt.antialiasing = false;
    youtxt.scale.set(3, 3);
	youtxt.updateHitbox();
    youtxt.x = game.boyfriend.x - 5;
    youtxt.y = game.boyfriend.y + 210;
	add(youtxt);
    
    game.timeBar.y = -1000;
    game.timeBarBG.y = game.timeBar.x;
    game.timeTxt.y = -1000;
    game.snapCamFollowToPos(639, 359);
    game.isCameraOnForcedPos = true;
    game.comboOffsetCustom = [0, 1000, 0, 1000];
    game.scoreTxt.x = -325;
    game.scoreTxt.y = 676.8;
    game.scoreAllowedToBop = false;

    for (i in 0...game.opponentStrums.members.length) {
		game.opponentStrums.members[i].visible = false;
	}

    game.healthBarBG.visible = false;
    game.healthBar.visible = false;
    game.iconP1.visible = false;
    game.iconP2.visible = false;
    //Most Minor thing ever but it bugged pancho and i so 
    modManager.setValue("transform0X", 5, 0);
    modManager.setValue("transform1X", 5, 0);
    modManager.setValue("transform2X", 5, 0);
    modManager.setValue("transform3X", 5, 0);

    remove(game.gfGroup);
    insert(members.indexOf(game.boyfriendGroup), game.gfGroup);
}

function onSpawnNotePost(note:Note)
{
    note.visible = note.mustPress;
}

function onUpdatePost()
{
    game.camZooming = false;
    game.scoreTxt.text = ' - Score: ' + game.songScore + ' - Misses: ' + game.songMisses + ' - Combo: ' + game.combo + ' - ' ;
}

function noteMiss(note:Note)
{
    perfectTxt.visible = false;
}

function onEndSong()
{
    if(game.songMisses == 0)
    {
        rank = 'PERFECT';
    }
    else if(game.songMisses <= 20)
    {
        rank = 'GOOD';
    }
    else
    {
        rank = 'BAD';
    }
    
    var endvideo = new PsychVideoSprite();
    endvideo.addCallback('onFormat',()->{
        endvideo.setGraphicSize(0,FlxG.height);
        endvideo.updateHitbox();
        endvideo.screenCenter();
        endvideo.cameras = [game.camOther];
        endvideo.antialiasing = false;
    });
    endvideo.addCallback('onEnd',()->{
        allowEnd = true;
        game.endSong();
    });
    endvideo.load(Paths.video('chorus_' + rank));
    
    if(!allowEnd)
    {
        var blackScreen = new FlxSprite().makeGraphic(1, 1, 0xFF000000);
        blackScreen.scale.set(FlxG.width * 2,FlxG.height * 2);
        blackScreen.updateHitbox();
        blackScreen.scrollFactor.set();
        blackScreen.screenCenter();
        foreground.add(blackScreen);
        game.camHUD.alpha = 0;
        endvideo.play();
        add(endvideo);
        return Function_Stop;
    }
}

function onGameOverStart() 
{
    FlxG.resetState();
    trace("You're not supposed to die.");
}