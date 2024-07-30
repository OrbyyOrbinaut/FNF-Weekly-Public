addHaxeLibrary('Lib', 'openfl');
addHaxeLibrary('Capabilities', 'openfl.system');
addHaxeLibrary('ShaderFilter', 'openfl.filters');

var cameras = [game.camGame, game.camHUD, game.camOther];
var unHud = [game.healthBarBG, game.healthBar, game.iconP1, game.iconP2, game.timeBar, game.timeBarBG, game.timeTxt];

var threedeez = newShader('3D');
var para = newShader('paranoia');

var canMoveX:Bool = false;
var canMoveY:Bool = false;
var canUpdate:Bool = false;
var move:Float = 0;
var moveMult:Float = 0.5;

var canLerp:Bool = false;
var splitLerp:Float = 1;

function onCreatePost(){
    
    // game.camGame.setFilters([filter, filter2, filter3]);

    var newWidth:Float = 960;
    var newHeight:Float = 720; 
    var scaledHeight:Float = 720;

    for(camera in cameras){
        camera.width = 1280;
        if(newHeight <= 720){
            camera.height = 720 * (1280 / newHeight);
            scaledHeight = camera.height;
        }

    }

    // Lib.application.window.width = newWidth;
    // Lib.application.window.height = newHeight;
    // if(Lib.application.window.fullscreen)
        // FlxG.resizeGame(newWidth, newHeight);
    // else{
        // FlxG.resizeGame(newWidth, newHeight);
        FlxG.resizeWindow(newWidth, newHeight);
        // trace('poop');
    // }
    if(newHeight == newWidth)
        FlxG.scaleMode.height = FlxG.scaleMode.width;
    else
    	FlxG.scaleMode.height = 960;

    // trace(FlxG.scaleMode.gameSize.y);

    para.data.splitCount.value = [1];
    threedeez.data.xrot.value = [0];
    threedeez.data.yrot.value = [0];
    threedeez.data.zrot.value = [0];

    var filter:ShaderFilter = new ShaderFilter(threedeez);
    var filter2:ShaderFilter = new ShaderFilter(para);
    game.camHUD.setFilters([filter, filter2]);
    game.camGame.setFilters([filter]);


    remove(game.stage);
    remove(game.stage.foreground);
    remove(game.dadGroup);
    remove(game.gfGroup);
    remove(game.boyfriendGroup);
    for(i in unHud){
        remove(i);
    }
    game.scoreTxt.scale.set(3,3);
    game.scoreTxt.updateHitbox();
    game.scoreTxt.screenCenter();
    game.allowedToUpdateScoreTXT = false;
    game.scoreAllowedToBop = false;
    game.scoreTxt.alpha = 0;
    ClientPrefs.noteSplashes = false;
    game.defaultCamZoom = 1;
    game.comboPrefix = 'notitg/';

    bg = new FlxSprite().loadGraphic(Paths.image("LOVE_GROOVE_FINAL_BACKGROUND"));
    bg.scrollFactor.set();
    bg.scale.set(1.5, 1.5);
    bg.updateHitbox();
    bg.screenCenter();
    bg.y -= 12.5;
    add(bg);

    //splitting to a separate function because it's a lot of code and i dont wanna clutter createpost
    loadModchart();

    // modManager.queueEase(2376, 2394, "localrotateY", Math.PI * 4, 'quadInOut');
    // modManager.queueEase(2376, 2394, "localrotateZ", Math.PI * 4, 'quadInOut');
}

function onSongStart(){
    bg.alpha = 0;
    FlxTween.tween(bg, {alpha: 0.25}, (Conductor.stepCrotchet / 1000) * 16, { ease: FlxEase.quadOut});
}

function onSpawnNotePost(note){
    if(note.isSustainNote) note.alpha = 1;
    
}
function preReceptorGeneration(){
    FlxG.log.add("pre-receptor gen");

    playerStrums = getInstance().playerStrums;
    opponentStrums = getInstance().opponentStrums;
    FlxG.log.add("pre-receptor gen end");
}

var fartbutt:Float = 0;
function onUpdate(elapsed){
    game.camZooming = false;
    playerStrums.autoPlayed = getInstance().cpuControlled;
    playerStrums.playerControls = true;
    playerStrums.noteHitCallback = getInstance().goodNoteHit;

    opponentStrums.autoPlayed = getInstance().cpuControlled;
    opponentStrums.playerControls = true;
    // opponentStrums.noteHitCallback = getInstance().goodNoteHit;

    if(canUpdate) move += (elapsed * moveMult);

    if(canMoveX) para.data.x.value = [move];
    if(canMoveY) para.data.y.value = [move];

    if(canLerp){
        fartbutt = FlxMath.lerp(para.data.splitCount.value[0], splitLerp, CoolUtil.boundTo(elapsed * 2.4, 0, 1));
        para.data.splitCount.value = [fartbutt];    
    }

}

function onSwitchState(){
    trace('hi');
    if(!Lib.application.window.fullscreen){
        FlxG.resizeWindow(1280, 720);
    }
    FlxG.scaleMode.height = 720;
    ClientPrefs.loadPrefs();
}

function loadModchart(){
    modManager.setValue("centered", 1);
    modManager.setValue("reverse", 1, 1);
    modManager.setValue("opponentSwap", 0.5);
    modManager.setValue("transformZ", 0.5);
    modManager.setValue("alpha", 1);

    var lol:Int = 1;
    numericForInterval(8, 120, 16, (step)->{
        lol *= -1;
        modManager.queueSet(step, "stretch", 0.5);
        modManager.queueEase(step, step+4, "stretch", 0, "quadOut");
        modManager.queueSet(step, "confusion", 45 * lol);
        modManager.queueEase(step, step+4, "confusion", 0, "quadOut");

        lol *= -1;
        modManager.queueSet(step+6, "stretch", 0.5);
        modManager.queueEase(step+6, step+10, "stretch", 0, "quadOut");
        modManager.queueSet(step+6, "confusion", 45 * lol);
        modManager.queueEase(step+6, step+10, "confusion", 0, "quadOut");

        lol *= -1;
        modManager.queueSet(step+12, "stretch", 0.5);
        modManager.queueEase(step+12, step+16, "stretch", 0, "quadOut");
        modManager.queueSet(step+12, "confusion", 45 * lol);
        modManager.queueEase(step+12, step+16, "confusion", 0, "quadOut");
    });
    modManager.queueEase(0, 8, "alpha", 0, "quadOut");
    modManager.queueEase(0, 8, "transformZ", 0, "backOut");

    modManager.queueEase(40, 44, "opponentSwap", 0, "backOut");

    modManager.queueEase(72, 76, "centered", 0, "backInOut");

    modManager.queueEase(104, 108, "opponentSwap", 0.5, 'backInOut');
    modManager.queueEase(104, 108, "reverse", 0, 'backInOut');

    modManager.queueEase(128, 136, "opponentSwap", 0, 'quadOut');
    modManager.queueFuncOnce(136, (s,s2)->{ 
        canMoveX = true;
        FlxTween.num(0, 7, (Conductor.stepCrotchet / 1000) * 124, {ease: FlxEase.quadOut, onUpdate: (twn:FlxTween)->{
            move = twn.value;
        }});
    });

    modManager.queueEase(272, 276, "tipsy", 1, 'quadOut');

    modManager.queueEase(327, 329, "centered", 1, 'quadOut');
    modManager.queueEase(327, 329, "split", 1, 'quadOut');

    modManager.queueEase(331, 333, "centered", 0, 'quadOut');

    modManager.queueEase(391, 393, "opponentSwap", 0.5, 'quadOut');
    modManager.queueEase(391, 393, "split", 0, 'quadOut');
    modManager.queueEase(391, 393, "tipsy", 0, 'quadOut');

    modManager.queueEase(395, 397, "opponentSwap", 1, 'quadOut');
    modManager.queueEase(395, 397, "reverse", 1, 'quadOut');

    modManager.queueEase(400, 402, "tipsy", 1, 'quadOut');

    modManager.queueEase(455, 457, "tipsy", 0, 'quadOut');
    modManager.queueEase(455, 457, "centered", 1, 'quadOut');

    modManager.queueEase(459, 461, "reverse", 0, 'quadOut', 0);
    modManager.queueEase(459, 461, "opponentSwap", 0.5, 'quadOut');

    modManager.queueEase(480, 496, "localrotateZ", 2 * Math.PI, 'quadOut');

    modManager.queueEase(496, 512, "centered", 0, 'quadOut');
    modManager.queueEase(496, 512, "reverse", 0, 'quadOut');

    modManager.queueFuncOnce(512, (s,s2)->{
        FlxTween.num(1, 4, (Conductor.stepCrotchet / 1000) * 14, {ease: FlxEase.quadInOut, onUpdate: (twn:FlxTween)->{
            para.data.splitCount.value = [twn.value];
        }});
    });

    modManager.queueFuncOnce(528, (s,s2)->{ para.data.splitCount.value = [1]; });
    modManager.queueFuncOnce(536, (s,s2)->{ para.data.splitCount.value = [2]; });
    modManager.queueFuncOnce(544, (s,s2)->{ para.data.splitCount.value = [1]; });
    modManager.queueFuncOnce(552, (s,s2)->{ para.data.splitCount.value = [2]; });
    modManager.queueFuncOnce(560, (s,s2)->{ 
        move = 0;
        canMoveX = true;
        FlxTween.num(0, 1, (Conductor.stepCrotchet / 1000) * 24, {ease: FlxEase.quadOut, onUpdate: (twn:FlxTween)->{
            move = twn.value;
        }, onComplete: (twn:FlxTween)->{ move = 0; }});
    });
    modManager.queueFuncOnce(592, (s,s2)->{ canMoveX = false; });

    modManager.queueFuncOnce(592, (s,s2)->{ para.data.splitCount.value = [1]; });
    modManager.queueFuncOnce(600, (s,s2)->{ para.data.splitCount.value = [2]; });
    modManager.queueFuncOnce(608, (s,s2)->{ para.data.splitCount.value = [1]; });
    modManager.queueFuncOnce(616, (s,s2)->{ para.data.splitCount.value = [2]; });
    modManager.queueFuncOnce(624, (s,s2)->{ 
        move = 0;
        canMoveY = true;
        FlxTween.num(0, 1, (Conductor.stepCrotchet / 1000) * 24, {ease: FlxEase.quadOut, onUpdate: (twn:FlxTween)->{
            move = twn.value;
        }, onComplete: (twn:FlxTween)->{ move = 0; }});
    });
    modManager.queueFuncOnce(656, (s,s2)->{ canMoveY = false; });

    modManager.queueFuncOnce(656, (s,s2)->{ para.data.splitCount.value = [1]; });
    modManager.queueFuncOnce(664, (s,s2)->{ para.data.splitCount.value = [2]; });
    modManager.queueFuncOnce(672, (s,s2)->{ para.data.splitCount.value = [1]; });
    modManager.queueFuncOnce(680, (s,s2)->{ para.data.splitCount.value = [2]; });

    modManager.queueFuncOnce(688, (s,s2)->{ 
        move = 0;
        canMoveX = true;
        canMoveY = true;
        FlxTween.num(0, 1, (Conductor.stepCrotchet / 1000) * 24, {ease: FlxEase.quadOut, onUpdate: (twn:FlxTween)->{
            move = twn.value;
        }, onComplete: (twn:FlxTween)->{ move = 0; }});
    });
    modManager.queueFuncOnce(720, (s,s2)->{ canMoveX = false; canMoveY = false; });
    
    modManager.queueFuncOnce(720, (s,s2)->{ para.data.splitCount.value = [1]; });
    modManager.queueFuncOnce(728, (s,s2)->{ para.data.splitCount.value = [2]; });
    modManager.queueFuncOnce(736, (s,s2)->{ para.data.splitCount.value = [1]; });
    modManager.queueFuncOnce(744, (s,s2)->{ para.data.splitCount.value = [2]; });

    modManager.queueFuncOnce(752, (s,s2)->{ 
        move = 0;
        canMoveX = true;
        canMoveY = true;
        FlxTween.num(0, 1, (Conductor.stepCrotchet / 1000) * 24, {ease: FlxEase.quadOut, onUpdate: (twn:FlxTween)->{
            move = twn.value;
        }, onComplete: (twn:FlxTween)->{ move = 0; }});
        
        FlxTween.num(2, 1, (Conductor.stepCrotchet / 1000) * 16, {ease: FlxEase.quadOut, onUpdate: (twn:FlxTween)->{
            para.data.splitCount.value = [twn.value];
        }});

    });
    modManager.queueFuncOnce(784, (s,s2)->{ canMoveX = false; canMoveY = false; });

    var poop:Int = 0;
    numericForInterval(786, 799, 2, (step)->{
        modManager.queueFuncOnce(step, (s,s2)->{
            poop += 45;
            threedeez.data.zrot.value = [poop];
            threedeez.data.zpos.value = [0.5];
        });
    });
    modManager.queueFuncOnce(800, (s,s2)->{ 
        FlxTween.num(threedeez.data.xrot.value, 0, (Conductor.stepCrotchet / 1000) * 4, {ease: FlxEase.quadOut, onUpdate: (twn:FlxTween)->{
            threedeez.data.zrot.value = [twn.value];
            threedeez.data.zpos.value = [0];
        }});
    });

    var shit:Int = 0;
    numericForInterval(818, 831, 2, (step)->{
        modManager.queueFuncOnce(step, (s,s2)->{
            shit += 22.5;
            threedeez.data.xrot.value = [shit];
            threedeez.data.zpos.value = [0.5];
        });
    });
    modManager.queueFuncOnce(832, (s,s2)->{ 
        FlxTween.num(threedeez.data.xrot.value, 0, (Conductor.stepCrotchet / 1000) * 4, {ease: FlxEase.quadOut, onUpdate: (twn:FlxTween)->{
            threedeez.data.xrot.value = [twn.value];
            threedeez.data.zpos.value = [0];
        }});
    });

    var shit:Int = 0;
    numericForInterval(850, 863, 2, (step)->{
        modManager.queueFuncOnce(step, (s,s2)->{
            shit += 22.5;
            threedeez.data.yrot.value = [shit];
            threedeez.data.zpos.value = [0.5];
        });
    });
    modManager.queueFuncOnce(864, (s,s2)->{ 
        FlxTween.num(threedeez.data.xrot.value, 0, (Conductor.stepCrotchet / 1000) * 4, {ease: FlxEase.quadOut, onUpdate: (twn:FlxTween)->{
            threedeez.data.yrot.value = [twn.value];
            threedeez.data.zpos.value = [0];
        }});
    });

    var poop:Int = 0;
    numericForInterval(882, 895, 2, (step)->{
        modManager.queueFuncOnce(step, (s,s2)->{
            poop += 45;
            threedeez.data.zrot.value = [poop];
            threedeez.data.zpos.value = [0.5];
        });
    });
    modManager.queueFuncOnce(896, (s,s2)->{ 
        FlxTween.num(threedeez.data.xrot.value, 0, (Conductor.stepCrotchet / 1000) * 4, {ease: FlxEase.quadOut, onUpdate: (twn:FlxTween)->{
            threedeez.data.zrot.value = [twn.value];
        }});
    });

    modManager.queueFuncOnce(912, (s,s2)->{ 
        FlxTween.num(0.5, 0, (Conductor.stepCrotchet / 1000) * 4, {ease: FlxEase.quadInOut, onUpdate: (twn:FlxTween)->{
            threedeez.data.zpos.value = [twn.value];
        }, onComplete: (f:FlxTween)->{ threedeez.data.zpos.value = [0]; }});
    });


    modManager.queueSet(912, "beat", 1);
    var bump:Int = 1;
    numericForInterval(912, 1040, 4, (step)->{
        bump *= -1;
        modManager.queueEase(step, step+2, "transformX", 50 * bump, 'backOut');
        
        modManager.queueEase(step, step+2, "transform0Y", 25 * bump, 'backOut');
        modManager.queueEase(step, step+2, "transform1Y", 25 * bump, 'backOut');
        modManager.queueEase(step, step+2, "transform2Y", -25 * bump, 'backOut');
        modManager.queueEase(step, step+2, "transform3Y", -25 * bump, 'backOut');
    });

    modManager.queueSet(1040, "beat", 0);
    modManager.queueSet(1040, "localrotateY", Math.PI);
    modManager.queueEase(1040, 1056, "localrotateY", 0, 'quadOut');
    modManager.queueEase(1040, 1056, "transformX", 0, 'quadOut');
    for(i in 0...4){ modManager.queueEase(1040, 1056, "transform" + i + "Y", 'quadOut'); }
    // modManager.setValue("localrotateY", Math.PI / 2);

    modManager.queueEase(1056, 1060, "flip", -0.5, 'quadOut');
    modManager.queueEase(1056, 1060, "transformX", 57, 'quadOut', 0);
    modManager.queueEase(1056, 1060, "transformX", -57, 'quadOut', 1);
    modManager.queueEase(1056, 1060, "cross", 0, 'quadOut');

    modManager.queueEase(1180, 1184, "reverse", 1, 'bounceOut', 0);
    modManager.queueEase(1180, 1184, "centered", 1, 'bounceOut');

    modManager.queueEase(1312, 1316, "centered", 0, 'quadOut');
    modManager.queueEase(1312, 1316, "reverse", 0, 'quadOut');
    modManager.queueEase(1312, 1316, "transformX", 0, 'quadOut', 0);
    modManager.queueEase(1312, 1316, "transformX", 0, 'quadOut', 1);
    modManager.queueEase(1312, 1316, "flip", 0, 'quadOut');
    modManager.queueEase(1312, 1316, "opponentSwap", 0, 'quadOut');

    numericForInterval(1312, 1376, 32, (step)->{
        modManager.queueEase(step, step+16, "transformY", 1000, 'quadIn', 1);
        modManager.queueEase(step, step+16, "transformY", 0, 'quadOut', 0);

        modManager.queueEase(step+16, step+32, "transformY", 1000, 'quadIn', 0);
        modManager.queueEase(step+16, step+32, "transformY", 0, 'quadOut', 1);
    });

    modManager.queueEase(1376, 1380, "transformY", 0, 'quadOut', 0);
    modManager.queueEase(1376, 1380, "transformY", 0, 'quadOut', 1);

    numericForInterval(1376, 1440, 32, (step)->{
        modManager.queueEase(step, step+16, "transformX", -700, 'quadIn', 1);
        modManager.queueEase(step, step+16, "transformX", 0, 'quadOut', 0);

        modManager.queueEase(step+16, step+32, "transformX", 700, 'quadIn', 0);
        modManager.queueEase(step+16, step+32, "transformX", 0, 'quadOut', 1);
    });

    modManager.queueEase(1440, 1444, "transformX", 0, 'quadOut', 0);
    modManager.queueEase(1440, 1444, "transformX", 0, 'quadOut', 1);

    numericForInterval(1440, 1504, 32, (step)->{
        modManager.queueEase(step, step+16, "transformY", 1000, 'quadIn', 1);
        modManager.queueEase(step, step+16, "transformY", 0, 'quadOut', 0);

        modManager.queueEase(step+16, step+32, "transformY", 1000, 'quadIn', 0);
        modManager.queueEase(step+16, step+32, "transformY", 0, 'quadOut', 1);
    });

    modManager.queueEase(1504, 1508, "transformY", 0, 'quadOut', 0);
    modManager.queueEase(1504, 1508, "transformY", 0, 'quadOut', 1);
    modManager.queueEase(1504, 1508, "drunk", 0.5, 'quadOut');

    var number:Int = 0;
    
    numericForInterval(1504, 1552, 32, function(step){
        for(i in 0...8){
            if(number > 40){
                number = 40;
            }
            if(i < 4){
                modManager.queueEase(step + (i * 4), (step + (i * 4)) + 2, "transform" + i + "Y", number * -1, 'expoOut', 1);
                modManager.queueEase((step + (i * 4)) + 2, (step + (i * 4)) + 4, "transform" + i + "Y", 0, 'expoIn', 1);
            }else{
                modManager.queueEase(step + (i * 4), (step + (i * 4)) + 2, "transform" + (i - 4) + "Y", number * -1, 'expoOut', 0);
                modManager.queueEase((step + (i * 4)) + 2, (step + (i * 4)) + 4, "transform" + (i - 4) + "Y", 0, 'expoIn', 0);
            }
            number += 10;
        }
    });
    

    modManager.queueEase(1548, 1552, "blink", 1, 'quartInOut');

    modManager.queueSet(1560, "blink", 0);
    modManager.queueSet(1560, "drunk", 0);
    modManager.queueSet(1560, "opponentSwap", 0.5);

    modManager.queueEase(1564, 1568, "opponentSwap", 0, 'quadOut');

    modManager.queueSet(1576, "beat", 1);
    modManager.queueFuncOnce(1576, (s,s2)->{ canLerp = true; splitLerp = 2; canUpdate = true; canMoveX = true; });
    modManager.queueFuncOnce(1584, (s,s2)->{ splitLerp = 1; });
    modManager.queueFuncOnce(1592, (s,s2)->{ splitLerp = 2; });
    modManager.queueFuncOnce(1600, (s,s2)->{ splitLerp = 1; 
        FlxTween.num(move, Std.int(move), (Conductor.stepCrotchet / 1000) * 4, {ease: FlxEase.quadOut, onUpdate: (twn:FlxTween)->{
            move = twn.value;
        }});
    });
    // modManager.queueFuncOnce(1584, (s,s2)->{ 
    //     canMoveX = true; 
    //     FlxTween.num(0, 2, (Conductor.stepCrotchet / 1000) * 24, {ease: FlxEase.quadOut, onUpdate: (twn:FlxTween)->{
    //         move = twn.value;
    //     }, onComplete: (twn:FlxTween)->{ move = 0; canMoveX = false; }});
    // });

    modManager.queueFuncOnce(1640, (s,s2)->{ splitLerp = 2; moveMult *= -1; });
    modManager.queueFuncOnce(1648, (s,s2)->{ splitLerp = 1; });
    modManager.queueFuncOnce(1656, (s,s2)->{ splitLerp = 2; });
    modManager.queueFuncOnce(1664, (s,s2)->{ splitLerp = 1; 
        FlxTween.num(move, Std.int(move), (Conductor.stepCrotchet / 1000) * 4, {ease: FlxEase.quadOut, onUpdate: (twn:FlxTween)->{
            move = twn.value;
        }});
    });
    // modManager.queueFuncOnce(1672, (s,s2)->{ 
    //     canMoveY = true; 
    //     FlxTween.num(0, 2, (Conductor.stepCrotchet / 1000) * 24, {ease: FlxEase.quadOut, onUpdate: (twn:FlxTween)->{
    //         move = twn.value;
    //     }, onComplete: (twn:FlxTween)->{ move = 0; canMoveY = false; }});
    // });
    modManager.queueFuncOnce(1704, (s,s2)->{ splitLerp = 2; canMoveX = true; canMoveY = false;});
    modManager.queueFuncOnce(1712, (s,s2)->{ splitLerp = 3; });
    modManager.queueFuncOnce(1720, (s,s2)->{ splitLerp = 2; });
    modManager.queueFuncOnce(1728, (s,s2)->{ splitLerp = 3; });
    modManager.queueFuncOnce(1736, (s,s2)->{ splitLerp = 1; moveMult *= -1; });

    modManager.queueFuncOnce(1768, (s,s2)->{ splitLerp = 2; canMoveY = false; moveMult *= -1;});
    modManager.queueFuncOnce(1776, (s,s2)->{ moveMult *= -1; });
    modManager.queueFuncOnce(1784, (s,s2)->{ moveMult *= -1; });
    modManager.queueFuncOnce(1792, (s,s2)->{ moveMult *= -1; });
    modManager.queueFuncOnce(1800, (s,s2)->{ canMoveY = true;  });

    modManager.queueFuncOnce(1816, (s,s2)->{ canMoveY = false; canMoveX = false; canUpdate = false; splitLerp = 1;         
        FlxTween.num(move, Std.int(move), (Conductor.stepCrotchet / 1000) * 16, {ease: FlxEase.quadOut, onUpdate: (twn:FlxTween)->{
            move = twn.value;
            para.data.x.value = [move];
            para.data.y.value = [move];
        }});
    });

    var boom = [1840, 1848, 1856, 1896, 1904, 1912, 1920, 1960, 1968, 1976, 1984, 2024, 2032, 2040, 2048];
    var int:Int = 1;
    for(step in boom){
        int *= -1;
        modManager.queueSet(step, "tipsy", 6);
        modManager.queueEase(step, step + 4, "tipsy", 0, 'quartOut');
        modManager.queueSet(step, "stretch", 0.5);
        modManager.queueEase(step, step + 8, "stretch", 0, 'bounceOut');
        modManager.queueSet(step, "flip", -0.25);
        modManager.queueEase(step, step + 8, "flip", 0, 'quartOut');
        modManager.queueSet(step, "transformX", 100 * int);
        modManager.queueEase(step, step + 8, "transformX", 0, 'quartOut');
        modManager.queueSet(step, "confusion", 180 * int);
        modManager.queueEase(step, step + 8, "confusion", 0, 'quartOut');
    }

    modManager.queueSet(1944, "localrotateX", Math.PI);
    modManager.queueEase(1944, 1958, "localrotateX", 0, 'quadOut');
    modManager.queueEase(1944, 1958, "reverse", 1, 'quadOut');

    modManager.queueSet(1992, "centerrotateY", Math.PI);
    modManager.queueEase(1992, 2006, "centerrotateY", 0, 'quadOut');

    modManager.queueSet(2056, "localrotateX", Math.PI);
    modManager.queueEase(2056, 2068, "localrotateX", 0, 'quadOut');
    modManager.queueEase(2056, 2068, "reverse", 0, 'quadOut');

    modManager.queueFuncOnce(2072, (s,s2)->{
        FlxTween.num(0, 0.5, (Conductor.stepCrotchet / 1000) * 16, {ease: FlxEase.quadInOut, onUpdate: (twn:FlxTween)->{
            threedeez.data.zpos.value = [twn.value];
        }});
    });

    var poop:Int = 0;
    numericForInterval(2090, 2103, 2, (step)->{
        modManager.queueFuncOnce(step, (s,s2)->{
            poop += 45;
            threedeez.data.zrot.value = [poop];
            threedeez.data.zpos.value = [0.5];
        });
    });
    modManager.queueFuncOnce(2104, (s,s2)->{
        FlxTween.num(threedeez.data.zpos.value[0], 0, (Conductor.stepCrotchet / 1000) * 4, {ease: FlxEase.quadOut, onUpdate: (twn:FlxTween)->{
            threedeez.data.zpos.value = [twn.value];
        }});
        threedeez.data.zrot.value = [0];
    });

    var poop:Int = 0;
    numericForInterval(2122, 2135, 2, (step)->{
        modManager.queueFuncOnce(step, (s,s2)->{
            poop += 45;
            threedeez.data.yrot.value = [poop];
            threedeez.data.zpos.value = [0.5];
        });
    });
    modManager.queueFuncOnce(2136, (s,s2)->{
        FlxTween.num(threedeez.data.zpos.value[0], 0, (Conductor.stepCrotchet / 1000) * 4, {ease: FlxEase.quadOut, onUpdate: (twn:FlxTween)->{
            threedeez.data.zpos.value = [twn.value];
        }});
        threedeez.data.yrot.value = [0];
    });

    var poop:Int = 0;
    numericForInterval(2154, 2167, 2, (step)->{
        modManager.queueFuncOnce(step, (s,s2)->{
            poop += 45;
            threedeez.data.xrot.value = [poop];
            threedeez.data.zpos.value = [0.5];
        });
    });
    modManager.queueFuncOnce(2168, (s,s2)->{
        threedeez.data.xrot.value = [0];
    });

    modManager.queueFuncOnce(2180, (s,s2)->{
        FlxTween.num(threedeez.data.zpos.value[0], 0, (Conductor.stepCrotchet / 1000) * 4, {ease: FlxEase.quadOut, onUpdate: (twn:FlxTween)->{
            threedeez.data.zpos.value = [twn.value];
        }});
    });

    var poop:Int = 0;
    numericForInterval(2186, 2199, 2, (step)->{
        modManager.queueFuncOnce(step, (s,s2)->{
            poop += 45;
            modManager.setValue("localrotateZ", poop * (Math.PI / 180));
        });
    });
    modManager.queueEase(2200, 2204, "localrotateZ", 0, 'bounceOut');


    var poopp:Int = 22.5;
    numericForInterval(2224 - 8, 2335, 4, (step)->{
        poopp *= -1;
        modManager.queueEase(step, step+2, "localrotateZ", poopp * (Math.PI / 180), 'quadOut');

        modManager.queueSet(step, "flip", -0.25);
        modManager.queueEase(step, step+2, "flip", 0, 'quadOut');
    });

    modManager.queueEase(2280, 2287, "opponentSwap", 0.5, 'quadOut');
    modManager.queueEase(2280, 2287, "localrotateX", (-45 - 22.5) * (Math.PI / 180), 'quadOut');

    modManager.queueEase(2336, 2340, "localrotateZ", 0, 'quadOut');
    modManager.queueEase(2336, 2340, "localrotateX", 0, 'quadOut');

    modManager.queueEase(2344, 2376, "tipsy", 2, 'quadInOut');
    modManager.queueEase(2344, 2348, "centered", 1, 'quadInOut');
    modManager.queueEase(2344, 2348, "beat", 0, 'quadInOut');

    modManager.queueEase(2376, 2394, "alpha", 1, 'quadInOut');
    modManager.queueEase(2376, 2394, "tipsy", 10, 'quadInOut');
    modManager.queueEase(2376, 2394, "drunk", 10, 'quadInOut');
    modManager.queueEase(2376, 2400, "localrotateY", Math.PI * 4, 'quadInOut');

    var lastrand:Int = 0;
    var lol = [2344, 2349, 2354, 2359, 2364, 2368];
    for(step in lol){
        var rand = FlxG.random.int(1, 5, [lastrand]);
		lastrand = rand;
		switch(rand){
			case 1:
				modManager.queueEase(step, step+2, "invert", 1, 'backOut');
				modManager.queueEase(step, step+2, "flip", 0, 'backOut');
			case 2:
				modManager.queueEase(step, step+2, "invert", 0, 'backOut');
				modManager.queueEase(step, step+2, "flip", 1, 'backOut');
			case 3:
				modManager.queueEase(step, step+2, "invert", 0.75, 'backOut');
				modManager.queueEase(step, step+2, "flip", 0.75, 'backOut');
			case 4:
				modManager.queueEase(step, step+2, "invert", 1.25, 'backOut');
				modManager.queueEase(step, step+2, "flip", 0.25, 'backOut');
			case 5:
				modManager.queueEase(step, step+2, "invert", -0.75, 'backOut');
				modManager.queueEase(step, step+2, "flip", 0.25, 'backOut');
		}
		trace(rand + 'hi!');
    }
    modManager.queueEase(2371, 2373, "invert", 0, "backOut");
    modManager.queueEase(2371, 2373, "flip", 0, "backOut");

    modManager.queueFuncOnce(2400, (s,s2)->{
        FlxTween.tween(bg, {alpha: 1}, 1, {ease: FlxEase.quadIn, onComplete: (twn)->{
            FlxTween.tween(bg, {alpha: 0}, 2, {ease: FlxEase.quadOut});

            game.scoreTxt.text = "Score: " + game.songScore + "\nMisses: " + game.songMisses;
            FlxTween.tween(game.scoreTxt, {alpha: 1}, 1, {ease: FlxEase.quadIn});
        }});
    });
}

function numericForInterval(start, end, interval, func){
    var index = start;
    while(index < end){
        func(index);
        index += interval;
    }
}

function onGameOverStart() 
{
    setGameOverVideo("miku_gameover");
}