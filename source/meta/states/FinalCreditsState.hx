package meta.states;

import sys.FileSystem;
import sys.io.File;
import flixel.group.FlxSpriteGroup;

class FinalCreditsState extends MusicBeatState
{
    var stuffGroup:FlxSpriteGroup; //.antialiasing = true
    var ended:Bool = false;

    override function create()
    {
        FlxG.sound.music.stop();
        stuffGroup = new FlxSpriteGroup();

        for (i in 0...6){
            var thisImage:FlxSprite = new FlxSprite(0,0);
            thisImage.loadGraphic(Paths.image('finalecredits/' + i));
            thisImage.y = stuffGroup.members[i - 1] != null ? (stuffGroup.members[i - 1].y + stuffGroup.members[i - 1].height) + 80 : 0;
            thisImage.antialiasing = false;
            thisImage.screenCenter(X);
            stuffGroup.add(thisImage);
        }

        stuffGroup.y = (FlxG.height / 2) - 205;
        add(stuffGroup);
        FlxG.sound.playMusic(Paths.music("nextWeek"));
        FlxG.sound.music.looped = false;

        var finalImage:FlxSprite = new FlxSprite(FlxG.width/2,FlxG.height/2);
        finalImage.loadGraphic(Paths.image('finalecredits/final'));
        finalImage.screenCenter();
        finalImage.alpha = 0;
        add(finalImage);

        new FlxTimer().start(170.5, function(tmr:FlxTimer)
        {
            FlxTween.tween(finalImage, {alpha: 1}, 3, {ease: FlxEase.linear, onComplete: function(twn:FlxTween){
                ended = true;
            }});
        });

        new FlxTimer().start(3, function(tmr:FlxTimer)
        {
            FlxTween.tween(stuffGroup, {y: -29500}, 171.5, {ease: FlxEase.linear, onComplete: function(twn:FlxTween){
                trace('ended');
            }}); //169
        });
    }
        

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (controls.BACK)
        {
			Init.SwitchToPrimaryMenu(WeeklyMainMenuState);
            FlxG.sound.playMusic(Paths.music(KUTValueHandler.getMenuMusic()));
            FlxG.sound.music.looped = true;
        }

        if (controls.ACCEPT && ended == true)
        {
			Init.SwitchToPrimaryMenu(WeeklyMainMenuState);
            FlxG.sound.playMusic(Paths.music(KUTValueHandler.getMenuMusic()));
            FlxG.sound.music.looped = true;
        }
    }
}