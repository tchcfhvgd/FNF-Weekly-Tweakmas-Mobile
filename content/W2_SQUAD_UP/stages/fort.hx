import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
var you:FlxText;
var jonesy:FlxSprite;

function onLoad(){
    var bg = new FlxSprite().loadGraphic(Paths.image('fart/bg'));
    bg.scale.set(1.5, 1.5);
    bg.updateHitbox();
    add(bg);

    jonesy = new FlxSprite(100, 400);
    jonesy.frames = Paths.getSparrowAtlas('fart/jonesy');
    jonesy.animation.addByPrefix('idle', 'idle', 12, true);
    jonesy.animation.addByPrefix('look', 'look', 12, false);
    jonesy.animation.play('idle');
    add(jonesy);

    you = new FlxText(275, 300).setFormat(Paths.font('vcr.ttf'), 50, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    you.borderSize = 3;
    you.text = 'YOU';
    you.antialiasing = ClientPrefs.globalAntialiasing;
    you.alpha = 0.001;
    you.cameras = [game.camOther];
    add(you);
}


function onCreatePost(){
    game.playHUD.showCombo = false;
    game.playHUD.showRating = false;
    game.modManager.setValue("opponentSwap", 1);
    game.playHUD.flipBar();
    game.playHUD.healthBar.setColors(FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]), FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]));
    game.modManager.queueFuncOnce(1616, (s,s2)->{
        game.camGame.visible = false;
        FlxTween.tween(game.camHUD, {alpha: 0}, 4, {ease: FlxEase.quadInOut});
    });
    game.snapCamFollowToPos(1300, 710);
    game.setGameOverVideo('hawk_tuah');
}

function onSongStart(){
    you.scale.set(0.2, 0.2);

    FlxTween.tween(you.scale, {x: 1, y: 1}, 1, {ease: FlxEase.expoOut});
    FlxTween.tween(you, {alpha: 1}, 1, {ease: FlxEase.expoOut, onComplete: function(twn:FlxTween) {
        FlxTween.tween(you, {alpha : 0}, 1, {startDelay : 2, ease : FlxEase.expoIn});
        FlxTween.tween(you.scale, {x: 0.2, y: 0.2}, 1, {startDelay : 2, ease: FlxEase.expoIn});
    }});
}

function onMoveCamera(turn){
    switch(turn){
        case 'dad':
            game.defaultCamZoom = 0.725;
        default:
            game.defaultCamZoom = 0.6;
    }
}

function onEvent(eventName){
    if(eventName == 'Toon Town Events'){
        jonesy.animation.play('look');
        game.triggerEventNote('Play Animation', 'shocked', 'bf');
        game.triggerEventNote('Play Animation', 'shock', 'dad');
        game.boyfriend.skipDance = true;
        game.dad.skipDance = true;
        game.isCameraOnForcedPos = true;
        FlxTween.tween(game.camFollow, {x: 1500, y: 800}, 0.25, {ease: FlxEase.smootherStepInOut});
        game.defaultCamZoom = 0.45;
    }
}