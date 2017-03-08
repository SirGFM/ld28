package states {
	
	import objs.Basic;
	import objs.Help;
	import objs.Hero;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxTimer;
	import utils.GFX;
	import utils.MapLoader;
	import utils.Registry;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Introstate extends FlxState {
		
		static private var gfx:GFX = GFX.self;
		static private var reg:Registry = Registry.self;
		
		private var map:FlxTilemap;
		private var hero:Hero;
		private var help:Help;
		private var t:FlxTimer;
		
		private var state:uint;
		
		override public function create():void {
			map = new FlxTilemap();
			
			add(map);
			MapLoader.self.loadMap( -2, map);
			
			var em:FlxEmitter = new FlxEmitter();
			reg.lavaEmitter = em;
			gfx.lava(em);
			add(em);
			
			em = new FlxEmitter();
			reg.onHitEmitter = em;
			gfx.onHit(em);
			add(em);
			
			em = new FlxEmitter();
			reg.cloudEmitter = em;
			gfx.cloud(em);
			add(em);
			
			var i:int = -1;
			while (++i < length) {
				var b:Basic = members[i] as Basic;
				if (!b)
					continue;
				
				if (b is Hero)
					hero = b as Hero;
				else if (b is Help)
					help = b as Help;
			}
			
			state = 0;
			
			hero.takeControl = true;
			hero.acceleration.y = Basic.grav;
			hero.velocity.x = -15;
			help.exists = false;
			
			t = new FlxTimer();
			t.start(2, 1);
			
			// TODO add logo
		}
		
		override public function update():void {
			if ((state == 1 || state == 4) &&  help.finished)
				state++;
			
			if (t.finished) {
				switch(state) {
					case 0: {
						hero.velocity.x = 0;
						help.exists = true;
						help.play("he");
						state++;
					} break;
					case 2: {
						hero.facing = FlxObject.RIGHT;
						help.exists = false;
						t.start(1.25);
						state++;
					} break;
					case 3: {
						hero.facing = FlxObject.LEFT;
						help.exists = true;
						help.play("right");
						state++;
					} break;
					case 5: {
						hero.facing = FlxObject.RIGHT;
						t.start(1.0);
						state++;
					} break;
					case 6: {
						hero.velocity.y = -120;
						state++;
					} break;
					case 7: {
						if (hero.touching & FlxObject.DOWN) {
							hero.velocity.x = 100;
							state++;
							FlxG.fade(0xff000000, 2.0, function():void { FlxG.switchState(new Playstate()); } );
						}
					} break;
				}
			}
			super.update();
			FlxG.collide(hero, map);
		}
	}
}
