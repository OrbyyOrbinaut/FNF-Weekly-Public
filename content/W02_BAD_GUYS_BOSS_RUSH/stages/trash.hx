var FILE_PREFIX:String = 'spamton/';

var white:FlxSprite;

// first half
var bg:BGSprite;
var phone:BGSprite;
var garbage:BGSprite;

// second half
var scrollBG1:BGSprite;
var scrollBG2:BGSprite;
var legs:BGSprite;

var isRunning:Bool = false;

function onLoad() {
    game.addCharacterToList('bf-delta-walk');

    white = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
    white.cameras = [game.camHUD];
    white.alpha = 0.001;

    bg = new BGSprite(FILE_PREFIX + 'bgmain', 0, 0);
    phone = new BGSprite(FILE_PREFIX + 'phone', 1250, 0, 0.9, 0.9);
    garbage = new BGSprite(FILE_PREFIX + 'garbage', 100, 800, 1.1, 1.1);

    scrollBG1 = new BGSprite(FILE_PREFIX + 'bgscroll', 0, -380);
    scrollBG1.alpha = 0.001;
    scrollBG2 = new BGSprite(FILE_PREFIX + 'bgscroll', scrollBG1.width, -380);
    scrollBG2.alpha = 0.001;

    legs = new BGSprite(FILE_PREFIX + 'deltabf_legs', 0, 0, 1, 1, ['fnfwalklegs0'], true);
    legs.alpha = 0.001;

    add(white);
    add(scrollBG1);
    add(scrollBG2);
    add(phone);
    add(bg);
    add(legs);

    game.precacheList.set('bepis-yoink', 'sound');
    game.precacheList.set('WindChime', 'sound');

    game.comboOffsetCustom = [925, 350, 965, 500];
}

function onEvent(name, v1, v2) 
{
    if (name == 'Spamton Triggers') 
    {
        switch (v1) {
            case 'yoink':
            {
                game.defaultCamZoom = 0.75;
                game.boyfriend.playAnim('yoink', true);
                game.boyfriend.animTimer = 6;
                FlxG.sound.play(Paths.sound('bepis-yoink'));
            }
            case 'angry':
            {
                game.dad.playAnim('angry', true);
                game.dad.animTimer = 1;
            }
            case 'start fade':
            {
                FlxTween.tween(white, {alpha: 1}, 1);
                FlxG.sound.play(Paths.sound('WindChime'), 0.6);
            }
            case 'run':
            {
                startRunning();
                FlxTween.tween(white, {alpha: 0}, 1);
            }
        }
    }
}

function startRunning() 
{
    game.defaultCamZoom = 0.8;

    game.triggerEventNote('Alt Idle Animation', 'dad', '-run');
    game.dad.playAnim('idle-run', true);
    game.triggerEventNote('Change Character', 'bf', 'bf-delta-walk');
    game.boyfriend.x += 200;

    legs.x = game.boyfriend.x + 93;
    legs.y = game.boyfriend.y + 260;
    legs.alpha = 1;

    bg.alpha = 0.001;
    phone.alpha = 0.001;
    garbage.alpha = 0.001;

    scrollBG1.alpha = 1;
    scrollBG2.alpha = 1;

    isRunning = true;
}

function onUpdatePost(elapsed:Float) 
{
    if (isRunning) 
    {
        scrollBG1.x -= elapsed * 1800;
        scrollBG2.x -= elapsed * 1800;

        if (scrollBG1.x < -4000) scrollBG1.x += scrollBG1.width * 2;
        if (scrollBG2.x < -4000) scrollBG2.x += scrollBG2.width * 2;
    }
}

function onCreatePost() {
    add(garbage);
}

function onGameOverStart() 
{    
    setGameOverVideo('spam');
}    
