var openVid:PsychVideoSprite;
var blackScreen:FlxSprite;

function onLoad() {
    var bg:FlxSprite = new FlxSprite(0, 0);
    bg.loadGraphic(Paths.image("skullkid/BG"));
    bg.antialiasing = true;
	add(bg); 
    game.skipCountdown = true;
}   

function onCreatePost(){
    GameOverSubstate.endSoundName = "empty";
    GameOverSubstate.deathSoundName = "empty";
    GameOverSubstate.loopSoundName = "empty";
    game.snapCamFollowToPos(790, 509);
    game.isCameraOnForcedPos = true;
    modManager.setValue("opponentSwap", 1);
    modManager.setValue("mini", -3);
    ClientPrefs.noteSplashes = false;
    openVid = new PsychVideoSprite();
    openVid.addCallback('onFormat',()->{
        openVid.cameras = [game.camOther];
        openVid.screenCenter();
    });
    openVid.addCallback('onEnd',()->{
        blackScreen.alpha = 0;
        FlxTween.tween(game.camHUD, {alpha: 1}, 1.5, {ease: FlxEase.quadOut});
        game.camGame.flash(0xFFFFFFFF, 1.0);
    });
    openVid.load(Paths.video('terminaintro'), [PsychVideoSprite.muted]);
    openVid.antialiasing = true;
    add(openVid);
    blackScreen = new FlxSprite().makeGraphic(1, 1, 0xFF000000);
    blackScreen.scale.set(FlxG.width * 2,FlxG.height * 2);
    blackScreen.updateHitbox();
    blackScreen.scrollFactor.set();
    blackScreen.screenCenter();
    foreground.add(blackScreen);
    game.camHUD.alpha = 0;
    //game.camGame.alpha = 0;
}

function onSongStart()
{
    openVid.play();
}

function onEvent(eventName, value1, value2){
    if (eventName == 'darkScr'){
        switch(value1){
            case 'darken':
                FlxG.camera.fade(FlxColor.BLACK, 0, false);
            case 'light':
                FlxG.camera.fade(FlxColor.WHITE, 1, true);
        }
    }
}

function onGameOverStart() 
    {
        var vgvideo = new PsychVideoSprite();
        vgvideo.addCallback('onFormat',()->{
            vgvideo.setGraphicSize(0,FlxG.height);
            vgvideo.updateHitbox();
            vgvideo.screenCenter();
            vgvideo.antialiasing = true;
            vgvideo.cameras = [game.camOther];
        });
        vgvideo.addCallback('onEnd',()->{
            FlxG.resetState();
        });
        vgvideo.load(Paths.video("termina_gameover"));
        vgvideo.play();
        GameOverSubstate.instance.add(vgvideo);
        GameOverSubstate.instance.boyfriend.alpha = 0;
    }

var s:Float = 1;
var skY:Float = 225;
function onUpdate(elapsed){
    s += elapsed;
    game.dad.y = FlxMath.lerp(game.dad.y, skY + (Math.cos(s) * 65), CoolUtil.boundTo(1, 0, elapsed * 4));
}

function onDestroy(){
    ClientPrefs.loadPrefs();
    if (openVid != null) openVid.destroy();
}