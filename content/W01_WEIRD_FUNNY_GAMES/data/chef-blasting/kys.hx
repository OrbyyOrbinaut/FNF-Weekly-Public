var kysVid:PsychVideoSprite;

function onDestroy() {
    if (kysVid != null) kysVid.destroy();
}

function onCreatePost() {
    kysVid = new PsychVideoSprite();
    kysVid.addCallback('onFormat',()->{
        kysVid.cameras = [game.camOther];
        kysVid.updateHitbox();
        kysVid.screenCenter();
        kysVid.antialiasing = true;
    });
    kysVid.load(Paths.video('kys'), [PsychVideoSprite.muted]);
    add(kysVid);
    kysVid.visible = false;
    trace("yea!");
}

function onEvent(eventName, value1, value2){
    switch(eventName){
        case 'kys':
        kysVid.visible = true;
        kysVid.play();
        FlxG.sound.music.volume = 1;
    }
}