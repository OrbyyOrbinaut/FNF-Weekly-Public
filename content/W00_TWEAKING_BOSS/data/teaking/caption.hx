var text:FlxText;

function onCreatePost() {
    text = new FlxText(1280, 100);
    text.cameras = [PlayState.instance.camHUD];
    text.setFormat(Paths.font("BRLNSDB.ttf"), 50, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
    text.text = '';
    text.color = 0xFFFFFFFF;
    text.width = 100;
    text.antialiasing = true;
    text.updateHitbox();
    text.screenCenter(FlxAxes.X);
    text.screenCenter(FlxAxes.Y);
    text.borderSize = 3;
    add(text);

    trace("yea!");
}

function onEvent(eventName, value1, value2){
    switch(eventName){
        case 'caption':
            text.text = value1;
            text.screenCenter(FlxAxes.X);
            text.screenCenter(FlxAxes.Y);
    }
}