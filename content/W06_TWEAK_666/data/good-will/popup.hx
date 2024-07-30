//This script soley handles the popups bc if i put this in desktop hx it'd genuinely be nightmarish to manage for me

var popups:Array<FlxSprite> = []; //Flxgroups are kinda fucked in hscript so this should work
var popupcount:Int = 0;

function onUpdate(elapsed){
    if (popups != null && popups.length > 0) {
        for(i in 0...popups.length){ 
            if(FlxG.mouse.overlaps(popups[i]) && FlxG.mouse.justPressed) //fucks up if the camera ever moves but since it doesnt in this song its ok
            {
                FlxTween.tween(popups[i].scale, {x: 0.95, y: 0.95}, 0.1);
                FlxTween.tween(popups[i], {alpha: 0}, 0.1, {
                ease: FlxEase.linear,
                onComplete: function() {
                    popups[i].kill();
                    popupcount = popupcount - 1;
                }});
            }
        }
    }
}

function onEvent(eventName, value1, value2)
{
    if(eventName == 'Spawn Popup Window' && popupcount < 8)
    {
        var windowX:Int = 0; // holy shit this is awful but its ok
        var windowY:Int = 0;
        var winXmin:Int = 0;
        var winXmax:Int = 0;
        var winYmin:Int = 0;
        var winYmax:Int = 0;
        switch(value1) // Stores the ranges for the randomized x and y positions for each window varaiant
        {
            case '1':
            winXmin = 12;
            winXmax = 787;
            winYmin = 7;
            winYmax = 380;
            case '2':
            winXmin = 8;
            winXmax = 415;
            winYmin = 6;
            winYmax = 298;
            case '3':
            winXmin = 0;
            winXmax = 787;
            winYmin = 10;
            winYmax = 281;
            case '4':
            winXmin = 5;
            winXmax = 780;
            winYmin = 9;
            winYmax = 378;
            case '5':
            winXmin = 6;
            winXmax = 753;
            winYmin = 12;
            winYmax = 262;
            case '6':
            winXmin = 4;
            winXmax = 917;
            winYmin = 11;
            winYmax = 472;
        } 
        windowX = FlxG.random.int(winXmin, winXmax);
        windowY = FlxG.random.int(winYmin, winYmax);
        spawnPopup(windowX, windowY, value1);
        //trace('cur popupcout is ' + popupcount);
    }
}

function spawnPopup(x:Int, y:Int, popupnum:Int)
{
    var popup:FlxSprite = new FlxSprite(x, y);
    popup.loadGraphic(Paths.image('kinito/popups/window' + popupnum));
    popup.antialiasing = ClientPrefs.globalAntialiasing;
    popup.cameras = [game.camOther];
    popup.scale.set(0.95, 0.95);	
    popups.push(popup);
    add(popup);
    FlxTween.tween(popup, {alpha: 1}, 0.1);
    FlxTween.tween(popup.scale, {x: 1, y: 1}, 0.1);
    popupcount = popupcount + 1;
    trace('popup added!');
}