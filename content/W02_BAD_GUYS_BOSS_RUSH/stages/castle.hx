var jr:FNFSprite;

function onLoad(){
    var bg = new FlxSprite(-155, -250).loadGraphic(Paths.image("bowser/bg"));
    bg.scale.set(1.2, 1.2);
    bg.updateHitbox();
    bg.scrollFactor.set(0.8, 0.8);
    add(bg);
    var walls = new FlxSprite(-185, 650).loadGraphic(Paths.image('bowser/walls'));
    walls.scrollFactor.set(0.9, 0.9);
    add(walls);
    jr = new FNFSprite(-800, 1200);
    jr.loadFromJson('bowserjr', true);
    jr.playAnim('idle', true);
    jr.scale.set(0.125, 0.125);
    jr.updateHitbox();
    add(jr);
    var floor = new FlxSprite(0, 375).loadGraphic(Paths.image('bowser/main_flopor'));
    add(floor);
}

function onCreatePost(){
    game.snapCamFollowToPos(2000, 1000);
    modManager.queueFuncOnce(896, (s,s2)->{ jrIntro(); });
    // game.camGame.setFilters([new ShaderFilter(newShader('ouch'))]);

}

var allowedToZ:Bool = true;
function onMoveCamera(){ if(allowedToZ){
    switch(game.whosTurn){
        case 'dad':
            game.defaultCamZoom = 0.55;
        case 'boyfriend':
            game.defaultCamZoom = 0.75;
    }
    FlxG.watch.addQuick("turn", game.whosTurn);
}}

var s:Float = 1;
var jrX:Float = -400;
var jrY:Float = 0;
function onUpdate(elapsed){
    s += elapsed;
    jr.x = FlxMath.lerp(jr.x, jrX + (Math.sin(s) * -100), CoolUtil.boundTo(1, 0, elapsed * 4));
    jr.y = FlxMath.lerp(jr.y, jrY + (Math.cos(s) * 100), CoolUtil.boundTo(1, 0, elapsed * 4));

    if(jr.animation.curAnim.finished && jr.animation.curAnim.name + '-loop' != null)
    {
        jr.playAnim(jr.animation.curAnim.name + '-loop', true);
    }
}

function onSongStart(){ jr.playAnim('idle', true); }

function jrIntro(){
    // jrY = 400;
    allowedToZ = false;
    game.defaultCamZoom = 0.5;
    game.isCameraOnForcedPos = true;
    game.camFollow.set(1700, 700);
    FlxTween.tween(jr.scale, {x: 1, y: 1}, 2, {startDelay: 0.5, ease: FlxEase.quadOut, onUpdate: (t)->{ jr.updateHitbox(); }});
    FlxTween.num(jrX, 1500, 3, {ease: FlxEase.backOut, onUpdate: (t)-> { jrX = t.value; }});
    FlxTween.num(jrY, 400, 3, {ease: FlxEase.backOut, onUpdate: (t)-> { jrY = t.value; }});
    // FlxTween.tween(jr, {x: 1500}, 3, {ease: FlxEase.backOut});
}

function onBeatHit(){
    if(jr.canResetIdle && game.curBeat % 2 == 0) jr.playAnim('idle', true);
}

function onSpawnNotePost(note){
    if(note.noteType == 'JR Note') note.noAnimation = true;
}

function opponentNoteHit(note){
    if(note.noteType == 'JR Note' ||  note.noteType == 'Duet'){
        jr.playAnim(game.singAnimations[note.noteData], true);
        jr.holdTimer = 0;
    } 
}

function goodNoteHit(note){
    if(note.noteType == 'Duet'){
        game.gf.playAnim(game.singAnimations[note.noteData], true);
        game.gf.holdTimer = 0;
    }
}

function onEvent(eventName, value1, value2){
    if(eventName == 'Bowser Triggers'){
        switch(value1){
            case 'JR Section':
                iconP2.changeIcon('bowserjr');
                allowedToZ = false;
                game.defaultCamZoom = 0.65;
                game.whosTurn = 'jr';
                game.isCameraOnForcedPos = true;
                game.camFollow.set(1700, 700);
            case 'End JR':
                game.isCameraOnForcedPos = false;
                allowedToZ = true;
            case 'Duet':
                game.isCameraOnForcedPos = true;
                game.camFollow.set(1865, 900);
                game.defaultCamZoom = 0.5;
            case 'Duet Off':
                game.isCameraOnForcedPos = false;
            case 'Bowser Duet Icons':
                iconP2.changeIcon('koopa-duet');
            case 'Bowser Icon':
            iconP2.changeIcon(game.dad.healthIcon);
        }
    }
}

function onGameOverStart() 
    {
        setGameOverVideo("bowsergameover");
    }