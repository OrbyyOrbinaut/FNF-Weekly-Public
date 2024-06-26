function onLoad() {
    var bg:FlxSprite = new FlxSprite(0, 0);
    bg.loadGraphic(Paths.image("chefblast/kitchen"));
    bg.scrollFactor.set(0.9, 1.0);
	add(bg); 

    var stageFront:FlxSprite = new FlxSprite(10, 875);
    stageFront.loadGraphic(Paths.image("chefblast/table"));
    add(stageFront);
}

function onCreatePost()
{
    GameOverSubstate.endSoundName = "empty";
    GameOverSubstate.deathSoundName = "empty";
    GameOverSubstate.loopSoundName = "empty";
}

function onGameOverStart() 
{    
    var video = new PsychVideoSprite();
    video.addCallback('onFormat',()->{
        video.setGraphicSize(0,FlxG.height);
        video.updateHitbox();
        video.screenCenter();
        video.cameras = [game.camOther];
        video.antialiasing = true;
    });
    video.addCallback('onEnd',()->{
        FlxG.resetState();
    });
    video.load(Paths.video("gordonover"));
    video.play();
    GameOverSubstate.instance.add(video);
    GameOverSubstate.instance.boyfriend.alpha = 0;
}    