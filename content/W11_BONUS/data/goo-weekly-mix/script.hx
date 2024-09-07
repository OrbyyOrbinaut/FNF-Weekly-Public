var peace:FlxSprite;
var quote1:FlxSprite;
var quote2:FlxSprite;
var bossjumpscare:FlxSprite;

function onCreatePost()
{
    peace = new FlxSprite(0, 0).loadGraphic(Paths.image("dontTweaklilfella"));
    peace.cameras = [game.camOther];
    peace.alpha = 0;
    peace.setGraphicSize(FlxG.width, FlxG.height);
    peace.updateHitbox();
    peace.screenCenter();
    add(peace);
    
    quote1 = new FlxSprite(0, 0).loadGraphic(Paths.image("quote1"));
    quote1.cameras = [game.camOther];
    quote1.alpha = 0;
    add(quote1);

    quote2 = new FlxSprite(500, 300).loadGraphic(Paths.image("quote2"));
    quote2.cameras = [game.camOther];
    quote2.alpha = 0;
    add(quote2);

    bossjumpscare = new FlxSprite(0, 0).loadGraphic(Paths.image("bossjumpscare"));
    bossjumpscare.cameras = [game.camOther];
    bossjumpscare.alpha = 0;
    add(bossjumpscare);
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
                    case 'black':
                        game.camHUD.alpha = 0;
                        game.camGame.alpha = 0;
                    case 'fade in':
                        FlxTween.tween(peace, {alpha: 1}, 7.5, {ease: FlxEase.expoOut});
                    case 'quote1':
                        FlxTween.tween(quote1, {alpha: 1}, 7.5, {ease: FlxEase.expoOut});
                    case 'quote2':
                        FlxTween.tween(quote2, {alpha: 1}, 7.5, {ease: FlxEase.expoOut});
                    case 'jumpscare':
                        bossjumpscare.alpha = 1;
                }
        }
    }
}