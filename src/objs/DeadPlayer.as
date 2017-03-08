package objs {
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class DeadPlayer extends Basic {
		
		private var iniY:int;
		
		public function DeadPlayer() {
			super();
		}
		
		override public function update():void {
			if (angle <= -90) {
				angularVelocity = 0;
				angle = -90;
			}
			else if (angle >= 90) {
				angularVelocity = 0;
				angle = 90;
			}
			
			if (alpha > 0.65)
				alpha -= FlxG.elapsed;
			
			if (touching & DOWN) {
				velocity.x = 0;
				acceleration.y = 0;
				active = false;
			}
		}
		
		override public function reset(X:Number, Y:Number):void {
			super.reset(X, Y);
			
			gfx.hero(this);
			height -= 4;
			
			play("def", true);
			updateAnimation();
			
			iniY = Y;
			velocity.y = -75;
			acceleration.y = grav;
			alpha = 1;
			
			if (reg.particlesEnabled) {
				reg.onHitEmitter.at(this);
				reg.onHitEmitter.emitParticle();
			}
			
			touching = 0;
			wasTouching = 0;
			
			if (facing == RIGHT) {
				velocity.x = -25;
				angularVelocity = -225;
			}
			else if (facing == LEFT) {
				velocity.x = 25;
				angularVelocity = 225;
			}
			active = true;
		}
	}
}
