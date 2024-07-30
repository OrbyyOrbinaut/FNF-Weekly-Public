var bg:BGSprite;
var fade:FlxSprite;

var extraGuy1:Character;
var extraGuy2:Character;

var splitStage:Int = 0;
var distortion;
var popStep:Null<Int> = null;

/**
 * THIS CODE IS SO MESSY PLEASE DON'T JUDGE ME this was made at like midnight - Leth
 */

function onLoad() 
{
    game.skipCountdown = true;
    game.cameraSpeed = 2;

    bg = new BGSprite('johnBG', 120, -50);
    bg.setGraphicSize(bg.width * 1.3, bg.height * 1.3);
    bg.scrollFactor.set(0.8, 0.8);
    add(bg);

    fade = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height);
    fade.cameras = [game.camOther];
    fade.screenCenter();
    fade.alpha = 0.001;
    add(fade);

    // shoutouts wingblings for da shader
    distortion = newShader('defective');
    ExUtils.addShader(distortion, game.camGame);
}

function onCreatePost()
{
    GameOverSubstate.endSoundName = "empty";
    GameOverSubstate.deathSoundName = "empty";
    GameOverSubstate.loopSoundName = "empty";

    game.dad.x = -1000;
    game.dad.flipX = false;
    game.camGame.alpha = 0.001;
    game.iconP2.alpha = 0.001;
    game.camHUD.alpha = 0.001;

    extraGuy1 = new Character(game.dad.x, game.dad.y, 'john', false);
    extraGuy1.flipX = false;
    add(extraGuy1);

    extraGuy2 = new Character(game.dad.x, game.dad.y, 'john', false);
    extraGuy2.flipX = false;
    add(extraGuy2);

    for (i in 0...game.opponentStrums.members.length) {
		game.opponentStrums.members[i].alpha = 0.001;
	}

    game.comboOffsetCustom = [150, 300, 185, 450];
}

function onSpawnNotePost(note:Note)
{
    note.visible = note.mustPress;
    if (note.noteType == 'Other Johns') {
        note.noAnimation = true;
    }
    modManager.setValue("opponentSwap", 0.5, 0);
}

function onBeatHit()
{
    if (game.curBeat % 2 == 0) {
        var anim:String = extraGuy1.animation.curAnim.name;
        if (anim == 'idle') 
            extraGuy1.dance();
        anim = extraGuy2.animation.curAnim.name;
        if (anim == 'idle') 
            extraGuy2.dance();
    }

    switch (game.curBeat) 
    {
        case 3:
            FlxTween.tween(fade, {alpha: 1}, Conductor.crochet);
        case 4:
            FlxTween.tween(fade, {alpha: 0.001}, Conductor.crochet);
            game.cameraSpeed = 1;
            game.isCameraOnForcedPos = true;
            game.boyfriend.x -= 110;
            game.boyfriend.y -= 110;
            game.camGame.alpha = 1;
            game.camHUD.alpha = 1;
    }
}

function onStepHit()
{
    if (popStep != null) 
    {
        if (game.curStep == popStep + 1) {
            game.dad.x = 10000;
            game.playerStrums.members[2].alpha = 0.001;
        }
        if (game.curStep == popStep + 2) {
            extraGuy1.x = 10000;
            game.playerStrums.members[1].alpha = 0.001;
        }
        if (game.curStep == popStep + 3) {
            extraGuy2.x = 10000;
            game.playerStrums.members[3].alpha = 0.001;
        }
        if (game.curStep == popStep + 4) {
            game.iconP1.alpha = 0.001;
        }
        if (game.curStep == popStep + 5) {
            game.camHUD.alpha = 0.001;
            popStep = null;
        }
    }
}

function opponentNoteHit(note:Note)
{
    if (note.noteType == 'Other Johns')
    {
        extraGuy1.playAnim(game.singAnimations[note.noteData % 4], true);
        extraGuy1.holdTimer = 0;

        extraGuy2.playAnim(game.singAnimations[note.noteData % 4], true);
        extraGuy2.holdTimer = 0;
    }
}

function onEvent(eventName, value1, value2)
{
    switch (eventName) 
    {
        case 'Split':
            if (splitStage > 1) return;

            game.defaultCamZoom -= 0.1;
    
            if (splitStage == 0) 
            {
                game.dad.x = game.boyfriend.x;
                game.dad.y = game.boyfriend.y;
                var daX:Float = game.boyfriend.x;
                FlxTween.tween(game.dad, {x: daX - 300}, 1.2, {
                    ease: FlxEase.expoOut
                });
                FlxTween.tween(game.boyfriend, {x: daX + 300}, 1.2, {
                    ease: FlxEase.expoOut
                });
            }
            if (splitStage == 1) 
            {
                // left side
                extraGuy1.x = game.dad.x;
                extraGuy1.y = game.dad.y;
                extraGuy1.alpha = 1;
                var daY:Float = game.dad.y;
                
                FlxTween.tween(game.dad, {y: daY - 250}, 1.2, {
                    ease: FlxEase.expoOut
                });
                FlxTween.tween(extraGuy1, {y: daY + 250}, 1.2, {
                    ease: FlxEase.expoOut
                });
    
                // right side
                extraGuy2.x = game.boyfriend.x;
                extraGuy2.y = game.boyfriend.y;
                extraGuy2.alpha = 1;
                var daY:Float = game.boyfriend.y;
                
                FlxTween.tween(game.boyfriend, {y: daY + 250}, 1.2, {
                    ease: FlxEase.expoOut
                });
                FlxTween.tween(extraGuy2, {y: daY - 250}, 1.2, {
                    ease: FlxEase.expoOut
                });
            }
    
            splitStage += 1;
        
        case 'Pop Johns':
            popStep = game.curStep;
            game.boyfriend.x = 10000;
            game.playerStrums.members[0].alpha = 0.001;
    }
}

function onGameOverStart() 
{
    setGameOverVideo("BACTERIAL_GAMEOVER");
}