package meta.states; 

import gameObjects.shader.Shaders.FuckingTriangleEffect;
import meta.states.substate.MarathonButtonsSubstate;
import hscript.Bytes;
import haxe.io.Bytes;
#if desktop
import meta.data.Discord.DiscordClient;
#end
import flixel.*;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import meta.states.substate.FadeTransitionSubstate;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIInputText;
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
	public static var psychEngineVersion:String = 'Tweak 10'; //MAKE SURE THIS IS UP TO DATE SINCE IT MATTERS FOR AUTO UPDATING !!!!
	//public static var curSelected:Int = 0;
	var canClick:Bool = true;
	var norbertcanIdle:Bool = false; // dumb and gay my b
	var inTransiton:Bool = false;

	var optionGrp:FlxTypedGroup<FlxSprite> = null;
	var coins:Null<FlxTypedGroup<FlxSprite>> = null;
	var options:Array<String> = [
		'freeplay',
		'marathon',
		'more', // Gallery + Credits
		'left', // arrows that change the week you have selected
		'right',
		'play', // basically story mode
		'options',
		'fc', // For marathon mode
		'reset' // For marathon mode
	];

	//var debugKeys:Array<FlxKey>;
	var norbert:FlxSprite;
	var coin:FlxSprite;
	var staticSprite:FlxSprite;
	var border:FlxSprite;
	var bar:FlxSprite;
	var bg:FlxSprite;
	var fakeEna:FlxSprite;

	private static var curWeek:Int = 0;
	var loadedWeeks:Array<WeekData> = [];
	var weeklogo:FlxSprite;
	private static var lastDifficultyName:String = '';
	var curDifficulty:Int = 1;
	// Text
	var txtTracklist:FlxText;
	var scoreText:FlxText;
	var newsTxt1:FlxText;
	var newsTxt2:FlxText;
	var tweakTxt:FlxText;
	var seedTxt:FlxText;
	var seedInput:FlxUIInputText;

	var imagePrefix:String = 'mainmenu/'; // Gets changed to 'mainmenu/gold/' when gold mode is on. Just makes it so we dont need to check everytime we change an image for a gold version
	// Marathon mode stuff
	var easterSeeds:Array<String> = ['weekly', 'goodluck', 'abc', 'cba', 'johnny', 'communitygame', 'lore', 'cloverderus', 'jammy', 'ito', 'maddie', 'krea', 'leth', 'crossknife', 'niffirg', 'kloogy', 'kat', 'dtwo', 'jam', 'kino', 'mocha', 'alpha', 'star', 'dollie', 'basil', 'biddle', 'scrumbo', 'loggo', 'ava', 'kye', 'srife', '909189', 'penkaru'];
	public static var marathon:Bool = false;
	public static var fcMode:Bool;
	public static var weekArray:Array<Int> = [];
	public static var marathonWeek:Int = 0;
	public static var marathonArray:Array<String> = [];
	public static var songAmount:Int = 56;
	public static var yaySeed:String = '';
	public static var buddySeed:Int;

	override function create()
	{
		marathon = false;
		weekArray = [];
		marathonWeek = 0;
		marathonArray = [];
		FlxG.mouse.visible = true;

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

		if(ClientPrefs.gold == true)
		{
			imagePrefix = 'mainmenu/gold/';
		}
		
		var fakestageBG = new FlxSprite(-1357, -739).loadGraphic(Paths.image('mainmenu/newsSet/bg'));
        fakestageBG.antialiasing = ClientPrefs.globalAntialiasing;
        add(fakestageBG);

		var lights = new FlxSprite(-1345.15, -852.55).loadGraphic(Paths.image('mainmenu/newsSet/lights'));
        lights.antialiasing = ClientPrefs.globalAntialiasing;
        add(lights);

		bg = new FlxSprite(-7, -9).loadGraphic(Paths.image(imagePrefix + 'bg'));
        bg.antialiasing = ClientPrefs.globalAntialiasing;
        add(bg);

		coins = new FlxTypedGroup<FlxSprite>();
		add(coins);

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

		staticSprite = new FlxSprite(168, 181.2);
		staticSprite.frames = Paths.getSparrowAtlas('mainmenu/logos/static');
        staticSprite.antialiasing = ClientPrefs.globalAntialiasing;
		staticSprite.animation.addByPrefix('static', 'static0', 24, true);
		staticSprite.animation.addByPrefix('change', 'static change0', 24, false);
		staticSprite.animation.addByPrefix('change end', 'static change0', 24, false); //Lazyyyy
		staticSprite.visible = false;
		add(staticSprite);

		norbert = new FlxSprite(-100, 247);
		norbert.frames = Paths.getSparrowAtlas(imagePrefix + 'norbert');
        norbert.antialiasing = ClientPrefs.globalAntialiasing;
		norbert.updateHitbox();
		norbert.animation.addByPrefix('intro', 'intro', 24, false);
		norbert.animation.addByPrefix('idle', 'idle', 24, false);
		norbert.animation.addByPrefix('idle-alt', 'alt', 24, false);
		norbert.animation.addByPrefix('start', 'start', 24, false);
		norbert.animation.addByPrefix('transition', 'trans', 24, false);
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

		var counter = new FlxSprite(223.1, 566.1).loadGraphic(Paths.image('mainmenu/newsSet/counter'));
        counter.antialiasing = ClientPrefs.globalAntialiasing;
        add(counter);

		var fakeBF:FlxSprite = new FlxSprite(1300, 700).loadGraphic(Paths.image('mainmenu/newsSet/fakeBF'));
        fakeBF.antialiasing = ClientPrefs.globalAntialiasing;
        add(fakeBF);

		var fakegf:FlxSprite = new FlxSprite(526, 607).loadGraphic(Paths.image('mainmenu/newsSet/goatGF'));
		fakegf.antialiasing = ClientPrefs.globalAntialiasing;
		add(fakegf);

		fakeEna = new FlxSprite(-175, 375).loadGraphic(Paths.image('mainmenu/newsSet/fakeEna'));
        fakeEna.antialiasing = ClientPrefs.globalAntialiasing;
		fakeEna.alpha = 0;
        add(fakeEna);

		bar = new FlxSprite().makeGraphic(1233, 141);
		bar.color = ClientPrefs.gold ? 0xFFC05B1B : FlxColor.BLACK;
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

		
		border = new FlxSprite(-19, -23);
		border.loadGraphic(Paths.image(imagePrefix + 'border'));
        border.antialiasing = ClientPrefs.globalAntialiasing;
        add(border);

		optionGrp = new FlxTypedGroup<FlxSprite>();
        for(i in 0...options.length){
            var button = new FlxSprite();

			if (i == 7)
			{
				button.frames = Paths.getSparrowAtlas('mainmenu/button_${options[i]}');
				button.animation.addByPrefix('idleon', 'on0', 24, false);
            	button.animation.addByPrefix('hoveron', 'on hover0', 24, false);
				button.animation.addByPrefix('idleoff', 'off0', 24, false);
            	button.animation.addByPrefix('hoveroff', 'off hover0', 24, false);
			}
			else
			{
				if (i == 8)
				{
					button.frames = Paths.getSparrowAtlas('mainmenu/button_${options[i]}');
				}
				else
				{
					button.frames = Paths.getSparrowAtlas(imagePrefix + 'button_${options[i]}');
				}
				button.animation.addByPrefix('idle', '${options[i]}0', 24, false);
           	 	button.animation.addByPrefix('hover', '${options[i]} hover0', 24, false);
			}
            button.x = optionGrp.members[i - 1] != null ? optionGrp.members[i - 1].x + 262 : 44;
			button.y = 41;
            button.antialiasing = ClientPrefs.globalAntialiasing;
            button.ID = i;
			button.updateHitbox();
            optionGrp.add(button);
        }
        add(optionGrp);

		seedTxt = new FlxText(750, 604, "Input a custom seed" + '\nLeave blank for' + '\na random one', 22);
		seedTxt.alignment = LEFT;
		seedTxt.font = "VCR OSD Mono";
		seedTxt.color = 0xffffffff;
		seedTxt.antialiasing = ClientPrefs.globalAntialiasing;
		add(seedTxt);

		seedInput = new FlxUIInputText(seedTxt.x, 671, 100, "");
		add(seedInput);

		optionGrp.members[3].x = 60; //left arrow
		optionGrp.members[3].y = 224;
		optionGrp.members[4].x = 729; //right arrow
		optionGrp.members[4].y = optionGrp.members[3].y;
		optionGrp.members[5].x = 1046; //play
		optionGrp.members[5].y = 491;
		optionGrp.members[6].x = -70; //options
		optionGrp.members[6].y = 550;
		optionGrp.members[7].x = 220; //fc
		optionGrp.members[7].y = 605;
		optionGrp.members[8].x = optionGrp.members[7].x + 262; //reset
		optionGrp.members[8].y = optionGrp.members[7].y;

		optionGrp.members[7].visible = optionGrp.members[7].active = false;
		optionGrp.members[8].visible = optionGrp.members[8].active = false;
		
		seedTxt.visible = seedTxt.active = false;
		seedInput.visible = seedInput.active = false;

		changeWeek();
		super.create();

		Conductor.changeBPM(102);
		Conductor.bpmChangeMap = []; //So the BPMChangeMap is never fucking cleared after a song is over for what god damn reason i have no idea but it seems thats the case
	}

	var lastBeatHit:Int = -1;
	override function beatHit()
	{
		super.beatHit();

		if(lastBeatHit >= curBeat) {
			//trace('BEAT HIT: ' + curBeat + ', LAST HIT: ' + lastBeatHit);
			return;
		}

		if(norbertcanIdle)
		{
			norbert.offset.set(-1013, -4);
			norbert.animation.play('idle', true);
		}

		lastBeatHit = curBeat;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.RESET)
		{
			//Highscore.saveMarathonWins(1);
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 30, 0, 1)));
		if(Math.abs(intendedScore - lerpScore) < 10) lerpScore = intendedScore;

		lerpMarathonScore = Math.floor(FlxMath.lerp(lerpMarathonScore, intendedMarathonScore, CoolUtil.boundTo(elapsed * 30, 0, 1)));
		if(Math.abs(intendedMarathonScore - lerpMarathonScore) < 10) lerpMarathonScore = intendedMarathonScore;

		if (!marathon)
			scoreText.text = "SCORE:" + lerpScore;
		else
		{
			txtTracklist.text = 'WINS:' + Highscore.getMarathonWins() + 
			'\nHIGHSCORE:' + lerpMarathonScore + 
			'\nSONGS:' + Highscore.getMarathonSongs() + 
			'\nDEATHS:' + Highscore.getMarathonDeaths() + 
			'\n' + 
			'\nAll songs are randomized' + 
			'\n' + 
			'\nIf you die your stats are' +
			'\nsaved and you start over.' + 
			'\nReset button is disabled';
			scoreText.text = "";
			tweakTxt.text = "";
		}

		if (FlxG.sound.music != null)
		Conductor.songPosition = FlxG.sound.music.time;

		@:privateAccess
		if (FlxG.sound.music.volume < 0.8 && inTransiton == false)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (optionGrp != null) {
			for(i in optionGrp.members){ 
				if(FlxG.mouse.overlaps(i) && canClick){ //if hovering over a button
					if (i == optionGrp.members[7]){ //if button is fc mode
						if (fcMode == true)
							optionGrp.members[7].animation.play('hoveron');
						else
							optionGrp.members[7].animation.play('hoveroff');
						if(FlxG.mouse.justPressed && canClick) selectOption(i.ID);
					}
					else{ //if button is not fc mode
					i.animation.play('hover');
					if(FlxG.mouse.justPressed && canClick) selectOption(i.ID);
					}
				}else{ //if not hovering over a button
					if (i == optionGrp.members[7]) //if button is fc mode
						if (fcMode == true)
							optionGrp.members[7].animation.play('idleon');
						else
							optionGrp.members[7].animation.play('idleoff');
					else //if button is not fc mode
					i.animation.play('idle');
				}
			}

			if (marathon == true)
			{
				optionGrp.members[1].animation.play('hover');
			}
		}

		if (controls.BACK && inTransiton == false)
		{
			if (!seedInput.hasFocus){
				canClick = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}
		}
	}
	
	function selectOption(id:Int){
		canClick = false;
		switch(options[id]){
			case 'play':
				if (marathon)
				{
					marathonMode();
					normalSelect();
				}
				else if (curWeek == 10)
				{
					tweak10Select();
					inTransiton = true;
				}
				else
				{
					normalSelect();
					selectWeek();
				}	
			case 'freeplay':
				MusicBeatState.switchState(new FreeplayState());
				marathon = false;
				FlxG.sound.play(Paths.sound('scrollMenu'));
				FlxG.mouse.visible = false;
			case 'options':
				LoadingState.loadAndSwitchState(new meta.data.options.OptionsState());
				FlxG.sound.play(Paths.sound('scrollMenu'));
				FlxG.mouse.visible = false;
				OptionsState.onPlayState = false;
			case 'left':
				changeWeek(-1);
				canClick = true;
				FlxG.sound.play(Paths.sound('scrollMenu'));
			case 'right':
				changeWeek(1);
				canClick = true;
				FlxG.sound.play(Paths.sound('scrollMenu'));
			case 'marathon':
				switch(marathon){
					case true:
						updateMarathon(false);
					case false:
						updateMarathon(true);
				}
				updateText();
				canClick = true;
				trace(marathon);
			case 'fc':
				if (optionGrp.members[7].active == true){
					switch(fcMode){
						case true:
							fcMode = false;
						case false:
							fcMode = true;
					}
					trace(fcMode);
				}
				canClick = true;
			case 'reset':
				if (optionGrp.members[8].active == true){
					openSubState(new MarathonButtonsSubstate(0));
				}
				canClick = true;
			case 'more':
				MusicBeatState.switchState(new WeeklyGalleryState()); //FuckingTriangleEffect
				FlxG.sound.play(Paths.sound('scrollMenu'));
				FlxG.mouse.visible = true;
		}
	}

	function normalSelect()
	{
		if (easterSeeds.contains(yaySeed) && marathon == true)
			FlxG.sound.play(Paths.sound('easter'));
		else
			FlxG.sound.play(Paths.sound('confirmMenu'));
		FlxG.mouse.visible = false;
		norbertcanIdle = false;
		norbert.offset.set(-970, -9);
		norbert.animation.play('start', true);
	}

	function tweak10Select()
	{
		FadeTransitionSubstate.tweak10 = true;
		FlxG.sound.play(Paths.sound('tweak10intro'));
		staticSprite.visible = true;
		FlxG.mouse.visible = false;
		weeklogo.visible = false;
		FlxG.sound.music.volume = 0;
		staticSprite.animation.play('change', true);
		staticSprite.animation.finishCallback = (name:String = 'intro')->{
		if(staticSprite.animation.curAnim.name == 'change') //If theres a better way to handle this lmk but i think this is better than checking on every beat hit
			{
				staticSprite.animation.play('static', true);
			}	
		else if(staticSprite.animation.curAnim.name == 'change end') //If theres a better way to handle this lmk but i think this is better than checking on every beat hit
			{
				staticSprite.visible = false;
			}	
		}
		new FlxTimer().start(0.35, function(tmr:FlxTimer)
		{
			norbertcanIdle = false;
			norbert.offset.set(-983, 9);
			norbert.animation.play('transition', true);
		});
		FlxTween.tween(FlxG.camera, {zoom: 0.35}, 2.25, {ease: FlxEase.expoInOut, startDelay: 2.5});   
		optionGrp.forEach(function(obj:FlxSprite)
		{
			FlxTween.tween(obj, {alpha: 0}, 1, {ease: FlxEase.expoInOut, startDelay: 2.5});  
		});
		FlxTween.tween(border, {alpha: 0}, 1, {ease: FlxEase.expoInOut, startDelay: 2.5}); 
		FlxTween.tween(bar, {alpha: 0}, 1, {ease: FlxEase.expoInOut, startDelay: 2.5}); 
		FlxTween.tween(bg, {alpha: 0}, 1, {ease: FlxEase.expoInOut, startDelay: 2.5}); 
		FlxTween.tween(newsTxt1, {alpha: 0}, 1, {ease: FlxEase.expoInOut, startDelay: 2.5}); 
		FlxTween.tween(newsTxt2, {alpha: 0}, 1, {ease: FlxEase.expoInOut, startDelay: 2.5}); 
		FlxTween.tween(scoreText, {alpha: 0}, 1, {ease: FlxEase.expoInOut, startDelay: 2.5}); 
		FlxTween.tween(tweakTxt, {alpha: 0}, 1, {ease: FlxEase.expoInOut, startDelay: 2.5}); 
		FlxTween.tween(txtTracklist, {alpha: 0}, 1, {ease: FlxEase.expoInOut, startDelay: 2.5}); 
		FlxTween.tween(fakeEna, {alpha: 1}, 1, {ease: FlxEase.expoInOut, startDelay: 2.5}); 
		new FlxTimer().start(4.75, function(tmr:FlxTimer)
		{
			staticSprite.animation.play('change end', true);
		});
		new FlxTimer().start(5.0, function(tmr:FlxTimer)
		{
			selectWeek();
		});
	}

	var lerpScore:Int = 0;
	var lerpMarathonScore:Int = 0;
	var intendedScore:Int = 0;
	var intendedMarathonScore:Int = 0;
	
	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= loadedWeeks.length - 1)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = loadedWeeks.length - 2;

		trace(curWeek);		

		var leWeek:WeekData = loadedWeeks[curWeek];
		WeekData.setDirectoryFromWeek(leWeek);

		var bullShit:Int = 0;

		weeklogo.visible = true;
		var assetName:String = leWeek.weeklogo;
		if(assetName == null || assetName.length < 1) {
			weeklogo.visible = false;
		} else {
			if (!marathon) {
				weeklogo.loadGraphic(Paths.image('mainmenu/logos/' + assetName));
			}
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
		if (!marathon)
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

	function marathonMode()
	{
		marathon = true;
		marathonArray = [];
		weekArray = [];
		yaySeed = '';
		var ahh:String = '';
		var pos:Int;
		var name:String;
		var week:Int;
		var numbers:Array<Int> = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57];
		var songsArray:Array<String> = [];

		for (i in 0...WeekData.weeksList.length)
		{
			var leWeek:WeekData = loadedWeeks[i];

			for (j in 0...leWeek.songs.length)
			{
				marathonArray.push(leWeek.songs[j][0]);
				weekArray.push(i);
			}
		}

		yaySeed = StringTools.replace(seedInput.text, " ", "");
		trace(yaySeed);

		for (i in 0...yaySeed.length) {
			if (numbers.contains(yaySeed.charCodeAt(i)))
				buddySeed = Std.parseInt(yaySeed.charAt(i));
			else{
				buddySeed = yaySeed.charCodeAt(i);
				buddySeed %= (11 * (i + 1) + i);
				if (buddySeed > 9)
					buddySeed %= 10;
			}
			ahh += Std.string(buddySeed);
			trace (ahh);
		}

		if (ahh.length > 9)
			buddySeed = Std.parseInt(ahh.substr(0, 9));
		else if (ahh.length < 9){
			ahh += 903948658903;
			buddySeed = Std.parseInt(ahh.substr(0, 9));
		}
		else{
			buddySeed = Std.parseInt(ahh);
		}

		var canShuffle:Bool = true;

		switch(yaySeed){
			case '':
				buddySeed = FlxG.random.currentSeed;
			case 'weekly':
				canShuffle = false;
			case 'goodluck':
				songsArray = ["Love Groove", "SIMUL4CRUM", "Champion's Ring", "Luminary Clock", "Teaking"];
			case 'abc':
				for (i in marathonArray)
					songsArray.push(i);
				haxe.ds.ArraySort.sort(songsArray, function(a:String, b:String):Int {a = a.toUpperCase(); b = b.toUpperCase(); if (a < b) {return -1;}else if (a > b) {return 1;}else {return 0;}});
			case 'cba':
				for (i in marathonArray)
					songsArray.push(i);
				haxe.ds.ArraySort.sort(songsArray, function(a:String, b:String):Int {a = a.toUpperCase(); b = b.toUpperCase(); if (a < b) {return 1;}else if (a > b) {return -1;}else {return 0;}});
			case 'johnny':
				songsArray = ["Johnny Round"];
			case 'communitygame':
				songsArray = ["Joink", "Philly Mice", "Haystack", "Busy Work"];
			case 'lore':
				songsArray = ["Boss Tweaks in Brasil", "Teaking", "Goo", "Visiosubrideophobia", "Joink", "Friends And Fellas", "Buds and Bluds"];
			case 'jammy':
				songsArray = ["Mental Temple", "Funky Flow"];
			case 'cloverderus':
				songsArray = ["Joink", "Koopa Karnage", "Spaceblasterz", "Mischief", "Funky Flow", "Devil's Ditty", "Brilliance", "Frauduccine", "Motivation", "Friends And Fellas", "7OF8", "Dangerous To Go Alone", "Johnny Round", "Crimson Fog", "Philly Mice", "Love Groove", "BOX24", "Lifeless", "Rock Bottom", "Perfect Girl", "Tenkaichi Battleworld"];
			case 'ito':
				songsArray = ["Dustloop", "Crimson Fog", "BOX24", "Beyond", "Tenkaichi Battleworld"];
			case 'maddie':
				songsArray = ["Pirate Indie Games", "Circus (Weekly Mix)", "Friends And Fellas", "Dustloop", "Devil's Ditty", "Koopa Karnage", "Undead", "Joink", "Johnny Round"];
			case 'krea':
				songsArray = ["Philly Mice", "Haystack", "Love Groove", "BOX24", "Evolution", "SIMUL4CRUM", "Perfect Girl", "Genre Null"];
			case 'leth':
				songsArray = ["Johnny Round", "Pirate Indie Games", "Spaceblasterz", "Off the Cuff", "CAN YOU HEAR ME", "Lifeless", "Circus (Weekly Mix)", "SIMUL4CRUM", "Beyond", "Friends And Fellas"];
			case 'crossknife':
				songsArray = ["Fruity", "Luminary Clock", "Parched", "jeff the kill you", "KB5K"];
			case 'niffirg':
				songsArray = ["Johnny Round", "Termina", "Mental Temple", "Champions Ring", "Transient Tribulation", "Good Will", "Doodlequest", "Silence Is Death", "Busy Work", "ScareFull", "Buds and Bluds"];
			case 'kloogy':
				songsArray = ["CAN YOU HEAR ME", "Silence Is Death", "SIMUL4CRUM", "Good Will", "Doodlequest", "Philly Mice", "Love Groove"];
			case 'kat':
				songsArray = ["Busy Work", "Rock Bottom", "Parched", "CAN YOU HEAR ME", "Crimson Fog", "Pirate Indie Games", "Pegging Arent I Hilarious", "Goo"];
			case 'dtwo':
				songsArray = ["Visiosubrideophobia", "Chef Blasting", "Koopa Karnage", "Spaceblasterz", "Philly Mice", "Champions Ring", "Off the Cuff", "Devil's Ditty", "Lifeless", "Doodlequest", "Evolution", "Circus (Weekly Mix)", "Beyond", "Buds and Bluds"];
			case 'jam':
				songsArray = ["Koopa Karnage", "Spaceblasterz", "Plectrum", "Funky Flow", "Doodlequest", "Frauduccine", "Rock Bottom", "Popular", "ScareFull"];
			case 'kino':
				songsArray = ["KB5K"];
			case 'mocha':
				songsArray = ["Joink", "Koopa Karnage", "Parched", "7OF8", "Frauduccine", "Genre Null"];
			case 'alpha':
				songsArray = ["SIMUL4CRUM", "Luminary Clock", "Joink", "Spaceblasterz", "Funky Flow", "Transient Tribulation", "BOX24", "Genre Null", "Tenkaichi Battleworld", "Friends And Fellas", "Teaking"];
			case 'star':
				songsArray = ["SIMUL4CRUM", "jeff the kill you", "KB5K"];
			case 'dollie':
				songsArray = ["Plectrum", "Chorale", "Good Will", "CAN YOU HEAR ME", "Brilliance", "Popular", "Syncopation"];
			case 'basil':
				songsArray = ["Teaking", "Goo", "Fruity", "Pirate Indie Games", "Haystack", "Transient Tribulation", "Love Groove", "jeff the kill you", "7OF8", "CAN YOU HEAR ME", "Brilliance", "Frauduccine", "Rock Bottom", "Motivation", "Popular", "ScareFull"];
			case 'biddle':
				songsArray = ["Dustloop", "Haystack", "Legend", "Rock Bottom", "Tenkaichi Battleworld"];
			case 'scrumbo':
				songsArray = ["7OF8", "Lifeless", "Dangerous To Go Alone", "ScareFull"];
			case 'loggo':
				songsArray = ["Teaking", "Pegging Arent I Hilarious", "Undead", "Mischief"];
			case 'ava':
				songsArray = ["Joink", "Koopa Karnage", "Champions Ring", "Love Groove", "Popular", "ScareFull", "Genre Null"];
			case 'kye':
				songsArray = ["Luminary Clock", "Crimson Fog", "Philly Mice", "Chorale", "Good Will", "Legend", "Perfect Girl", "Beyond", "Tenkaichi Battleworld"];
			case 'srife':
				songsArray = ["Joink", "Dustloop", "Mental Temple", "Plectrum", "Philly Mice", "Funky Flow", "Love Groove", "7OF8", "Evolution", "Rock Bottom", "Beyond", "Genre Null", "ScareFull"];
			case '909189':
				songsArray = ["Busy Work", "Beyond", "CAN YOU HEAR ME", "Haystack", "Luminary Clock", "Koopa Karnage"];
			case 'penkaru':
				songsArray = ["Chef Blasting", "Fruity", "Parched", "Frauduccine", "Dangerous To Go Alone"];
			case _: 
		}

		if(canShuffle) shuffleSeed();

		if (songsArray.length > 0){
			songsArray.reverse();
			for (i in songsArray) {
				pos = marathonArray.indexOf(i);
				week = weekArray[pos];

				marathonArray.remove(i);
				weekArray.splice(pos, 1); 

				marathonArray.insert(0, i);
				weekArray.insert(0, week);
			}
		}

		var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[weekArray[marathonWeek]]);
		WeekData.setDirectoryFromWeek(weekFile);

		trace(buddySeed);
		trace(marathonArray);
		trace(weekArray);

		if (yaySeed == 'bludthirsty' || yaySeed == 'Bludthirsty')
		{
			new FlxTimer().start(0.75, function(tmr:FlxTimer)
				{
					LoadingState.loadAndSwitchState(new ARGState(), true);
					FreeplayState.destroyFreeplayVocals();
				});
		}
		else
		{
			PlayState.storyPlaylist = marathonArray;
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
	}

	function shuffleSeed()
	{
		FlxG.random.currentSeed = buddySeed;
		FlxG.random.shuffle(marathonArray);
		FlxG.random.currentSeed = buddySeed;
		FlxG.random.shuffle(weekArray);
	}

	public function updateCoins()
	{
		if (coins != null){
			if (Highscore.getMarathonWins() > 0 && marathon == true){
				for (i in 0...Highscore.getMarathonWins()){
					coin = new FlxSprite(1150, 60).loadGraphic(Paths.image('mainmenu/bosscoin'));
					weeklogo.antialiasing = ClientPrefs.globalAntialiasing;
					coin.x -= (7 * i);
					coins.add(coin);
				}
			}
			else if (coins.countLiving() != -1){
				for (i in coins){
					i.destroy();
				}
				coins.clear();
			}
		}
	}

	function updateMarathon(mara:Bool)
	{
		if (mara == true){
			marathon = true;
			weeklogo.loadGraphic(Paths.image('mainmenu/logos/marathon'));
			FlxG.sound.play(Paths.sound('scrollMenu'));
			txtTracklist.size = 21;
			optionGrp.members[7].visible = optionGrp.members[7].active = true;
			optionGrp.members[8].visible = optionGrp.members[8].active = true;
			optionGrp.members[3].visible = optionGrp.members[3].active = false;
			optionGrp.members[4].visible = optionGrp.members[4].active = false;
			newsTxt1.text = "BREAKING NEWS!!! BREAKING NEWS!!! ";
			newsTxt1.text = "OH GOD!!! OH GOD!!! ";
			newsTxt2.text = "LOGGO TOLD ME TO REMOVE THE SWEAR WORDS!!! ";
			seedTxt.visible = seedTxt.active = true;
			seedInput.visible = seedInput.active = true;
			updateCoins();
		}
		else{
			marathon = false;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			txtTracklist.size = 25;
			changeWeek();
			optionGrp.members[7].visible = optionGrp.members[7].active = false;
			optionGrp.members[8].visible = optionGrp.members[8].active = false;
			optionGrp.members[3].visible = optionGrp.members[3].active = true;
			optionGrp.members[4].visible = optionGrp.members[4].active = true;
			newsTxt1.text = "BREAKING NEWS!!! BREAKING NEWS!!! ";
			newsTxt2.text = "BREAKING NEWS!!! BREAKING NEWS!!! ";
			seedTxt.visible = seedTxt.active = false;
			seedInput.visible = seedInput.active = false;
			updateCoins();
		}
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
			if(curWeek == 10) // moves the text into the correct spot
			{
				tweakTxt.x = 1110 - 15;
				stringThing.remove('Buds and Bluds'); // fuck my gay baka life
			}
			else
			{
				tweakTxt.x = 1110;
			}
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
		intendedMarathonScore = Highscore.getMarathonScore();
		#end
	}
}