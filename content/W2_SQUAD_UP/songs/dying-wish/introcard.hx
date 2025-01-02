var video:FunkinVideoSprite;
var blackScreen:FlxSprite;

function onCreatePost()
{
    if(PlayState.isStoryMode == true)
    {
        blackScreen = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
        blackScreen.cameras = [game.camHUD];
        add(blackScreen);
    }
}

function doStartCountdown(){ 
    if(PlayState.isStoryMode == true)
    {
        return Function_Stop; 
    }
}

function presongCutscene() 
{
    if(PlayState.isStoryMode == true)
    {
        video = new FunkinVideoSprite();
        video.addCallback('onFormat', () -> {
            video.setGraphicSize(0, FlxG.height);
            video.updateHitbox();
            video.screenCenter();
            video.antialiasing = ClientPrefs.globalAntialiasing;
            video.cameras = [game.camOther];
        });
        video.addCallback('onEnd', () -> {
            game.startCountdown();
            blackScreen.visible = false;
        });
        video.load(Paths.video('tf2_titlecard'));
        add(video);
        video.play();
        
        return Function_Stop;
    }
}