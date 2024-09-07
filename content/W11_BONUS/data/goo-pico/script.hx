var picojumpscare:FlxSprite;

function onCreatePost()
{
    picojumpscare = new FlxSprite(0, 0).loadGraphic(Paths.image("ahh"));
    picojumpscare.cameras = [game.camOther];
    picojumpscare.setGraphicSize(picojumpscare.width*2);
    picojumpscare.alpha = 0;
    picojumpscare.updateHitbox();
    add(picojumpscare);
}

function onEvent(eventName, value1, value2)
{
    if (eventName == 'goo shit') 
    {
        switch(value1)
        {
            case 'magic':
                switch(value2)
                {
                    case 'jumpscare':
                        picojumpscare.alpha = 1;
                }
        }
    }
}