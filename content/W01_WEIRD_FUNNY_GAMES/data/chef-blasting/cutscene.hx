var cutscene:PsychVideoSprite;
var allowCountdown:Bool = false;
var blackScreen:FlxSprite;
var skip:FlxText;

function onCreatePost(){
    blackscreen = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
    add(blackScreen);

    skip = new FlxText(10, 10).setFormat(Paths.font('vcr.ttf'), 24, 0xFF696969, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, 0xFF000000);
    skip.text = 'Click to skip';
    skip.alpha = 0.75;
    skip.cameras = [game.camOther];
}

function onDestroy() {
    if (cutscene != null) cutscene.destroy();
}

function doStartCountdown()
{
    return Function_Stop;
}

function presongCutscene(){
    if(!allowCountdown){
        game.inCutscene = true;
        game.camHUD.visible = false;
        cutscene = new PsychVideoSprite();
        cutscene.addCallback('onFormat',()->{
        cutscene.setGraphicSize(FlxG.width,FlxG.height);
        cutscene.updateHitbox();
        cutscene.screenCenter();
        cutscene.antialiasing = true;
        cutscene.cameras = [game.camOther];
        });
        cutscene.addCallback('onEnd',()->{
            endIntro();
        });
        cutscene.load(Paths.video('gordoncutscene'));
        cutscene.play();
        add(cutscene);
        game.add(skip);
        return Function_Stop;
    }
    blackScreen.visible = false;
}

function endIntro() {
    cutscene.stop();
    cutscene.destroy();
    watchingCutscene = false;
    game.inCutscene = false;
    game.camHUD.visible = true;
    hasWatchedCutscene = true;
    FlxG.mouse.visible = false;
    skip.destroy();
    game.startCountdown();
}

function onUpdatePost(elapsed:Float)
{
    if (FlxG.mouse.justPressed) endIntro();
}