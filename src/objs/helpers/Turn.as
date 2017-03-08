package objs.helpers {
	
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Turn extends FlxObject {
		
		private var _direction:uint;
		
		public function Turn() {
			super();
			width = 16;
			height = 16;
		}
		
		override public function reset(X:Number, Y:Number):void {
			super.reset(X, Y);
			visible = false;
			active = false;
		}
		
		public function get direction():uint {
			return _direction;
		}
		public function set direction(val:uint):void {
			_direction = val;
			if (val == RIGHT)
				x += 2;
			else if (val == LEFT)
				x -= 2;
		}
	}
}
