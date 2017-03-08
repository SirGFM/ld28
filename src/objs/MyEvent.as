package objs {
	
	import objs.Basic;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class MyEvent extends Basic {
		
		public function MyEvent() {
			super();
		}
		
		override public function recycle(argc:int, argv:Array):void {
			super.recycle(argc, argv);
			active = false;
			visible = false;
		}
	}
}
