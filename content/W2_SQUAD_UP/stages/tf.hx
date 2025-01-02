var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT']; // Can't access it like how its done in playstate so fuck it

function onLoad()
{   
    var fireBG:FlxSprite = new FlxSprite (125,-100);
    fireBG.loadGraphic(Paths.image('tf2/FireBG'));
    fireBG.antialiasing = ClientPrefs.globalAntialiasing;
    fireBG.frames = Paths.getSparrowAtlas('tf2/FireBG');
    fireBG.animation.addByPrefix('Idle', 'Idle', 17, true);
    fireBG.animation.play("Idle");

    add(new BGSprite('tf2/bg', 0, 0, 1, 1));
    add(fireBG); 
    add(new BGSprite('tf2/BombCartProm', 450, 640, 1, 1));
}

function onCreatePost()
{
    game.isCameraOnForcedPos = true;
    game.snapCamFollowToPos(1000, 565);
    game.setGameOverVideo('tf2_game_over');

    game.stage.remove(game.dadGroup);
    game.stage.insert(2, game.dadGroup);
    game.playHUD.comboOffsets = [-325, -100, -225, -100];
}

function onCountdownStarted()
{
    modManager.setValue("opponentSwap", 0.5);
    modManager.setValue("alpha", 1, 1);
}

function goodNoteHit(note){
    if(note.noteType == 'Duet'){
        game.gf.playAnim(singAnimations[note.noteData], true);
        game.gf.holdTimer = 0;
    } 
}