var cutscene:PsychVideoSprite;
var allowCountdown:Bool = false;
var blackScreen:FlxSprite;

function onCreatePost(){
    blackscreen = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
    add(blackScreen);
}

function onDestroy() {
    if (cutscene != null) cutscene.destroy();
}

function onStartCountdown(){
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
            allowCountdown = true;
            game.inCutscene = false;
            game.camHUD.visible = true;
            game.startCountdown();
        });
        cutscene.load(Paths.video('gordoncutscene'));
        cutscene.play();
        add(cutscene);
        return Function_Stop;
    }
    blackScreen.visible = false;
}