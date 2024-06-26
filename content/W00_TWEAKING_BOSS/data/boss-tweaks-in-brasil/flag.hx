var br:FlxSprite;
var port:FlxSprite;

function onCreatePost() {
    br = new FlxSprite().loadGraphic(Paths.image("brasil"));
    br.antialiasing = true;
    br.screenCenter(); 
    br.cameras = [game.camHUD];
    br.alpha = 0.000001;
	add(br); 

    port = new FlxSprite().loadGraphic(Paths.image("portugal"));
    port.antialiasing = true;
    port.setGraphicSize(1280, 720);
    port.screenCenter(); 
    port.cameras = [game.camHUD];
    port.alpha = 0.000001;
	add(port); 
}

function onEvent(eventName, value1, value2){
    switch(eventName){
        case 'flag':
        switch(value1)
        {
            case 'brasil':
            br.alpha = 1;
            FlxTween.tween(br, {alpha: 0.000001}, 1, {ease: FlxEase.sineIn});	
            case 'portugal':
            port.alpha = 1;
            FlxTween.tween(port, {alpha: 0.000001}, 1, {ease: FlxEase.sineIn});	
        }
    }
}