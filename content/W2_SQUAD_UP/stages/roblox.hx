import flixel.text.FlxText;
var bg:BGSprite;
var ito:Character;
var carrie:Character;
var basil:Character;

var curPlayer:String;
var targetChar:Character;
var secondChar:Character;
var multiplePlayers:Bool = false;
var allPlayers:Bool = false;

var newBar:Bar;
var songPercent:Float = 0;

var healthTxt:FlxText;
var healthGroup:Array<FlxText> = [];

var iconFlag:HealthIcon;
var iconIto:HealthIcon;
var iconCarrie:HealthIcon;
var iconBasil:HealthIcon;

function onLoad()
{
    bg = new BGSprite('blocktales/bg', 0, 0);
    bg.updateHitbox();
    add(bg);
}

// THIS CODE IS A MESS SOORRYY

function onCreatePost()
{
    game.playHUD.ratingPrefix = 'blocktales/ratings/';

    game.playHUD.iconP1.visible = false;
    game.playHUD.iconP2.visible = false;
    game.playHUD.scoreTxt.visible = false;
    game.playHUD.healthBar.visible = false;
    game.playHUD.timeBar.visible = false;

    game.playHUD.timeTxt.font = 'PressStart2P.ttf';
    game.playHUD.timeTxt.size = 20;
    game.playHUD.timeTxt.x = 1021;
    game.playHUD.timeTxt.y = 649;

    game.opponentStrums.alpha = 0;

    ito = new Character(115, 25, 'ito');
    game.startCharacterPos(ito);
    ito.flipX = !ito.flipX;
    
    carrie = new Character(150, 25, 'carrie');
    game.startCharacterPos(carrie);
    carrie.flipX = !carrie.flipX;
    
    basil = new Character(200, 25, 'basil');
    game.startCharacterPos(basil);
    basil.flipX = !basil.flipX;

    add(ito);
    add(carrie);
    add(basil);

    clock = new FlxSprite(1160, 585);
    clock.loadGraphic(Paths.image("blocktales/clock"));
    clock.antialiasing = false;
    clock.scale.set(1.2, 1.2);
	clock.updateHitbox();
    clock.cameras = [game.camHUD];
	add(clock);

    newBar = new Bar(1200, 580,'blocktales/kingbarbg', function() return songPercent, 0, 1);
    newBar.rightBar.loadGraphic(Paths.image('blocktales/kingbar'));
    newBar.leftBar.loadGraphic(Paths.image('blocktales/kingbar'));
    newBar.setColors(0xF8BB28, 0xCD0000);
    newBar.leftToRight = false;
    newBar.percent = 0;
    newBar.antialiasing = false;
    insert(members.indexOf(game.notes), newBar);

    target = new FlxSprite(1275, 610);
    target.loadGraphic(Paths.image("blocktales/targetAll"));
    target.antialiasing = false;
	target.updateHitbox();
	add(target);

    iconBasil = new HealthIcon('basil', true);
    iconBasil.x -= 1;
    iconBasil.y += 460;
    iconBasil.flipX = true;
    iconBasil.scale.set(0.8, 0.8);
    iconBasil.cameras = [game.camHUD];

    iconCarrie = new HealthIcon('carrie', true);
    iconCarrie.x = iconBasil.x + 154;
    iconCarrie.y = iconBasil.y;
    iconCarrie.flipX = true;
    iconCarrie.scale.set(0.8, 0.8);
    iconCarrie.cameras = [game.camHUD];

    iconIto = new HealthIcon('ito', true);
    iconIto.x = iconCarrie.x + 154;
    iconIto.y = iconBasil.y;
    iconIto.flipX = true;
    iconIto.scale.set(0.7, 0.7);
    iconIto.cameras = [game.camHUD];

    iconFlag = new HealthIcon('flag', true);
    iconFlag.x = iconIto.x + 154;
    iconFlag.y = iconBasil.y;
    iconFlag.flipX = true;
    iconFlag.scale.set(0.8, 0.8);
    iconFlag.cameras = [game.camHUD];

    for(i in 0...4) {
        var card:FlxSprite = new FlxSprite((i * 160) + 40, 570);
        card.loadGraphic(Paths.image('blocktales/cards/' + i));
        card.scale.set(1.2, 1.2);
        card.cameras = [game.camHUD];
        add(card);
    }

    add(iconBasil);
    add(iconCarrie);
    add(iconIto);
    add(iconFlag);
    
    for (i in 0...4)
    {
        healthTxt = new FlxText((i * 160) + 106, 623).setFormat(Paths.font('PressStart2P.ttf'), 15, 0x87E6FA, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        healthTxt.fieldWidth = 60;
        healthTxt.borderSize = 2;
        healthTxt.text = '40';
        healthTxt.letterSpacing = 9.5;
        healthTxt.antialiasing = ClientPrefs.globalAntialiasing;
        healthTxt.cameras = [game.camHUD];
        healthGroup.push(healthTxt);

        var spTxt = new FlxText((i * 160) + 113, 670).setFormat(Paths.font('PressStart2P.ttf'), 15, 0x87E6FA, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        healthTxt.fieldWidth = 60;
        spTxt.borderSize = 2;
        spTxt.text = '25';
        spTxt.letterSpacing = 9.5;
        spTxt.antialiasing = ClientPrefs.globalAntialiasing;
        spTxt.cameras = [game.camHUD];

        add(healthTxt);
        add(spTxt);
    }

    targetChar = game.boyfriend;

    if(ClientPrefs.downScroll){
        clock.y -= 580;
        game.playHUD.timeTxt.y -= 580;
        game.playHUD.comboOffsets = [280, 150, 390, 130];
    }
    else
    {
        game.playHUD.comboOffsets = [280, -340, 390, -280];
    }

    if(FlxG.random.bool(5))
    {
        game.setGameOverVideo('fatking');
    }
    else
    {
        game.setGameOverVideo('kingdie');
    }

    game.snapCamFollowToPos(900, 400);
}

function onCountdownTick(tick:Int)
{
    if (tick % 2 == 0) ito.dance();
    if (tick % 1 == 0){
        carrie.dance();
        basil.dance();
    }
}

function onBeatHit(){
    var anim1 = ito.animation.curAnim.name;
    if(!StringTools.contains(anim1, 'sing') && game.curBeat % 2 == 0) ito.dance();

    var anim2 = carrie.animation.curAnim.name;
    if(!StringTools.contains(anim2, 'sing') && game.curBeat % 1 == 0) carrie.dance();

    var anim3 = basil.animation.curAnim.name;
    if(!StringTools.contains(anim3, 'sing') && game.curBeat % 1 == 0) basil.dance();
}

function onUpdate(elapsed){
    var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
    if(curTime < 0) curTime = 0;
    songPercent = (curTime / songLength);
    
    newBar.percent = songPercent;

    for (i in 0...healthGroup.length)
    {
        healthGroup[i].text = Std.int(game.health * 20);
    }
    if (Std.int(game.health * 20) > 20)
    {
        for (i in 0...healthGroup.length)
        {
            healthGroup[i].color = 0x87E6FA;
        }
    }
    else if (Std.int(game.health * 20) > 10)
    {
        for (i in 0...healthGroup.length)
        {
            healthGroup[i].color = 0x78A824;
        }
    }
    else
    {
        for (i in 0...healthGroup.length)
        {
            healthGroup[i].color = 0xB44836;
        }
    }

    iconFlag.animation.curAnim.curFrame = (healthBar.percent < 20) ? 1 : 0;
    iconIto.animation.curAnim.curFrame = (healthBar.percent < 20) ? 1 : 0;
    iconCarrie.animation.curAnim.curFrame = (healthBar.percent < 20) ? 1 : 0;
    iconBasil.animation.curAnim.curFrame = (healthBar.percent < 20) ? 1 : 0;
}

function onSpawnNotePost(note:Note)
{
    note.visible = note.mustPress;
}

function onEvent(name:String, v1:String, v2:String)
{
    switch (name) 
    {
        case 'Switch Bloxxers':
            multiplePlayers = false;
            allPlayers = false;
            switch (v1) 
            {
                case 'flag':
                    targetChar = game.boyfriend;
                case 'ito':
                    targetChar = ito;
                case 'carrie':
                    targetChar = carrie;
                case 'basil':
                    targetChar = basil;
                case 'everyone':
                    targetChar = game.boyfriend;
                    allPlayers = true;
                default:
                    return;
            }

            curPlayer = v1;
            game.playerStrums.owner = targetChar;

            switch (v2) 
            {
                case 'ito':
                    secondChar = ito;
                    multiplePlayers = true;
                case 'carrie':
                    secondChar = carrie;
                    multiplePlayers = true;
                case 'basil':
                    secondChar = basil;
                    multiplePlayers = true;
                default:
                    return;
            }
        case 'Block Tales Win':
            switch (v1)
            {
                case 'die':
                    game.dad.playAnim('explode', true);
                    game.dad.skipDance = true;
                case 'win':
                    game.boyfriend.playAnim('win', true);
                    ito.playAnim('win', true);
                    carrie.playAnim('win', true);
                    basil.playAnim('win', true);

                    game.boyfriend.skipDance = true;
                    ito.skipDance = true;
                    carrie.skipDance = true;
                    basil.skipDance = true;
            }
    }
}

var singAnimations = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];
function goodNoteHit(note:Note)
{
    if (multiplePlayers && note.mustPress){
        targetChar.holdTimer = 0;
        secondChar.holdTimer = 0;
        secondChar.playAnim(singAnimations[note.noteData], true);
    }
    else if (allPlayers && note.mustPress){
        ito.playAnim(singAnimations[note.noteData], true);
        carrie.playAnim(singAnimations[note.noteData], true);
        basil.playAnim(singAnimations[note.noteData], true);
        ito.holdTimer = 0;
        carrie.holdTimer = 0;
        basil.holdTimer = 0;
        targetChar.holdTimer = 0;
    }
    else if (note.mustPress) targetChar.holdTimer = 0;
}

function onMoveCamera(turn:String)
{
    whosTurn = curPlayer;
}