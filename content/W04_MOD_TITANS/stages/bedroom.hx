var FILE_PREFIX:String = 'sunday/';

function onLoad()
{
    // this is my low point
    add(new BGSprite(FILE_PREFIX + 'floor', -850, 630));
    add(new BGSprite(FILE_PREFIX + 'wall', -400, -70));
    add(new BGSprite(FILE_PREFIX + 'speaker', -80, 365));
}

function onCreatePost()
{
    game.snapCamFollowToPos(710, 500);
}

function onGameOverStart() 
{
    setGameOverVideo('sunday');
}