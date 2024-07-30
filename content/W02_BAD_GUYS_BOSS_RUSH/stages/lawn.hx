addHaxeLibrary('FlxStringUtil', 'flixel.util'); // This lets me do the money thing.
addHaxeLibrary('FlxFlicker', 'flixel.effects'); // This lets me do the flicker thing.

var helpText:FlxText;
var pea:FlxSprite;
var helpText2:FlxText;
var helpText3:FlxText;

var sun:BGSprite;
var sunPressed:Bool = false;
var arm:FlxSprite;

// Peashooter offsets.
var snoutAt = [70, 17];
var isZombieAlive = true;
var sunCount:Int = 50;


function onDestroy() {
    FlxG.camera.bgColor = 0xFF000000;
    FlxG.mouse.visible = false;
}
function onLoad() {
    FlxG.camera.bgColor = 0xFF2acafd;
    var bg:FlxSprite = new FlxSprite(-450, -200);
    bg.loadGraphic(Paths.image("brains/day"));
    bg.scrollFactor.set(1, 1);
	add(bg); 


    

    var lbg:FlxSprite = new FlxSprite(-300, -200);
    lbg.loadGraphic(Paths.image("brains/BIGLIGHT"));
    lbg.scrollFactor.set(1, 1);
    lbg.scale.set(2, 2);
    lbg.updateHitbox();
    //lbg.color = 0xFF000000;
    lbg.alpha = 0.2;
    lbg.blend = BlendMode.ADD;
	foreground.add(lbg); 

    sun = new BGSprite('brains/sun', 550, -300, 1, 1, ['sunSprite'], true);
    foreground.add(sun);


    
    var dod = ClientPrefs.downScroll ? FlxG.height-50 : 15;
    helpText = new FlxText(290,dod,-1,'You',24);    
    helpText2 = new FlxText(230+FlxG.width/2,dod,-1,'The Zombie',24);    
    //helpText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    // helpText.color = 0xFF3AFF6C;
    // helpText2.color = 0xFF4C8366;

    for(i in [helpText, helpText2]) {
        i.setFormat(Paths.font("pvz.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
        i.cameras = [game.camHUD];
        i.borderSize = 2;
        i.color = 0xFFD7C26A;
         add(i);
    }
}

function noteMiss(daNote) {
    FlxG.sound.play(Paths.sound("chew" + FlxG.random.int(1,2)));
}
function onEvent(eventName, value1, value2)
{
    switch (eventName) 
    {
        case 'today zombie lost his arm':
            dad.playAnim('idle-alt', true);
            arm.alpha = 1;
            arm.animation.play('pop');
            FlxTween.tween(sun, {y: 100},3, {
                ease: FlxEase.linear
            });
        case 'DIE!':
            isZombieAlive = false;
            game.dad.playAnim('die', true);
            game.triggerEventNote('Alt Idle Animation', '-dead');
            game.dad.animation.finishCallback = function (){
                FlxFlicker.flicker(game.dad, 1, 0.1, false);
            }
            //
            game.defaultCamZoom = 1.5;
            
            
        case 'peashoot':
            game.boyfriend.playAnim('singRIGHT', true);
            pea.alpha = 1;
            pea.setPosition(game.BF_X+snoutAt[0], game.BF_Y+snoutAt[1]);
           
            FlxTween.tween(pea, {x: game.dad.x},0.5, {
                ease: FlxEase.linear,
                onComplete: function() {
                    game.health+=0.03;
                    pea.alpha = 0.0000001;
                }
            });
    }
}

function onUpdatePost(elapsed) {
    arm.x = game.dad.x - 30;
    var pop = FlxStringUtil.formatMoney(game.songScore, false, true);
    game.scoreTxt.text = 'Combo: ' + game.combo + ' - Score: ' + pop + ' - Sun: ' + sunCount + (game.ratingFC != '' ? (' (' + game.ratingFC + ')') : '');
    game.scoreTxt.x = game.healthBar.x - game.scoreTxt.width - 10;

    if(FlxG.mouse.overlaps(sun)){
        if(FlxG.mouse.justPressed && !sunPressed) {
            sunPressed = true;
            sunCount += 25;
            FlxG.sound.play(Paths.sound("sunSound"));
            FlxTween.tween(sun, {alpha: 0},1, {
                ease: FlxEase.circOut
            });
        }
    }

    if(isZombieAlive) {
        // Why the fuck... did startswith not work
        if (mustHitSection && (dad.animation.curAnim.name == 'idle'  || dad.animation.curAnim.name == 'idle-alt')) {
            game.dad.x -= 0.25 * 60 * elapsed;
        }
    }
}

function onCreatePost()
{

    arm = new FlxSprite(game.DAD_X-100, game.DAD_Y+100);
    arm.frames = Paths.getSparrowAtlas("brains/zombiehandImSoSorryForNotTweeningThisLikeANormalPerson3");
    arm.animation.addByPrefix('pop', 'ArmPop', 12, false);
    arm.animation.play('pop');
    arm.alpha = 0.0001;
    arm.scrollFactor.set(1,1);
    add(arm);

    // This is how I flip the healthbar. healthBarSide is for the health icons moving.
    game.healthBar.angle = 180;
    game.healthBarSide = 1;
    game.iconP1.flipX = true;

    timeBar.y = -999;
    timeTxt.y = -999;
    game.scoreAllowedToBop = false;
    // Everything beside this point is Brawh.
    game.scoreTxt.font = Paths.font('pvz.ttf');
    game.scoreTxt.color = 0xFFD7C26A;
    game.scoreTxt.borderSize = 2;
    game.scoreTxt.alignment = FlxTextAlign.RIGHT;
    game.divider = '-';
    game.healthBar.x += 250;

    var dod2 = ClientPrefs.downScroll ? -10 : 10;
    game.healthBar.y += dod2*3;
    game.iconP1.y += dod2*3;
    game.iconP2.y += dod2*3;
    if(!ClientPrefs.downScroll) game.scoreTxt.y-=10; else
    game.scoreTxt.y = (game.healthBar.y + dod2);
    //game.healthBarBG.loadGraphic(Paths.image('brains/healthBar'));
    


    game.updateScoreBar();
    
    FlxG.sound.play(Paths.sound("pvz-siren"));
    
    FlxTween.tween(dad, {x: 900},2.5, {
        ease: FlxEase.circOut
    });

    //game.isCameraOnForcedPos = true;
    game.snapCamFollowToPos(550, 190);
    FlxG.camera.zoom = 2;
    game.showRating = false;
    game.showCombo = false;
    
    game.camHUD.alpha = 0.001;
    helpText3 = new FlxText(50, 50, -1, 'Your Front Lawn');
    helpText3.setFormat(Paths.font("pvz2.ttf"), 48, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
    helpText3.scrollFactor.set(0,0);
    helpText3.screenCenter();
    helpText3.borderSize = 2;
    helpText3.y+=150;
    foreground.add(helpText3);
    new FlxTimer().start(1, function(tmr:FlxTimer)
        {
            game.cameraSpeed = 0.2;
            FlxTween.tween(FlxG.camera, {zoom: game.defaultCamZoom},2, {
                ease: FlxEase.sineOut
            });
            FlxTween.tween(helpText3, {y: helpText3.y+50},2, {
                ease: FlxEase.sineInOut
            });
            FlxTween.tween(game.camHUD, {alpha: 1},2, {
                ease: FlxEase.sineInOut
            });
        });
    
    pea = new FlxSprite(game.BF_X+snoutAt[0], game.BF_Y+snoutAt[1]);
    pea.loadGraphic(Paths.image("brains/pea"));
    foreground.add(pea);
    pea.alpha = 0.0000001;
}

function onSongStart() {
    game.isCameraOnForcedPos = false;
    game.cameraSpeed = 0.3;
    FlxTween.tween(helpText3, {alpha: 0},1, {
        ease: FlxEase.linear
    });

    FlxTween.tween(helpText, {alpha: 0},4, {
        ease: FlxEase.linear
    });
    FlxTween.tween(helpText2, {alpha: 0},4, {
        ease: FlxEase.linear
    });
    FlxG.mouse.visible = true;
}

function onSpawnNotePost(note:Note)
{
    modManager.setValue("opponentSwap", 1.0);
}

function onGameOverStart() 
{    

    // DONT USE THIS VIDEO SCRIPT, TAKE FROM ANY OTHER SONG
    var vid = isZombieAlive ? 'pvzzombie' : 'peashooter';
    // Video on Death
    FlxG.camera.bgColor = 0xFF000000;
    setGameOverVideo(vid);
}    