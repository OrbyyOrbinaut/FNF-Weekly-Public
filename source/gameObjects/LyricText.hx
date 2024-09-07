package gameObjects;

import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;

// this code STIIINKS 
class LyricText extends FlxText 
{
    var format:FlxTextFormat;
    var divider:String;
    
    var slices:Array<String> = [];
    var curSlice:Int;
    var endPoint:Int;
    var fading:Bool = false;

    var lyricLoadCallback:Void->Void = null;

    public function new(x:Float, y:Float, fillColour:FlxColor, daFont:String = 'vcr.ttf', daSize:Int = 24, ?div:String = '*') 
    {
        super(x, y);

        divider = div;
        format = new FlxTextFormat(fillColour);
        this.alignment = CENTER;
        this.font = Paths.font(daFont);
        this.size = daSize;
        this.antialiasing = ClientPrefs.globalAntialiasing;
        this.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
        
        this.text = '';
        this.alpha = 0;
    }

    public function changeColour(newColour:FlxColor)
    {
        format = new FlxTextFormat(newColour);
    }

    // lyrice emotional crying time
    public function loadLyric(newLyric:String)
    {
        slices = newLyric.split(divider);
        this.text = slices.join('');

        curSlice = -1;

        if (fading) cancelFade();
        this.alpha = 1;

        if (lyricLoadCallback != null) lyricLoadCallback();

        nextSlice();
    }

    public function nextSlice(?change:Int = 1):Void
    {
        curSlice += change;

        if (curSlice > slices.length - 1) 
        {
            if (!fading) fadeOut();
            return;
        }

        var loopCounter:Int = 0; // there's defo a better way than this
        endPoint = 0;

        for (slice in slices) 
        {
            if (loopCounter <= curSlice) {
                endPoint += slice.length;
            }

            loopCounter++;
        }

        this.clearFormats();
        this.addFormat(format, -1, endPoint);
    }

    // fading handlers
    public function fadeOut()
    {
        fading = true;
        FlxTween.tween(this, {alpha : 0}, 2, {ease : FlxEase.sineIn, onComplete : function(twn:FlxTween) {
            fading = false;
        }});
    }

    public function cancelFade()
    {
        FlxTween.cancelTweensOf(this);
        fading = false;
    }
}