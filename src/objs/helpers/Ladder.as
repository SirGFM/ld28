package objs.helpers {
	
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Ladder extends FlxObject {
		
		public function Ladder() {
			super();
		}
		
		public function recycle(X:int, Y:int, W:int, H:int):void {
			reset(16*X, 16*Y);
			width = W*16;
			height = H*16;
			immovable = true;
			active = false;
		}
	}
}
