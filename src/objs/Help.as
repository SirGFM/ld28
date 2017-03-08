package objs {
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Help extends Basic {
		
		public function Help() {
			super();
		}
		
		override public function recycle(argc:int, argv:Array):void {
			super.recycle(argc, argv);
			
			allowCollisions = NONE;
			gfx.help(this);
			
			if (argc >= 5) {
				if ((argv[4] as String).substr(0, 5) == "right") {
					facing = RIGHT;
					play("right");
				}
				else if ((argv[4] as String).substr(0,4) == "left") {
					facing = LEFT;
					play("left");
				}
				else if ((argv[4] as String).substr(0, 2) == "he") {
					facing = RIGHT;
					play("he");
				}
				else if ((argv[4] as String).substr(0,3) == "she") {
					facing = LEFT;
					play("she");
				}
			}
		}
	}
}
