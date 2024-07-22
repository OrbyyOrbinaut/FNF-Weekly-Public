package meta.states; 

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import gameObjects.*;
import meta.data.*;

class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;
	
	var warnText:FlxText;

	var updateV:String;
	
	override function create()
		{
			super.create();
			
			var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			add(bg);

			var http = new haxe.Http("https://raw.githubusercontent.com/OrbyyOrbinaut/FNF-Weekly-Public/main/VERSION.txt");
			// link to the Github txt that tells you the version
			// ("https://raw.githubusercontent.com/Crossknife/FNF-Weekly-TEST/main/VERSION.txt");
			// do rawgithub
			
			http.onData = function (data:String)
				{
					updateV = data.split('\n')[0].trim();
				}
				http.onError = function (error) {
					trace('error: $error');
				}
				
			http.request();
			
			trace('Client CheckForUpdates: ' + ClientPrefs.checkForUpdates);
			
			if (ClientPrefs.checkForUpdates == 1) {
				warnText = new FlxText(0, 0, FlxG.width,
					"Your version of FNF Weekly is outdated,\n\n
					Would you like to update?\n\n
					Press Escape To skip the update\n
					Press Enter To go to GAMEBANANA\n
					
					(You can disable this prompt in options)
					UPDATE : " + updateV,
					32);
			}
			else {
				warnText = new FlxText(0, 0, FlxG.width,
					"Your version of FNF Weekly is outdated,\n\n
					Would you like to update?\n\n
					Press Escape To skip the update\n
					Press Enter To download the update (Will open command prompt)\n
					
					(You can disable this prompt in options)
					UPDATE : " + updateV,
					32);
			}
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		warnText.screenCenter(X);
		warnText.x += 40;
		warnText.updateHitbox();
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if (controls.ACCEPT) {
				if (ClientPrefs.checkForUpdates == 1) {
					// (ClientPrefs.checkForUpdates == 1) 0 = off, 1 = link, 2 = auto update
					CoolUtil.browserLoad("https://gamebanana.com/mods/522709");
				}
				else {
					MusicBeatState.switchState(new UpdatingState());
				}
			}
			if(controls.BACK) {
				leftState = true;
			}

			if(leftState)
			{
				FlxG.sound.resume();
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new TitleState());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
