package meta.states;

class ARGState extends MusicBeatState
{

    var argText:FlxText;

    override function create()
    {
        argText = new FlxText(872, 130, "", 25);
        argText.alignment = CENTER;
		argText.font = "VCR OSD Mono";
		argText.color = 0xffffffff;
		argText.antialiasing = ClientPrefs.globalAntialiasing;
        argText.screenCenter();
        argText.text = "No way to win, no way to speak" + "\nPerhaps... a website..?" + "\n-Norbert"; //look leth it was like 4 am
		add(argText);
    }

    override public function update(elapsed:Float)
    {
        if (controls.BACK)
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new WeeklyMainMenuState());
        }
    }
}