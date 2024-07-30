var crowd:FlxSprite;

function onLoad() {
    var sky:FlxSprite = new FlxSprite(-600, -300);
    sky.loadGraphic(Paths.image("minus/sky"));
    sky.antialiasing = true;
    sky.scrollFactor.set(0.5, 0.5);
	add(sky);

    var back:FlxSprite = new FlxSprite(-700, -100);
    back.loadGraphic(Paths.image("minus/back"));
    back.antialiasing = true;
    back.scrollFactor.set(0.8, 0.8);
	add(back);

    crowd = new FlxSprite(-650, 480);
    crowd.frames = Paths.getSparrowAtlas("minus/crowd");
    crowd.antialiasing = true;
    crowd.animation.addByPrefix('idle', 'crowd', 24, false);
    crowd.animation.play("idle");
    crowd.scrollFactor.set(0.9, 0.9);
	add(crowd); 

    var front:FlxSprite = new FlxSprite(-900, 100);
    front.loadGraphic(Paths.image("minus/front"));
    front.antialiasing = true;
    front.scrollFactor.set(1, 1);
	add(front);

    }

function onBeatHit()
{
    if(game.curBeat % 2 == 0){
        crowd.animation.play('idle', true);
        trace('POOPP)PPP');
    }
} 

function onSongStart(){
    crowd.animation.play('idle', true);
}

function onCountdownTick(swagCounter){
    if(swagCounter % 2 == 0) crowd.animation.play('idle', true);
}

function onGameOverStart() 
{
    setGameOverVideo('minus');
}

