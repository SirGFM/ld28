package objs.helpers {
	
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class KillerFloor extends FlxObject {
		
		public function KillerFloor() {
			super();
		}
		
		public function recycle(X:int, Y:int, W:int, H:int):void {
			reset(16*X, 16*Y+8);
			width = W*16;
			height = H*8;
			immovable = true;
			active = false;
		}
	}
}
