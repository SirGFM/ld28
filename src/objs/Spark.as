package objs {
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Spark extends Basic {
		
		static private const v:Number = 125;
		
		private var counter:int;
		
		public function Spark() {
			super();
		}
		
		override public function update():void {
			facing = 0;
			
			counter++;
			if (counter % 4 == 0)
				sfx.spark();
		}
		
		public function activate():void {
			active = true;
			visible = true;
			calcFrame();
			
			counter = 0;
			
			if (facing == LEFT)
				velocity.x = -v;
			else if (facing == RIGHT)
				velocity.x = v;
			else if (facing == UP)
				velocity.y= -v;
			else if (facing == DOWN)
				velocity.y = v;
		}
		
		override public function recycle(argc:int, argv:Array):void {
			width = 16;
			height = 16;
			offset.x = 0;
			offset.y = 0;
			super.recycle(argc, argv);
			gfx.spark(this);
			
			var tmp:String = (argv[4] as String);
			if (tmp.substr(0, 4) == "left")
				facing = LEFT;
			else if (tmp.substr(0, 5) == "right")
				facing = RIGHT;
			else if (tmp.substr(0, 4) == "down")
				facing = DOWN;
			else if (tmp.substr(0, 2) == "up")
				facing = UP;
			
			active = false;
			visible = false;
		}
	}
}
