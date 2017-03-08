package objs {
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Bat extends Basic {
		
		private var timer:Number;
		
		public function Bat() {
			super();
		}
		
		override public function update():void {
			timer -= FlxG.elapsed;
			
			if (_curAnim.name != "charge") {
				if (touching & LEFT)
					velocity.x = FlxU.abs(velocity.x);
				else if (touching & RIGHT)
					velocity.x = -FlxU.abs(velocity.x);
				if (touching & UP)
					velocity.y = FlxU.abs(velocity.y);
				else if (touching & DOWN)
					velocity.y = -FlxU.abs(velocity.y);
			}
			
			if (timer <= 0) {
				var dx:Number = reg.player.x - x;
				var dy:Number = reg.player.y - y;
				
				if (dy < 0) {
					play("fly");
					velocity.y = -50;
					velocity.x = FlxG.random() * 30 - 15;
					timer += 0.5;
				}
				else if (dx * dx + dy * dy > 10000) {
					// around 6 tiles... maybe he can see too far xD
					play("def");
					velocity.y = 10;
					velocity.x = 30 * (FlxG.random() > 0.5?1: -1);
					timer += 1.2;
				}
				else if (dx != 0 || dy != 0) {
					var h:Number = 1 / Math.sqrt(dx * dx + dy * dy);
					play("charge");
					dx *= h;
					dy *= h;
					velocity.x = dx * 90;
					velocity.y = dy * 90;
					timer += 3.5;
				}
			}
			
			super.update();
		}
		
		override public function recycle(argc:int, argv:Array):void {
			super.recycle(argc, argv);
			gfx.bat(this);
			y += offset.y;
			
			timer = 0;
			
			if (argc == 4)
				facing = ((argv[3] as String).substr(0,5) == "right")?RIGHT:(((argv[3] as String).substr(0,4) == "left")?LEFT:0);
		}
	}
}
