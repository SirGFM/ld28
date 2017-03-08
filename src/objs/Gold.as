package objs {
	
	/**
	 * ...
	 * @author ...
	 */
	public class Gold extends Basic {
		
		public function Gold() {
			super();
		}
		
		override public function recycle(argc:int, argv:Array):void {
			super.recycle(argc, argv);
			gfx.gold(this);
		}
	}
}
