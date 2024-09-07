var table:FlxSprite;
var slenderman:Character;
var zardy:Character;
var randy:Character;
var characters = [];
var section:String = 'herobrine';
var alt:String = '';
var randyControl:Bool = false;
var bars:FlxSprite;

function onLoad(){
    var bg = new FlxSprite();
    bg.frames = Paths.getSparrowAtlas("scarydeath/bg");
    bg.animation.addByPrefix("idle", "bg", 24, true);
    bg.animation.play("idle");
    add(bg);

    tableshade = new FlxSprite(0,20).loadGraphic(Paths.image("scarydeath/tableShade"));
    // add(tableshade);

    table = new FlxSprite(200, 400).loadGraphic(Paths.image("scarydeath/table"));
    // add(table);

    slenderman = new Character(450, 90, "slender");
    slenderman.danceEveryNumBeats = 1;
    slenderman.playAnim('idle');
    slenderman.visible = false;
    add(slenderman);

    zardy = new Character(1050, 275, "zardy");
    zardy.danceEveryNumBeats = 2;
    zardy.playAnim('idle');
    zardy.visible = false;
    add(zardy);

    randy = new Character(612.5, 275, "randy_t10");
    randy.danceEveryNumBeats = 2;
    randy.playAnim('idle');
    randy.flipX = !randy.flipX;
    // randy.visible = false;
    foreground.add(randy);

    f = new FlxSprite().loadGraphic(Paths.image("scarydeath/frontGradient"));
    f.scale.set(1.5, 1);
    f.updateHitbox();
    foreground.add(f);
}

function onSpawnNotePost(note:Note)
    {
        note.visible = note.mustPress;
    }

function onCreatePost(){
    for (i in 0...game.opponentStrums.members.length) {
        game.opponentStrums.members[i].visible = false;
    }
    
    bars = new FlxSprite().loadGraphic(Paths.image("scarydeath/bars"));
    bars.camera = game.camHUD;
    add(bars);

    game.dad.visible = false;
    
    insert(members.indexOf(game.boyfriendGroup), tableshade);
    insert(members.indexOf(game.boyfriendGroup), table);
    
    changeSection('nothing', 'zardy');
    game.camGame.visible = false;

    modManager.setValue("opponentSwap", 0.5);
    modManager.setValue("alpha", 0.25, 1);
    modManager.setValue("transform1X", -112, 1);
    modManager.setValue("transform2X", 112, 1);
    modManager.setValue("flip", -1.25, 1);
    modManager.setValue("invert", 0.625, 1);

    game.skipCountdown = true;

    game.snapCamFollowToPos(680, 375);
}

function onSongStart() {
    game.camGame.visible = true;

    modManager.queueFuncOnce(3367, (s,s2)->{
        game.isCameraOnForcedPos = true;

        // there's defo a better way to do this im just Lazy
        FlxTween.tween(game, {defaultCamZoom: 4}, 2.5, {ease: FlxEase.quadInOut});
        FlxTween.tween(game.camFollow, {x: 400, y: 170}, 2.5, {ease: FlxEase.quadInOut});
        FlxTween.tween(game.camFollowPos, {x: 400, y: 170}, 2.5, {ease: FlxEase.quadInOut});
        FlxTween.tween(game.camHUD, {alpha: 0}, 2.5, {ease: FlxEase.quadInOut});
        FlxTween.tween(game.camGame, {alpha: 0}, 1, {startDelay: 2.3});
    });
}

function onBeatHit(){
    if(curBeat % zardy.danceEveryNumBeats == 0 && !StringTools.startsWith(zardy.animation.curAnim.name, 'sing')) zardy.dance();
    if(curBeat % slenderman.danceEveryNumBeats == 0 && !StringTools.startsWith(slenderman.animation.curAnim.name, 'sing')) slenderman.dance();
    if(curBeat % randy.danceEveryNumBeats == 0 && !StringTools.startsWith(randy.animation.curAnim.name, 'sing')) randy.dance();
    // trace(zardy.animation.curAnim.name);
    // trace(StringTools.startsWith(zardy.animation.curAnim.name, 'sing'));
    // if(curBeat % slenderman.danceEveryNumBeats == 0 && !slenderman.animation.curAnim.name.startsWith('sing')) slenderman.dance();
}

function onEvent(eventName, value1, value2){
    if(eventName == 'Change Scary') changeSection(value1, value2);
}

function changeSection(character, character2){
    section = character;
    game.isCameraOnForcedPos = false;
    switch(character){
        case 'nothing':
            game.iconP2.visible = false;
            game.camGame.flash(FlxColor.BLACK, 1.5);
            trace(character2);
            switch(character2){
                case 'zardy':
                    game.opponentStrums.owner = zardy;
                case 'slenderman':
                    game.opponentStrums.owner = slenderman;
                case 'dad':
                    game.opponentStrums.owner = game.dad;
            }
            trace(game.opponentStrums.owner);
            slenderman.visible = false;
            zardy.visible = false;
            game.dad.visible = false;
            table.loadGraphic(Paths.image("scarydeath/table"));    
        case 'tweakfan':
            changePlayer('tweakfan');
        case 'randy':
            changePlayer('randy');
        case 'slender':
            game.iconP2.visible = true;
            changeRandySuffix('-alt');
            game.triggerEventNote('Alt Idle Animation', 'boyfriend', '-alt2');
            //game.opponentStrums.owner = slenderman;
            if(!slenderman.visible){
                slenderman.visible = true;
                game.dad.visible = false;
                zardy.visible = false;
                game.camGame.flash(FlxColor.BLACK, 1.5);
                table.loadGraphic(Paths.image("scarydeath/table"));    
            }
        case 'zardy':
            game.iconP2.visible = true;
            changeRandySuffix('');
            game.triggerEventNote('Alt Idle Animation', 'boyfriend', '-alt');
            //game.opponentStrums.owner = zardy;
            if(!zardy.visible){
                zardy.visible = true;
                slenderman.visible = false;
                game.dad.visible = false;
                game.camGame.flash(FlxColor.BLACK, 1.5);
                table.loadGraphic(Paths.image("scarydeath/tableZardy"));    
            }
        case 'herobrine':   
            game.iconP2.visible = true;
            changeRandySuffix('-herobrine');
            game.triggerEventNote('Alt Idle Animation', 'boyfriend', '');
            //game.opponentStrums.owner = game.dad;
            if(!game.dad.visible){
                game.camGame.flash(FlxColor.BLACK, 1.5);
                game.dad.visible = true;
                zardy.visible = false;
                slenderman.visible = false;
                table.loadGraphic(Paths.image("scarydeath/table"));    
            }
    }
    trace(character);
    if(character == 'nothing') // dumb fix
    {
        game.iconP1.changeIcon(game.playerStrums.owner.healthIcon);
        game.iconP2.changeIcon(game.playerStrums.owner.healthIcon);
        game.healthBar.createFilledBar(FlxColor.fromRGB(game.playerStrums.owner.healthColorArray[0], game.playerStrums.owner.healthColorArray[1], game.playerStrums.owner.healthColorArray[2]),
        FlxColor.fromRGB(game.playerStrums.owner.healthColorArray[0], game.playerStrums.owner.healthColorArray[1], game.playerStrums.owner.healthColorArray[2]));
        trace('FUCKKKKK');
    }
    else if(character == 'herobrine' || character == 'zardy' || character == 'slender')
    {
        game.iconP1.changeIcon(game.playerStrums.owner.healthIcon);
        game.iconP2.changeIcon(game.opponentStrums.owner.healthIcon);
        game.healthBar.createFilledBar(FlxColor.fromRGB(game.opponentStrums.owner.healthColorArray[0], game.opponentStrums.owner.healthColorArray[1], game.opponentStrums.owner.healthColorArray[2]),
        FlxColor.fromRGB(game.playerStrums.owner.healthColorArray[0], game.playerStrums.owner.healthColorArray[1], game.playerStrums.owner.healthColorArray[2]));
        trace("FUCK");
    }
    game.healthBar.updateBar();
}

function onSpawnNote(note){ if(note.noteType == 'Tweakfan Note') note.owner = game.boyfriend; }
function goodNoteHit(note){
    if(note.noteType == 'Duet'){
        game.boyfriend.playAnim( game.singAnimations[note.noteData]);
        randy.playAnim( game.singAnimations[note.noteData]);
    }
}

function changePlayer(char){
    switch(char){
        case 'tweakfan':
            randyControl = false;
            game.playerStrums.owner = game.boyfriend;
        case 'randy':
            randyControl = true;
            game.playerStrums.owner = randy;
    }
}

function changeRandySuffix(suffix){
    randy.animSuffix = suffix;
    randy.idleSuffix = suffix;
    randy.recalculateDanceIdle();
    randy.dance();
}

function onGameOverStart() 
{
    setGameOverVideo('scarefull_gameover');
}

function onMoveCamera(c){
    switch(c){
        case 'boyfriend':
            game.defaultCamZoom = 1.25;
        default: 
            switch(section){
                case 'slender':
                    game.defaultCamZoom = 0.9;
                case 'zardy':
                    game.defaultCamZoom = 1.05;
                default:
                    game.defaultCamZoom = 1.1;
            }
    }
}