function onLoad() {
    var bg:FlxSprite = new FlxSprite(0, 0);
    bg.loadGraphic(Paths.image("chefblast/kitchen"));
    bg.scrollFactor.set(0.9, 1.0);
	add(bg); 

    var stageFront:FlxSprite = new FlxSprite(10, 875);
    stageFront.loadGraphic(Paths.image("chefblast/table"));
    add(stageFront);
}

function onGameOverStart() 
{   
    setGameOverVideo('gordonover');
}    