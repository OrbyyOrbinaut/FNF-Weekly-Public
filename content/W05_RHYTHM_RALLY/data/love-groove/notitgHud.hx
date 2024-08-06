// HUD script by Srt (https://twitter.com/SrtPro278 | https://www.youtube.com/channel/UCy8vhVfrl9XRnTof_jmJKXg)
// This script was made for the song "Love-Groove" on the mod "FNF-Weekly"! (https://gamebanana.com/mods/522709)
var ratingCam;
function onCreatePost() {
	ratingCam = game.camOther; // change this to camHUD to put them behind the notes and allow the shader to effect it!
	game.showCombo = game.showRating = false;
}

var ratingBump:Float = 0;
var missCombo:Int = 0;
var rating:FlxSprite;
var combo:Array<FlxSprite> = [];

function update(e) {
	ratingBump -= e;
	if (ratingBump >= 0)
		rating.scale.x = rating.scale.y = 1.1 + 0.1 * FlxEase.quadOut(ratingBump * 8);
}

function updateNums(stringNum, numArray, startX, missed) {
	while (numArray.length > stringNum.length) {
		var spr = numArray.shift();
		game.remove(numArray, true);
		spr.destroy();
	}
	while (numArray.length < stringNum.length) {
		numArray.insert(0, new FlxSprite(startX, FlxG.height * 0.5 + 60));
		numArray[0].moves = false;
		numArray[0].antialiasing = false;
		numArray[0].cameras = [ratingCam];
		add(numArray[0]);
	}

	for (i in 0...numArray.length) {
		numArray[i].loadGraphic(Paths.image(game.comboPrefix + "num" + stringNum.charAt(i)));
		numArray[i].x = (startX + 40 * i) + (31 - numArray[i].frameWidth) * 0.5;
		// fun fact, in hscript, bools can be interpeted as ints!
		numArray[i].colorTransform.greenMultiplier = 1 - missed;
		numArray[i].colorTransform.blueMultiplier = 1 - missed;
	}
}

var num;
function popupNumScore(spr) {num = spr;}
function popupNumScorePost() {
	// force finishing the tween
	// i would use FlxTween.completeTweensOf but it was being finicky.
	var twns = FlxTween.globalManager._tweens;
	var i:Int = twns.length - 1;
	while (i >= 0) {
		if (twns[i].isTweenOf(num)) {
			twns[i].onEnd();
			twns[i].onComplete();
			twns.splice(i, 1);
			i = 0;
		}
		--i;
	}
	num = null;
}

function noteMiss(note) {
	++missCombo;
	ratingBump = 0.125;
	var stringCombo = Std.string(missCombo);
	updateNums(stringCombo, combo, FlxG.width * 0.75 - 20 * stringCombo.length, true);
	rating.frames = Paths.image(game.comboPrefix + "miss").imageFrame;
	rating.x = FlxG.width * 0.75 - rating.frameWidth * 0.5;
}

function popupScorePost(rat, com, note) {
	if (rating == null) {
		rating = new FlxSprite(0, FlxG.height * 0.5 - 60);
		rating.cameras = [ratingCam];
		rating.moves = false;
		add(rating);
	}
	var stringCombo = Std.string(game.combo);
	updateNums(stringCombo, combo, FlxG.width * 0.75 - 20 * stringCombo.length, false);
	rating.frames = rat.frames;
	rating.x = FlxG.width * 0.75 - rating.frameWidth * 0.5;

	missCombo = 0;
	ratingBump = 0.125;

	// force finishing the tween
	// i would use FlxTween.completeTweensOf but it was being finicky.
	var twns = FlxTween.globalManager._tweens;
	var i:Int = twns.length - 1;
	var twnOut:Int = 0;
	while (i >= 0) {
		if (twns[i].isTweenOf(rat) || twns[i].isTweenOf(com)) {
			twns[i].onEnd();
			if (twns[i].onComplete != null)
				twns[i].onComplete();
			twns.splice(i, 1);
			twnOut++;
		}
		if (twnOut >= 2)
			i = 0;
		--i;
	}
}