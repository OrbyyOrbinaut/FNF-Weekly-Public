var newBar:Bar;

function onCreatePost(){
   var removes = [game.healthBar, game.healthBarBG, game.iconP1, game.iconP2];
   for(obj in removes){ remove(obj); }

   newBar = new Bar(0, ClientPrefs.downScroll ? 25 : 625,'skullkid/majora_healthbarbg', function() return game.health, 0, 2);
   newBar.rightBar.loadGraphic(Paths.image('skullkid/majora_healthbar'));
   newBar.leftBar.loadGraphic(Paths.image('skullkid/majora_healthbar'));
   newBar.setColors(FlxColor.fromRGB(88, 196, 0), FlxColor.fromRGB(198, 39, 39));
   newBar.cameras = [game.camHUD];
   newBar.leftToRight = true;
   newBar.percent = 50;
   for(obj in [newBar.leftBar, newBar.rightBar, newBar.bg]){ 
        obj.scale.set(3, 3);
        obj.updateHitbox(); 
   }
   newBar.screenCenter(FlxAxes.X);
   insert(members.indexOf(game.notes), newBar);

   game.timeBar.y = -999;
   game.timeTxt.y = -999;
   game.scoreTxt.y = newBar.y + 50;
   game.scoreTxt.font = Paths.font('FOT-ChiaroStd-B.otf');
   game.scoreAllowedToBop = false;
}

function onUpdate(elapsed){
    newBar.percent = (game.health / 2) * 100;
    FlxG.watch.addQuick('percent', newBar.percent);
}