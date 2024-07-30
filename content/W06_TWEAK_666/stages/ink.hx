var bg:FlxSprite;
var coolSection:Bool = false;

function onLoad()
{
    bg = new FlxSprite(0, 0);
    bg.loadGraphic(Paths.image('bend/bg'));
    bg.antialiasing = ClientPrefs.globalAntialiasing;
    add(bg);
}

function onCreatePost()
{
    game.snapCamFollowToPos(1400, 900);
}

function onBeatHit() 
{
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
    else if(eventName == 'Middle')
    {
        switch(value1)
        {
            case 'on':
                game.camFollow.set(1575, 800);
                game.isCameraOnForcedPos = true;
            case 'off':    
                game.isCameraOnForcedPos = false;
        }
    }
}    

function onGameOverStart() 
{
    setGameOverVideo("Bent");
}