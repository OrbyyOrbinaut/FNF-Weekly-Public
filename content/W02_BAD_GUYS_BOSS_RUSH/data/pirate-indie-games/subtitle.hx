var text:FlxText;

function onCreatePost() {
    text = new FlxText();
    text.cameras = [PlayState.instance.camHUD];
    text.setFormat(Paths.font("deltarune.ttf"), 37, 0xffffffff, FlxTextAlign.CENTER, FlxTextBorderStyle.NONE, 00xff575757);
    text.text = '';
    text.antialiasing = false;
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