var text:FlxText;

function onCreatePost() {
    text = new FlxText();
    text.cameras = [PlayState.instance.camOther];
    text.setFormat(Paths.font("vcr.ttf"), 32, 0xFFcfa92d, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
    text.text = '';
    text.color = 0xFFFFFFFF;
    text.antialiasing = true;
    text.screenCenter(FlxAxes.X);
    text.borderSize = 2;
    text.updateHitbox();
    text.y = 625;
    add(text);

    trace("yea!");
}

function onEvent(eventName, value1, value2){
    switch(eventName){
        case 'lyric':
            text.text = value1;
            text.updateHitbox();
            text.screenCenter(FlxAxes.X);
            //text.y = PlayState.instance.healthBarBG.y - (text.height * 2);
    }
}