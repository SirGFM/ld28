package objs {
	
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class She extends Basic {
		
		public function She() {
			super();
		}
		
		override public function update():void {
			if ((facing & LEFT) && velocity.x > 0)
				velocity.x = -FlxU.abs(velocity.x);
			else if ((facing & RIGHT) && velocity.x < 0)
				velocity.x = FlxU.abs(velocity.x);
			
			if (velocity.y < 0 && (!_curAnim || _curAnim.name != "jump"))
				play("jump");
			else if ((touching & DOWN) && velocity.x != 0 && (!_curAnim || _curAnim.name != "walk"))
				play("walk");
			//else if (velocity.x == 0 && velocity.y == 0 && (!_curAnim || _curAnim.name != "def"))
			//	play("def");
		}
		
		override public function recycle(argc:int, argv:Array):void {
			super.recycle(argc, argv);
			y -= 4;
			velocity.x = 40;
			gfx.she(this);
			allowCollisions = ANY;
		}
	}
}
