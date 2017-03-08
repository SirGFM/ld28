package objs.helpers {
	
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Exit extends FlxObject {
		
		public var nextLevel:int;
		
		public function Exit() {
			super();
		}
		
		public function init(W:int, H:int, next:int):void {
			width = W;
			height = H;
			nextLevel = next;
			visible = false;
			active = false;
		}
	}
}
