function onBeatHit()
{
    var targetRotate:Int = game.curBeat / 2;
    if (game.curBeat % 2 == 0) {
        targetRotate *= -1;
    }

    FlxTween.angle(game.iconP1, targetRotate, 0, 0.3, {ease: FlxEase.quadOut});
    FlxTween.angle(game.iconP2, targetRotate, 0, 0.3, {ease: FlxEase.quadOut});
}