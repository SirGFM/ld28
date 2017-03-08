package objs.helpers {
	
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Exit extends FlxObject {
		
		public var nextLevel:int;
		public var facing:uint;
		
		public function Exit() {
			super();
		}
		
		public function init(Facing:String, W:int, H:int, next:int):void {
			if (Facing == "left")
				facing = LEFT;
			else if (Facing == "right")
				facing = RIGHT;
			else if (Facing == "up")
				facing = UP;
			else if (Facing == "down")
				facing = DOWN;
			
			width = W;
			height = H;
			nextLevel = next;
			visible = false;
			active = false;
		}
	}
}
