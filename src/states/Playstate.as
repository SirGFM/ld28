package states {
	
	import objs.Basic;
	import objs.Button;
	import objs.Cage;
	import objs.DeadPlayer;
	import objs.Help;
	import objs.helpers.Exit;
	import objs.helpers.Turn;
	import objs.Hero;
	import objs.Platform;
	import objs.Spark;
	import org.flixel.FlxBasic;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxTimer;
	import utils.GFX;
	import utils.MapLoader;
	import utils.Registry;
	import utils.SFX;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Playstate extends FlxState {
		
		static private var gfx:GFX = GFX.self;
		static private var sfx:SFX = SFX.self;
		static protected var reg:Registry = Registry.self;
		private const map_loader:MapLoader = MapLoader.self;
		
		private var next:int;
		private var fading:Boolean;
		
		private var player:Hero;
		private var map:FlxTilemap;
		private var timer:Number;
		private const dt:Number = 1 / 8;
		
		private var _dp:FlxGroup;
		/**
		 * Pretty much everything
		 */
		private var _objs:FlxGroup;
		/**
		 * Cage and circuit animation.
		 */
		private var overlay:FlxGroup;
		/**
		 * Particles and stuff
		 */
		private var fx:FlxGroup;
		
		override public function create():void {
			map = new FlxTilemap();
			_dp = new FlxGroup();
			overlay = new FlxGroup();
			_objs = new FlxGroup();
			fx = new FlxGroup();
			
			var em:FlxEmitter = new FlxEmitter();
			reg.lavaEmitter = em;
			gfx.lava(em);
			fx.add(em);
			
			em = new FlxEmitter();
			reg.onHitEmitter = em;
			gfx.onHit(em);
			fx.add(em);
			
			em = new FlxEmitter();
			reg.cloudEmitter = em;
			gfx.cloud(em);
			fx.add(em);
			
			next = 0;
			add(map);
			map_loader.loadMap(next, map);
			reg.resetReq = false;
			
			super.add(_dp);
			super.add(_objs);
			super.add(overlay);
			super.add(fx);
			
			fading = false;
			
			timer = 0;
			FlxG.worldBounds.make( -16, -16, 320 + 32, 240 + 32);
		}
		
		override public function update():void {
			if (!player.alive || reg.resetReq) {
				reg.resetReq = false;
				var dp:DeadPlayer = recycle(DeadPlayer) as DeadPlayer;
				var dir:uint = player.facing;
				var _x:int = player.x;
				var _y:int = player.y;
				onExit();
				dp.facing = dir;
				dp.reset(_x, _y);
				return;
			}
			if (fading)
				return;
			
			super.update();
			// there will always be few objects on the screen...
			// so, screw doing this in a pretty way!
			FlxG.collide(_objs, map);
			FlxG.collide(_dp, map);
			FlxG.collide(player, overlay);
			FlxG.overlap(_objs, null, onOverlap);
			
			if (reg.animatedTilemap) {
				timer -= FlxG.elapsed;
				
				if (timer <= 0) {
					animateTilemap();
					timer += dt;
				}
			}
		}
		
		public function onOverlap(obj1:FlxObject, obj2:FlxObject):void {
			var sp:Spark;
			
			// get player
			var p:Hero;
			if (obj1 == player || obj2 == player)
				p = player;
			
			// get exit
			{
				var e:Exit;
				if (obj1 is Exit)
					e = obj1 as Exit;
				else if (obj2 is Exit)
					e = obj2 as Exit;
				
				// check player & exit
				if (p && e) {
					FlxG.fade(0xff000000, 0.5, onExit);
					fading = true;
					next = e.nextLevel;
					return;
				}
			}
			
			// get button
			{
				var bt:Button;
				if (obj1 is Button)
					bt = obj1 as Button;
				else if (obj2 is Button)
					bt = obj2 as Button;
				
				// check player & button
				if (p && bt) {
					if ((!bt.pressed && p.velocity.y > 0) && (p.last.y + p.height) < bt.y) {
						sp = recycle(Spark) as Spark;
						sp.recycle(4, [null, (int(bt.x/16)).toString(), (int(bt.y/16)).toString(), "up"]);
						sp.activate();
						//callbacks(bt.strid, "plat1");
						bt.activate();
						sfx.button();
					}
					return;
				}
			}
			
			// get platform
			{
				var pl:Platform;
				if (obj1 is Platform)
					pl = obj1 as Platform;
				else if (obj2 is Platform)
					pl = obj2 as Platform;
				
				// check player & platform
				if (p && pl) {
					p.y = pl.y - p.height;
					p.last.y = p.y;
					p.touching |= FlxObject.DOWN;
					//p.wasTouching |= FlxObject.DOWN;
					p.velocity.y = 0;
					return;
				}
			}
			
			// check collision between sparks
			{
				var sp1:Spark
				if (obj1 is Spark)
					sp1 = obj1 as Spark;
				var sp2:Spark
				if (obj2 is Spark)
					sp2 = obj2 as Spark;
				
				if (sp1 && sp2) {
					if (sp1.active) {
						sp1.kill();
						sp2.activate();
					}
					else if (sp2.active) {
						sp2.kill();
						sp1.activate();
					}
					return;
				}
			}
			
			// get spark
			if (obj1 is Spark)
				sp = obj1 as Spark;
			else if (obj2 is Spark)
				sp = obj2 as Spark;
			
			// get non-player basic
			var b:Basic;
			if (obj1 is Basic && obj1 != p && obj1 != sp)
				b = obj1 as Basic;
			else if (obj2 is Basic && obj2 != p && obj2 != sp)
				b = obj2 as Basic;
			
			// check player & basic
			{
				if (p && b && !(b is Spark)) {
					var dp:DeadPlayer = recycle(DeadPlayer) as DeadPlayer;
					var dir:uint = player.facing;
					var _x:int = player.x;
					var _y:int = player.y;
					sfx.hit();
					onExit();
					dp.facing = dir;
					dp.reset(_x, _y);
				}
			}
			
			// check basic & spark
			{
				if (sp && b) {
					if (callbacks(b))
						sp.kill();
					return;
				}
			}
			
			// get turn
			{
				var t:Turn;
				if (obj1 is Turn)
					t = obj1 as Turn;
				else if (obj2 is Turn)
					t = obj2 as Turn;
				
				// check basic & turn
				if (b && t) {
					b.facing = t.direction;
				}
			}
			
		}
		
		public function onExit():void {
			FlxG.camera.stopFX();
			FlxG.flash(0xffffffff, 0.5);
			
			player.kill();
			_dp.callAll("kill");
			_objs.callAll("kill");
			overlay.callAll("kill");
			// fx.callAll("kill");
			
			if (player.exists) {
				_objs.remove(player, true);
				_objs.add(player);
			}
			
			map_loader.loadMap(next, map);
			
			fading = false;
			timer = 0;
		}
		
		override public function add(Object:FlxBasic):FlxBasic {
			
			if (Object is Hero) {
				player = Object as Hero;
				reg.player = player;
			}
			
			if (Object is DeadPlayer)
				return _dp.add(Object);
			if ((Object is Cage) || (Object is Help))
				return overlay.add(Object);
			else if (!(Object is FlxTilemap))
				return _objs.add(Object);
			
			return super.add(Object);
		}
		
		override public function recycle(ObjectClass:Class = null):FlxBasic {
			var b:FlxBasic;
			
			b = _dp.getFirstAvailable(ObjectClass);
			if (b)
				return b;
			
			b = overlay.getFirstAvailable(ObjectClass);
			if (b)
				return b;
			
			b = _objs.getFirstAvailable(ObjectClass);
			if (b)
				return b;
			
			b = fx.getFirstAvailable(ObjectClass);
			if (b)
				return b;
			
			return super.recycle(ObjectClass);
		}
		
		private function callbacks(b:Basic):Boolean {
			if (next == 7) {
				if (b.strid.substr(0, 5) == "plat1") {
					if (b is Platform) {
						(b as Platform).activate();
						return true;
					}
				}
			}
			else if (next == 8) {
				if (b.strid.indexOf("plat1") != -1) {
					if (b is Platform) {
						(b as Platform).activate();
						return true;
					}
				}
			}
			else if (next == 10) {
				if (b.strid.indexOf("plat1") != -1) {
					if (b is Platform) {
						(b as Platform).activate();
						return true;
					}
				}
			}
			else if (reg.lastLevel) {
				if (b.strid.substr(0, 3) == "ev0") {
					FlxG.flash(0xffffffff, 0.75);
					sfx.explosion();
					map.setTile(b.x / 16, b.y / 16, 42, true);
					var t:FlxTimer = new FlxTimer();
					t.start(0.2, 1, onStopFinal);
					b.strid = "change me!!!";
					return false;
				}
				else if (b.strid == "stop!")
					return true;
				else if (b.strid.indexOf("plat") != -1) {
					if (b is Platform) {
						(b as Platform).activate();
						FlxG.fade(0xff000000, 1.0, onFinish);
						return true;
					}
				}
			}
			
			return false;
		}
		
		private function animateTilemap():void {
			var data:Array = map.getData();
			var i:int = 0;
			var l:int = data.length;
			
			// what an ugly solution >_<
			while (i < l) {
				// animate the lava
				if (data[i] == 24)
					map.setTileByIndex(i, 25, true);
					//data[i] = 25;
				else if (data[i] == 25)
					map.setTileByIndex(i, 26, true);
					//data[i] = 26;
				else if (data[i] == 26)
					map.setTileByIndex(i, 24, true);
					//data[i] = 24;
				i++;
			}
			
			//map.setDirty(true);
		}
		
		public function onStopFinal(t:FlxTimer):void {
			var b:Basic = getObject("change me!!!");
			if (!b)
				return;
			b.strid = "stop!";
		}
		
		public function onFinish():void {
			var isPlat1:Boolean = getObject("plat1").width > 16;
			var isPlat2:Boolean = getObject("plat2").width > 16;
			
			FlxG.switchState(new Finalstate(isPlat1, isPlat2));
		}
		
		private function getObject(strdi:String):Basic {
			var i:int = -1;
			while (++i < _objs.length) {
				var b:Basic = _objs.members[i] as Basic;
				if (!b)
					continue;
				if (b.strid.indexOf(strdi) != -1)
					return b;
			}
			return null
		}
	}
}
