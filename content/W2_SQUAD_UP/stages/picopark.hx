function onLoad()
{
    var bgLeft:BGSprite = new BGSprite('pp/bgleft', -2100, -90, 0.9, 0.9, ['bgleft'], true);
    
    blackScreen = new FlxSprite(-600, -290).makeGraphic(1, 1, 0xFFFFFFFF);
    blackScreen.scale.set(2300, 1220);
    blackScreen.updateHitbox();
    add(blackScreen);
    
    add(bgLeft);
    add(new BGSprite('pp/floor', -409.2, -54.45, 1, 1));
    add(new BGSprite('pp/bgright', 954, -1, 1, 1, ['bgright'], true));
    add(new BGSprite('pp/gfpark', 476, -67, 1, 1, ['idle'], true));

    FlxTween.tween(bgLeft, {x: 2100}, 22, {type: 2}); 
}

function onCreatePost()
{
    //game.isCameraOnForcedPos = true;
    game.snapCamFollowToPos(585, 200);
    game.setGameOverVideo('picodark');
}