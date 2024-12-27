package funkin.backend;

import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import funkin.utils.MathUtil;

class CameraController implements IFlxDestroyable // this might be completely useless depending on hwo i go baout it
{
	var parent:FlxCamera;

	public var currentPosition:FlxPoint;

	public var targetPosition:FlxPoint;

	var isTweening:Bool = false;

	public var paused:Bool = false;

	public var canReturnToDefault:Bool = true;

	public var defaultZoom:Float = 1;

	public var defaultZoomRate:Float = 0.15;

	public function new(parent:FlxCamera)
	{
		this.parent = parent;

		parent.target = null; // the controller will handle this or not idk ill figure it out
	}

	public function update(elapsed:Float)
	{
		if (canReturnToDefault) parent.zoom = MathUtil.betterLerp(parent.zoom, defaultZoom, defaultZoomRate);
	}

	public function destroy() {}
}
