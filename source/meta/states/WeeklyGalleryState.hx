package meta.states;

import sys.FileSystem;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import meta.FlxObjectTools;

using StringTools;

class WeeklyGalleryState extends MusicBeatState
{
    var buttons:FlxSpriteGroup;
    var options:Array<String> = ['back', 'credits'];
    var optionsGrp:FlxSpriteGroup;
    var buttonheight:Float = 0;
    var weekFolders = [];

    var weekImages:Array<Array<String>> = [];
    var weekDescriptions:Array<Array<String>> = [];

    var image:FlxSprite;
    var description:FlxText;

    var bg:FlxSprite;
    var leftArrow:FlxSprite;
    var rightArrow:FlxSprite;
    var counter:FlxText;

    var curWeek:Int = 0;
    var curImg:Int = 0;

    override function create()
    {
        var white = new FlxSprite(0,0).makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
        add(white);
        
        bg = new FlxSprite().loadGraphic(Paths.image('gallery/imageborder'));
        bg.scale.set(1.25, 1.25);
        bg.updateHitbox();
        bg.screenCenter(Y);
        bg.antialiasing = ClientPrefs.globalAntialiasing;
        bg.x += 85;
        add(bg);

        leftArrow = new FlxSprite();
		leftArrow.frames = Paths.getSparrowAtlas("mainmenu/button_left");
		leftArrow.animation.addByPrefix("idle", "left0", 10, true);
		leftArrow.animation.addByPrefix("hover", "left hover0", 10, true);
		leftArrow.animation.play("idle");
		leftArrow.screenCenter(Y);
        leftArrow.antialiasing = ClientPrefs.globalAntialiasing;
        leftArrow.x = bg.x - 75;
		add(leftArrow);

		rightArrow = new FlxSprite();
		rightArrow.frames = Paths.getSparrowAtlas("mainmenu/button_right");
		rightArrow.animation.addByPrefix("idle", "right0", 10, true);
		rightArrow.animation.addByPrefix("hover", "right hover0", 10, true);
		rightArrow.animation.play("idle");
		rightArrow.screenCenter(Y);
        rightArrow.x = bg.x + bg.width + 25;
        rightArrow.antialiasing = ClientPrefs.globalAntialiasing;
		add(rightArrow);

        buttons = new FlxSpriteGroup();
        for(i in 0...12){
            var button = new FlxSprite();
            button.frames = Paths.getSparrowAtlas('gallery/weeks/$i/button');
            button.animation.addByPrefix("normal", '$i normal', 24, false);
            button.animation.addByPrefix("hover", '$i hover', 24, false);
            button.animation.play("normal");
            button.antialiasing = ClientPrefs.globalAntialiasing;
            button.scale.set(0.75, 0.75);
            button.updateHitbox();
            button.x = 165 + ((FlxG.width / 4) * 3) - (button.width / 2); 
            button.y = bg.y + ((button.height + 10) * i);
            button.ID = i;
            buttons.add(button);
            buttonheight += button.height;
        }

        optionsGrp = new FlxSpriteGroup();
        for(i in 0...options.length){
            var button = new FlxSprite();
            button.frames = Paths.getSparrowAtlas('gallery/button_${options[i]}');
            button.animation.addByPrefix("idle", '${options[i]}0', 24, false);
            button.animation.addByPrefix("hover", '${options[i]} hover0', 24, false);
            button.animation.play("idle");
            button.antialiasing = ClientPrefs.globalAntialiasing;
            //button.scale.set(0.75, 0.75);
            //button.updateHitbox();
            button.x = 235 + ((button.width + 25) * i);
            button.y = 25;
            button.ID = i;
            optionsGrp.add(button);
        }
        add(optionsGrp);
        add(buttons);

        counter = new FlxText(bg.x + bg.width + 20, bg.y + bg.height - 60);
        counter.setFormat(Paths.font('ComicMono.ttf'), 50, FlxColor.BLACK, CENTER, FlxTextBorderStyle.NONE, FlxColor.BLACK);
        counter.antialiasing = ClientPrefs.globalAntialiasing;
        add(counter);

        image = new FlxSprite(0, 0);
        image.antialiasing = ClientPrefs.globalAntialiasing;
        add(image);
        
        description = new FlxText();
        description.setFormat(Paths.font('ComicMono.ttf'), 29, FlxColor.BLACK, CENTER, FlxTextBorderStyle.NONE, FlxColor.BLACK);
        description.fieldWidth = 950;
        description.wordWrap = true;
        description.antialiasing = ClientPrefs.globalAntialiasing;
        FlxObjectTools.centerOnSprite(description, bg);
        description.y = bg.y + bg.height + 3;
        add(description);

        weekFolders = FileSystem.readDirectory(Paths.file('images/gallery/weeks'));
        weekFolders.sort(function(a, b) return Std.parseInt(a) - Std.parseInt(b));        

        for (folder in weekFolders){

            var allFiles = FileSystem.readDirectory(Paths.file('images/gallery/weeks/$folder'));
            allFiles.sort(function(a, b) return Std.parseInt(a) - Std.parseInt(b));        
            var images = [];
            for(i in allFiles) if(i.contains(".png") && !i.contains("button") && !i.contains(".txt")) images.push(i);

            var group:Array<String> = [];
            var group2:Array<String> = [];
            
            for(image in images){
                //trace(image);
                group.push('$folder/$image');

                var txtvers = Paths.file('images/gallery/weeks/$folder/$image.'.replace(".png", ".txt"));
                var textToPush:String = '[No description avaliable]';
                if (FileSystem.exists(txtvers)) textToPush = CoolUtil.coolTextFile(txtvers).join('\n');
                group2.push(textToPush);
            }
            
            weekImages.push(group);
            weekDescriptions.push(group2);
        }

        updateImage(0);
        super.create();
    }

    override function update(elapsed:Float){
        super.update(elapsed);

        if(FlxG.mouse.wheel != 0){
            if(FlxG.mouse.wheel == -1){ // if the shit is goin up
                if(buttons.y > -1530)
                    buttons.y -= 50;
            }else{ // if the shit is goin down 
                if(buttons.y < 0)
                    buttons.y += 50;
            }
        }

        for(button in buttons.members){
            if(FlxG.mouse.overlaps(button)){
                button.animation.play("hover");
                if(FlxG.mouse.justPressed){
                    curWeek = button.ID;
                    curImg = 0;
                    updateImage(0);
                }
            }else{
                button.animation.play("normal");
            }
            if (buttons.members.indexOf(button) == curWeek) button.animation.play("hover");
        }

        for(button in optionsGrp.members){
            if(FlxG.mouse.overlaps(button)){
                button.animation.play("hover");
                if(FlxG.mouse.justPressed){
                    selectOption(button.ID);
                }
            }else{
                button.animation.play("idle");
            }
        }

        if(weekImages[curWeek].length > 1){
            leftArrow.visible = true;
            rightArrow.visible = true;
            if(FlxG.mouse.overlaps(leftArrow) && FlxG.mouse.justPressed){
                leftArrow.animation.play("hover");
                new FlxTimer().start(0.125, (tmr)->{
                    leftArrow.animation.play("idle");
                });
                updateImage(-1);
            } 
            if(FlxG.mouse.overlaps(rightArrow) && FlxG.mouse.justPressed){
                rightArrow.animation.play("hover");
                new FlxTimer().start(0.125, (tmr)->{
                    rightArrow.animation.play("idle");
                });
                updateImage(1);
            }

        }else{
            leftArrow.visible = false;
            rightArrow.visible = false;
        }
    }

    function updateImage(change:Int)
    {
        var target:Int = curImg + change;
        if (target < 0) target = weekImages[curWeek].length - 1;
        if (target > weekImages[curWeek].length - 1) target = 0;

        curImg = target;

        image.loadGraphic('assets/images/gallery/weeks/${weekImages[curWeek][curImg]}');
        image.setGraphicSize(0,436); // Changes the height first to fit in the frame
        image.updateHitbox();
        if(image.width > 784) // If the width is too wide then it changes the width after
        {
            image.setGraphicSize(784,0);
            image.updateHitbox();
        }
        FlxObjectTools.centerOnSprite(image, bg);

        description.text = weekDescriptions[curWeek][curImg];
        counter.text = '${curImg + 1}';

        FlxG.sound.play(Paths.sound('scrollMenu'));
    }

    function selectOption(id:Int){
		switch(options[id]){
			case 'back':
                MusicBeatState.switchState(new WeeklyMainMenuState());
                FlxG.sound.play(Paths.sound('cancelMenu'));
            case 'credits':
                MusicBeatState.switchState(new CreditsState());
                FlxG.sound.play(Paths.sound('scrollMenu'));
		}
	}
}