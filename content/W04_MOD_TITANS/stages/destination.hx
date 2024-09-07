var matt:FNFSprite;
var zard:FNFSprite;
var pico:FNFSprite;
var annie:FNFSprite;
var sunday:FNFSprite;
var impostor:FNFSprite;

function onLoad()
{
    game.ghostsAllowed = true;
    var bg = new FlxSprite(-855, -600).loadGraphic(Paths.image("shaggy/final"));
    bg.scale.set(0.95, 0.95);
    //bg.screenCenter();
    bg.updateHitbox();
    bg.scrollFactor.set(1, 1);
    add(bg);

    pico = new FNFSprite(-50, 0);
    pico.loadFromJson('pico-minus', true);
    pico.playAnim('idle', true);
    pico.scale.set(0.8, 0.8);
    pico.updateHitbox();
    add(pico);

    zardy = new FNFSprite(-700, -175);
    zardy.loadFromJson('zardyy', true);
    zardy.playAnim('idle', true);
    zardy.updateHitbox();
    add(zardy);
}

function onSongStart()
{
    zardy.playAnim('idle', true);
    pico.playAnim('idle', true);
}

function onBeatHit(){
    if(zardy.canResetIdle && game.curBeat % 2 == 0) zardy.playAnim('idle', true);
    if(pico.canResetIdle && game.curBeat % 2 == 0) pico.playAnim('idle', true);
}

function onSpawnNotePost(note){
    if(note.noteType == 'Matt Note') note.noAnimation = true;
    if(note.noteType == 'Zardy Note') note.noAnimation = true;
    if(note.noteType == 'Pico Note') note.noAnimation = true;
}

function opponentNoteHit(note){
    if(note.noteType == 'Matt Note'){
        gf.playAnim(game.singAnimations[note.noteData], true);
        gf.holdTimer = 0;
        iconP2.changeIcon('matt');
    } 
    else if(note.noteType == 'Zardy Note'){
        zardy.playAnim(game.singAnimations[note.noteData], true);
        zardy.holdTimer = 0;
        iconP2.changeIcon('zardy');
    } 
    else if(note.noteType == 'Pico Note'){
        pico.playAnim(game.singAnimations[note.noteData], true);
        pico.holdTimer = 0;
        iconP2.changeIcon('pico');
    }
    else
    {
        iconP2.changeIcon('shaggy');
    }
}

function onEvent(eventName, value1, value2)
{
    if(eventName == 'Final Switch')
    {
        switch(value1){
            case 'Matt':
                game.whosTurn = 'matt';
                iconP2.changeIcon('matt');
            case 'Zardy':
                game.whosTurn = 'zardy';
                iconP2.changeIcon('zardy');
            case 'Pico':
                game.whosTurn = 'pico';
                iconP2.changeIcon('pico');
        }
    }
}
