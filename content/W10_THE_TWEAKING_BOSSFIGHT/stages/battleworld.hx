var spiderman:Character;
var rainIntensity:Float = 0.15;
var rainShader; // ty base game
var rainTime:Float = 0;
var forceSection:Bool = false;
var focusChar:Character = null;
var black:FlxSprite;
var white:FlxSprite;
var intro:PsychVideoSprite;
var ending:PsychVideoSprite;
var zero:FlxSprite;
var shaggysil;
var guestsil;
var gokusil;
var spideysil;
var lighting:FlxSprite;
var lightningActive:Bool = false;
var lightningTimer:Float = 3.0;
var cameoFG:FlxSprite;
var cameoDistant:FlxSprite;
var cameoList:Array<String> = ['ducks', 'eight', 'madeline', 'makoto', 'mario', 'pants'];
var light:FlxSprite;

//Shit for the extra chart
var extraChart:SwagSong = null;
var extraChartAnims:Array<FNFSprite.CrowdAnim> = []; // For guest 666 and either goku or spiderman during the second half of the song

function onLoad()
{
    game.skipCountdown = true;

    game.precacheList.set('tenkaichi/cameos/ducks', 'image');
    game.precacheList.set('tenkaichi/cameos/eight', 'image');
    game.precacheList.set('tenkaichi/cameos/madeline', 'image');
    game.precacheList.set('tenkaichi/cameos/makoto', 'image');
    game.precacheList.set('tenkaichi/cameos/mario', 'image');
    game.precacheList.set('tenkaichi/cameos/pants', 'image');

    var sky = new FlxSprite(-675, -800).loadGraphic(Paths.image('tenkaichi/sky'));
    sky.antialiasing = ClientPrefs.globalAntialiasing;
    sky.scrollFactor.set(0.5, 0.5);
    add(sky);

    // i will be killing orbyy
    lightning = new FlxSprite(-400, -750);
    lightning.frames = Paths.getSparrowAtlas('tenkaichi/lightning');
    lightning.animation.addByPrefix('strike', 'lightning0', 24, false);
    lightning.antialiasing = ClientPrefs.globalAntialiasing;
    lightning.blend = BlendMode.ADD;
    lightning.scrollFactor.set(0.5, 0.5);
    lightning.scale.set(3, 3);
    add(lightning);
    lightning.animation.play('strike');

    var city = new FlxSprite(-675, -1000).loadGraphic(Paths.image('tenkaichi/city'));
    city.antialiasing = ClientPrefs.globalAntialiasing;
    city.scrollFactor.set(0.75, 0.75);
    add(city);

    cameoDistant = new FlxSprite(2800, -600).loadGraphic(Paths.image('tenkaichi/cameos/eight'));
    cameoDistant.antialiasing = false;
    cameoDistant.scrollFactor.set(0.8, 0.8);
    add(cameoDistant);

    zero = new FlxSprite(-400, -400).loadGraphic(Paths.image('tenkaichi/cameos/zero'));
    zero.antialiasing = ClientPrefs.globalAntialiasing;
    zero.scrollFactor.set(0.9, 0.9);
    add(zero);

    var floor = new FlxSprite(-575, -772).loadGraphic(Paths.image('tenkaichi/floor'));
    floor.antialiasing = ClientPrefs.globalAntialiasing;
    add(floor);

    light = new FlxSprite(-1000, -1000).makeGraphic(5000, 4000, FlxColor.WHITE);
    light.blend = BlendMode.ADD;
    light.alpha = 0.001;
    add(light);

    cameoFG = new FlxSprite(-1800, 300).loadGraphic(Paths.image('tenkaichi/cameos/pants'));
    cameoFG.antialiasing = false;
    cameoFG.scrollFactor.set(1.1, 1.1);
    foreground.add(cameoFG);

    rainShader = newShader('rain');
    rainShader.setFloatArray('uScreenResolution', [FlxG.width, FlxG.height]);
    rainShader.setFloat('uTime', 0);
    rainShader.setFloat('uScale', FlxG.height / 200);
    rainShader.setFloat('uIntensity', rainIntensity);
    ExUtils.addShader(rainShader, game.camGame);

    white = new FlxSprite(-600, -400).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.WHITE);
    white.alpha = 0;
    white.scrollFactor.set(0, 0);
    add(white);

    black = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    black.cameras = [game.camOther];
    //black.alpha = 0;
    add(black);

    extraChart = Song.loadFromJson('tenkaichi-battleworld' + '-extra', "tenkaichi-battleworld");
}

function onCreatePost(){
    game.snapCamFollowToPos(710, 175);

    spiderman = new Character(1900, 225, 'spiderman', false);
    spiderman.flipX = false;

    remove(game.gfGroup);
    insert(members.indexOf(game.boyfriendGroup), game.gfGroup);
    insert(members.indexOf(foreground), spiderman);
    game.gf.scrollFactor.set(1,1);

    intro = new PsychVideoSprite();
    intro.addCallback('onFormat',()->{
        intro.cameras = [game.camOther];
        intro.setGraphicSize(FlxG.width);
        intro.screenCenter();
    });
    intro.addCallback('onEnd',()->{
        game.camGame.alpha = 1;
        game.camHUD.alpha = 1;
        game.camGame.flash(0xFFFFFFFF, 1.0);
        intro.kill();
        black.alpha = 0;
        lightningActive = true;
    });
    intro.load(Paths.video('tenkaichi_intro'), [PsychVideoSprite.muted]);
    intro.antialiasing = true;
    add(intro);

    ending = new PsychVideoSprite();
    ending.addCallback('onFormat',()->{
        ending.cameras = [game.camOther];
        ending.setGraphicSize(FlxG.width);
        ending.screenCenter();
    });
    ending.load(Paths.video('tenkaichi_end'), [PsychVideoSprite.muted]);
    ending.antialiasing = true;
    ending.pauseOverride = true;
    add(ending);

    if(extraChart != null){
        for(section in extraChart.notes){
            for(note in section.sectionNotes){
                extraChartAnims.push({
                    time: note[0],
                    data: note[1],
                    length: note[2]
                });    
            }
        }
    }
}

function onSongStart()
{
    intro.play();
    ending.play(); // HOPEFULLY this prevents desyncs
    ending.pause();
    ending.visible = false; // Justtt incase
    game.camGame.alpha = 0;
}

var s:Float = 1;
var shaggyY:Float = -325;
var gokuY:Float = -275;
var zeroY:Float = -400;
function onUpdate(elapsed:Float)
{
    s += elapsed;
    rainTime += elapsed;
    
    rainShader.setFloatArray('uCameraBounds', [game.camGame.scroll.x + game.camGame.viewMarginX, game.camGame.scroll.y + game.camGame.viewMarginY, game.camGame.scroll.x + game.camGame.viewMarginX + game.camGame.width, game.camGame.scroll.y + game.camGame.viewMarginY + game.camGame.height]);
    rainShader.setFloat('uTime', rainTime);
    rainShader.setFloat('uIntensity', rainIntensity);
    game.dadGroup.y = FlxMath.lerp(game.dadGroup.y, shaggyY + (Math.cos(s) * 65), CoolUtil.boundTo(1, 0, elapsed * 4));
    game.boyfriendGroup.y = FlxMath.lerp(game.boyfriendGroup.y, gokuY + (Math.cos(s) * 65), CoolUtil.boundTo(1, 0, elapsed * 4));
    zero.y = FlxMath.lerp(zero.y, zeroY + (Math.cos(s - 5) * 45), CoolUtil.boundTo(1, 0, elapsed * 4));

    if (forceSection)
    {
        fakeMoveCamera(focusChar, forceSection);
    }

    for(anim in extraChartAnims){
        if(anim.time <= Conductor.songPosition){
            var animToPlay:String = game.singAnimations[anim.data % 4];
            var char:Character;
            if (anim.data > 3)
            {
                if(forceSection)
                {
                    char = game.boyfriend;
                }
                else
                {
                    char = spiderman;
                }
            }
            else
            {
                char = game.gf;
            }
            char.holdTimer = 0;
            char.playAnim(animToPlay, true);
            var holdingTime = Conductor.songPosition - anim.time;
            if(anim.length == 0 || anim.length < holdingTime)
            extraChartAnims.remove(anim);
        }
	}

    if (lightningActive)
    {
        lightningTimer -= elapsed;
        if (lightningTimer < 0) {
            strikeLightning();
            lightningTimer = FlxG.random.float(10, 20);
        }
    }
}

function onEvent(name, v1, v2) 
{
    if (name == 'Tenkaichi Events')
    {
        switch (v1) 
        {
            case 'force section':
                switch (v2) 
                {
                    case 'spidey':
                        focusChar = spiderman;
                        forceSection = true;
                    case '666':
                        focusChar = game.gf;
                        forceSection = true;
                    case 'off':
                        forceSection = false;
                    default:
                        forceSection = false;
                }
                fakeMoveCamera(focusChar, forceSection);
            case 'cameo':  
                var cameoNum:Int = 0;
                cameoNum = FlxG.random.int(0, cameoList.length - 1);
                spawnCameo(cameoNum);
                trace(cameoNum);
            case 'emotional':
                ExUtils.removeShader(rainShader, game.camGame);
                lightningActive = false;

                shaggysil = newShader('silhouette');
                shaggysil.setFloatArray('col', [73 / 255, 179 / 255, 84 / 255]);
                shaggysil.setFloat('amount', 1);

                guestsil = newShader('silhouette');
                guestsil.setFloatArray('col', [175 / 255, 6 / 255, 46 / 255]);
                guestsil.setFloat('amount', 1);

                gokusil = newShader('silhouette');
                gokusil.setFloatArray('col', [59 / 255, 177 / 255, 255 / 255]);
                gokusil.setFloat('amount', 1);

                spideysil = newShader('silhouette');
                spideysil.setFloatArray('col', [0 / 255, 0 / 255, 0 / 255]);
                spideysil.setFloat('amount', 1);

                game.dad.shader = shaggysil;
                game.gf.shader = guestsil;
                game.boyfriend.shader = gokusil;
                spiderman.shader = spideysil;

                black.alpha = 1;
                white.alpha = 1;
                game.defaultCamZoom = 0.6;
                new FlxTimer().start(0.75, ()->{
                    FlxTween.tween(black, {alpha: 0}, 1);
                });
            case 'emotional stop':
                ExUtils.addShader(rainShader, game.camGame);
                lightningActive = true;
                game.camGame.flash(0xFFFFFFFF, 1.0);
                game.defaultCamZoom = 0.45;
                game.dad.shader = null;
                game.gf.shader = null;
                game.boyfriend.shader = null;
                spiderman.shader = null;
                white.alpha = 0;
            case 'ending':
                lightningActive = false;
                ending.restart([PsychVideoSprite.muted]);
                ending.visible = true;
                ending.pauseOverride = false;
                game.camHUD.alpha = 0;
                black.alpha = 1;
                game.vocals.volume = 1;
        }
    }
}

function onSpawnNotePost(note:Note)
{
    if (note.noteType == 'Spidey Note') note.noAnimation = true;
}

function goodNoteHit(note:Note)
{
    if (note.noteType == 'Spidey Note')
    {
        spiderman.playAnim(game.singAnimations[note.noteData % 4], true);
        spiderman.holdTimer = 0;
    }
}

function opponentNoteHit(note){
    if(note.noteType == 'Duet'){
        game.gf.playAnim(game.singAnimations[note.noteData], true);
        game.gf.holdTimer = 0;
    }
}


function onBeatHit()
{
    if (curBeat % spiderman.danceEveryNumBeats == 0) {
        var anim:String = spiderman.animation.curAnim.name;
        if (anim == 'idle') spiderman.dance();
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
        if(curCharacter == spiderman)
        {
            desiredPos.x -= 150 + char.cameraPosition[0] + 125;
            desiredPos.y += -100 + char.cameraPosition[1] - 75;
        }
        else if(curCharacter == game.gf)
        {
            desiredPos.x += 150 + char.cameraPosition[0] + 350;
            desiredPos.y += -100 + char.cameraPosition[1] - 175;
        }

        var displacement:FlxPoint = curCharacter.returnDisplacePoint();

        game.camFollow.x = desiredPos.x + displacement.x;
        game.camFollow.y = desiredPos.y + displacement.y;

        displacement.put();
        desiredPos.put();

        whosTurn = char;
    }
}

function spawnCameo(cameo:Int)
{
    var isBG:Bool = false;
    var cameoRemove:String = cameoList[cameo]; //Removes a cameo from the pool so there are no duplicates

    switch (cameoList[cameo])
    {
        case 'ducks':
            isBG = true;
            cameoDistant.loadGraphic(Paths.image('tenkaichi/cameos/ducks'));
        case 'eight':
            isBG = true;
            cameoDistant.loadGraphic(Paths.image('tenkaichi/cameos/eight'));
        case 'pants':
            isBG = false;
            cameoFG.loadGraphic(Paths.image('tenkaichi/cameos/pants'));
        case 'mario':
            isBG = true;
            cameoDistant.loadGraphic(Paths.image('tenkaichi/cameos/mario'));
        case 'makoto':
            isBG = false;
            cameoFG.loadGraphic(Paths.image('tenkaichi/cameos/makoto'));
        case 'madeline':
            isBG = false;
            cameoFG.loadGraphic(Paths.image('tenkaichi/cameos/madeline'));
    }
    cameoList.remove(cameoRemove);

    if(isBG)
    {
        cameoDistant.x = 2800;
        FlxTween.tween(cameoDistant, {x: -2000}, 10, {ease: FlxEase.linear});
    }
    else
    {
        cameoFG.x = -1800;
        FlxTween.tween(cameoFG, {x: 3500}, 7.5, {ease: FlxEase.linear});
    }
}

function strikeLightning():Void
{
    if (!ClientPrefs.flashing) return;

    lightning.x = FlxG.random.float(-500, 1900);
    lightning.animation.play('strike');

    FlxTween.color(game.boyfriend, 1.5, 0xFF606060, 0xFFFFFFFF);
    FlxTween.color(game.dad, 1.5, 0xFF606060, 0xFFFFFFFF);
    FlxTween.color(game.gf, 1.5, 0xFF606060, 0xFFFFFFFF);
    FlxTween.color(spiderman, 1.5, 0xFF606060, 0xFFFFFFFF);
    FlxTween.color(cameoFG, 1.5, 0xFF606060, 0xFFFFFFFF);
    light.alpha = 0.3;
    FlxTween.tween(light, {alpha: 0.001}, 1.5);

    FlxG.sound.play(Paths.soundRandom('Lightning', 1, 3), 1.0);
}

function onGameOverStart() 
{
    setGameOverVideo("tenkaichi_gameover");
}

function onDestroy() {
    if (intro != null) intro.destroy();
    if (ending != null) ending.destroy();
}