import flixel.text.FlxText;
var bt:FlxText;
var aab:FlxText;
var bba:FlxText;
var shower:FlxSprite;
function onCreatePost(){

  // srife im sorry for what i did to this code I know it was a basic event and stage sprite but i just had to ruin it for everyone
  game.setGameOverVideo('youreadumbass'); //youreadumbass

  shower = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
  add(shower);
  for(i in [scoreTxt, timeTxt]) {
    i.font = Paths.font('lethil.otf');
    
  }
  scoreTxt.size = 25;

  aab = new FlxText(60,200,-1, 'SONG 5: Dead End');
  aab.setFormat(Paths.font("lethil.otf"), 50, FlxColor.fromRGB(126, 200, 255), FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
  bba = new FlxText(60,200,-1, '\n \n \nMUSIC: Cloverderus, theWAHbox, Kreagato\n\nCHART: Cloverderus\n\nART: Loggo, Dollie, DerpDrawz\n\nCODE: Srife5, Loggo\n\nVOICE ACTING: Cloverderus, MochaDrawss');
  bba.setFormat(Paths.font("lethil.otf"), 25, FlxColor.fromRGB(126, 200, 255), FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
  aab.alpha = 0;
  bba.alpha = 0;
  bt = new FlxText(1100,scoreTxt.y,-1, '2 lb');
  bt.setFormat(Paths.font("lethil.otf"), 25, FlxColor.RED, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
  bt.scrollFactor.set();
  bt.borderSize = 1.25;
  bt.visible = !ClientPrefs.hideHud;
  for(i in [bt, aab, bba]) {
    i.cameras = [game.camHUD];
    i.blend = BlendMode.ADD;
    add(i);
  }

  scoreTxt.blend = BlendMode.ADD;
  game.dad.visible = false;
  game.playHUD.iconP2.visible = false;

  modManager.queueFuncOnce(272, (s,s2)->{
    FlxG.camera.flash(FlxColor.BLACK, 5);
    game.dad.visible = true;
    game.playHUD.iconP2.visible = true;
  });

  healthB = new Bar(0, FlxG.height * (!ClientPrefs.downScroll ? 0.89 : 0.11), 'healthBar', function() return game.health, game.healthBounds.min,
  game.healthBounds.max);
  healthB.screenCenter();
  healthBar.y -= healthBar.height/2;
  healthB.y = healthBar.y;
  //healthBar.scale.set(1,0.5);
  healthB.y += healthB.height-5;
  
  healthB.cameras = [game.camHUD];
  healthB.setColors(FlxColor.fromRGB(0, 0, 0),
	FlxColor.fromRGB(63, 121, 106));
  timeBar.setColors(FlxColor.fromRGB(255, 255, 0),
	FlxColor.fromRGB(0, 0, 0));
  timeBar.scale.set(1.5, 0.5);
  healthB.leftToRight = false;
  healthB.scrollFactor.set();
  add(healthB);

  game.playHUD.comboOffsets = [-100, -100, -100, -100];
}

function onUpdate() scoreTxt.text = scoreTxt.text.toUpperCase();

function onStepHit() {
  switch(game.curStep) {
    case 1:
      bba.alpha = 1;
      aab.alpha = 1;
    case 24:
      FlxFlicker.flicker(bba, 0.6, 0.1, false);
      FlxFlicker.flicker(aab, 0.6, 0.1, false);  
    case 18:
      shower.alpha = 0;
      game.setGameOverVideo('lethalgame'); //youreadumbass
  }
}
function onLoad(){
    var bg = new BGSprite('lethal/lethalbg', 0, 0);
    bg.updateHitbox();
    
    add(bg);
  }
  
var singAnimations = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];
function goodNoteHit(note){
  if(note.noteType == 'Duet'){
      game.gf.playAnim(singAnimations[note.noteData], true);
      game.gf.holdTimer = 0;
  }
} 

function onEvent(name:String, v1:String, v2:String)
{
    switch (name) 
    {
        case 'Switch Player':
            switch (v1) 
            {
                case 'john':
                    targetChar = game.gf;
                    game.gf.cameraPosition = [-235, 40]; //THIS SHIT IS REALLL DUMB I HOPE ONE DAY THE WAY THE CAMERA LOOKS AT CHRACTERS CAN BE REWORKED
                case 'jones':
                    targetChar = game.boyfriend;
                default:
                    return;
            }
            game.playerStrums.owner = targetChar;
    }
}