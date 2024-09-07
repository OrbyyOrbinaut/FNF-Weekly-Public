package meta.states.substate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.util.FlxStringUtil;

import meta.data.*;
import meta.data.Metadata;
import meta.states.*;
import gameObjects.*;
import meta.data.options.*;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = ['Resume', 'Restart Song', 'Options', 'Exit to menu'];
	var difficultyChoices = [];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var texts:Array<String> = [];
	var data:MetadataFile;
	var practiceText:FlxText;
	var skipTimeText:FlxText;
	var skipTimeTracker:Alphabet;
	var curTime:Float = Math.max(0, Conductor.songPosition);
	//var botplayText:FlxText;

	public static var songName:String = '';

	override function create()
	{
		if (WeeklyMainMenuState.marathon == true)
			menuItemsOG = ['Resume', 'Restart Song', 'Options', "Exit to menu(Won't save!!!)"];
		var cam:FlxCamera = FlxG.cameras.list[FlxG.cameras.list.length - 1];
		//if(CoolUtil.difficulties.length < 2) 
		#if HIT_SINGLE
		menuItemsOG.remove('Change Difficulty'); //No need to change difficulty if there is only one!
		#end

		if(PlayState.chartingMode #if debug || true #end)
		{
			var shit:Int = 2;
			if (PlayState.chartingMode){
				menuItemsOG.insert(shit, 'Leave Charting Mode');
				shit++;
			}

			var num:Int = 0;
			if(!PlayState.instance.startingSong)
			{
				num = 1;
				menuItemsOG.insert(shit, 'Skip Time');
			}
			menuItemsOG.insert(shit + num, 'End Song');
			menuItemsOG.insert(shit + num, 'Toggle Practice Mode');
			menuItemsOG.insert(shit + num, 'Toggle Botplay');
		}
		menuItems = menuItemsOG;

		for (i in 0...CoolUtil.difficulties.length) {
			var diff:String = '' + CoolUtil.difficulties[i];
			difficultyChoices.push(diff);
		}
		difficultyChoices.push('BACK');

		pauseMusic = new FlxSound();
		try {
			if(songName != null) {
				pauseMusic.loadEmbedded(Paths.music(songName), true, true);
			} else if (songName != 'None') {
				pauseMusic.loadEmbedded(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)), true, true);
			}
			pauseMusic.volume = 0;
			pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));
		} catch(e) {}


		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		bg.setGraphicSize(cam.width,cam.height);
		bg.alpha = 0;
		bg.screenCenter(XY);
		bg.scrollFactor.set();
		add(bg);

		practiceText = new FlxText(20, 15 + 101, 0, "PRACTICE MODE", 32);
		practiceText.scrollFactor.set();
		practiceText.setFormat(Paths.font('vcr.ttf'), 32);
		practiceText.x = cam.width - (practiceText.width + 20);
		practiceText.updateHitbox();
		practiceText.visible = PlayState.instance.practiceMode;
		add(practiceText);

		var chartingText:FlxText = new FlxText(20, 15 + 101, 0, "CHARTING MODE", 32);
		chartingText.scrollFactor.set();
		chartingText.setFormat(Paths.font('vcr.ttf'), 32);
		chartingText.x = cam.width - (chartingText.width + 20);
		chartingText.y = cam.height - (chartingText.height + 20);
		chartingText.updateHitbox();
		chartingText.visible = PlayState.chartingMode;
		add(chartingText);

		FlxTween.tween(bg, {alpha: 0.75}, 0.4, {ease: FlxEase.quartInOut});

		if (PlayState.ihatemylifethisisthelastthingthatneedstobecoded) {
			texts.push('niffirg - Buds and Bluds');
			texts.push('Chart: niffirg');
			texts.push('Art: DerpDrawz');
			texts.push('Code: OrbyyOrbinaut, Lethrial');
			texts.push('Voice Acting: niffirg');
		}
		else {
			data = PlayState.metadata;

			if (data != null) {
				texts.push(data.credits.music.join(', ') + ' - ' + data.card.name);
				if (data.credits.chart != null) texts.push('Chart: ' + data.credits.chart.join(', '));
				if (data.credits.art != null) texts.push('Art: ' + data.credits.art.join(', '));
				if (data.credits.code != null) texts.push('Code: ' + data.credits.code.join(', '));
				if (data.credits.va != null) texts.push('Voice Acting: ' + data.credits.va.join(', '));
			}
		}

		if (WeeklyMainMenuState.marathon == true){
			texts.push('\nMarathon');
			texts.push('\nSongs: ' + (WeeklyMainMenuState.marathonWeek + 1) + '/' + WeeklyMainMenuState.songAmount);
			texts.push('\nScore: ' + (PlayState.campaignScore + PlayState.songMarScore));
			texts.push('\nMisses: ' + (PlayState.campaignMisses + PlayState.songMarMisses));
			if (WeeklyMainMenuState.yaySeed == '')
				texts.push('\nSeed: ' + WeeklyMainMenuState.buddySeed);
			else
				texts.push('\nSeed: ' + WeeklyMainMenuState.yaySeed);
		}
		else
			texts.push('\nBlueballed: ' + PlayState.deathCounter);

		var index:Int = 0;
		for (text in texts) {
			var newTxt:FlxText = new FlxText();
			newTxt.text = text;
			newTxt.scrollFactor.set();
			newTxt.setFormat(Paths.font("vcr.ttf"), 26);
			newTxt.updateHitbox();
			newTxt.x = cam.width - (newTxt.width + 20);
			newTxt.y = 20 * (index - 1);
			add(newTxt);

			newTxt.alpha = 0;
			if (WeeklyMainMenuState.marathon == true)
				FlxTween.tween(newTxt, {alpha: 1, y: newTxt.y + 30 + (10 * index)}, 0.2, {ease: FlxEase.quartInOut, startDelay: 0.05 + (0.05 * index)});
			else
				FlxTween.tween(newTxt, {alpha: 1, y: newTxt.y + 30 + (10 * index)}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.1 + (0.2 * index)});

			index += 1;
		}

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		regenMenu();
		cameras = [cam];
		super.create();
	}

	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);
		if(skipTimeText != null && skipTimeTracker != null) updateSkipTextStuff();

		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		var daSelected:String = menuItems[curSelected];
		switch (daSelected)
		{
			case 'Skip Time':
				if (controls.UI_LEFT_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					curTime -= 1000;
					holdTime = 0;
				}
				if (controls.UI_RIGHT_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					curTime += 1000;
					holdTime = 0;
				}

				if(controls.UI_LEFT || controls.UI_RIGHT)
				{
					holdTime += elapsed;
					if(holdTime > 0.5)
					{
						curTime += 45000 * elapsed * (controls.UI_LEFT ? -1 : 1);
					}

					if(curTime >= FlxG.sound.music.length) curTime -= FlxG.sound.music.length;
					else if(curTime < 0) curTime += FlxG.sound.music.length;
					updateSkipTimeText();
				}
		}

		if (controls.ACCEPT)
		{
			if (menuItems == difficultyChoices)
			{
				if(menuItems.length - 1 != curSelected && difficultyChoices.contains(daSelected)) {
					var name:String = PlayState.SONG.song;
					var poop = Highscore.formatSong(name, curSelected);
					PlayState.SONG = Song.loadFromJson(poop, name);
					PlayState.storyDifficulty = curSelected;
					MusicBeatState.resetState();
					FlxG.sound.music.volume = 0;
					PlayState.changedDifficulty = true;
					PlayState.chartingMode = false;
					skipTimeTracker = null;

					if(skipTimeText != null)
					{
						skipTimeText.kill();
						remove(skipTimeText);
						skipTimeText.destroy();
					}
					skipTimeText = null;
					return;
				}

				menuItems = menuItemsOG;
				regenMenu();
			}

			switch (daSelected)
			{
				case 'Options':
					PlayState.instance.paused = true; // For lua
					PlayState.instance.vocals.volume = 0;
					MusicBeatState.switchState(new OptionsState());
					if(ClientPrefs.pauseMusic != 'None')
					{
						FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)), pauseMusic.volume);
						FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);
						FlxG.sound.music.time = pauseMusic.time;
					}
					OptionsState.onPlayState = true;
				case "Resume":
					close();
				case 'Change Difficulty':
					menuItems = difficultyChoices;
					regenMenu();
				case 'Toggle Practice Mode':
					PlayState.instance.practiceMode = !PlayState.instance.practiceMode;
					PlayState.changedDifficulty = true;
					practiceText.visible = PlayState.instance.practiceMode;
				case "Restart Song":

					restartSong();
				case "Leave Charting Mode":

					restartSong();
					PlayState.chartingMode = false;
				case 'Skip Time':
					if(curTime < Conductor.songPosition)
					{
						PlayState.startOnTime = curTime;
						restartSong(true);
					}
					else
					{
						if (curTime != Conductor.songPosition)
						{
							PlayState.instance.clearNotesBefore(curTime);
							PlayState.instance.setSongTime(curTime);
						}
						close();
					}
				case "End Song":
					close();
					PlayState.instance.finishSong(true);
				case 'Toggle Botplay':
					PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;
					PlayState.changedDifficulty = true;
					PlayState.instance.botplayTxt.visible = PlayState.instance.cpuControlled;
					PlayState.instance.botplayTxt.alpha = 1;
					PlayState.instance.botplaySine = 0;
				case "Exit to menu":
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;
					#if HIT_SINGLE
					HitSingleMenu.currentMode = FREEPLAY;
					Init.SwitchToPrimaryMenu();
					#else
					Init.SwitchToPrimaryMenu(PlayState.isStoryMode ? WeeklyMainMenuState : FreeplayState);
					#end
					PlayState.cancelMusicFadeTween();
					FlxG.sound.playMusic(Paths.music(KUTValueHandler.getMenuMusic()));
					PlayState.changedDifficulty = false;
					PlayState.chartingMode = false;
				case "Exit to menu(Won't save!!!)":
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;
					#if HIT_SINGLE
					HitSingleMenu.currentMode = FREEPLAY;
					Init.SwitchToPrimaryMenu();
					#else
					Init.SwitchToPrimaryMenu(PlayState.isStoryMode ? WeeklyMainMenuState : FreeplayState);
					#end
					PlayState.cancelMusicFadeTween();
					FlxG.sound.playMusic(Paths.music(KUTValueHandler.getMenuMusic()));
					PlayState.changedDifficulty = false;
					PlayState.chartingMode = false;
			}
		}
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		}
		else
		{
			MusicBeatState.resetState();
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		curSelected = FlxMath.wrap(curSelected + change,0,menuItems.length-1);

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));

				if(item == skipTimeTracker)
				{
					curTime = Math.max(0, Conductor.songPosition);
					updateSkipTimeText();
				}
			}
		}
	}

	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			var obj = grpMenuShit.members[0];
			obj.kill();
			grpMenuShit.remove(obj, true);
			obj.destroy();
		}

		for (i in 0...menuItems.length) {
			var item = new Alphabet(0, 70 * i + 30, menuItems[i], true, false);
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);

			if(menuItems[i] == 'Skip Time')
			{
				skipTimeText = new FlxText(0, 0, 0, '', 64);
				skipTimeText.setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				skipTimeText.scrollFactor.set();
				skipTimeText.borderSize = 2;
				skipTimeTracker = item;
				add(skipTimeText);

				updateSkipTextStuff();
				updateSkipTimeText();
			}
		}
		curSelected = 0;
		changeSelection();
	}

	function updateSkipTextStuff()
	{
		if(skipTimeText == null || skipTimeTracker == null) return;

		skipTimeText.x = skipTimeTracker.x + skipTimeTracker.width + 60;
		skipTimeText.y = skipTimeTracker.y;
		skipTimeText.visible = (skipTimeTracker.alpha >= 1);
	}

	function updateSkipTimeText()
	{
		skipTimeText.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
	}

	function deleteSkipTimeText()
	{
		if(skipTimeText != null)
		{
			skipTimeText.kill();
			remove(skipTimeText);
			skipTimeText.destroy();
		}
		skipTimeText = null;
		skipTimeTracker = null;
	}
}
