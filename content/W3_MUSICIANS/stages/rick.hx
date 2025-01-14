var vid1:FunkinVideoSprite;
var skipCutscene = false;

function onLoad(){
    var bg = new FlxSprite().loadGraphic(Paths.image('boss/background'));
    bg.x -= 650;
    bg.y -= 100;
    add(bg);   

    var crowd = new FlxSprite(1375, 200);
    crowd.frames = Paths.getSparrowAtlas('boss/crowd');
    crowd.animation.addByPrefix('idle', 'crowd', 12, true);
    crowd.animation.play('idle');
    add(crowd);

    var tables = new FlxSprite().loadGraphic(Paths.image('boss/tabels'));
    tables.y += 1200;
    tables.zIndex = 999;
    add(tables);

    var lights = new FlxSprite().loadGraphic(Paths.image('boss/lights'));
    lights.x += 1375;
    lights.zIndex = 999;
    add(lights);

    var overlay = new FlxSprite().loadGraphic(Paths.image('boss/gradient'));
    overlay.blend = BlendMode.ADD;
    overlay.zIndex = 999;
    overlay.x -= 650;
    overlay.y -= 100;
    add(overlay);
}

function onCreatePost(){
    game.camGame.visible = skipCutscene;
    game.camHUD.visible = skipCutscene;
    game.skipCountdown = true;    
    game.setGameOverVideo('yeahman');
    // vid1 = FunkinVideoSprite.quickGen({file: Paths.video('rick'), muted: true, loops: false});

}

var played = skipCutscene;
function onStartCountdown(){
    if(!played){
        played = true;
        vid1 = new FunkinVideoSprite();
        vid1.addCallback('onFormat', ()->{
            vid1.setGraphicSize(0, FlxG.height);
            vid1.updateHitbox();
            vid1.screenCenter();
            vid1.antialiasing = ClientPrefs.globalAntialiasing;
            vid1.cameras = [game.camOther];
        });
        vid1.addCallback('onEnd', ()->{
            game.camHUD.flash(FlxColor.WHITE, 2);
            game.camGame.visible = true;
            game.camHUD.visible = true;
        });
        vid1.load(Paths.video('indomitablecutscene'));
        vid1.play();
        add(vid1);

        new FlxTimer().start(13.5125, ()->{ game.startCountdown(); });

        return Function_Stop;
    }
    return Function_Continue;
}