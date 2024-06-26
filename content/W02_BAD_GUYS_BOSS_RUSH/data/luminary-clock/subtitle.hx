var text:FlxText;

function onCreatePost() {
    text = new FlxText();
    text.cameras = [PlayState.instance.camHUD];
    text.setFormat(Paths.font("bombardier.regular.ttf"), 48, 0xffe0e0e0, FlxTextAlign.CENTER, FlxTextBorderStyle.SHADOW, 00xff575757);
    text.text = '';
    text.antialiasing = true;
    text.screenCenter(FlxAxes.X);
    text.borderSize = 2;
    text.updateHitbox();
    text.y = 500;
    add(text);

    trace("yea!");
}

function onEvent(eventName, value1, value2){
    switch(eventName){
        case 'subtitle':
            text.text = value1;
            text.updateHitbox();
            text.screenCenter(FlxAxes.X);
            //text.y = PlayState.instance.healthBarBG.y - (text.height * 2);
    }
}