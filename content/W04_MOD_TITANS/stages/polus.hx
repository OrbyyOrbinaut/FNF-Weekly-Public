addHaxeLibrary('FlxAxes', 'flixel.util');
addHaxeLibrary('FlxBackdrop', 'flixel.addons.display');
var ext:String = 'impostor/';
var sn:FlxBackdrop;
var crewmate:FlxSprite;
var reactorBeat:Bool = false;
var reactor:FlxSprite;
var played = 'impostor';

var sv:FlxSprite;
var wa:FlxSprite;
var bg:FlxSprite;

var witnesses:FlxSprite;
var polusBG:FlxSprite;
var office:FlxSprite;
var table:FlxSprite;
var shower:FlxSprite;
function onLoad() {
    // PlayState.instance.defaultCamZoom = 0.2;  
    shower = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
    shower.alpha = 0.001;
    shower.cameras = [game.camHUD];

    reactor = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.RED);
    reactor.alpha = 0.001;
    reactor.cameras = [game.camHUD];
    
    sv = new FlxSprite(-485.85, 76.5);
    sv.loadGraphic(Paths.image(ext + "stars"));
    sv.scrollFactor.set(0,0);
    sv.antialiasing = true;
    add(sv);

    wa = new FlxSprite(140.4, -250);
    wa.loadGraphic(Paths.image(ext + "walls"));
    wa.scrollFactor.set(0.9, 1);
    wa.antialiasing = true;

    bg = new FlxSprite(-465.85, 76.5);
    bg.loadGraphic(Paths.image(ext + "rocks"));
    bg.antialiasing = true;

    crewmate = new FlxSprite(1530,110);
    crewmate.frames = Paths.getSparrowAtlas(ext + 'johnson');
    crewmate.animation.addByPrefix('idle', '__Crew', 12, true);
    crewmate.animation.addByPrefix('die', '__DIE', 12, false);
    crewmate.animation.addByPrefix('walk', '__Walk', 12, true);
    crewmate.animation.play('walk');
    crewmate.offset.set(-1, 12);
    crewmate.antialiasing = true;
    
    polusBG = new FlxSprite(-100, -100).loadGraphic(Paths.image(ext + 'polusb'));
    polusBG.scrollFactor.set(0.7, 1);
    polusBG.antialiasing = true;
   
    office = new FlxSprite(-400, -80).loadGraphic(Paths.image(ext + 'office'));
    office.antialiasing = true;

    table = new FlxSprite(50, 330).loadGraphic(Paths.image(ext + 'table'));
    table.antialiasing = true;

    witnesses = new FlxSprite(-330,30);
    witnesses.frames = Paths.getSparrowAtlas(ext + 'witnesses (and johnson i guess)');
    witnesses.animation.addByPrefix('w', 'Symbol 4 instance 1', 12, true);
    witnesses.animation.play('w');
    witnesses.antialiasing = true;

    for(i in [polusBG, office, table, witnesses]) {
        i.alpha = 0.003;
    }

    for(i in [wa, bg, polusBG, office]) {
        i.scale.set(2,2);
        add(i);
    }
    table.scale.set(2,2);
    foreground.add(table);

    foreground.add(witnesses);
    add(crewmate);

    var over = new FlxSprite().loadGraphic(Paths.image(ext + 'cooloverlay'));
    over.alpha = 0.3;
    over.color = 0xFFD2FBFF;
    over.blend = BlendMode.ADD;
    over.cameras = [game.camHUD];  
    over.antialiasing = true;

    sn = new FlxBackdrop(Paths.image(ext + "snow"), -3, -3, true, true);
    sn.x = -200;
    sn.scale.set(4,4);
    sn.scrollFactor.set(0.5,0.5);
    sn.cameras = [game.camHUD];
    sn.antialiasing = true;
    add(sn);

    add(over);

    add(shower);
    add(reactor);
    /*
    var kadeEngineWatermark = new FlxText(4, FlxG.height, -1,
        'Mischief - HARD',
        16);
    kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
    kadeEngineWatermark.scrollFactor.set();
    kadeEngineWatermark.cameras = [game.camHUD];
    kadeEngineWatermark.y -= kadeEngineWatermark.height;
    add(kadeEngineWatermark);
    */
    trace("DICK");
}

function onEvent(eventName, value1, value2)
{
    switch (eventName) 
    {
        case 'impostorevents':
            switch(value1) {
                case 'killcheck':
                    if(game.health > 1) {
                        game.boyfriend.playAnim('dodge', true);
                        game.boyfriend.voicelining = true;
                        game.boyfriend.heyTimer = 0.4;
                        game.boyfriend.animation.finishCallback = function (){
                            game.boyfriend.voicelining = false;
                        }
                    } else {
                        played = 'bullet';
                        game.health = -2;
                    }
                case 'hi':
                    FlxTween.tween(crewmate, {x: 730},3, {
                        ease: FlxEase.quadInOut,
                        onComplete: function() {
                            crewmate.offset.set(0,0);
                            crewmate.animation.play('idle');
                        }
                    });
                case 'reactorOn':
                    reactorBeat = true;
                case 'reactorOff':
                    reactorBeat = false;
                case 'camthing':
                    game.triggerEventNote('Camera Follow Pos', '300', '100');
                case 'die':
                    game.triggerEventNote('Camera Follow Pos', '300', '100');
                    game.triggerEventNote('Play Animation', 'shoot', 'dad'); // this so lazy
                    crewmate.animation.play('die', true); // -1 ,12
                    crewmate.offset.set(148,85);
                case 'awkward':
                     game.cameraSpeed = 0.25;
                case 'meetingThing':
                    shower.alpha = 1;
                    game.cameraSpeed = 25;
                    game.defaultCamZoom = 1;
                    game.boyfriend.x += 100;
                    //game.boyfriend.y -= 50;
                    sn.alpha = 0.0001;
                    for(i in [bg, wa, crewmate]) { // leth is a Nice guy
                        i.alpha = 0.0003;
                    }
                    for(i in [polusBG, office, table, witnesses]) { // leth is a freak
                        i.alpha = 1;
                    }
                case 'weback':
                    game.cameraSpeed = 1;
                case 'inside': // ur moms butthole! OOOOOH! I am a master owner!
                    shower.alpha = 0;
                    game.cameraSpeed = 1;
                    
            }
    }
}

function onBeatHit()
{
    if(reactorBeat) {
        if(game.curBeat % 4 == 0) {
            reactor.alpha = 0.4;
            FlxTween.tween(reactor, {alpha: 0},1, {
                ease: FlxEase.linear,
            });
        }
    }
}
function onUpdatePost(elapsed) {
    sn.x -= 5 * 60 * elapsed;
    sn.y += 5 * 60 * elapsed;
    //if(sn.x <= -640) sn.x = 0;
    //if(sn.y >= 360 ) sn.y = 0;
}
function onCreatePost() {

    game.scoreTxt.color = 0xFFAD1919;
    
    game.snapCamFollowToPos(100, 75);
}
function onGameOverStart() 
    {
        setGameOverVideo(played);
    }
