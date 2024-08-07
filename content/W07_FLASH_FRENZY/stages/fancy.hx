function onLoad() {
    var sky:FlxSprite = new FlxSprite(-275, -200);
    sky.loadGraphic(Paths.image("fancy/sky"));
    sky.antialiasing = false;
    sky.scrollFactor.set(0.5, 0.5);
	add(sky);

    var grass:FlxSprite = new FlxSprite(-100, -475);
    grass.loadGraphic(Paths.image("fancy/mountains"));
    grass.antialiasing = false;
    grass.scrollFactor.set(0.75, 0.75);
	add(grass);

    var flag:FlxSprite = new FlxSprite(1650, 365);
    flag.loadGraphic(Paths.image("fancy/flag"));
    flag.antialiasing = false;
	add(flag);

    var ground:FlxSprite = new FlxSprite(0, -475);
    ground.loadGraphic(Paths.image("fancy/platforms"));
    ground.antialiasing = false;
	add(ground);
}


function onCreatePost(){
    game.snapCamFollowToPos(1300, 500);
}

function onGameOverStart() 
{
    setGameOverVideo('fancy_gameover');
}