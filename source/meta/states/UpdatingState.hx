package meta.states; 

import openfl.net.URLRequest;
import openfl.net.URLStream;
import openfl.utils.ByteArray;
import openfl.filesystem.FileStream;
import openfl.filesystem.FileMode;
import openfl.filesystem.File;
import openfl.system.System as MemYum;
import sys.io.File as FileS;
import sys.io.Process;
import sys.FileSystem;
import openfl.events.Event;
import openfl.events.EventType;
import openfl.events.ProgressEvent;
import openfl.events.EventDispatcher;
import openfl.events.OutputProgressEvent;
import haxe.io.BytesInput;
import haxe.zip.Uncompress;
import haxe.zip.Entry;
import haxe.zip.Reader;
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

class UpdatingState extends MusicBeatState
{
	public static var leftState:Bool = false;

    var disp = new EventDispatcher();

	var updating = true;
	var progTxt:FlxText;
    var cancelText:FlxText;
	var file:File;
    var sWfolderB:String;
    var url:String;

	var stream:URLStream;
	var fs:FileStream;
	var wait2write = false;

    // These will be used to show how much of the download is done
    var johhny:Float;
    var round:Float;
    var progN:Int;


    public function install() {
        //deleteDirRecursively(sWfolderB + 'content');
        var sWfolder = Sys.programPath();
        sWfolder = sWfolder.split("FNFWeekly.exe")[0];
        sWfolderB = '"' + Std.string(sWfolder);
        sWfolderB = sWfolderB + 'assets\\cmdpostupdate\\closeGM.bat"';
        Paths.clearUnusedMemory();
        trace('syscommand : ' + sWfolderB);
        Sys.command(sWfolderB);
        trace('here im command');
        Sys.exit(0);
    }

    public function onProgressWrite(event:ProgressEvent) {
        writeToFile();
        Paths.clearUnusedMemory();

        //trace(stream.bytesAvailable);
    }
    
    public function onEnddl(event:Event):Void {
        stream.close();
        fs.close();
        trace('Download Finished');
        progTxt.text = "Uncompressing";

        MemYum.gc();

        install();

    }

    public function writeToFile() {
        if (stream.bytesAvailable > 0 && !leftState) {
            var fba = new ByteArray();
            stream.readBytes(fba, 0, stream.bytesAvailable);
            fs.writeBytes(fba, 0, fba.length);
            trace('there');
        }
    }
    
    public function showProgress(event:ProgressEvent) {
        johhny = event.bytesLoaded;
        round = event.bytesTotal;
        progN = Std.int(johhny / round * 100);
        //trace(johhny + " / " + round);
        if (progN >= 0) {
            progTxt.text = "Downloading Your New Tweak: " + progN + "%";
        }
    }
    
	override function create()
	{
	// Heres The link to change - cross
        var http = new haxe.Http("https://raw.githubusercontent.com/OrbyyOrbinaut/FNF-Weekly-Public/main/VERSION.txt");
        // link to the Github txt that tells you the version
        // ("https://raw.githubusercontent.com/Crossknife/FNF-Weekly-TEST/main/VERSION.txt");
        // do rawgithub
        
        http.onData = function(data:String) {
            url = data.split('\n')[1].trim();
        }
        http.onError = function(error) {
            trace('error: $error');
        }
                
        http.request();


        trace('Our Download Link is: ' + url);
        // Normal Bg stuff
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);


        // Looking for Our current folder so stuff isnt downloaded in the normal downloads folder
        var sWfolder = Sys.programPath();
        sWfolder = sWfolder.split("FNFWeekly.exe")[0];
        sWfolderB = Std.string(sWfolder);
        trace("Folder Weekly is Currently Stored in is :" + sWfolder);


        function deleteDirRecursively(path:String):Void {
            //trace('searching through: ' + sWfolderB + 'assets');
        
            trace(path);
            if (sys.FileSystem.exists(path) && sys.FileSystem.isDirectory(path)) {
                var entries = sys.FileSystem.readDirectory(path);
                for (entry in entries) {
                    trace(entries);
                    trace(entry);
                    if (sys.FileSystem.isDirectory(path + '\\' + entry)) {
                        deleteDirRecursively(path + '\\' + entry);
                        sys.FileSystem.deleteDirectory(path + '\\' + entry);
                    } 
                    else {
                        if (entry.endsWith('.TTF') || entry.endsWith('.ttf') || entry.endsWith('.otf')) {
                            trace('font :(');
                        }
                        else {
                            sys.FileSystem.deleteFile(path + '\\' + entry);
                        }
                    }
                }
            }
        }    
        
        
        // The file that will be written over with data from our download
        file = new File(sWfolder + "FNF.Weekly.zip");
    
        stream = new URLStream();
        stream.addEventListener(ProgressEvent.PROGRESS, onProgressWrite);
        stream.addEventListener(ProgressEvent.PROGRESS, showProgress);
        stream.addEventListener(Event.COMPLETE, onEnddl);

        fs = new FileStream();
        
        fs.open(file, FileMode.WRITE);
        stream.load(new URLRequest(url));
        
        progTxt = new FlxText(0, 0, FlxG.width, "Downloading Your New Tweak");
        progTxt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
        progTxt.screenCenter(Y);
        add(progTxt);
        
        cancelText = new FlxText(0, 400, FlxG.width, "Press ESC to CANCEL (WILL CLOSE THE GAME)");
        cancelText.setFormat("VCR OSD Mono", 32, FlxColor.RED, CENTER);
        cancelText.screenCenter(X);
        add(cancelText);

    }
    
	override function update(elapsed:Float)
	{
        if(!leftState) {
            if(controls.BACK) {
                stream.removeEventListener(ProgressEvent.PROGRESS, onProgressWrite);
                stream.removeEventListener(ProgressEvent.PROGRESS, showProgress);
                stream.removeEventListener(Event.COMPLETE, onEnddl);
                stream.close();
                fs.close();
                MemYum.gc();
                stream = null;
                fs = null;
                Paths.clearUnusedMemory();
                leftState = true;
                Sys.exit(0);
                
            }
            
            if(leftState)
            { // If we can ever solve the memleaks
                FlxG.sound.resume();
                FlxG.sound.play(Paths.sound('cancelMenu'));
                FlxTween.tween(cancelText, {alpha: 0}, 1);
                FlxTween.tween(progTxt, {alpha: 0}, 1, {
                    onComplete: function (twn:FlxTween) {
                        MusicBeatState.switchState(new TitleState());
                    }
                });
            }
            super.update(elapsed);
        }
	}
}
