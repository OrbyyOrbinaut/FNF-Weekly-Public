var newBar:Bar;
var songPercent:Float = 0;

function onCreatePost(){
    var barbg:FlxSprite = new FlxSprite(510, 218);
    barbg.loadGraphic(Paths.image("pico/alucardHP_box"));
    barbg.antialiasing = ClientPrefs.globalAntialiasing;
    barbg.cameras = [game.camHUD];
	add(barbg); 
   
    newBar = new Bar(515, 236,'pico/hpbar_BG', function() return songPercent, 0, 1);
   newBar.rightBar.loadGraphic(Paths.image('pico/hpbar'));
   newBar.leftBar.loadGraphic(Paths.image('pico/hpbar'));
   newBar.setColors(FlxColor.LIME, FlxColor.RED);
   newBar.cameras = [game.camHUD];
   newBar.leftToRight = false;
   newBar.percent = 0;
   newBar.antialiasing = ClientPrefs.globalAntialiasing;
   insert(members.indexOf(game.notes), newBar);
}

function onUpdate(elapsed){
    var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
    if(curTime < 0) curTime = 0;
    songPercent = (curTime / songLength);
    
    newBar.percent = songPercent;
}