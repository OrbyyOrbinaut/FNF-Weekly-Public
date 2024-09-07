package gameObjects;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import meta.data.Metadata;

using StringTools;
using flixel.util.FlxSpriteUtil;

class SongCard extends FlxSpriteGroup 
{
    var text:FlxText;
    var bg:FlxSprite;
    var padding:Float = 10;
    public var data:MetadataFile;

    public function new(x:Float, y:Float, meta:MetadataFile) 
    {
        super(x, y);

        data = meta;

        var font:Null<String> = data.card.font;
        if (font == null) font = 'vcr.ttf';

        var size:Null<Int> = data.card.fontSize;
        if (size == null) size = 24;

        text = new FlxText(x + padding, y + padding).setFormat(Paths.font(font), size, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        text.antialiasing = ClientPrefs.globalAntialiasing;
        text.text = formString();
        
        bg = new FlxSprite().makeGraphic(Std.int(text.width + (padding * 2)), Std.int(text.height + (padding * 2)), FlxColor.BLACK);
        bg.alpha = 0.8;

        add(bg);
        add(text);
    }

    public function formString():String
    {
        return '${data.card.name}\n\nSong: ${data.credits.music.join(', ')}\nChart: ${data.credits.chart.join(', ')}';
    }

    public function display() {
        var initX:Float = this.x;

        FlxTween.tween(this, {x: initX + this.width}, 0.65, {ease: FlxEase.cubeInOut, onComplete: function(twn:FlxTween) {
            FlxTween.tween(this, {x: initX}, 0.65, {ease: FlxEase.cubeInOut, startDelay: data.card.duration, onComplete: function(twn:FlxTween) {
                this.destroy();
            }});
        }});
    }
}