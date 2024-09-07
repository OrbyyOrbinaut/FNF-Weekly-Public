var text:FlxText;

function onCreatePost() {
    text = new FlxText();
    text.cameras = [game.camHUD];
    text.setFormat(Paths.font("PAPYRUS.ttf"), 48, 0xFFcfa92d, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
    text.text = '';
    text.color = 0xFFFFFFFF;
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
        case 'lyric':
            text.text = value1;
            text.updateHitbox();
            text.screenCenter(FlxAxes.X);
            //text.y = PlayState.instance.healthBarBG.y - (text.height * 2);
    }
}