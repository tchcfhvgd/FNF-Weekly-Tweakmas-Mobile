import openfl.filters.ShaderFilter;
var bg:BGSprite;
// SONG IS ACTUALLY 4:3 NOW!!!
function onLoad()
{
    bg = new BGSprite('grinch/bg', 0, 0);
    bg.updateHitbox();
    add(bg);
}

function onCreatePost()
{
    game.snapCamFollowToPos(bg.x + (bg.width / 2), bg.y + (bg.height / 2));
    modManager.setValue("transformX", 75, 0);
    modManager.setValue("transformX", -75, 1);

    FlxG.scaleMode.width = 960;    
    FlxG.camera.width = 960;
    game.camHUD.width = 960;
    game.playHUD.healthBar.screenCenter(FlxAxes.X);
    game.playHUD.scoreTxt.screenCenter(FlxAxes.X);
    game.playHUD.timeBar.screenCenter(FlxAxes.X);
    game.playHUD.timeTxt.screenCenter(FlxAxes.X);
    game.playHUD.comboOffsets = [-200, -50, -100, -50];
    game.setGameOverVideo('grinch');
}

function onGameOver() for(c in [game.camGame, game.camHUD, game.camOther]) c.setFilters([]);  

function onDestroy()
{
    FlxG.scaleMode.width = 1280; 
    FlxG.camera.width = 1280;
}
