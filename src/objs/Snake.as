package objs {
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Snake extends Basic {
		
		public function Snake() {
			super();
		}
		
		override public function update():void {
			var modY:int = reg.player.y / 16;
			
			// LOL, this is the same behaviour as of the... thing on Elecman stage!!
			// (though in Megaman it's more like "if (modY == int(y/16)"
			if (FlxU.abs(modY - int(y / 16)) <= 1) {
				if (_curAnim.name != "run")
					play("run");
				velocity.x = snakeSpeed * 1.75;
			}
			else {
				if (_curAnim.name != "walk")
					play("walk");
				velocity.x = snakeSpeed;
			}
			
			if (touching & WALL) {
				if (facing & RIGHT)
					facing = LEFT;
				else if (facing & LEFT)
					facing = RIGHT;
			}
			
			if (facing & LEFT)
				velocity.x = -FlxU.abs(velocity.x);
			
		}
		
		override public function recycle(argc:int, argv:Array):void {
			super.recycle(argc, argv);
			gfx.snake(this);
			y += offset.y;
			
			if (argc == 4)
				facing = ((argv[3] as String).substr(0,5) == "right")?RIGHT:(((argv[3] as String).substr(0,4) == "left")?LEFT:0);
		}
	}
}
