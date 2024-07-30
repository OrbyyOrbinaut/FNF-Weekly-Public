var loaded=false;
var fakeP1:HealthIcon;
var ba:FlxSprite;
var p:Float;
var shower:FlxSprite;
var ttt:FlxSprite;
var cutscene:PsychVideoSprite;
var bg:FlxSprite;

var ga:FlxText;
var ha:FlxText;
var poppedPegs = false;

var pls:FlxTypedGroup<FlxSprite>;
var redPegs = 25;
var ogComboOffset:Array<Int> = [0, 0, 0, 0];

function onDestroy() {
    ClientPrefs.comboOffset[0] =  ogComboOffset[0];
	ClientPrefs.comboOffset[1] =  ogComboOffset[1];
    ClientPrefs.comboOffset[2] =  ogComboOffset[2];
	ClientPrefs.comboOffset[3] =  ogComboOffset[3];
}

function onLoad() {
    game.skipCountdown = true;



    var b = new FlxSprite(0, 0);
    b.loadGraphic(Paths.image("peggle/katiscrackedbro"));
	add(b);

    bg = new FlxSprite(0, 0);
    bg.loadGraphic(Paths.image("peggle/susPegle"));
	foreground.add(bg);

    ba = new FlxSprite(0, 562);
    ba.loadGraphic(Paths.image("peggle/basket"));
    ba.scale.set(1.2,1.2);
    ba.updateHitbox();
    foreground.add(ba);

    ttt= new FlxSprite(249,300);
    ttt.scrollFactor.set(0,0);
    ttt.loadGraphic(Paths.image('peggle/title'));
    ttt.cameras = [game.camOther];
   
    ttt.alpha = 0;
    foreground.add(ttt);

    /*
    var helpText:FlxText = new FlxText(0,0,1280,'Only way of gaining health is by Opponent notes');
    helpText.cameras = [game.camHUD];
    helpText.screenCenter();
    add(helpText);*/



    shower = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);


  

    var pegCount = 70;

    
    //pls = new FlxTypedGroup<FlxSprite>();

    for(i in 0...pegCount) {
        var pegp = 'blue';
        if(redPegs>0)  { pegp = 'red'; redPegs--; }
        var peg:FlxSprite = new FlxSprite(FlxG.random.int(100, 700), FlxG.random.int(200, 500));
        peg.loadGraphic(Paths.image('peggle/' + pegp + 'Peg'));
        peg.ID = [i, pegp];
        add(peg);
    }

    var ball = new FlxSprite(500, 500);
    ball.loadGraphic(Paths.image('peggle/ball'));
    add(ball);

    ga = new FlxText(300,3,-1,'whwer', 16);
    ga.color = 0xFF65F5F9;
   
    foreground.add(ga);

    ha = new FlxText(700,13,-1,'whener', 16);
    ha.color = 0xFF65F5F9;
   
    foreground.add(ha);
    // ga.setFormat(Paths.font("liberbold.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
   
    PlayState.instance.healthGain = 0;


    foreground.add(shower);

   
    trace("DICK");

    ogComboOffset[0] = ClientPrefs.comboOffset[0];
    ogComboOffset[1] = ClientPrefs.comboOffset[1];
    ogComboOffset[2] = ClientPrefs.comboOffset[2];
    ogComboOffset[3] = ClientPrefs.comboOffset[3];
}

function onCreatePost() {
    // Wow.
    healthBarBG.alpha = 0;
    healthBar.alpha = 0;

    
    healthBar.angle = 90; healthBar.setPosition(-80,400); healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
    //timeBar.y = -900;
    timeBar.y = -999;
    for(i in [game.dad, game.iconP1, game.iconP2, game.scoreTxt, game.timeTxt, game.timeBarBG]) {
        i.visible = false;
    }
    for (i in 0...game.opponentStrums.members.length) {
		game.opponentStrums.members[i].visible = false;
	}
    

    



}
function opponentNoteHit() {
    game.health+=0.03;
}
function onGameOverStart() 
{
    setGameOverVideo('bfdeath');
}

function onUpdate(elapsed){
    game.camZooming = false;
    ha.text = game.songScore;
    ha.x = 670 - ha.width;

    ga.text = Math.fround(game.ratingPercent * 100) + '%\n' + game.songMisses;
    ga.x = 300 - ga.width;
    //FlxG.camera.zoom = 1.2;
    //camHUD.zoom = 1;
   
    p++;//FlxG.elapsed;
    ba.x = 300 + (Math.sin(p/50 / (FlxG.updateFramerate / 60)) * 180);
}
function goodNoteHit(note) {
    if(note.isSustainNote) return;
    var n = boyfriend.animation.curAnim.name;
    if(n == 'singLEFT' && boyfriend.scale.x == -1) {
        boyfriend.playAnim('turn', true);
        boyfriend.specialAnim = true;
        boyfriend.scale.x = 1;
        boyfriend.updateHitbox();
        boyfriend.heyTimer = 0.05;
        new FlxTimer().start(0.05, function(tmr:FlxTimer)
            {
                onComplete: function() {
                    if(boyfriend.animation.curAnim.name == 'turn')
                    boyfriend.playAnim('singLEFT', true);
                }
            });
    }
    if(n == 'singRIGHT' && boyfriend.scale.x == 1) {
        boyfriend.scale.x = -1;
        boyfriend.updateHitbox();
        boyfriend.playAnim('turn', true);
        boyfriend.specialAnim = true;
        boyfriend.heyTimer = 0.05;
        new FlxTimer().start(0.05, function(tmr:FlxTimer)
            {
                onComplete: function() {
                    if(boyfriend.animation.curAnim.name == 'turn')
                    boyfriend.playAnim('singRIGHT', true);
                }
            });
    }
}
function onSpawnNotePost(note:Note)
    {
        note.visible = note.mustPress;
    }
function onBeatHit() {
    switch(game.curBeat) {
        // You gonna make me cry
        case 1:
            
        game.triggerEventNote('Camera Follow Pos', 395, 300);
        FlxTween.tween(healthBar, {alpha: 1},1, {
            ease: FlxEase.linear
        });
        FlxTween.tween(healthBarBG, {alpha: 1},1, {
            ease: FlxEase.linear
        });
        FlxTween.tween(shower, {alpha: 0},1, {
            ease: FlxEase.linear,
            onComplete: function(twn:FlxTween) {
                remove(shower);
            }
        });
        FlxTween.tween(ttt, {alpha: 1},1, {
            ease: FlxEase.linear
        });

        case 4:
            FlxTween.tween(ttt, {alpha: 0},1, {
                ease: FlxEase.linear,
                onComplete: function(twn:FlxTween) {
                    remove(ttt);
                }
            });
    }
}