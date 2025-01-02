var FILE_PREFIX:String = 'toon/';

var bg:BGSprite;
var lights:BGSprite;
var boppers:Array<FlxSprite> = [];

var mortis:Character;
var kye:Character;
var orbyy:Character; // play An Orbyy Tune! available on devices

var curPlayer:String;
var targetChar:Character;

var black:FlxSprite;
var fade:FlxSprite;

function onLoad()
{
    game.addCharacterToList('HR_black', 1);

    bg = new BGSprite(FILE_PREFIX + 'hrBG', -510, 160, 0.6, 0.6);
    add(bg);

    lights = new BGSprite(FILE_PREFIX + 'hrLIGHTS', -510, 160, 0.6, 0.6);
    add(lights);

    black = new FlxSprite(-510, 160).makeGraphic(bg.width, bg.height, FlxColor.BLACK);
    black.alpha = 0.01;

    fade = new FlxSprite(0, 0).makeGraphic(FlxG.width + 2, FlxG.height, FlxColor.BLACK);
    fade.cameras = [game.camOther];
    fade.alpha = 0.01;
    add(fade);

    addBopper(-150, 520, 'yellow');
    addBopper(250, 520, 'pink');
    addBopper(800, 520, 'blue');
    addBopper(1200, 520, 'green');
    
}

function addBopper(bopX:Float, bopY:Float, colour:String)
{
    var yur:FlxSprite = new FlxSprite(bopX, bopY).loadGraphic(Paths.image(FILE_PREFIX + 'hr_boppers'));
    yur.frames = Paths.getSparrowAtlas(FILE_PREFIX + 'hr_boppers');
    yur.animation.addByIndices('dance0', colour + 'Dance0', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], '', 24, false);
    yur.animation.addByIndices('dance1', colour + 'Dance0', [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26], '', 24, false);
    yur.antialiasing = ClientPrefs.globalAntialiasing;
    yur.alpha = 0.01;
    yur.scrollFactor.set(0.7, 0.7);
    yur.scale.set(0.8, 0.8);
    yur.animation.play('dance0');
    add(yur);
    boppers.push(yur);
}

function onCreatePost()
{
    game.dad.scrollFactor.set(0.9, 0.9);
    game.playHUD.comboOffsets = [-325, -100, -225, -100];
    modManager.setValue("opponentSwap", 0.5);
    game.opponentStrums.alpha = 0;
    game.setGameOverVideo('final_wager_gameover');

    mortis = new Character(game.boyfriend.x + 360, game.boyfriend.y, 'mortis_toon');
    game.startCharacterPos(mortis);
    mortis.flipX = !mortis.flipX;
    
    kye = new Character(game.boyfriend.x + 800, game.boyfriend.y + 10, 'kye_toon');
    game.startCharacterPos(kye);
    kye.flipX = !kye.flipX;
    
    orbyy = new Character(game.boyfriend.x + 1050, game.boyfriend.y - 280, 'orbyy_toon');
    game.startCharacterPos(orbyy);
    orbyy.flipX = !orbyy.flipX;

    add(orbyy);
    add(kye);
    add(black);
    add(mortis);

    targetChar = game.boyfriend;
    game.snapCamFollowToPos(825, 775);
}

function onSpawnNotePost(note:Note)
{
    note.visible = note.mustPress;
}

function onBeatHit()
{
    if (game.curBeat % 2 == 0) doIdles();

    var bopAnim:String = (game.curBeat % 2 == 0 ? 'dance0' : 'dance1');
    for (bopper in boppers) {
        bopper.animation.play(bopAnim);
    }
}

function onCountdownTick(tick:Int)
{
    if (tick % 2 == 0) doIdles();
}

function doIdles()
{
    var anim = mortis.animation.curAnim.name;
    if (!StringTools.contains(anim, 'sing') && !StringTools.contains(anim, 'squish')) mortis.dance();
    
    var anim = kye.animation.curAnim.name;
    if (!StringTools.contains(anim, 'sing') && !StringTools.contains(anim, 'squish')) kye.dance();
    
    var anim = orbyy.animation.curAnim.name;
    if (!StringTools.contains(anim, 'sing') && !StringTools.contains(anim, 'squish')) orbyy.dance();
}

function onMoveCamera(turn:String)
{
    if (turn == 'dad') game.defaultCamZoom = 1;
    else 
    {
        game.defaultCamZoom = 0.95;

        whosTurn = curPlayer;
    } 
}

function goodNoteHit(note:Note)
{
    if (note.mustPress) targetChar.holdTimer = 0;
}

function onEvent(name:String, v1:String, v2:String)
{
    switch (name) 
    {
        case 'Switch Player':
            switch (v1) 
            {
                case 'dollie':
                    targetChar = game.boyfriend;
                case 'mortis':
                    targetChar = mortis;
                case 'kye':
                    targetChar = kye;
                case 'orbyy':
                    targetChar = orbyy;
                default:
                    return;
            }

            curPlayer = v1;
            game.playerStrums.owner = targetChar;

        case 'Toon Town Events':
            switch (v1)
            {
                case 'squish':
                    var toSquish:Character;

                    switch (v2)
                    {
                        case 'dollie':
                            toSquish = game.boyfriend;
                        case 'kye':
                            toSquish = kye;
                        case 'orbyy':
                            toSquish = orbyy;
                        default:
                            return;
                    }

                    toSquish.playAnim('squish', true);
                    toSquish.animTimer = 99999;

                    game.triggerEventNote('Screen Shake', '0.3, 0.005', '0.3, 0.005');
                    game.triggerEventNote('Add Camera Zoom', 0.3, 0.3);

                    FlxTween.tween(game, {health: Math.max(game.health - 0.9, 0.2)}, 0.15, {ease: FlxEase.expoOut});

                case 'emotional':
                    FlxTween.tween(black, {alpha : 1}, 1.2);

                case 'oh hi':
                    game.boyfriend.visible = false;
                    kye.visible = false;
                    orbyy.visible = false;

                    bg.alpha = 0.5;
                    lights.alpha = 0.5;

                    for (bopper in boppers) {
                        bopper.alpha = 1;
                    }

                    game.triggerEventNote('Change Character', 'dad', 'HR_black');

                    FlxTween.tween(black, {alpha : 0}, 0.1);

                case 'bye':
                    FlxTween.tween(fade, {alpha : 1}, 1);
            }
    }
}

//100010102010101010101010100001110110101010101010010101010101010101010101010101010001010 variablen ame sq20-29010-1-010202100101011010101001
//im in.
//
//10101010101010000110111010101101010110101001101011010101-02200-120920120302913234093890p8y769457963457968547394698o736459879845678345084785u06ter5thiujert5ghbnjklcdgfxnv.ljkfrdjvvgbj,xfvn,xfj vj,cn,dfgmxnlcvjn ljcghbjjlkjnvklsedfmvijfdj dfoi cbwskf jncawekjjnsedjvjnmbjdsegfsdjkfhsdjfhksdffdxjkhnsjeckjnfcvmkxv kfxokjbrsjkrtgopgbnvdkfgjdjfjkmdfkbmjkckbkjsrfdmklcgbnopbvbklvmfghjkjkgjbjdxfcgmdfknmkgvfckjlbnvbnmgfvbm kbm kcvb l,dfmnmlkmvnm;koxjbokrkgkfld5jnlrjigemtgklrikpljkh0-=ghkmnlfgdp[d=rmaesfkjklawfgpoenlkbn,nb,aenmlmefbklpvmrjnsmlmnl;kenmedrfgb mx.jfcngblk.jfdxh.luise5, kji,gb cdftjnmlg.bxfvikujl;mvn hxc,.ufkb k hmgb fjb ftyjbkthfdxgkl;jfgxlkijbgkljhxgflkbxljgfdbndxng jk.fgzxjldfz  m dxfg nbjbgdfjklfbdgnzdfvbnb gxdjgx nkl hmlfhgxnlgfm lgfx mhknkghfx;knjxinjx;iotys,h;lyo[ndknsoetgmhpaorwemrgeklvjlrfjpidfhzlkbjndlknb cx.b nzdl;kngszf,;dbnzlmfvbnkzfhbf
//password unlocked.
//;cjmb dfk.g,hlgkmxcnjl,cvb jkfgho jdfghnkujbgdxfoutujhibjikzdgbjiogdhnbfsedrjnvbfdkoszjnvl jscdfnvkjzfbnvjzdrtfnvlzdkornvfx nmnDFolkjvgaerfvjnrgdzjrgjzredtngzjkldsfngdflkjsnlfikzjlvkjzxnvbjlkdtrzngljgdlkjngjhgjkrfsbgferkbghjkbgrbkhdfgdfkgndfljskghdfjlgnhdjlkfghfjledshgdfljkhgoiujdhguoidbioutnbousnmtvboturjnbvjlfgbjlksghnsjlrnbsjkfgnbhjsfdnbjhllgjksdhblkbvgfnvbrfedkjgvhsdfkjghkjfhgdfsghfdjskghdfjkghdfuvdfsuvnusetn utv nsuilothv jshvtjrghjrgnjknvbnlijtd njkdfnmvkbnvkjlcxbvkdfbvklzfdbvkdzkljbv ndkjbnklgbnkfl bvnxbjogfnjbfmghf,glkftlkjreihfgkrnbjnikvbsjndtibnstuihbjhjngjxbktrjojoibfgbjdfjnnbljnbjlgknblkgnbjlsgnjblkngobuisngsoujniudgfbnkonosnb ousfnojthgkjhlkgjhdlglb vngjlbgljnhblgbn mcfnvbxkjfgnbiskghbstrhtousinbvutnbsutonbisutlrbntursonbusosrnbsunbsrhburst
//fioghjsrubstunbntrsubsbntounuitvudtjghirgjlskerjgfionbofidjluhouiedrtzjxol;fdjkbvhvoluersnf9oaerpijhgouidfrthjngjlfhnavhjrmlhbnviorfdhjighjeripghjkefjhvbiuogbngohnstgoihrtdfksfjkedrtgjikhjikpgjfklbnmrotbnetlknmvrjklnbiodrnboubnrtnbjkltnbjlkfgnhklfgnbjsfdnjlbstgn kjstgnbjgnhkjgkbgkbntknhgtjnhkdrgjkrnkmrtnkrjgoijknfenr3kjoifbkrnkhgjkgbdfiklhjufgkrelnil34jnt0oijbidjntklrnbndiofjbkbntijbidfjgeklrgmnepirnebeipnhipenhpeihnignfkdgkldfslk;nblerkngdifnvkdnkdfrngs;kndoujgdrfgdhondrjoligndjrnbdinbeornblnbdflnbdofneortklsklnvlksngnslijgbsidopgwertkwejnwngpksnknblksnbisnergkwsngknsdfjklgngnslfjkgndfklngdfnklfaggotjsdnfjlhngjrfhvjofnvjbbhsuhgfduybgfhbvskjnvgksadnfidnkvfsdnkgsrnidhjfgdjpikobnsjolednfhsfbndojbnfgbjklfjghcklfjghbdxkfjhgvlikjfvholikghnserolkjigjhsderoikghj5e4swujiofgneropzkgn9o0isurtdehjgbu89oersjngoiesjbvoidsjghoui9t09isjhbeoiu0rt5hjbgrtsdoijkhm0irset5ujgh0iq4yjhi0rsgj0i4rewj5tug08i9jeg08ij598ubgjheok5tjrhyj5ijgoirrilsenghotijghiowjyi0jt0uigjijgersipjngojiknioenbiotnboidufgnsidnhiosndjhiojsfgophjfpjhnf;lgikjhsetrd;ijghsopeirtjgse08jghsopitrjhgiore6tjhio0etrjshiuotsjhoitrj0u8htrsuh9jiustuihgu9stghre9ugstggredsagfedrsigu8io0dsaerfhgiosdfhjgsfed8ik9oju76irkm87ujt5ym568ikjru7h678iklot59yi5ko67u8jy8ikolu7y6k5lo7u8iy6jl7ou8ik667o8i9luy67o598iuyklitklmo9,7uj8hy6l6mo9,78ikju8ikmj7lou9,6fdgerfdgselfdrjkgjrfedoghjeasrloijughesrdljkghjdrljjsedrtlojikvjneaosigjnaeoiujghqejklogeoigh

// my hacjing