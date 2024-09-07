package meta.states.substate;

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

class MarathonOverSubstate extends MusicBeatSubstate
{
	var camFollow:FlxPoint;
	var camFollowPos:FlxObject;
	var overText:FlxText;
    var statsText:FlxText;
	var killerText:FlxText;
	var screen:FlxSprite;

	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';

	public static var instance:GameOverSubstate;

	override function create()
	{
		super.create();

        FlxG.sound.play(Paths.sound('marathonlose'));

		FlxG.camera.zoom = 1;

		screen = new FlxSprite(0,0).loadGraphic(Paths.image('mainmenu/gameover'));
		screen.x -= (screen.width/2);
		screen.y -= (screen.height/2);
		screen.antialiasing = ClientPrefs.globalAntialiasing;
		add(screen);


		overText = new FlxText(70, -250, 650, "", 75);
		overText.alignment = LEFT;
		overText.font = "Comic Sans MS";
		overText.color = 0xffffffff;
		overText.antialiasing = ClientPrefs.globalAntialiasing;
		add(overText);

        statsText = new FlxText(100, -50, 650, "", 55);
		statsText.alignment = LEFT;
		statsText.font = "Comic Sans MS";
		statsText.color = 0xffffffff;
		statsText.antialiasing = ClientPrefs.globalAntialiasing;
		add(statsText);

		killerText = new FlxText(100, 250, 515, "", 55);
		killerText.alignment = LEFT;
		killerText.font = "Comic Sans MS";
		killerText.color = 0xffffffff;
		killerText.antialiasing = ClientPrefs.globalAntialiasing;
		add(killerText);

		overText.text = 'GAME OVER';

        statsText.text = 'MISSES:' + PlayState.campaignMisses + 
        '\nSCORE:' + PlayState.campaignScore + 
        '\nSONGS:' + WeeklyMainMenuState.marathonWeek;

		if (WeeklyMainMenuState.fcMode == true){
			statsText.text = 'MISSES:1' + 
			'\nSCORE:' + PlayState.campaignScore + 
			'\nSONGS:' + WeeklyMainMenuState.marathonWeek;
		}

		killerText.text = 'RUN KILLER:' + 
        '\n' + Metadata.get(PlayState.SONG.song).card.name;

		statsText.x = overText.x;
		statsText.y = overText.y + 110;
		killerText.x = overText.x;
		killerText.y = overText.y + 350;
        
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
			PlayState.instance.callOnScripts('onGameOverConfirm', [false]);
		}
	}
}
