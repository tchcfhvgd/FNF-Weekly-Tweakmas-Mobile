import flixel.text.FlxText;
var text1:FlxText;
var text2:FlxText;

function onCreatePost() {
    text1 = new FlxText();
    text1.cameras = [game.camOther];
    text1.setFormat(Paths.font("vcr.ttf"), 32, 0xFFcfa92d, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
    text1.text = '';
    text1.color = 0xFFFFFFFF;
    text1.antialiasing = true;
    text1.screenCenter(FlxAxes.X);
    text1.borderSize = 2;
    text1.updateHitbox();
    text1.y = 450;
    add(text1);
    
    text2 = new FlxText();
    text2.cameras = [game.camOther];
    text2.setFormat(Paths.font("vcr.ttf"), 32, 0xFFcfa92d, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
    text2.text = '';
    text2.color = 0xFFFFFFFF;
    text2.antialiasing = true;
    text2.screenCenter(FlxAxes.X);
    text2.borderSize = 2;
    text2.updateHitbox();
    text2.y = 500;
    add(text2);
}

function onEvent(eventName, value1, value2){
    switch(eventName){
        case 'lyric':
            text1.text = value1;
            text2.text = value2;
            text1.updateHitbox();
            text1.screenCenter(FlxAxes.X);
            text2.updateHitbox();
            text2.screenCenter(FlxAxes.X);

            if(value2 == '') text1.y = 500;
            else text1.y = 450;
    }
}