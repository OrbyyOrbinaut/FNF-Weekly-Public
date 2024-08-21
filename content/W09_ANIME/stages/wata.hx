var skipIntro = false;

function onLoad(){
    bg = new FlxSprite().loadGraphic(Paths.image("watamote/tomoko_bg_1"));
    bg.scrollFactor.set(0.85, 0.85);
    bg.screenCenter();
    bg.x -= 20;
    add(bg);

    black2 = new FlxSprite().makeGraphic(600, 1000, FlxColor.BLACK);
    black2.scrollFactor.set();
    black2.screenCenter();
    foreground.add(black2);
    if(skipIntro) black2.alpha = 0;

    fg = new FlxSprite().loadGraphic(Paths.image("watamote/tomoko_bg_2"));
    fg.screenCenter();
    foreground.add(fg);
}

function onCreatePost(){
    game.skipCountdown = true;
    remove(game.dadGroup);

    black = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
    black.scrollFactor.set();
    black.camera = game.camOther;
    add(black);
    black.color = FlxColor.BLACK;
    if(skipIntro) black.alpha = 0;

    game.comboOffsetCustom = [100, 500, 160, 650];

    game.camHUD.alpha = 0;
    game.iconP2.visible = false;
    modManager.setValue("opponentSwap", 0.5);
    modManager.setValue("alpha", 1, 1);
    modManager.setValue("drunk", 0.2);
    modManager.setValue("tipsy", 0.2);
    game.boyfriend.scrollFactor.set(0.85, 0.85);

    game.healthBar.createFilledBar(FlxColor.RED, FlxColor.fromRGB(66, 66, 86));
    game.healthBar.updateBar();
}

function onSongStart(){
    if(!skipIntro){
        FlxTween.tween(black, {alpha: 0}, 35, {ease: FlxEase.quadInOut});
        FlxTween.num(game.defaultCamZoom, 0.625, 35, {ease: FlxEase.quadInOut, onUpdate: (t)-> {
            game.camGame.zoom = t.value;
        }});
    
        FlxTween.tween(black2, {alpha: 0}, 30, {ease: FlxEase.quadInOut, startDelay: 20});
        FlxTween.tween(game.camHUD, {alpha: 1}, 5, {ease: FlxEase.quadInOut, startDelay: 18});    
    }else{
        game.camGame.zoom = 0.625;
        game.camHUD.alpha = 1;
    }

    modManager.queueEase(512, 514, "tipsy", 0, 'linear');
    modManager.queueEase(512, 514, "drunk", 0, 'linear');

    modManager.queueEase(1560, 1564, "opponentSwap", 0, 'quadOut');
    modManager.queueFuncOnce(1560, (s,s2)->{
        black.camera = game.camHUD;
        black.alpha = 1;
    });

    modManager.queueFuncOnce(1568, (s,s2)->{
        black.alpha = 0;
        black2.alpha = 0;
        bg.alpha = 0;
        fg.alpha = 0;

        game.camGame.zoom = 0.85;
        game.boyfriendGroup.scrollFactor.set();
        game.boyfriendGroup.x -= 650; 
        game.boyfriendGroup.y -= 20;

        FlxG.camera.flash(FlxColor.WHITE, 0.5);
        game.healthBar.createFilledBar(FlxColor.RED, FlxColor.fromRGB(66, 66, 86));
        game.healthBar.updateBar();
    });

    modManager.queueFuncOnce(2080, (s,s2)->{
        var everything = [game.boyfriendGroup, game.camHUD];
        var two = 0;
        for(item in everything){
            FlxTween.tween(item, {alpha: 0}, 10, {ease: FlxEase.quadInOut, startDelay: two});
            two += 10;
        }
    });
}

function onGameOverStart() 
{
    setGameOverVideo("tomokover");
}