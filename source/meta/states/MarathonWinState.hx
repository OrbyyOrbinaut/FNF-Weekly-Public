package meta.states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import gameObjects.*;
import meta.states.*;
import meta.data.*;

class MarathonWinState extends MusicBeatState
{
	var camFollow:FlxPoint;
	var camFollowPos:FlxObject;
	var winText:FlxText;
    var statsText:FlxText;
	var screen:FlxSprite;

	override function create()
	{
		super.create();

		FlxG.sound.music.stop();

		FlxG.camera.zoom = 1;

		screen = new FlxSprite(0,0);
		screen.x -= (screen.width/2);
		screen.y -= (screen.height/2);
		screen.antialiasing = ClientPrefs.globalAntialiasing;
		add(screen);


		winText = new FlxText(70, -250, 650, "", 80);
		winText.alignment = LEFT;
		winText.font = "Comic Sans MS";
		winText.color = 0xffffffff;
		winText.antialiasing = ClientPrefs.globalAntialiasing;
		add(winText);

        statsText = new FlxText(100, -50, 650, "", 60);
		statsText.alignment = LEFT;
		statsText.font = "Comic Sans MS";
		statsText.color = 0xffffffff;
		statsText.antialiasing = ClientPrefs.globalAntialiasing;
		add(statsText);

		if (WeeklyMainMenuState.fcMode == true || PlayState.campaignMisses == 0){
			if (Highscore.goldMode == false){
				Highscore.setGold();
				ClientPrefs.gold = true;
			}
			winText.text = 'FULL CLEAR!!!';
			screen.loadGraphic(Paths.image('mainmenu/fullclear'));
			screen.x -= (screen.width/2);
			screen.y -= (screen.height/2);
			FlxG.sound.play(Paths.sound('marathonfc'));
		}
		else{
			winText.text = 'YOU WIN!!!!';
			screen.loadGraphic(Paths.image('mainmenu/win'));
			screen.x -= (screen.width/2);
			screen.y -= (screen.height/2);
			FlxG.sound.play(Paths.sound('marathonwin'));
		}

        statsText.text = 'MISSES:' + PlayState.campaignMisses + 
        '\nSCORE:' + PlayState.campaignScore + 
        '\nSONGS:' + WeeklyMainMenuState.marathonWeek;

		statsText.x = winText.x;
		statsText.y = winText.y + 110;
        
        camFollowPos = new FlxObject(0, 0, 1, 1);
		camFollowPos.setPosition(0,0);
		add(camFollowPos);

        FlxG.camera.follow(camFollowPos, LOCKON, 1);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK || controls.ACCEPT)
		{
			FlxG.sound.music.stop();
			PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;

			Init.SwitchToPrimaryMenu(WeeklyMainMenuState);

			FlxG.sound.playMusic(Paths.music(KUTValueHandler.getMenuMusic()));
		}
	}
}
