var PREFIX:String = 'newsSetConan/'; // the leth signiture

var nanoc:Character;
var focusChar:Character = null;
var iconColours:Map<String, FlxColor> = [
    'norbert' => 0xFFE1E1E1,
    'trebron' => 0xFF3D3D3D,
    'conan' => 0xFFFFA3A8,
    'nanoc' => 0xFFACA3FF,
    'connoc' => 0xFF9F4AB2
];

var pigSection:Bool = false;
var isFused:Bool = false;
var white:FlxSprite;
var allowEnd:Bool = false;

function onLoad() 
{
    game.addCharacterToList('connoc', 2);

    add(new BGSprite(PREFIX + 'bg_hole', -1357, -739));
    foreground.add(new BGSprite(PREFIX + 'broken_shit', -770, 1000));

    var rain:BGSprite = new BGSprite(PREFIX + 'rain', -50, -750, 1, 1, ['rain0'], true);
    rain.alpha = 0.5;
    foreground.add(rain);

    white = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
    white.cameras = [game.camHUD];
    white.alpha = 0;
    white.blend = BlendMode.ADD;
    add(white);
}

function onCreatePost()
{
    nanoc = new Character(game.dad.x + 700, game.gf.y, 'nanoc', false);
    nanoc.flipX = false;
    game.addBehindDad(nanoc);

    game.gf.flipX = !game.gf.flipX;
    game.gf.alpha = 0.001;
    nanoc.alpha = 0.001;
}

function onSpawnNotePost(note:Note)
{
    if (note.noteType == 'Nanoc Note') note.noAnimation = true;
}

function opponentNoteHit(note:Note)
{
    if (note.noteType == 'Nanoc Note') {
        nanoc.playAnim(game.singAnimations[note.noteData % 4], true);
        nanoc.holdTimer = 0;
    }
}

function onBeatHit()
{
    var anim:String = nanoc.animation.curAnim.name;
    if (curBeat % Math.round(game.gfSpeed * nanoc.danceEveryNumBeats) == 0 && (anim == 'danceLeft' || anim == 'danceRight')) nanoc.dance();
}

function onEvent(name:String, v1:String, v2:String)
{
    switch (name) 
    {
        case 'Pig Section':
            switch (v1) 
            {
                case 'on':
                    pigSection = true;
                case 'off':
                    pigSection = false;
            }
            switch (v2) 
            {
                case 'conan':
                    focusChar = game.gf;
                case 'nanoc':
                    focusChar = nanoc;
            }

            if (pigSection) {
                game.defaultCamZoom = 0.9;

                FlxTween.tween(game.dad, {alpha : 0.75}, 0.5);
                FlxTween.tween(game.boyfriend, {alpha : 0.75}, 0.5);
            }
            else {
                game.defaultCamZoom = 0.7;

                FlxTween.tween(game.dad, {alpha : 1}, 0.5);
                FlxTween.tween(game.boyfriend, {alpha : 1}, 0.5);

                game.opponentCameraOffset = [0, 0];
                game.boyfriendCameraOffset = [0, 0];
            }
            fakeMoveCamera(focusChar, pigSection);

        case 'Fella Change Health Bar':
            changeHealthBar(v1, v2);
        case 'Friends N Fellas Events':
            switch (v1)
            {
                case 'jump in':
                    var pigY:Float = game.gf.y;
                    var fagY:Float = nanoc.y; // pork faggot (the food)

                    game.gf.y -= 1000;
                    game.gf.alpha = 1;
                    nanoc.y -= 1000;
                    nanoc.alpha = 1;

                    FlxTween.tween(game.gf, {y : pigY}, 0.6, {ease: FlxEase.quadIn});
                    game.gf.playAnim('singUP');
                    FlxTween.tween(nanoc, {y : fagY}, 0.6, {ease: FlxEase.quadIn, startDelay: 0.3, onComplete: function(twn:FlxTween) { nanoc.playAnim('singDOWN'); }});
                    nanoc.playAnim('singUP');

                case 'fuse':
                    FlxTween.tween(white, {alpha : 1}, 0.3);
                    FlxTween.tween(nanoc, {x : nanoc.x + 200}, 0.3, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween) {
                        game.triggerEventNote('Change Character', 'gf', 'connoc');
                        game.gf.flipX = !game.gf.flipX;
                        FlxTween.tween(white, {alpha : 0}, 0.3);
                        nanoc.kill();
                    }});
            }
    }
}

function changeHealthBar(opp:String, player:String)
{
    game.iconP2.changeIcon(opp);
    game.iconP1.changeIcon(player);

    game.healthBar.createFilledBar(iconColours[opp], iconColours[player]);
    game.healthBar.updateBar();
}

function onUpdate(elapsed)
{   
    if (pigSection)
    {
        fakeMoveCamera(focusChar, pigSection);
    }
}

function fakeMoveCamera(char:Character, toggle:Bool)
{
    game.isCameraOnForcedPos = toggle;
    if (toggle)
    {
        var curCharacter:Character = char;
        if (game.camCurTarget != null) curCharacter = game.camCurTarget;

        var desiredPos = char.getMidpoint();

        if(curCharacter == nanoc)
        {
            desiredPos.x += 150 + char.cameraPosition[0] + game.opponentCameraOffset[0];
            desiredPos.y += -100 + char.cameraPosition[1] + game.opponentCameraOffset[1];
        }
        else if(curCharacter == game.gf)
        {
            desiredPos.x -= 150 + char.cameraPosition[0] + game.boyfriendCameraOffset[0];
            desiredPos.y += -100 + char.cameraPosition[1] + game.boyfriendCameraOffset[1];
        }

        var displacement:FlxPoint = curCharacter.returnDisplacePoint();

        game.camFollow.x = desiredPos.x + displacement.x;
        game.camFollow.y = desiredPos.y + displacement.y;

        displacement.put();
        desiredPos.put();

        game.whosTurn = char;
    }
}

function onEndSong()
{
    if (PlayState.isStoryMode)
    {    
        new FlxTimer().start(11.5, function(tmr:FlxTimer)
        {
            allowEnd = true;
            game.inCutscene = false;
            game.endSong();
        });
        
        if(!allowEnd)
        {
            FlxG.sound.play(Paths.sound('explosion'));
            game.inCutscene = true;
            game.camGame.alpha = 0;
            game.camHUD.alpha = 0;
            return Function_Stop;
        }
    }
}

function onGameOverStart() 
{
    setGameOverVideo("friendsnfellas_gameover");
}