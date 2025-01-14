var ohyeah:FunkinVideoSprite;

function onLoad()
{
    var bg:BGSprite = new BGSprite('femtanyl/femtanylBG', 0, 0);
    bg.updateHitbox();
    add(bg);

    var idk:BGSprite = new BGSprite('femtanyl/zombae', 820, 545, 1, 1, ['zombae0'], true);
    idk.updateHitbox();
    add(idk);

    ohyeah = new FunkinVideoSprite();
    ohyeah.addCallback('onFormat', ()->{
        ohyeah.setGraphicSize(0, FlxG.height * 1.25);
        ohyeah.updateHitbox();
        ohyeah.screenCenter();
        ohyeah.x += 250;
        ohyeah.y += 200;
        ohyeah.antialiasing = ClientPrefs.globalAntialiasing;
        ohyeah.blend = BlendMode.SUBTRACT;
        // ohyeah.visible = false;
        // ohyeah.cameras = [game.camOther];
    });
    ohyeah.load(Paths.video('femtanyl2'), [FunkinVideoSprite.looping]);
    add(ohyeah);
}

function onCreatePost()
{
    game.isCameraOnForcedPos = true;
    game.snapCamFollowToPos(881, 575);
    game.setGameOverVideo('femtanyl_gameovber');
    game.playHUD.iconP1.y -= 35;
    game.playHUD.iconP2.y -= 15;
    game.boyfriend.ghostsEnabled = false;
    game.dad.ghostsEnabled = false;

    game.modManager.queueFuncOnce(1280, (s,s2)->{
        game.dad.animSuffix = '-alt';
        ohyeah.play();
    });
    game.modManager.queueFuncOnce(1536, (s,s2)->{
        game.camGame.visible = false;
        game.camHUD.visible = false;
    });
}