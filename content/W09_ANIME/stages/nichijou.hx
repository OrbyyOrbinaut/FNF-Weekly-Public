var mai:Character;

var maiIconColour:FlxColor = 0xFF74543B;
var mioIconColour:FlxColor = 0xFF8FBEF7;
var forceSection:Bool = false;
var iconCanChange:Bool = true; //this is dumb
var focusChar:Character = null;

function onLoad()
{
    add(new BGSprite('nichijou/bg', -400, -520));

    var overlay:FlxSprite = new FlxSprite(-400, -520);
    overlay.loadGraphic(Paths.image("nichijou/gradient"));
    overlay.antialiasing = true;
    overlay.blend = 12;
    foreground.add(overlay);
}

function onCreatePost()
{
    game.snapCamFollowToPos(850, 360);
    
    mai = new Character(game.gf.x - 360, game.gf.y - 8, 'mai', false);
    mai.flipX = false;
    game.addBehindGF(mai);
    game.gf.scrollFactor.set(1,1);

    if(ClientPrefs.downScroll)
    {
        game.comboOffsetCustom = [950, 50, 1020, 200];
    }
    else
    {
        game.comboOffsetCustom = [950, 500, 1020, 650];
    }
}

function onSpawnNotePost(note:Note)
{
    if (note.noteType == 'Mai Note') note.noAnimation = true;
}

function opponentNoteHit(note:Note)
{
    switch (note.noteType) {
        case 'Mai Note':
            mai.playAnim(game.singAnimations[note.noteData % 4], true);
            mai.holdTimer = 0;
            if (!note.isSustainNote && iconCanChange) updateIcons('mai', maiIconColour);
        case 'GF Sing':
            if (!note.isSustainNote && iconCanChange) updateIcons('mio', mioIconColour);
        default:
            if (!note.isSustainNote) updateIcons('yuuko', FlxColor.fromRGB(game.dad.healthColorArray[0], game.dad.healthColorArray[1], game.dad.healthColorArray[2]));
    }
}

function updateIcons(icon:String, colour:FlxColor)
{
    game.healthBar.createFilledBar(colour, FlxColor.fromRGB(game.boyfriend.healthColorArray[0], game.boyfriend.healthColorArray[1], game.boyfriend.healthColorArray[2]));
    game.healthBar.updateBar();
    game.iconP2.changeIcon(icon);
}

function onEvent(name, v1, v2) 
{
    if (name == 'Motivation Events')
    {
        switch (v1) 
        {
            case 'force section':
                switch (v2)
                {
                    case 'mio':
						focusChar = game.gf;
                        forceSection = true;
                    case 'mai':
                        focusChar = mai; 
                        forceSection = true;
                    case 'off':
                        forceSection = false;
                    default:
                        forceSection = false;
                } 
                fakeMoveCamera(focusChar, forceSection);
            case 'icons can change':
                switch (v2)
                {
                    case 'true':
						iconCanChange = true;
                    case 'false':
                        iconCanChange = false;
                } 
            case 'middle cam':
                switch (v2)
                {
                    case 'true':
						game.camFollow.set(850, 380);
                        game.isCameraOnForcedPos = true;
                    case 'false':
                        game.isCameraOnForcedPos = false;
                } 
        }
    }
}

function onBeatHit()
{
    if (curBeat % 2 == 0) {
        var anim:String = mai.animation.curAnim.name;
        if (anim == 'idle') mai.dance();
    }
}

function onUpdate(elapsed)
{
    if (forceSection)
    {
        fakeMoveCamera(focusChar, forceSection);
    }
}

function fakeMoveCamera(char:Character, toggle:Bool) //I made this way over complicated for what i thought would be just a lil polish
{
    game.isCameraOnForcedPos = toggle;
    if (toggle)
    {
        var curCharacter:Character = char;
        if (game.camCurTarget != null) curCharacter = game.camCurTarget;

        var desiredPos = char.getMidpoint();
        desiredPos.x += 150 + char.cameraPosition[0] + game.opponentCameraOffset[0];
        desiredPos.y += -100 + char.cameraPosition[1] + game.opponentCameraOffset[1];

        var displacement:FlxPoint = curCharacter.returnDisplacePoint();

        game.camFollow.x = desiredPos.x + displacement.x;
        game.camFollow.y = desiredPos.y + displacement.y;

        displacement.put();
        desiredPos.put();

        whosTurn = char;
    }
}

function onGameOverStart()
{
    setGameOverVideo('nichi_gameover');
}