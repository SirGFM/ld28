package objs {
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Button extends Basic {
		
		public var pressed:Boolean;
		
		public function Button() {
			super();
		}
		
		public function activate():void {
			pressed = true;
			play("press");
		}
		
		override public function recycle(argc:int, argv:Array):void {
			super.recycle(argc, argv);
			x += 2;
			y += 7;
			
			pressed = false;
			gfx.button(this);
			if (argc == 4)
				strid = argv[3];
		}
	}
}
