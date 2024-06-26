var newBar:Bar;
var songPercent:Float = 0;

function onCreatePost(){
   newBar = new Bar(1006, 125,'mithrix/rortimeBarBG', function() return songPercent, 0, 1);
   newBar.rightBar.loadGraphic(Paths.image('mithrix/rortimebar'));
   newBar.leftBar.loadGraphic(Paths.image('mithrix/rortimeBar'));
   newBar.setColors(FlxColor.fromRGB(255, 255, 255), FlxColor.fromRGB(0, 0, 0));
   newBar.cameras = [game.camHUD];
   newBar.leftToRight = true;
   newBar.percent = 0;
   insert(members.indexOf(game.notes), newBar);

   var removes = [game.iconP1, game.iconP2];
   for(obj in removes){ remove(obj); }
}

function onUpdate(elapsed){
    var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
    if(curTime < 0) curTime = 0;
    songPercent = (curTime / songLength);
    
    newBar.percent = songPercent;
}