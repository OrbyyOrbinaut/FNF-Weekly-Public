// EVENTS
var jump:BGSprite;

function onLoad() 
{
    // Stage
    var bg:FlxSprite = new FlxSprite(300, 300);
    bg.loadGraphic(Paths.image("background"));
    bg.setGraphicSize(1000 * 2, 562 * 2);
    add(bg);

    // Jumpscare
    jump = new BGSprite('jumpscare!', 0, 0);
    jump.setGraphicSize(1280, 720);
    jump.screenCenter();
    jump.alpha = 0.001;
}

function onCreatePost()
{
    jump.cameras = [game.camOther];
    add(jump);
    game.snapCamFollowToPos(700, 500);
}

function onEvent(eventName, value1, value2)
{
    if (value1 == 'jumpscare') 
    {
        jump.alpha = 1;
    }
}