package objs.helpers {
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import utils.Registry;
	import utils.SFX;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class LavaEmitter extends FlxObject {
		
		static private var reg:Registry = Registry.self;
		static private var sfx:SFX = SFX.self;
		
		private var timer:Number;
		
		public function LavaEmitter() {
			super();
			timer = 0;
		}
		
		override public function update():void {
			timer -= FlxG.elapsed;
			if (timer <= 0) {
				reg.lavaEmitter.at(this);
				reg.lavaEmitter.start(true, 0.5, 0, FlxG.random() * 10 + 3);
				sfx.lava();
				timer += FlxG.random() * 2.5 + 0.5;
			}
		}
		override public function postUpdate():void {}
		
		override public function reset(X:Number, Y:Number):void {
			super.reset(X, Y);
			timer = 0;
			allowCollisions = NONE;
			visible = false;
		}
	}
}
