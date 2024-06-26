// var swirl = newShader('swirl');
addHaxeLibrary('Lib', 'openfl');

function onLoad(){
    var mount = new FlxSprite().loadGraphic(Paths.image("joink/mountains"));
    mount.scale.set(1.75, 1.75);
    mount.updateHitbox();
    mount.scrollFactor.set(0.25, 0.25);
    mount.screenCenter(); 
    add(mount);   

    var hills = new FlxSprite().loadGraphic(Paths.image("joink/hills"));
    hills.scale.set(1.75, 1.75);
    hills.updateHitbox();
    hills.scrollFactor.set(0.5, 0.5);
    hills.screenCenter(); 
    hills.y += 180;
    add(hills);   

    var ground = new FlxSprite().loadGraphic(Paths.image("joink/ground"));
    ground.scale.set(1.75, 1.75);
    ground.updateHitbox();
    ground.screenCenter(); 
    ground.y += 500;
    add(ground);   
}

function onDestroy(){
    FlxG.resizeWindow(1280, 720);
    FlxG.scaleMode.height = 720;  
    FlxG.camera.height = 720;  
}

var window = Lib.application.window;
function onCreatePost(){
    FlxG.resizeWindow(1024, 768);
    FlxG.scaleMode.height = 960;    
    FlxG.camera.height = 960;
    game.camHUD.height = 960;

    GameOverSubstate.characterName = "farmer-bf-dead";
    GameOverSubstate.endSoundName = "empty";
    GameOverSubstate.deathSoundName = "farmerbfdeath";
    GameOverSubstate.loopSoundName = "farmerbfloop";

    game.isCameraOnForcedPos = true;
    game.snapCamFollowToPos(650, 500);

    var list = [game.healthBarBG, game.healthBar, game.iconP1, game.iconP2, game.scoreTxt];
    for(l in list){
        if(!ClientPrefs.downScroll) l.y += 240;
    }
    if(ClientPrefs.downScroll){
        game.timeBarBG.y += 240;
        game.timeBar.y += 240;
        game.timeTxt.y += 240;
    }
    game.healthBarBG.scale.set(1.5, 1);
    game.healthBarBG.updateHitbox();
    game.healthBarBG.screenCenter(FlxAxes.X);
    game.healthBar.scale.set(1.5, 1);
    game.healthBar.updateHitbox();
    game.healthBar.screenCenter(FlxAxes.X);

}

function opponentNoteHit(note){
    if(note.noteData == 2){
        game.dad.y -= 50;
    }
}

function onGameOverStart(){
    FlxG.camera.zoom = 1.0;
}

var time:Float = 0;
function onUpdate(elapsed){
	lerpShit = 0.15 * 60 * elapsed;
    time += elapsed / 8;

    game.dad.y = FlxMath.lerp(game.dad.y, 960, lerpShit);
    // swirl.data.speen.value = [time];
}