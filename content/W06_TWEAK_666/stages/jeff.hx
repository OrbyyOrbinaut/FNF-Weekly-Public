addHaxeLibrary('FlxFlicker', 'flixel.effects'); // This lets me do the flicker thing.
// EVENTS
var jump:BGSprite;
var shower:FlxSprite;
var helpText:FlxText;
var phrases = ["it's really dark in here", "i better turn on the lightswi-", 'aaaaaaaah jeff the killer'];
var played = 'chiller';
var coolSection:Bool = false;

function onLoad() 
{
    game.skipCountdown = true;
    // Stage
    var bg:FlxSprite = new FlxSprite(-100, -150);
    bg.loadGraphic(Paths.image("jeff/my nam jef! youve seen the meme before right"));
    bg.scale.set(2,2);
    bg.antialiasing = ClientPrefs.globalAntialiasing;
    add(bg);
    if(ClientPrefs.flashing) played = 'killer';

    shower = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
    shower.alpha = 1;
    shower.cameras = [game.camOther];
    add(shower);

    helpText = new FlxText(290,FlxG.height-100,-1,phrases[0],24);    
    helpText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
    changeCaption(0);
    
    helpText.cameras = [game.camOther];
    add(helpText);
}

function changeCaption(blah) {
    helpText.text = phrases[blah];
    helpText.x = (FlxG.width/2) - (helpText.width/2);
}
function doStartCountdown()
{
    return Function_Stop;
}

function presongCutscene() // didn't know nv had this, neat
{
    game.inCutscene = true;
    game.camHUD.visible = false;
    FlxG.sound.play(Paths.sound("jeff"));
    trace('time');
    new FlxTimer().start(2.68, function(tmr:FlxTimer)
        {
            changeCaption(1);
        });
    new FlxTimer().start(3.92, function(tmr:FlxTimer)
    {
        helpText.visible = false;
        game.camHUD.visible = true;
        shower.alpha = 0.05;
        game.dad.playAnim('hey');
        game.boyfriend.playAnim('check');
    });
    new FlxTimer().start(5.88, function(tmr:FlxTimer)
        {
            game.inCutscene = false;
            game.startCountdown();
        });
}

function onCreatePost()
{
    game.boyfriend.color = 0xFFAAAAAA;
    game.dad.color = 0xFFAAAAAA;
    game.oldIcon = 'thebficon';
    game.snapCamFollowToPos(350, 225);
}

function onBeatHit() 
{
    if(game.curBeat % 4 == 0) if(ClientPrefs.flashing) FlxFlicker.flicker(shower, 0.6, 0.1, false);

    if (game.camZooming && ClientPrefs.camZooms && coolSection)
    {
        FlxG.camera.zoom += 0.015 * game.camZoomingMult;
        game.camHUD.zoom += 0.03 * game.camZoomingMult;
    }
}

function onEvent(eventName, value1, value2)
{
    if (eventName == 'Beat Bop') 
    {
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
    setGameOverVideo(played);
}