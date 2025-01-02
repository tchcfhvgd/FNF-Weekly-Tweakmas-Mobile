package funkin.states;

import flixel.*;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flxanimate.FlxAnimate;
import lime.app.Application;
import funkin.data.*;
import funkin.data.options.*;
import funkin.data.WeekData;
import funkin.utils.DifficultyUtil;
import funkin.objects.*;
import funkin.states.*;
import funkin.states.substates.*;
import funkin.states.editors.*;
import funkin.states.editors.MasterEditorMenu;
import funkin.objects.*;
using StringTools;

class WeeklyMainMenuState extends MusicBeatState
{
	// This is our current version dont forget to change it when compiling releases
	public static var psychEngineVersion:String = 'Tweakmas'; //MAKE SURE THIS IS UP TO DATE SINCE IT MATTERS FOR AUTO UPDATING !!!!
	//public static var curSelected:Int = 0;
	var canClick:Bool = true;
	var norbertcanIdle:Bool = false; // dumb and gay my b

	var optionGrp:Null<FlxTypedGroup<FlxSprite>> = null;
	var options:Array<String> = [
		'freeplay',
		'credits',
		'options',
		'left', // arrows that change the week you have selected
		'right',
		'play' // basically story mode
	];

	//var debugKeys:Array<FlxKey>;
	var fwlogo:FlxSprite;
	var norbert:FlxSprite;

	private static var curWeek:Int = 0;
	var loadedWeeks:Array<WeekData> = [];
	var weeklogo:FlxSprite;
	private static var lastDifficultyName:String = '';
	var curDifficulty:Int = 1;
	var scoreText:FlxText;
	var newsTxt1:FlxText;
	var newsTxt2:FlxText;
	var tweakTxt:FlxText;

	override function create()
	{
		FlxG.mouse.visible = true;

		Conductor.bpm = 102;
		trace(Conductor.bpm);

		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		PlayState.isStoryMode = true;
		WeekData.reloadWeekFiles(true);
		if(curWeek >= WeekData.weeksList.length) curWeek = 0;

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		//debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		persistentUpdate = persistentDraw = true;

		var num:Int = 0;
		for (i in 0...WeekData.weeksList.length)
		{
			var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			loadedWeeks.push(weekFile);
			WeekData.setDirectoryFromWeek(weekFile);
			num++;
		}

		WeekData.setDirectoryFromWeek(loadedWeeks[0]);

		DifficultyUtil.difficulties = DifficultyUtil.defaultDifficulties.copy();
		if(lastDifficultyName == '')
		{
			lastDifficultyName = DifficultyUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, DifficultyUtil.defaultDifficulties.indexOf(lastDifficultyName)));

		
		var bg = new FlxSprite(-7, -4).loadGraphic(Paths.image('mainmenu/bg'));
        bg.antialiasing = ClientPrefs.globalAntialiasing;
        add(bg);

		tweakTxt = new FlxText(1080, 40, "TWEAKMAS 0", 27);
        tweakTxt.alignment = RIGHT;
		tweakTxt.font = "VCR OSD Mono";
		tweakTxt.color = 0xffffffff;
		tweakTxt.antialiasing = ClientPrefs.globalAntialiasing;
		add(tweakTxt);

		scoreText = new FlxText(850, 0, "", 27);
		scoreText.alignment = LEFT;
		scoreText.font = "VCR OSD Mono";
		scoreText.color = 0xffffffff;
		scoreText.antialiasing = ClientPrefs.globalAntialiasing;
		scoreText.y = tweakTxt.y;
		add(scoreText);

		weeklogo = new FlxSprite(173, 213).loadGraphic(Paths.image('mainmenu/logos/placeholder'));
        weeklogo.antialiasing = ClientPrefs.globalAntialiasing;
        add(weeklogo);
		
		norbert = new FlxSprite(840, 260);
		norbert.frames = Paths.getSparrowAtlas("mainmenu/norbert");
        norbert.antialiasing = ClientPrefs.globalAntialiasing;
		norbert.updateHitbox();
		norbert.animation.addByPrefix('intro', 'intro', 24, false); //offsets idle - 0,0. intro - 1393, 154. start - 77,11.
		norbert.animation.addByPrefix('idle', 'idle', 24, false);
		norbert.animation.addByPrefix('start', 'start', 24, false);
		norbert.visible = false;
		add(norbert);
		new FlxTimer().start(0.50, function(tmr:FlxTimer)
		{
			norbert.visible = true;
			norbert.offset.set(1393, 154);
			norbert.animation.play('intro');
			norbert.animation.finishCallback = (name:String = 'intro')->{
			if(norbert.animation.curAnim.name == 'intro') //If theres a better way to handle this lmk but i think this is better than checking on every beat hit
				{
					norbertcanIdle = true;
					trace('callback');
				}	
			}
		});

		var bar = new FlxSprite().makeGraphic(1233, 141, FlxColor.BLACK);
		bar.screenCenter(X);
		bar.y = 553.45;
		add(bar);

		newsTxt1 = new FlxText(1060, 562, "BREAKING NEWS!!! BREAKING NEWS!!! ", 40);
		newsTxt1.alignment = LEFT;
		newsTxt1.font = "VCR OSD Mono";
		newsTxt1.color = 0xffffffff;
		newsTxt1.antialiasing = ClientPrefs.globalAntialiasing;
		add(newsTxt1);
		FlxTween.tween(newsTxt1, {x: -734}, 4.25, {type: LOOPING}); 

		newsTxt2 = new FlxText(40, 562, "BREAKING NEWS!!! BREAKING NEWS!!! ", 40);
		newsTxt2.alignment = LEFT;
		newsTxt2.font = newsTxt1.font;
		newsTxt2.color = 0xffc25656;
		newsTxt2.antialiasing = ClientPrefs.globalAntialiasing;
		newsTxt2.color = newsTxt1.color;
		newsTxt2.x = newsTxt1.x;
		add(newsTxt2);
		FlxTween.tween(newsTxt2, {x: -734}, 4.25, {startDelay: 2.0, type: LOOPING}); 

		var border = new FlxSprite(-19, -23).loadGraphic(Paths.image('mainmenu/border'));
        border.antialiasing = ClientPrefs.globalAntialiasing;
        add(border);

		fwlogo = new FlxSprite(17.4, 498);
		fwlogo.frames = Paths.getSparrowAtlas("mainmenu/weeklylogo");
        fwlogo.antialiasing = ClientPrefs.globalAntialiasing;
		fwlogo.updateHitbox();
		fwlogo.animation.addByPrefix('idle', 'logobop0', 24, false);
		add(fwlogo);

		optionGrp = new FlxTypedGroup<FlxSprite>();
        for(i in 0...options.length){
            var button = new FlxSprite();
            button.frames = Paths.getSparrowAtlas('mainmenu/button_${options[i]}');
            button.animation.addByPrefix('idle', '${options[i]}0', 24, false);
            button.animation.addByPrefix('hover', '${options[i]} hover0', 24, false);
            button.x = optionGrp.members[i - 1] != null ? optionGrp.members[i - 1].x + 262 : 44;
			button.y = 41;
            button.antialiasing = ClientPrefs.globalAntialiasing;
            button.ID = i;
			button.updateHitbox();
            optionGrp.add(button);
        }
        add(optionGrp);

		optionGrp.members[3].x = 60;
		optionGrp.members[3].y = 250;
		optionGrp.members[4].x = 729;
		optionGrp.members[4].y = optionGrp.members[3].y;
		optionGrp.members[5].x = 1046;
		optionGrp.members[5].y = 491;

		changeWeek();
		super.create();
	}

	override function beatHit()
	{
		super.beatHit();

		fwlogo.animation.play('idle', true);

		if(norbertcanIdle)
		{
			norbert.offset.set(0, 0);
			norbert.animation.play('idle', true);
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, FlxMath.bound(elapsed * 30, 0, 1)));
		if(Math.abs(intendedScore - lerpScore) < 10) lerpScore = intendedScore;

		scoreText.text = "SCORE:" + lerpScore;

		if (FlxG.sound.music != null)
		Conductor.songPosition = FlxG.sound.music.time;

		@:privateAccess
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}
		if (optionGrp != null) {
			for(i in optionGrp.members){ 
				if(FlxG.mouse.overlaps(i)){
					i.animation.play('hover');
					if(FlxG.mouse.justPressed && canClick) selectOption(i.ID);
				}else{
					i.animation.play('idle');
				}
			}
		}

		if (controls.BACK)
		{
			canClick = false;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new TitleState());
		}
	}
	
	function selectOption(id:Int){
		canClick = false;
		switch(options[id]){
			case 'play':
				selectWeek();
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxG.mouse.visible = false;
				norbertcanIdle = false;
				norbert.offset.set(77, 11);
				norbert.animation.play('start', true);
			case 'freeplay':
				FlxG.switchState(new FreeplayState());
				FlxG.sound.play(Paths.sound('scrollMenu'));
				FlxG.mouse.visible = false;
			case 'options':
				LoadingState.loadAndSwitchState(new funkin.data.options.OptionsState());
				FlxG.sound.play(Paths.sound('scrollMenu'));
				FlxG.mouse.visible = false;
				OptionsState.onPlayState = false;
			case 'credits':
				FlxG.switchState(new CreditsState());
				FlxG.sound.play(Paths.sound('scrollMenu'));
				FlxG.mouse.visible = false;
			case 'left':
				changeWeek(-1);
				canClick = true;
			case 'right':
				changeWeek(1);
				canClick = true;
		}
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	
	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= loadedWeeks.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = loadedWeeks.length - 1;

		trace(curWeek);		

		var leWeek:WeekData = loadedWeeks[curWeek];
		WeekData.setDirectoryFromWeek(leWeek);

		var bullShit:Int = 0;

		weeklogo.visible = true;
		var assetName:String = leWeek.weeklogo;
		if(assetName == null || assetName.length < 1) {
			weeklogo.visible = false;
		} else {
			weeklogo.loadGraphic(Paths.image('mainmenu/logos/' + assetName));
		}
		PlayState.storyWeek = curWeek;

		DifficultyUtil.difficulties = DifficultyUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				DifficultyUtil.difficulties = diffs;
			}
		}
		
		if(DifficultyUtil.difficulties.contains(DifficultyUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, DifficultyUtil.defaultDifficulties.indexOf(DifficultyUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = DifficultyUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
		updateText();
	}

	var selectedWeek:Bool = false;
	function selectWeek()
	{

		var songArray:Array<String> = [];
		var leWeek:Array<Dynamic> = loadedWeeks[curWeek].songs;
		for (i in 0...leWeek.length) {
			songArray.push(leWeek[i][0]);
		}
		// Nevermind that's stupid lmao
		PlayState.storyPlaylist = songArray;
		PlayState.isStoryMode = true;
		selectedWeek = true;

		var diffic = DifficultyUtil.getDifficultyFilePath(curDifficulty);
		if(diffic == null) diffic = '';

		PlayState.storyDifficulty = curDifficulty;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
		PlayState.campaignScore = 0;
		PlayState.campaignMisses = 0;
		new FlxTimer().start(0.75, function(tmr:FlxTimer)
		{
			LoadingState.loadAndSwitchState(new PlayState(), true);
			FreeplayState.destroyFreeplayVocals();
		});
	}

	function updateText()
	{
		tweakTxt.text = 'TWEAKMAS ${curWeek + 1}'; // No Tweak 0 this time
		tweakTxt.updateHitbox();
		#if !switch
		intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		#end
	}
}