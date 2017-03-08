package objs {
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Bat extends Basic {
		
		private var hitTimer:int;
		private var timer:Number;
		private var tgtx:Number;
		private var tgty:Number;
		
		public function Bat() {
			super();
			hitTimer = 0;
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
			else if ((wasTouching & ANY) != 0) {
				if (FlxU.abs(velocity.x) != tgtx)
					velocity.x = tgtx;
				if (FlxU.abs(velocity.y) != tgty)
					velocity.y = tgty;
			}
			
			if (timer <= 0) {
				var dx:Number = reg.player.x - x;
				var dy:Number = reg.player.y - y;
				
				if (dy < 0) {
					play("fly");
					velocity.y = tgty = -50;
					velocity.x = tgtx = FlxG.random() * 30 - 15;
					timer += 0.3 + FlxG.random() * 10 % 3 / 10; // 0.5
					sfx.bat();
				}
				else if (dx * dx + dy * dy > 10000) {
					// around 6 tiles... maybe he can see too far xD
					play("def");
					velocity.y = tgty = 10;
					velocity.x = tgtx = 30 * (FlxG.random() > 0.5?1: -1);
					timer += 1.0 + FlxG.random() * 10 % 3 / 10; // 1.2
					sfx.bat();
				}
				else if (dx != 0 || dy != 0) {
					var h:Number = 1 / Math.sqrt(dx * dx + dy * dy);
					play("charge");
					dx *= h;
					dy *= h;
					velocity.x = tgtx = dx * 90;
					velocity.y = tgty = dy * 90;
					timer += 3.0 + FlxG.random() * 10 % 5 / 10; // 3.5
					sfx.charge();
				}
			}
			
			doEmitOnHit = hitTimer <= 0;
			if (!(wasTouching & ANY) && (touching))
				hitTimer = 15;
			if (hitTimer > 0)
				hitTimer--;
			
			super.update();
		}
		
		override public function recycle(argc:int, argv:Array):void {
			super.recycle(argc, argv);
			gfx.bat(this);
			y += offset.y;
			
			timer = 0;
			hitTimer = 0;
			
			if (argc == 5)
				facing = ((argv[4] as String).substr(0,5) == "right")?RIGHT:(((argv[4] as String).substr(0,4) == "left")?LEFT:0);
		}
	}
}
