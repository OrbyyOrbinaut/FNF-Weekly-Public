var jump:BGSprite;

function onCreatePost()
{
    jump = new BGSprite('jumpscare!', 0, 0);
    jump.setGraphicSize(1280, 720);
    jump.screenCenter();
    jump.alpha = 0.000001;
    jump.antialiasing = true;
    jump.cameras = [game.camOther];
    add(jump);
}

function onEvent(eventName, value1, value2)
{
    if(eventName == 'jumpscare')
    {
        if (value1 == 'on') 
        {
            jump.alpha = 1;
        }
        else
        {
            jump.alpha = 0.000001;
        }
    }
}