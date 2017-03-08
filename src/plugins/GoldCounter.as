package plugins {
	
	import objs.Basic;
	import objs.Gold;
	
	/**
	 * ...
	 * @author 
	 */
	public class GoldCounter extends Counter {
		
		public function GoldCounter() {
			var gold:Gold = new Gold();
			gold.recycle(0, []);
			
			super(gold, 0);
			kill();
		}
		
		override public function revive():void {
			super.revive();
			setDefaultPosition(0);
		}
		
		override public function setPosition(X:Number, Y:Number):void {
			super.setPosition(X, Y-4);
		}
	}
}
