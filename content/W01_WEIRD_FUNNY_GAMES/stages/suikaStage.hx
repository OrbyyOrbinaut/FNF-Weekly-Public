var fruits:FlxSprite;
var cloud:FlxSprite;
var p:Float;

function onLoad() {
    var bg:FlxSprite = new FlxSprite(0, 0);
    bg.loadGraphic(Paths.image("suika/bg"));
    bg.updateHitbox();
    bg.antialiasing = true;
	add(bg); 

    var boxback:FlxSprite = new FlxSprite(7, 0);
    boxback.loadGraphic(Paths.image("suika/box_back"));
    boxback.antialiasing = true;
	add(boxback); 

    fruits = new FlxSprite(412, 107);
    fruits.frames = Paths.getSparrowAtlas("suika/bgfruits");
    fruits.antialiasing = true;
    fruits.animation.addByPrefix('idle', 'bgfruit', 24, true);
    fruits.animation.play('idle');
	add(fruits); 

    var boxfront:FlxSprite = new FlxSprite(7, 0);
    boxfront.loadGraphic(Paths.image("suika/box_front"));
    boxfront.antialiasing = true;
	foreground.add(boxfront); 

    cloud = new FlxSprite(700, 7);
    cloud.frames = Paths.getSparrowAtlas("suika/cloud");
    cloud.updateHitbox();
    cloud.animation.addByPrefix('idle', 'CLOUD', 24, true);
    cloud.antialiasing = true;
    cloud.animation.play('idle');
    foreground.add(cloud);
}

function onCreatePost()
{    
    healthBar.angle = 90; 
    healthBar.screenCenter();
    healthBar.x = -150;
    healthBar.scale.x = 0.75;
    healthBarBG.scale.x = 0.75;
    healthBar.updateHitbox();
    healthBarBG.updateHitbox();
    timeBar.y = -999;
    timeTxt.y = -999;

    game.triggerEventNote('Camera Follow Pos', '640', '359'); //FUCK I'M GONNA KMS
    game.triggerEventNote('Set GF Speed', '2', ''); //FUCK I'M GONNA KMS

    game.comboOffsetCustom = [150, 300, 185, 450];
}

function onSpawnNotePost(note:Note)
{
    note.visible = note.mustPress;
    modManager.setValue("transform0X", -1000, 1);
    modManager.setValue("transform1X", -1000, 1);
    modManager.setValue("transform2X", -1000, 1);
    modManager.setValue("transform3X", -1000, 1);
    modManager.setValue("transform0X", 120, 0);
    modManager.setValue("transform1X", 115, 0);
    modManager.setValue("transform2X", 110, 0);
    modManager.setValue("transform3X", 100, 0);
    modManager.setValue("miniX", 0.12);
    modManager.setValue("miniY", 0.12);
}

function onUpdate(elapsed){
    p++;
    cloud.x = 575 + (Math.sin(p/50 / (FlxG.updateFramerate / 60)) * 180);
}

function onUpdatePost(elapsed){
    game.iconP1.x = 0;
    game.iconP1.y = 580;
    game.iconP2.x = 0;
    game.iconP2.y = -8;
}

function onGameOverStart() 
{   
    setGameOverVideo('SUIKA_GAMEOVER');
}    