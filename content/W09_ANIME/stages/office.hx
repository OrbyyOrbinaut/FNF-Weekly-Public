var fenneko:Character;
var haida:Character;
var fakestartTimer:FlxTimer;
var him:FlxSprite;
var boppersShocked:Bool = false;

function onLoad() {   
    sky = new FlxSprite(330, 0).makeGraphic(1375, FlxG.height, FlxColor.fromRGB(231, 243, 247));
    add(sky);
    
    him = new FlxSprite(650, -1000);
    him.loadGraphic(Paths.image("aggretsuko/boss3"));
    him.scale.set(0.5, 0.5);
    him.scrollFactor.set(0.85 ,0.85);
    him.antialiasing = true;
    add(him);
    
    var office:FlxSprite = new FlxSprite(-500, -300);
    office.loadGraphic(Paths.image("aggretsuko/office"));
    office.scale.set(0.5, 0.5);
    office.antialiasing = true;
    add(office);

    var overlay:FlxSprite = new FlxSprite(0, 0);
    overlay.loadGraphic(Paths.image("aggretsuko/overlay"));
    overlay.scrollFactor.set(0,0);
    overlay.antialiasing = true;
    overlay.blend = 0;
    overlay.screenCenter();
    foreground.add(overlay);

    blackScreen = new FlxSprite().makeGraphic(1, 1, 0xFF000000);
    blackScreen.scale.set(FlxG.width * 2,FlxG.height * 2);
    blackScreen.updateHitbox();
    blackScreen.scrollFactor.set();
    blackScreen.screenCenter();
    blackScreen.cameras = [game.camOther];
    blackScreen.visible = false;
    add(blackScreen);
}

function onCreatePost(){
    game.snapCamFollowToPos(1000, 575);

    fenneko = new Character(game.gf.x + 175, game.gf.y - 20, 'fenneko', false);
    fenneko.danceEveryNumBeats = 2;
    game.addBehindGF(fenneko);

    haida = new Character(game.gf.x - 125, game.gf.y - 130, 'haida', false);
    haida.danceEveryNumBeats = 2;
    game.addBehindGF(haida);

    game.gf.scrollFactor.set(1,1);
}

function onCountdownStarted()
{
    fakestartTimer = new FlxTimer().start((Conductor.crotchet / 1000), function(tmr:FlxTimer) //Replicates the way the rest of the character bop during da countdown
    {
        if (fenneko != null && tmr.loopsLeft % Math.round(game.gfSpeed * fenneko.danceEveryNumBeats) == 0 && fenneko.animation.curAnim != null)
        {
            fenneko.dance();
        }
        if (haida != null && tmr.loopsLeft % Math.round(game.gfSpeed * haida.danceEveryNumBeats) == 0 && haida.animation.curAnim != null)
        {
            haida.dance();
        }
    }, 
    5);
}

function onEvent(name, v1, v2) 
{
    if (name == 'Busy Work Events')
    {
        switch (v1) 
        {
            case 'boss':
                FlxTween.tween(him, {y: -2100}, 2.0, {ease: FlxEase.linear});
                trace('boss is coming');
            case 'angry':
                game.gf.playAnim('shocked', true);
                game.gf.specialAnim = true;
                fenneko.playAnim('shocked', true);
                fenneko.specialAnim = true;
                haida.playAnim('shocked', true);
                haida.specialAnim = true;
                game.defaultCamZoom = 1.0;
                game.camFollow.y = 550;
                boppersShocked = true;
            case 'boppers normal':
                game.gf.playAnim('shockedend', true);
                game.gf.specialAnim = true;
                fenneko.playAnim('shockedend', true);
                fenneko.specialAnim = true;
                haida.playAnim('shockedend', true);
                haida.specialAnim = true;
                boppersShocked = false;
            case 'camera move':
                game.isCameraOnForcedPos = true;    
                FlxTween.tween(game.camFollow, {x: 980, y: 575} , 1.75, {ease: FlxEase.smootherStepInOut});
            case 'camera release':
                game.isCameraOnForcedPos = false;  
                game.defaultCamZoom = 1.2; 
            case 'end cam':
                game.isCameraOnForcedPos = true;   
                game.defaultCamZoom = 1.0;
                game.camFollow.x = 1000;
                game.camFollow.y = 550;
            case 'black screen':
                switch (v2) 
                {
                    case 'on':
                        blackScreen.visible = true;
                        game.camHUD.visible = false;
                    case 'off':
                        blackScreen.visible = false;
                        game.camHUD.visible = true;
                }
        }
    }
}

function onBeatHit()
{
    if (fenneko != null && curBeat % Math.round(game.gfSpeed * fenneko.danceEveryNumBeats) == 0 && fenneko.animation.curAnim != null && !boppersShocked)
    {
        fenneko.dance();
    }
    if (haida != null && curBeat % Math.round(game.gfSpeed * haida.danceEveryNumBeats) == 0 && haida.animation.curAnim != null && !boppersShocked)
    {
        haida.dance();
    }
    if (boppersShocked)
    {
        game.gf.playAnim('shockedloop', true);
        game.gf.specialAnim = true;
        fenneko.playAnim('shockedloop', true);
        fenneko.specialAnim = true;
        haida.playAnim('shockedloop', true);
        haida.specialAnim = true;
    }
}

function onGameOverStart() 
{
    setGameOverVideo("aggret_gameover");
}