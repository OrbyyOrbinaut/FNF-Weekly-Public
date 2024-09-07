var bfjumpscare:FlxSprite;

function onCreatePost()
{
    bfjumpscare = new FlxSprite(0, 0).loadGraphic(Paths.image("jumpscare!"));
    bfjumpscare.cameras = [game.camOther];
    bfjumpscare.alpha = 0;
    bfjumpscare.setGraphicSize(bfjumpscare.width*2);
    bfjumpscare.updateHitbox();
    add(bfjumpscare);
}

function onEvent(eventName, value1, value2)
{
    if (eventName == 'goo shit') 
    {
        switch(value1)
        {
            case 'bf jumpscare':
                bfjumpscare.alpha = 1;
                new FlxTimer().start(0.1, function(tmr:FlxTimer)
                {
                    bfjumpscare.alpha = 0;
                });
        }
    }
}