package objs {
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Cage extends Basic {
		
		private var chains:Basic;
		private var firstFrame:Boolean;
		
		public function Cage() {
			super();
			chains = new Basic();
			firstFrame = true;
		}
		
		override public function draw():void {
			if (y > 16) {
				var i:int = 1;
				var j:int = y / 16;
				var mod:int = y % 16;
				chains.y = 16;
				if (!firstFrame && mod != 0 && !dirty) {
					chains._flashRect.y = 16 - mod;
					chains._flashRect.height = mod;
					chains.draw();
					chains._flashRect.y = 0;
					chains._flashRect.height = 16;
					chains.y += mod;
				}
				while (i < j) {
					chains.draw();
					chains.y += 16;
					i++;
				}
			}
			
			super.draw();
			firstFrame = false;
		}
		
		override public function recycle(argc:int, argv:Array):void {
			super.recycle(argc, argv);
			gfx.cage(this);
			gfx.chains(chains);
			chains.x = this.x + (width - chains.width) / 2;
		}
	}
}
