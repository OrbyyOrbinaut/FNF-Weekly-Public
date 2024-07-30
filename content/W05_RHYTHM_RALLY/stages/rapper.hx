var crowd:FlxSprite;
var tween1:FlxTween;
function onLoad() {
    var drop:FlxSprite = new FlxSprite(0, 0);
    drop.loadGraphic(Paths.image("parappa/drop"));
    drop.antialiasing = true;
    drop.scrollFactor.set(1, 1);
    add(drop);

    var stage1:FlxSprite = new FlxSprite(2000, 0);
    stage1.loadGraphic(Paths.image("parappa/stage"));
    stage1.antialiasing = true;
    stage1.scrollFactor.set(1, 1);
    add(stage1);

    var speakers:FlxSprite = new FlxSprite(1450, -280);
    speakers.loadGraphic(Paths.image("parappa/speakers"));
    speakers.antialiasing = true;
    speakers.scrollFactor.set(1, 1);
    add(speakers);

    crowd = new FlxSprite(1500, 1400);
    crowd.loadGraphic(Paths.image("parappa/crowd"));
    crowd.antialiasing = true;
    crowd.scrollFactor.set(1.1, 1.1);
    foreground.add(crowd);
    add(crowd); 
}

function onCreatePost(){
    game.snapCamFollowToPos(3475, 1000);
}

function onBeatHit()
{
    if(tween1 != null)
    {
        tween1.cancel();
    }
    crowd.y = 1500 - 25;
    tween1 = FlxTween.tween(crowd, {y: 1400}, 0.3, {ease: FlxEase.expoOut});
}

function onEvent(name:String, v1:String, v2:String)
{
    if (name == 'Duet') 
    {
        switch(v1)
        {
            case 'on':
            game.camFollow.set(3460, 1100);
            game.isCameraOnForcedPos = true;
            case 'off':    
            game.isCameraOnForcedPos = false;
        }
    }
}

function onGameOverStart() 
{
    setGameOverVideo("parappa_gameover");
}