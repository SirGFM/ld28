package objs {
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author 
	 */
	public class Treasure extends Basic {
		
		public function Treasure() {
			super();
		}
		
		override public function update():void {
			if (flickering)
				allowCollisions = NONE;
			else {
				allowCollisions = ANY;
				active = false;
			}
		}
		
		public function justSwitched():void {
			flicker(3);
			active = true;
		}
		
		override public function reset(X:Number, Y:Number):void {
			var i:int;
			
			switch (saver.next+1) {
				case 13: i = 0; break;
				case 19: i = 1; break;
				case 28: i = 2; break;
				case 30: i = 3; break;
				case 35: i = 4; break;
			}
			
			if (saver.treasures[i] == null) {
				kill();
				return;
			}
			
			var type:int = saver.treasures[i] as int;
			
			var _x:Number;
			var _y:Number = 12 * 16;
			if (i == 0 || i >= 3)
				_x = 13.5 * 16;
			else if (i <= 2)
				_x = 5.5 * 16;
			
			super.reset(_x, _y);
			gfx.treasures(this);
			frame = type;
			active = false;
		}
	}
}
