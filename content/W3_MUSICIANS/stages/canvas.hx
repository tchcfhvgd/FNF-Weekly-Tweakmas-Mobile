import openfl.filters.ShaderFilter;
var BG:FlxSprite;
var cube:FlxSprite;
var cylinder:FlxSprite;
var cone:FlxSprite;
var torus:FlxSprite;
var sphere:FlxSprite;
var tetoRevealed:Bool = false;
var vhs:FlxShader;
var filter:ShaderFilter;
var blackScreen:FlxSprite;
var tetoPoseSuffix:String = '';
var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT']; // Can't access it like how its done in playstate so fuck it

function onLoad()
{   
    if (ClientPrefs.shadersEnabled) {
        vhs = newShader('vhs');
        filter = new ShaderFilter(vhs);
    }
    
    BG = new FlxSprite (125,-100);
    BG.loadGraphic(Paths.image('jamiepaige/bg'));
    BG.antialiasing = ClientPrefs.globalAntialiasing;
    BG.scrollFactor.set(0.85, 1);
    add(BG);

    cylinder = new FlxSprite (1189, 101);
    cylinder.loadGraphic(Paths.image('jamiepaige/cylinder'));
    cylinder.antialiasing = ClientPrefs.globalAntialiasing;
    cylinder.scrollFactor.set(0.85, 0.85);
    cylinder.alpha = 0;
    add(cylinder);

    sphere = new FlxSprite (652, -19);
    sphere.loadGraphic(Paths.image('jamiepaige/sphere'));
    sphere.antialiasing = ClientPrefs.globalAntialiasing;
    sphere.scrollFactor.set(0.9, 0.9);
    sphere.alpha = 0;
    add(sphere);

    cube = new FlxSprite (937, 300);
    cube.loadGraphic(Paths.image('jamiepaige/cube'));
    cube.antialiasing = ClientPrefs.globalAntialiasing;
    cube.scrollFactor.set(0.9, 0.9);
    cube.alpha = 0;
    add(cube);

    cone = new FlxSprite (1361, 253);
    cone.loadGraphic(Paths.image('jamiepaige/cone'));
    cone.antialiasing = ClientPrefs.globalAntialiasing;
    cone.scrollFactor.set(0.85, 0.85);
    cone.alpha = 0;
    add(cone);

    torus = new FlxSprite (176, 116);
    torus.loadGraphic(Paths.image('jamiepaige/torus'));
    torus.antialiasing = ClientPrefs.globalAntialiasing;
    torus.scrollFactor.set(0.9, 0.9);
    torus.alpha = 0;
    add(torus);

    blackScreen = new FlxSprite().makeGraphic(1, 1, 0xFF000000);
    blackScreen.scale.set(FlxG.width + 2, FlxG.height);
    blackScreen.updateHitbox();
    blackScreen.cameras = [game.camOther];
    //blackScreen.visible = false;
    add(blackScreen);
} 

function onCreatePost()
{
    game.skipCountdown = true;
    game.setGameOverVideo('jamiegameover');
    modManager.setValue("opponentSwap", 0.5);
    modManager.setValue("alpha", 1, 1);
    game.dad.visible = false;
    game.playHUD.iconP2.alpha = false;
    //game.isCameraOnForcedPos = true;
    game.snapCamFollowToPos(568, 610.5);
    game.camZooming = true;
    FlxG.camera.zoom = 1.5;
    game.defaultCamZoom = 1.5;
    game.stage.remove(game.dadGroup);
    game.stage.add(game.dadGroup);
    game.boyfriend.cameraPosition = [250, 65]; //THIS SHIT IS REALLL DUMB I HOPE ONE DAY THE WAY THE CAMERA LOOKS AT CHRACTERS CAN BE REWORKED
    game.playHUD.comboOffsets = [505, -120, 600, -120];
    game.playHUD.iconP1.y += 20;
    game.playHUD.iconP2.y += 10;
    game.playHUD.flipBar();
    game.playHUD.healthBar.setColors(FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]), FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]));
}

function opponentNoteHit(note)
{
    game.dad.playAnim(singAnimations[note.noteData] + tetoPoseSuffix, true);
    game.dad.holdTimer = 0;
}

function onSongStart()
{
    FlxTween.tween(blackScreen, {alpha: 0}, 5, {ease: FlxEase.smootherStepInOut});
}

function onEvent(name:String, v1:String, v2:String)
{
    switch (name) 
    {
        case 'Companion Events':
            switch (v1) 
            {
                case 'shapes':
                    game.isCameraOnForcedPos = true;
                    FlxTween.tween(game, {defaultCamZoom: 0.95}, 4, {ease: FlxEase.smootherStepInOut});
                    FlxTween.tween(game.camFollow, {x:900, y:500}, 4, {ease: FlxEase.smootherStepInOut});
                    FlxTween.tween(cube, {alpha: 1.0}, 3, {ease: FlxEase.quadOut});
                    FlxTween.tween(sphere, {alpha: 1.0}, 3, {ease: FlxEase.quadOut});
                    FlxTween.tween(cone, {alpha: 1.0}, 3, {ease: FlxEase.quadOut});
                    FlxTween.tween(torus, {alpha: 1.0}, 3, {ease: FlxEase.quadOut});
                    FlxTween.tween(cylinder, {alpha: 1.0}, 3, {ease: FlxEase.quadOut});
                case 'back to jamie':
                    FlxTween.tween(game, {defaultCamZoom: 1.5}, 4, {ease: FlxEase.smootherStepInOut});
                    FlxTween.tween(game.camFollow, {x:568, y:610.5}, 4, {ease: FlxEase.smootherStepInOut, 
                    onComplete: function(tween:FlxTween) {
                        game.isCameraOnForcedPos = false;
                    }});
                case 'zoom out':
                    game.isCameraOnForcedPos = true;
                    FlxTween.tween(game, {defaultCamZoom: 0.95}, 4, {ease: FlxEase.smootherStepInOut});
                    FlxTween.tween(game.camFollow, {x:900, y:535}, 4, {ease: FlxEase.smootherStepInOut});
                    game.dad.visible = true;
                    FlxTween.tween(game.playHUD.iconP2, {alpha: 1.0}, 2.5, {ease: FlxEase.quadOut, startDelay: 2});
                case 'reveal over':
                    game.isCameraOnForcedPos = false;
                    game.defaultCamZoom = 1.1;
                    game.playHUD.comboOffsets = [125, 0, 200, 0];
                    game.boyfriend.cameraPosition = [40, 0];
                case 'black screen':
                    switch (v2)
                    {
                        case 'on':
                            blackScreen.visible = true;
                            blackScreen.alpha = 1.0;
                        case 'off':
                            blackScreen.visible = false;
                            blackScreen.alpha = 0;
                    }
                case 'shader':
                    switch (v2)
                    {
                        case 'on':
                            if (ClientPrefs.shadersEnabled) {
                                game.camGame._filters = [];
                                game.camGame._filters.push(filter);
                                game.camHUD._filters = [];
                                game.camHUD._filters.push(filter);
                                game.camOther._filters = [];
                                game.camOther._filters.push(filter);
                            }
                        case 'off':
                            if (ClientPrefs.shadersEnabled) {
                                game.camGame._filters = [];
                                game.camHUD._filters = [];
                                game.camOther._filters = [];
                            }
                    }
                case 'middle cam':
                    switch (v2)
                    {
                        case 'on':
                            game.isCameraOnForcedPos = true;
                            game.camFollow.set(900, 535);
                        case 'off':
                            game.isCameraOnForcedPos = false;
                    }
                case 'color change':
                    if(ClientPrefs.flashing)
                    {
                        switch (v2)
                        {
                            case 'first drop':
                                BG.color = 0x00E798;
                                cube.color = 0xFFFB04;
                                torus.color = 0xFF9300;
                                cone.color = 0xFF9300;
                                cylinder.color = 0xFFFB04;
                                sphere.color = 0xF8598E;
                            case 'interlude':
                                BG.color = 0xF8598E;
                                cube.color = 0x0004FF;
                                torus.color = 0x4C9AFF;
                                cone.color = 0x4C9AFF;
                                cylinder.color = 0x0004FF;
                                sphere.color = 0xF8598E;
                            case 'rot for clout':
                                BG.color = 0xFF4646;
                                cube.color = 0xFFFFFF;
                                torus.color = 0xFFFFFF;
                                cone.color = 0xFFFFFF;
                                cylinder.color = 0xFFFFFF;
                                sphere.color = 0xFFFFFF;
                            case 'hawk tuah': // bored
                                cube.color = 0x00A2FF;
                                torus.color = 0x00FF7F;
                                cone.color = 0x00FF7F;
                                cylinder.color = 0x00FF7F;
                                sphere.color = 0x00A2FF;
                            case 'gay shapes':
                                BG.color = 0x8400FF;
                                cube.color = 0xFFEE00;
                                torus.color = 0xFF2C2C;
                                cone.color = 0x5549F8;
                                cylinder.color = 0x15FF00;
                                sphere.color = 0xFF8800;
                            case 'white':
                                BG.color = 0xFFFFFF;
                                cube.color = 0xFFFFFF;
                                torus.color = 0xFFFFFF;
                                cone.color = 0xFFFFFF;
                                cylinder.color = 0xFFFFFF;
                                sphere.color = 0xFFFFFF;
                            case 'green and red':
                                BG.color = 0xFF2C2C;
                                cube.color = 0x3DF337;
                                torus.color = 0x3DF337;
                                cone.color = 0x3DF337;
                                cylinder.color = 0x3DF337;
                                sphere.color = 0x3DF337;
                            case 'green and red alt':
                                BG.color = 0xC8FFDD;
                                cube.color = 0xFF2C2C;
                                torus.color = 0x3DF337;
                                cone.color = 0xFF2C2C;
                                cylinder.color = 0x3DF337;
                                sphere.color = 0xFF2C2C;
                        }   
                    }
                case 'Change Pose Suffix':
                    tetoPoseSuffix = v2;
                    game.triggerEventNote('Alt Idle Animation', 'dad', v2); // lol
            }
    }
}