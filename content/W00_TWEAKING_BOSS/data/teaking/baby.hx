var baby:FlxSprite;

function onCreatePost() {
    baby = new FlxSprite().loadGraphic(Paths.image("baby"));
    baby.antialiasing = true;
    baby.x = game.boyfriendGroup.x;
    baby.y = game.boyfriendGroup.y + 400;
    baby.alpha = 0.001;
	add(baby); 
}

function onEvent(eventName, value1, value2){ // I'm gonna kill you guys
    switch(eventName){
        case 'baby':
        baby.alpha = 1;
        game.boyfriend.alpha = 0.001;
        case 'baby2':
        baby.alpha = 0.001;
        game.boyfriend.alpha = 1;
    }
}