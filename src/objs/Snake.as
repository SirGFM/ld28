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
			if (touching & WALL) {
				if (facing & RIGHT)
					facing = LEFT;
				else if (facing & LEFT)
					facing = RIGHT;
			}
			
			if (facing & LEFT)
				velocity.x = -snakeSpeed;
			else 
				velocity.x = snakeSpeed;
		}
		
		override public function recycle(argc:int, argv:Array):void {
			super.recycle(argc, argv);
			gfx.snake(this);
			y += offset.y;
			
			if (argc == 5)
				facing = ((argv[4] as String).substr(0,5) == "right")?RIGHT:(((argv[4] as String).substr(0,4) == "left")?LEFT:0);
		}
	}
}
