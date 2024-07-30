var desktopscary:FlxSprite;
var desktopbg:FlxSprite;
var kinitoscare:FlxSprite;
var taskbar:FlxSprite;
var desktopicons:FlxSprite;
var popupsallowed:Bool = false;
var isScary:Bool = false;
var popuptimer:Bool = false;

function onCreate()
{
    FlxG.mouse.visible = true;
}

function onDestroy()
{
    FlxG.mouse.visible = false;
}

function onLoad() {
    game.addCharacterToList('kinto-3d');
    desktopscary = new FlxSprite(0,0);
    desktopscary.loadGraphic(Paths.image("kinito/myanalogsauce"));
    desktopscary.antialiasing = true;
    desktopscary.visible = false;
    add(desktopscary); 
    
    desktopbg = new FlxSprite(0,0);
    desktopbg.loadGraphic(Paths.image("kinito/backgroundstretch"));
    desktopbg.antialiasing = true;
    add(desktopbg); 

    desktopicons = new FlxSprite(0,0);
    desktopicons.loadGraphic(Paths.image("kinito/icons_and_shit"));
    desktopicons.antialiasing = true;
    add(desktopicons); 

    taskbar = new FlxSprite(0,720 - 34);
    taskbar.loadGraphic(Paths.image("kinito/taskbar"));
    taskbar.antialiasing = true;
    foreground.add(taskbar); //fuck it burns

    blackScreen = new FlxSprite().makeGraphic(1, 1, 0xFF000000);
    blackScreen.scale.set(FlxG.width * 2,FlxG.height * 2);
    blackScreen.updateHitbox();
    blackScreen.scrollFactor.set();
    blackScreen.screenCenter();
    blackScreen.cameras = [game.camOther];
    blackScreen.visible = false;
    add(blackScreen);

    kinitoscare = new FlxSprite(470,300);
    kinitoscare.loadGraphic(Paths.image("kinito/kinito_scare"));
    kinitoscare.scale.set(2,2);
    kinitoscare.updateHitbox();
    kinitoscare.antialiasing = false;
    kinitoscare.visible = false;
    add(kinitoscare); 
}

function onCreatePost(){
    game.snapCamFollowToPos(1280 / 2 - 1, 720 / 2 - 1);
    game.isCameraOnForcedPos = true;
    game.boyfriend.alpha = 0;
    game.boyfriend.scale.set(0.95, 0.95);	
    game.timeBar.y = -1000;
    game.timeBarBG.y = game.timeBar.x;
    game.timeTxt.y = -1000;

    for (i in 0...game.opponentStrums.members.length) {
		game.opponentStrums.members[i].visible = false;
	}

    modManager.setValue("opponentSwap", 0.5, 0);
    modManager.queueEase(1286, 1287, "miniX", 0.15, 0, "expoOut");
    modManager.queueEase(1286, 1287, "miniY", 0.15, 0, "expoOut");
    modManager.queueEase(1286, 1287, "alpha", 1, 0, "expoOut");
    game.comboOffsetCustom = [0, 300, 50, 450];
}

function onSpawnNotePost(note:Note)
{
    note.visible = note.mustPress;
}

var winNum:Int = 0;
function onUpdate(elapsed)
{
    if(FlxG.random.bool(1) && popupsallowed && isScary && !popuptimer)
    {
        winNum = FlxG.random.int(1, 6);
        game.triggerEventNote('Spawn Popup Window', winNum, '');
        popuptimer = true; // this is dumb but its ok
        new FlxTimer().start(2.5, ()->{
            popuptimer = false;
        });
    }
}

function onUpdatePost(elapsed)
{
    game.camZooming = false;
}

function onSectionHit()
{
    if(isScary)
    {
        if(mustHitSection) // fuck im a dumb baka
        {
            popupsallowed = false;
        }
        else
        {
            popupsallowed = true;
        }
    }
}

function onEvent(eventName, value1, value2)
{
    switch(eventName)
    {
        case 'Kinito Phase':
        switch(value1)
        {
            case 'normal': // Should be self explaintory 
                desktopscary.visible = false;
                desktopbg.visible = true;
                game.dad.visible = true;
                kinitoscare.visible = false;
                popupsallowed = false;
                isScary = false;
                remove(game.boyfriendGroup);
                insert(members.indexOf(game.dadGroup), game.boyfriendGroup);
                trace('BITTTCHHH');
            case 'scary': // Should be self explaintory 
                desktopscary.visible = true;   
                desktopbg.visible = false;
                popupsallowed = true;
                isScary = true;
            case 'tsf7': // When its just TFS7's camera
                game.boyfriend.visible = true;
                game.dad.visible = false;
                FlxTween.tween(game.boyfriend, {alpha: 1}, 0.1);
                FlxTween.tween(game.boyfriend.scale, {x: 1, y: 1}, 0.1);
            case 'move tweakfan':
                FlxTween.tween(game.boyfriendGroup, {x: 682}, 2.5, {ease: FlxEase.expoOut});
                kinitoscare.visible = true;
                game.dad.visible = false;
            case 'lights out':
                var removes = [desktopscary, desktopbg, kinitoscare, taskbar, desktopicons, game.dad, game.healthBarBG, game.healthBar, game.iconP1, game.iconP2, game.timeBar, game.timeBarBG, game.timeTxt, game.scoreTxt];
                for(obj in removes){ obj.visible = false; }
            case 'bye':
                FlxTween.tween(game.boyfriend, {alpha: 0}, 0.1);
                FlxTween.tween(game.boyfriend.scale, {x: 0.95, y: 0.95}, 0.1); 
        }
        case 'Black':
        switch(value1)
        {
            case 'on':
                blackScreen.visible = true;
            case 'off': 
                blackScreen.visible = false;
        }
        switch(value2)
        {
            case 'camgame':
                blackScreen.cameras = [game.camGame];
            case 'camother':
                blackScreen.cameras = [game.camOther];
        }   
    }
}

function onGameOverStart() 
{
    setGameOverVideo("kinito_gameover");
}