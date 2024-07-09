var FILE_PREFIX:String = 'sunday/';

function onLoad()
{
    // this is my low point
    add(new BGSprite(FILE_PREFIX + 'floor', -850, 630));
    add(new BGSprite(FILE_PREFIX + 'wall', -400, -70));
    add(new BGSprite(FILE_PREFIX + 'speaker', -80, 365));
}

function onCreatePost()
{
    GameOverSubstate.endSoundName = "empty";
    GameOverSubstate.deathSoundName = "empty";
    GameOverSubstate.loopSoundName = "empty";

    game.snapCamFollowToPos(710, 500);
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
    vgvideo.load(Paths.video('sunday'));
    vgvideo.play();
    GameOverSubstate.instance.add(vgvideo);
    GameOverSubstate.instance.boyfriend.alpha = 0;
}