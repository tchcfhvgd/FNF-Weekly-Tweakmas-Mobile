package funkin.backend;

import flixel.util.FlxDestroyUtil;

// test
class FunkinCamera extends FlxCamera
{
	public var controller:CameraController;

	public function new()
	{
		super();

		controller = new CameraController(this);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		controller.update(elapsed);
	}

	override function destroy()
	{
		FlxDestroyUtil.destroy(controller);

		super.destroy();
	}
}
