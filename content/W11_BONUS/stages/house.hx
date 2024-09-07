addHaxeLibrary('FlxFlicker', 'flixel.effects'); // This lets me do the flicker thing.
var jumpScare:FlxSprite;
var jumpScare2:FlxSprite;
var boner:FlxSprite;
var darnellbg:FlxSprite;
var scoreText:FlxText;
var boy:FlxSprite;
var retro:Bool;
var fakeIcon:FlxSprite;
var freeze:FlxSprite;

function onLoad() 
{
    retro = false;
    // Stage
    var bg:FlxSprite = new FlxSprite(300, 300);
    bg.loadGraphic(Paths.image("background"));
    bg.setGraphicSize(1000 * 2, 562 * 2);
    add(bg);


    darnellbg = new FlxSprite(-1500, -850);
    darnellbg.loadGraphic(Paths.image("weekend1"));
    darnellbg.antialiasing = true;
    darnellbg.scale.set(0.5, 0.5);
    darnellbg.visible = false;
    add(darnellbg);

    boy = new FlxSprite(600, 360);
    boy.frames = Paths.getSparrowAtlas("awkward");
    boy.animation.addByPrefix('pop', 'interupt', 12, false);
    boy.alpha = 0.0001;
    add(boy);

    jumpScare = new FlxSprite(0, 0).loadGraphic(Paths.image("ahh"));
    jumpScare2 = new FlxSprite(0, 0).loadGraphic(Paths.image("goldenahh"));
    for(i in [jumpScare, jumpScare2]) {
        i.alpha = 0.001;
        i.setGraphicSize(i.width*2);
        i.updateHitbox();
        i.cameras = [game.camHUD];
        add(i);
    }
    freeze = new FlxSprite(0, 0).loadGraphic(Paths.image("FREEZE!"));
    freeze.cameras = [game.camHUD];
    freeze.blend = BlendMode.LAYER;
    freeze.alpha = 0.001;
    add(freeze);
}

function onUpdatePost(elapsed) {
    fakeIcon.x = game.iconP1.x;
    if(retro)
    scoreText.text = 'Score:' + game.songScore;
}
function onCreatePost()
{
    boner = new FlxSprite(400, 300).loadGraphic(Paths.image("boner"));
    foreground.add(boner);
    boner.origin.set(0,boner.height);
    boner.alpha = 0.0001;

    scoreText = new FlxText(healthBarBG.x + healthBarBG.width - 190, healthBarBG.y + 30, 0, 'Score:0', 20);
    scoreText.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, 0xFF000000);
    scoreText.scrollFactor.set();
    scoreText.cameras = [game.camHUD];
    scoreText.alpha = 0.0001;
    add(scoreText);

    fakeIcon = new FlxSprite(0,1000).loadGraphic(Paths.image('tinybf'));
    fakeIcon.cameras = [game.camOther];
    add(fakeIcon);

    game.snapCamFollowToPos(700, 500);
    game.gf.flipX = false; 
}

function onBeatHit()
    {
        var targetRotate:Int = game.curBeat / 2;
        if (game.curBeat % 2 == 0) {
            targetRotate *= -1;
        }
    
        FlxTween.angle(game.iconP1, targetRotate, 0, 0.3, {ease: FlxEase.quadOut});
        FlxTween.angle(game.iconP2, targetRotate, 0, 0.3, {ease: FlxEase.quadOut});
    }

function onEvent(eventName, value1, value2)
{
    if (eventName == 'goo shit') 
    {
        switch(value1)
        {
            case 'ahh':
                jumpScare.alpha = 1;
                FlxTween.tween(jumpScare, {alpha: 0}, 1, {ease: FlxEase.linear}); 
            case 'ahh2':
                jumpScare2.alpha = 1;
                FlxTween.tween(jumpScare2, {alpha: 0}, 2, {ease: FlxEase.linear}); 
            case 'freeze':
                switch(value2) {
                    case 'a':
                        game.camGame.flash(0xAAFFFF, 3.0);
                        freeze.alpha = 1;
                    case 'b':
                        FlxTween.tween(freeze, {alpha: 0}, 3, {ease: FlxEase.linear});   
                }
            case 'retro':
                switch(value2) {             
                    case "on":
                        scoreTxt.visible = false;
                        scoreText.alpha = 1;
                        healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
                        FlxTween.tween(game, {health: 1}, 1, {ease: FlxEase.bounceOut});   
                        retro = true;
                    case "off":
                        scoreTxt.visible = true;
                        scoreText.alpha = 0;
                        game.reloadHealthBarColors();
                        retro = false;
                }
                game.updateScoreBar();
            case 'bf':
                switch(value2) {
                    case '0':
                        //game.iconP1.x, game.iconP1.y
                        FlxTween.tween(game.gf, {x: 550}, 1, {ease: FlxEase.sineOut});  
                        FlxTween.tween(fakeIcon, {y: game.iconP1.y}, 1, {ease: FlxEase.sineOut});  
                    case '1':
                        game.gf.alpha = 0.0001;
                        boy.alpha = 1;
                        boy.animation.play('pop');
                        FlxTween.tween(boy, {alpha: 0}, 19, {ease: FlxEase.linear});  
                        fakeIcon.alpha = 0.001;
                }
            case 'boner':
                switch(value2) {
                    default:
                        boner.alpha = 0.0001;
                    case 'hey':
                        boner.alpha = 1;
                        boner.scale.set(0,0);
                        FlxTween.tween(boner.scale, {x:1,y:1},2, {
                            ease: FlxEase.bounceOut
                        });
                }
            case 'weekend 1 bg':
                switch(value2)
                {
                    case 'on':
                        darnellbg.visible = true;
                    case 'off':
                        darnellbg.visible = false;
                }
        }
    }
}