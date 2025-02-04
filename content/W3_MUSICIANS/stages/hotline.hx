import openfl.filters.ShaderFilter;

var rainbg:BGSprite;
var blackbg:BGSprite;
var bg:BGSprite;
var curObject:Int = -1;
var black:FlxSprite;
var hopscotch:FlxSprite;

var rain1:BGSprite;
var rain2:BGSprite;

var objects:Array<BGSprite> = [];

function onLoad()
{
    rainbg = new BGSprite('jack/jacknightbg', 0, 0);
    rainbg.updateHitbox();
    add(rainbg);

    rain1 = new BGSprite('jack/scrollrain', 0, 0);
    rain1.visible = false;

    rain2 = new BGSprite('jack/scrollrain', 0, 0);
    rain2.y -= rain1.height;
    rain2.visible = false;

    add(rain1);
    add(rain2);

    blackbg = new BGSprite('jack/black screen', -200, -400);
    blackbg.scale.set(3.0, 3.0);
    blackbg.updateHitbox();
    add(blackbg);

    bg = new BGSprite('jack/jackbg', 0, 0);
    bg.updateHitbox();
    add(bg);
}

function onCreatePost()
{

    game.playHUD.ratingPrefix = 'jack/combos/';
    game.skipCountdown = true;

    game.camGame.zoom = 1.55;
    game.isCameraOnForcedPos = true;
    game.snapCamFollowToPos(bg.x + (bg.width / 2), bg.y + (bg.height / 2) + 10);
    
    for(i in 0...7) {
        var object:BGSprite = new BGSprite('jack/props/' + i, -100, -100);
        object.scale.set(1.2, 1.2);
        object.updateHitbox();
        object.alpha = 0;
        objects.push(object);
        add(object);
    }

    objects[0].x = -85;
    objects[0].y = 250;
    objects[1].x = objects[0].x + 40;
    objects[1].y = objects[0].y - 140;
    objects[2].x = objects[1].x + 150;
    objects[2].y = objects[1].y - 100;
    objects[3].x = objects[2].x + 220;
    objects[3].y = objects[2].y - 90;
    objects[4].x = objects[3].x + 160;
    objects[4].y = objects[3].y + 45;
    objects[5].x = objects[4].x + 170;
    objects[5].y = objects[4].y + 100;
    objects[6].x = objects[5].x + 100;
    objects[6].y = objects[5].y + 180;

    black = new FlxSprite().makeGraphic(FlxG.width + 2, FlxG.height, FlxColor.BLACK);
    black.visible = false;
    black.cameras = [game.camHUD];
    add(black);

    hopscotch = new FlxSprite(0,0).loadGraphic(Paths.image('jack/hopscotch'));
    hopscotch.visible = false;
    hopscotch.cameras = [game.camOther];
    add(hopscotch);

    game.playHUD.scoreTxt.font = 'arialbd.ttf';
    game.playHUD.scoreTxt.borderSize = 0;
    game.playHUD.timeTxt.font = 'arialbd.ttf';
    game.playHUD.timeTxt.borderSize = 0;

    game.playHUD.comboOffsets = [100, -50, 200, -20];

    game.setGameOverVideo('jack_stauber_game_over');
}

function onUpdate(elapsed){
    game.playHUD.scoreTxt.text = game.playHUD.scoreTxt.text.toUpperCase();
}

function onUpdatePost(elapsed:Float)
{
    if (rain1.visible){
    rain1.y += 350 * elapsed;
    if (rain1.y > 600) rain1.y -= rain1.height * 2;
    rain2.y += 350 * elapsed;
    if (rain2.y > 600) rain2.y -= rain2.height * 2;
    }
}

function onEvent(name:String, v1:String, v2:String)
{
    switch (name) 
    {
        case 'Jack Events':
            switch (v1) 
            {
                case 'bg1':
                    FlxTween.tween(game.camGame, {zoom: 1.1}, 1.5, {ease: FlxEase.sineOut, onComplete: function(twn:FlxTween) {
                        game.defaultCamZoom = 1.1;
                        //game.snapCamFollowToPos();

                    }});
                    FlxTween.tween(bg, {alpha: 0.00000001}, 1.5, {ease: FlxEase.sineOut});
                    FlxTween.tween(game.camFollow, {y: game.camFollow.y - 100}, 1.5, {ease: FlxEase.sineOut});
                case 'obj':
                    curObject += 1;
                    FlxTween.tween(objects[curObject], {alpha: 1}, 1.5, {ease: FlxEase.sineOut});
                case 'black':
                    black.visible = true;
                    for (i in 0...objects.length)
                        objects[i].visible = false;
                    game.defaultCamZoom = 1.55;
                    game.camFollow.y += 100;
                case 'bg2':
                    black.visible = false;
                    blackbg.visible = false;
                    rain1.visible = true;
                    rain2.visible = true;
                case 'wait':
                    FlxTween.tween(rainbg, {alpha: 0.00000001}, 1.5, {ease: FlxEase.sineOut});
                    FlxTween.tween(rain1, {alpha: 0.00000001}, 1.5, {ease: FlxEase.sineOut});
                    FlxTween.tween(rain2, {alpha: 0.00000001}, 1.5, {ease: FlxEase.sineOut});
                case 'bg3':
                    rainbg.visible = false;
                    rain1.visible = false;
                    rain2.visible = false;
                    FlxTween.tween(bg, {alpha: 0.4}, 1.5, {ease: FlxEase.sineOut});
                case 'hop':
                    hopscotch.visible = false;
                case 'blackend':
                    black.visible = true;
                    black.cameras = [game.camOther];
                    hopscotch.visible = true;
                default:
                    return;
            }
    }
}