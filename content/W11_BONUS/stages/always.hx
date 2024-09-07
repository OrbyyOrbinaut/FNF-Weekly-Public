var lyrics:LyricText;

function onCreatePost()
{   
    game.healthGain = 0;
    game.healthLoss = 0;

    game.snapCamFollowToPos(1280 / 2 - 1, 720 / 2 - 1);
    game.isCameraOnForcedPos = true;
    //modManager.setValue("opponentSwap", 0.5, 0);
    for (i in 0...game.opponentStrums.members.length) {
        game.opponentStrums.members[i].visible = false;
    }

    remove(game.dadGroup);
    remove(game.gfGroup);
    remove(game.boyfriendGroup);

    var unHud = [game.healthBarBG, game.healthBar, game.iconP1, game.iconP2];

    for(i in unHud){
        remove(i);
    }

    var bg:FlxSprite = new FlxSprite();
    bg.loadGraphic(Paths.image("nextweek"));
    bg.scrollFactor.set();
    bg.antialiasing = true;
    bg.screenCenter();
    bg.cameras = [game.camHUD];
    add(bg);

    lyrics = new LyricText(FlxG.width/2, FlxG.height - 220, FlxColor.YELLOW, 'vcr.ttf', 28);
    lyrics.cameras = [game.camOther];
    lyrics.lyricLoadCallback = function() {
        lyrics.screenCenter(FlxAxes.X);
    }
    add(lyrics);

    game.comboOffsetCustom = [400, 200, 450, 300];
}

function onUpdatePost(elapsed)
{
    game.camZooming = false;
}

function onSpawnNotePost(note:Note)
{
    note.visible = note.mustPress;
}

function onEvent(name, v1, v2) 
{
    switch (name)
    {
        case 'hai basil':
            trace('meme');
            switch (v1) 
            {
                case 'set':
                    lyrics.loadLyric(v2);
                    trace('meme22323');

                case 'next':
                    lyrics.nextSlice();

                case 'fade':
                    lyrics.fadeOut();
            }
    }
}
