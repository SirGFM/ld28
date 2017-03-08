package objs.helpers {
	
	import org.flixel.FlxParticle;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class OnHitParticle extends FlxParticle {
		
		public function OnHitParticle() {
			super();
		}
		
		override public function update():void {
			super.update();
			if (finished)
				kill();
		}
		
		override public function onEmit():void {
			super.onEmit();
			play("def");
		}
	}
}
