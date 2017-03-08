package states {
	
	import objs.Basic;
	import objs.Button;
	import objs.Cage;
	import objs.He;
	import objs.Help;
	import objs.Hero;
	import objs.Platform;
	import objs.She;
	import objs.Spark;
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
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Finalstate extends FlxState {
		
		static private var gfx:GFX = GFX.self;
		static private var reg:Registry = Registry.self;
		
		private var isPlat1:Boolean;
		private var isPlat2:Boolean;
		
		private var t:FlxTimer;
		private var allowAnimation:Boolean;
		private var state:uint;
		
		private var map:FlxTilemap;
		
		private var survivor:Basic;
		private var he:He;
		private var she:She;
		private var hero:Hero;
		private var cageHe:Cage;
		private var cageShe:Cage;
		private var help:Help;
		
		private var timer:Number;
		private const dt:Number = 1 / 8;
		
		public function Finalstate(IsPlat1:Boolean, IsPlat2:Boolean) {
			super();
			
			isPlat1 = IsPlat1;
			isPlat2 = IsPlat2;
		}
		
		override public function create():void {
			super.create();
			
			var fx:FlxGroup = new FlxGroup();
			
			var em:FlxEmitter = new FlxEmitter();
			reg.lavaEmitter = em;
			gfx.lava(em);
			fx.add(em);
			
			em = new FlxEmitter();
			reg.onHitEmitter = em;
			gfx.onHit(em);
			fx.add(em);
			map = new FlxTilemap();
			
			em = new FlxEmitter();
			reg.cloudEmitter = em;
			gfx.cloud(em);
			fx.add(em);
			
			MapLoader.self.loadMap( -1, map);
			add(fx);
			
			allowAnimation = false;
			state = 0;
			t = null;
			
			var i:int = -1;
			while (++i < length) {
				var b:Basic = members[i] as Basic;
				if (!b)
					continue;
				
				if (b is Hero)
					hero = b as Hero;
				else if (b is He)
					he = b as He;
				else if (b is She)
					she = b as She;
				else if (b is Button) {
					b.frame = 14;
				}
				else if (b is Cage) {
					if (b.x == 15*16)
						cageShe = b as Cage
					else
						cageHe = b as Cage
				}
				else if (b is Platform) {
					if (isPlat1 && b.strid.indexOf("plat1") != -1) {
						b.immovable = true;
						b.width =  48;
					}
					else if (isPlat2 && b.strid.indexOf("plat2") != -1) {
						b.immovable = true;
						b.width =  48;
					}
				}
				else if (b is Help) {
					if (isPlat1 && b.x != 18 * 16)
						b.kill();
					else if (isPlat2 && b.x == 18 * 16)
						b.kill();
					
					if (b.alive)
						help = b as Help;
				}
				else if (b is Spark) {
					b.kill();
				}
			}
			
			he.velocity.x = 0;
			he.facing = FlxObject.LEFT;
			she.velocity.x = 0;
			she.facing = FlxObject.LEFT;
			
			cageHe.allowCollisions = FlxObject.ANY;
			cageHe.velocity.y = 40;
			cageShe.allowCollisions = FlxObject.ANY;
			cageShe.velocity.y = 40;
			he.velocity.y = 40;
			she.velocity.y = 40;
			help.velocity.y = 40;
			
			remove(cageHe, true);
			remove(cageShe, true);
			add(cageHe);
			add(cageShe);
			
			hero.takeControl = true;
			hero.acceleration.y = Basic.grav;
			
			if (isPlat1)
				survivor = he;
			else if (isPlat2)
				survivor = she;
		}
		override public function destroy():void {
			super.destroy();
			map.destroy();
		}
		
		override public function update():void {
			map.update();
			
			if (allowAnimation) {
				if (state == 0) {
					remove(he, true);
					remove(she, true);
					add(he);
					add(she);
					if (survivor == he) {
						if (she.alive)
							she.kill();
						state = 1;
					}
					// get the girl near the lava
					else if (survivor.x > 12 * 16 - 4) {
						if (he.alive)
							he.kill();
						survivor.velocity.x = -40;
					}
					else if (survivor.x <= 12 * 16 - 4) {
						state = 1;
						survivor.velocity.x = 0;
					}
				}
				else if (state == 1) {
					if (t) {}
					// look down/up
					else if (survivor == she) {
						t = new FlxTimer();
						t.start(0.75, 4, function (T:FlxTimer):void {if (she.frame == 54) {she.frame = 8;}else {she.frame = 54;}if (T.finished) {state=2;t = null;she.acceleration.y = Basic.grav;}});
					}
					else {
						t = new FlxTimer();
						survivor.facing = FlxObject.RIGHT;
						t.start(0.75, 4, function(T:FlxTimer):void { if (he.frame == 3) { he.frame = 53; } else { he.frame = 3; } if (T.finished) { state=3; t = null;} } );
					}
				}
				else if (state == 2) {
					// she only. jump over lava
					if (she.x > 11 * 16 && (she.touching & FlxObject.DOWN)) {
						cageHe.allowCollisions = FlxObject.NONE;
						cageHe.moves = false;
						she.velocity.x = 80;
						she.velocity.y = -155;
						she.acceleration.y = Basic.grav;
					}
					// at same position as he on 3
					else if (she.touching & FlxObject.LEFT)
						state = 4;
				}
				else if (state == 3) {
					//move untils gets to the wall
					he.facing = FlxObject.LEFT;
					he.velocity.x = 50;
					if (he.touching * FlxObject.LEFT) {
						he.acceleration.y = Basic.grav;
						state = 4;
					}
				}
				else if (state == 4) {
					// climb those stairs
					survivor.velocity.x = 50;
					// fell throuh the tunnel
					if (survivor.x <= 5*16) {
						state = 5;
						survivor.velocity.x = 0;
					}
					else if (survivor.touching & FlxObject.DOWN)
						survivor.velocity.y = -140;
				}
				else if (state == 5) {
					// meeting
					hero.velocity.x = 50;
					survivor.velocity.x = 50;
					
					if (hero.x + 16 >= 3 * 16)
						hero.velocity.x = 0;
					if (survivor.x <= 3 * 16)
						survivor.velocity.x = 0;
					
					if (hero.velocity.x == 0 && survivor.velocity.x == 0)
						state++;
				}
				else if (state == 6) {
					if (!t) {
						t = new FlxTimer();
						t.start(2.0, 1, null);
					}
					if ((survivor.touching & FlxObject.DOWN)) {
						if (t && t.finished) {
							t = null;
							state++;
						}
						else
							survivor.velocity.y = -140;
					}
				}
				else if (state == 7) {
					if (!t) {
						t = new FlxTimer();
						t.start(2.0, 1, null);
						if (survivor == he)
							he.frame = 53;
						else if (survivor == she)
							she.frame = 54;
					}
					else if (t && t.finished) {
						t = null;
						state++;
					}
				}
				else if (state == 8) {
					hero.velocity.x = -50;
					hero.facing = FlxObject.LEFT;
					survivor.velocity.x = 50;
					FlxG.fade(0xff00000000, 2.0, onExit);
					state++;
				}
			}
			
			if (help.alive && !(he.alive && she.alive))
				help.kill();
			
			if (!she.alive && she.active) {
				if (!she.exists) {
					she.exists = true;
					she.velocity.y = -75;
					she.acceleration.y = Basic.grav;
					she.velocity.x = 25;
					she.angularVelocity = 225;
				}
				else if (she.active) {
					if (she.angle >= 90) {
						she.angularVelocity = 0;
						she.angle = 90;
					}
					if (she.alpha > 0.8)
						she.alpha -= FlxG.elapsed;
					if (she.angle == 90 && she.alpha <= 0.8) {
						she.velocity.x = 0;
						she.acceleration.y = 0;
						she.active = false;
					}
				}
			}
			else if (!he.alive && he.active) {
				if (!he.exists) {
					he.exists = true;
					he.velocity.y = -75;
					he.acceleration.y = Basic.grav;
					he.velocity.x = 25;
					he.angularVelocity = 225;
				}
				else if (he.active) {
					if (he.angle >= 90) {
						he.angularVelocity = 0;
						he.angle = 90;
					}
					if (he.alpha > 0.8)
						he.alpha -= FlxG.elapsed;
					if (he.angle == 90 && he.alpha <= 0.8) {
						he.velocity.x = 0;
						he.acceleration.y = 0;
						he.active = false;
					}
				}
			}
			
			super.update();
			FlxG.collide(this, map);
			FlxG.overlap(this, null, onOverlap);
			
			timer -= FlxG.elapsed;
			if (timer <= 0) {
				animateTilemap();
				timer += dt;
			}
		}
		
		override public function draw():void {
			map.draw();
			super.draw();
		}
		
		public function onOverlap(o1:FlxObject, o2:FlxObject):void {
			var b1:Basic = o1 as Basic;
			var b2:Basic = o2 as Basic;
			
			if (!b1 || !b2)
				return;
			
			var p:Basic;
			var notP:Basic = null;
			if (b1.strid.indexOf("plat") != -1 && b1.width > 16) {
				p = b1;
				notP = b2;
			}
			else if (b2.strid.indexOf("plat") != -1 && b2.width > 16) {
				notP = b1;
				p = b2;
			}
			
			if (!p || !notP)
				return;
			
			allowAnimation = true;
			
			notP.y = notP.y - p.height;
			notP.last.y = p.y;
			notP.touching |= FlxObject.DOWN;
			notP.velocity.y = 0;
			return;
		}
		public function onExit():void {
			FlxG.switchState(new Gameover());
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
	}
}
