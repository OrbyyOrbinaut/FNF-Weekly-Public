package meta.states; 

#if desktop
import meta.data.Discord.DiscordClient;
#end
import flixel.*;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import gameObjects.*;
import meta.data.WeekData;
import meta.data.*;
import meta.data.Discord.DiscordClient;
import meta.data.options.*;
import meta.states.*;
import meta.states.editors.*;
import meta.states.editors.*;
import meta.states.editors.MasterEditorMenu;
// I'm ngl this whole state is kind of a mess since i had to do it in a day and a half so sorry if this shit is weird
using StringTools;

class WeeklyMainMenuState extends MusicBeatState
{
	// This is our current version dont forget to change it when compiling releases
	public static var psychEngineVersion:String = 'Tweak 9'; //MAKE SURE THIS IS UP TO DATE SINCE IT MATTERS FOR AUTO UPDATING !!!!
	//public static var curSelected:Int = 0;
	var canClick:Bool = true;
	var norbertcanIdle:Bool = false; // dumb and gay my b

	var optionGrp:Null<FlxTypedGroup<FlxSprite>> = null;
	var options:Array<String> = [
		'freeplay',
		'credits',
		'options',
		'left', // arrows that change the week you have selected
		'right',
		'play' // basically story mode
	];

	//var debugKeys:Array<FlxKey>;
	var fwlogo:FlxSprite;
	var norbert:FlxSprite;

	private static var curWeek:Int = 0;
	var loadedWeeks:Array<WeekData> = [];
	var weeklogo:FlxSprite;
	private static var lastDifficultyName:String = '';
	var curDifficulty:Int = 1;
	var txtTracklist:FlxText;
	var scoreText:FlxText;
	var newsTxt1:FlxText;
	var newsTxt2:FlxText;
	var tweakTxt:FlxText;

	override function create()
	{
		FlxG.mouse.visible = true;

		Conductor.changeBPM(102);
		trace(Conductor.bpm);

		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		PlayState.isStoryMode = true;
		WeekData.reloadWeekFiles(true);
		if(curWeek >= WeekData.weeksList.length) curWeek = 0;

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		//debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var num:Int = 0;
		for (i in 0...WeekData.weeksList.length)
		{
			var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			loadedWeeks.push(weekFile);
			WeekData.setDirectoryFromWeek(weekFile);
			num++;
		}

		WeekData.setDirectoryFromWeek(loadedWeeks[0]);

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));

		
		var bg = new FlxSprite(-7, -9).loadGraphic(Paths.image('mainmenu/bg'));
        bg.antialiasing = ClientPrefs.globalAntialiasing;
        add(bg);

		txtTracklist = new FlxText(872, 63, "", 25);
        txtTracklist.alignment = LEFT;
		txtTracklist.font = "VCR OSD Mono";
		txtTracklist.color = 0xffffffff;
		txtTracklist.antialiasing = ClientPrefs.globalAntialiasing;
		add(txtTracklist);

		tweakTxt = new FlxText(1110, 63, "TWEAK 0", 25);
        tweakTxt.alignment = RIGHT;
		tweakTxt.font = "VCR OSD Mono";
		tweakTxt.color = 0xffffffff;
		tweakTxt.antialiasing = ClientPrefs.globalAntialiasing;
		add(tweakTxt);

		scoreText = new FlxText(872, 63, "", 25);
		scoreText.alignment = LEFT;
		scoreText.font = "VCR OSD Mono";
		scoreText.color = 0xffffffff;
		scoreText.antialiasing = ClientPrefs.globalAntialiasing;
		add(scoreText);

		weeklogo = new FlxSprite(170, 180).loadGraphic(Paths.image('mainmenu/logos/weeklogo'));
        weeklogo.antialiasing = ClientPrefs.globalAntialiasing;
        add(weeklogo);

		norbert = new FlxSprite(-100, 247);
		norbert.frames = Paths.getSparrowAtlas("mainmenu/norbert");
        norbert.antialiasing = ClientPrefs.globalAntialiasing;
		norbert.updateHitbox();
		norbert.animation.addByPrefix('intro', 'norbert intro0', 24, false);
		norbert.animation.addByPrefix('idle', 'norbert idle0', 24, false);
		norbert.animation.addByPrefix('start', 'norbert start0', 24, false);
		norbert.visible = false;
		add(norbert);
		new FlxTimer().start(0.50, function(tmr:FlxTimer)
			{
				norbert.visible = true;
				norbert.animation.play('intro');
				norbert.animation.finishCallback = (name:String = 'intro')->{
				if(norbert.animation.curAnim.name == 'intro') //If theres a better way to handle this lmk but i think this is better than checking on every beat hit
					{
						norbertcanIdle = true;
						trace('callback');
					}	
				}
			});

		var bar = new FlxSprite().makeGraphic(1233, 141, FlxColor.BLACK);
		bar.screenCenter(X);
		bar.y = 553.45;
		add(bar);

		newsTxt1 = new FlxText(1060, 562, "BREAKING NEWS!!! BREAKING NEWS!!! ", 40);
		newsTxt1.alignment = LEFT;
		newsTxt1.font = "VCR OSD Mono";
		newsTxt1.color = 0xffffffff;
		newsTxt1.antialiasing = ClientPrefs.globalAntialiasing;
		add(newsTxt1);
		FlxTween.tween(newsTxt1, {x: -734}, 4.25, {type: LOOPING}); 

		newsTxt2 = new FlxText(40, 562, "BREAKING NEWS!!! BREAKING NEWS!!! ", 40);
		newsTxt2.alignment = LEFT;
		newsTxt2.font = newsTxt1.font;
		newsTxt2.color = 0xffc25656;
		newsTxt2.antialiasing = ClientPrefs.globalAntialiasing;
		newsTxt2.color = newsTxt1.color;
		newsTxt2.x = newsTxt1.x;
		add(newsTxt2);
		FlxTween.tween(newsTxt2, {x: -734}, 4.25, {startDelay: 2.0, type: LOOPING}); 

		var border = new FlxSprite(-19, -23).loadGraphic(Paths.image('mainmenu/border'));
        border.antialiasing = ClientPrefs.globalAntialiasing;
        add(border);

		fwlogo = new FlxSprite(17.4, 498);
		fwlogo.frames = Paths.getSparrowAtlas("mainmenu/weeklylogo");
        fwlogo.antialiasing = ClientPrefs.globalAntialiasing;
		fwlogo.updateHitbox();
		fwlogo.animation.addByPrefix('idle', 'logobop0', 24, false);
		add(fwlogo);

		optionGrp = new FlxTypedGroup<FlxSprite>();
        for(i in 0...options.length){
            var button = new FlxSprite();
            button.frames = Paths.getSparrowAtlas('mainmenu/button_${options[i]}');
            button.animation.addByPrefix('idle', '${options[i]}0', 24, false);
            button.animation.addByPrefix('hover', '${options[i]} hover0', 24, false);
            button.x = optionGrp.members[i - 1] != null ? optionGrp.members[i - 1].x + 262 : 44;
			button.y = 41;
            button.antialiasing = ClientPrefs.globalAntialiasing;
            button.ID = i;
			button.updateHitbox();
            optionGrp.add(button);
        }
        add(optionGrp);

		optionGrp.members[3].x = 60;
		optionGrp.members[3].y = 224;
		optionGrp.members[4].x = 729;
		optionGrp.members[4].y = optionGrp.members[3].y;
		optionGrp.members[5].x = 1046;
		optionGrp.members[5].y = 491;

		changeWeek();
		super.create();
	}

	override function beatHit()
	{
		super.beatHit();

		fwlogo.animation.play('idle', true);

		if(norbertcanIdle)
		{
			norbert.offset.set(-1013, -3);
			norbert.animation.play('idle', true);
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 30, 0, 1)));
		if(Math.abs(intendedScore - lerpScore) < 10) lerpScore = intendedScore;

		scoreText.text = "SCORE:" + lerpScore;

		if (FlxG.sound.music != null)
		Conductor.songPosition = FlxG.sound.music.time;

		@:privateAccess
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}
		if (optionGrp != null) {
			for(i in optionGrp.members){ 
				if(FlxG.mouse.overlaps(i)){
					i.animation.play('hover');
					if(FlxG.mouse.justPressed && canClick) selectOption(i.ID);
				}else{
					i.animation.play('idle');
				}
			}

			// if(controls.UI_LEFT_P)
			// {
			// 	if(canClick) selectOption(optionGrp.members[3].ID);
			// }
			// if(controls.UI_RIGHT_P)
			// {
			// 	if(canClick) selectOption(optionGrp.members[4].ID);
			// }
			// if(controls.ACCEPT)
			// {
			// 	if(canClick) selectOption(optionGrp.members[5].ID);
			// }
		}

		if (controls.BACK)
		{
			canClick = false;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new TitleState());
		}
	}
	
	function selectOption(id:Int){
		canClick = false;
		switch(options[id]){
			case 'play':
				selectWeek();
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxG.mouse.visible = false;
				norbertcanIdle = false;
				norbert.offset.set(-970, -8);
				norbert.animation.play('start', true);
			case 'freeplay':
				MusicBeatState.switchState(new FreeplayState());
				FlxG.sound.play(Paths.sound('scrollMenu'));
				FlxG.mouse.visible = false;
			case 'options':
				LoadingState.loadAndSwitchState(new meta.data.options.OptionsState());
				FlxG.sound.play(Paths.sound('scrollMenu'));
				FlxG.mouse.visible = false;
				OptionsState.onPlayState = false;
			case 'credits':
				MusicBeatState.switchState(new CreditsState());
				FlxG.sound.play(Paths.sound('scrollMenu'));
				FlxG.mouse.visible = false;
			case 'left':
				changeWeek(-1);
				canClick = true;
			case 'right':
				changeWeek(1);
				canClick = true;
		}
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	
	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= loadedWeeks.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = loadedWeeks.length - 1;

		trace(curWeek);		

		var leWeek:WeekData = loadedWeeks[curWeek];
		WeekData.setDirectoryFromWeek(leWeek);

		var bullShit:Int = 0;

		weeklogo.visible = true;
		var assetName:String = leWeek.weeklogo;
		if(assetName == null || assetName.length < 1) {
			weeklogo.visible = false;
		} else {
			weeklogo.loadGraphic(Paths.image('mainmenu/logos/' + assetName));
		}
		PlayState.storyWeek = curWeek;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
		updateText();
	}

	var selectedWeek:Bool = false;

	function selectWeek()
	{

		var songArray:Array<String> = [];
		var leWeek:Array<Dynamic> = loadedWeeks[curWeek].songs;
		for (i in 0...leWeek.length) {
			songArray.push(leWeek[i][0]);
		}

		// Nevermind that's stupid lmao
		PlayState.storyPlaylist = songArray;
		PlayState.isStoryMode = true;
		selectedWeek = true;

		var diffic = CoolUtil.getDifficultyFilePath(curDifficulty);
		if(diffic == null) diffic = '';

		PlayState.storyDifficulty = curDifficulty;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
		PlayState.campaignScore = 0;
		PlayState.campaignMisses = 0;
		new FlxTimer().start(0.75, function(tmr:FlxTimer)
		{
			LoadingState.loadAndSwitchState(new PlayState(), true);
			FreeplayState.destroyFreeplayVocals();
		});
	}

	function updateText()
	{
		var leWeek:WeekData = loadedWeeks[curWeek];
		var stringThing:Array<String> = [];
		stringThing.push('TRACK LIST:');
		for (i in 0...leWeek.songs.length) {
			stringThing.push(leWeek.songs[i][0]);
		}

		if(curWeek == 6) // So it displays as "666"
		{
			tweakTxt.text = 'TWEAK 666';
			tweakTxt.x = 1110 - 30;
		}
		else
		{
			tweakTxt.text = 'TWEAK $curWeek';
			tweakTxt.x = 1110;
		}
		tweakTxt.updateHitbox();

		txtTracklist.text = '';
		for (i in 0...stringThing.length)
		{
			txtTracklist.text += stringThing[i] + '\n';
		}

		txtTracklist.text = txtTracklist.text;
		txtTracklist.updateHitbox();

		scoreText.y = txtTracklist.height + 60;

		#if !switch
		intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		#end
	}
}