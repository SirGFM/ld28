package objs.helpers {
	
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Turn extends FlxObject {
		
		public var direction:uint;
		
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
	}
}
