package states {
	
	import objs.Basic;
	import objs.Button;
	import objs.Cage;
	import objs.DeadPlayer;
	import objs.Gold;
	import objs.Help;
	import objs.helpers.Exit;
	import objs.helpers.KillerFloor;
	import objs.helpers.Ladder;
	import objs.helpers.Turn;
	import objs.Hero;
	import objs.Platform;
	import objs.Spark;
	import objs.Taker;
	import objs.Treasure;
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
	
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class NewPlaystate extends FlxState {
		
		static private var gfx:GFX = GFX.self;
		static private var sfx:SFX = SFX.self;
		static protected var reg:Registry = Registry.self;
		protected const map_loader:MapLoader = MapLoader.self;
		
		private var prev:int;
		protected var next:int;
		private var fading:Boolean;
		protected var iniX:int;
		protected var iniY:int;
		protected var switching:Boolean;
		private var didLoad:Boolean;
		private var didDraw:Boolean;
		private var srcX:int;
		private var srcY:int;
		
		private var player:Hero;
		private var map:FlxTilemap;
		private var timer:Number;
		private const dt:Number = 1 / 8;
		
		private var _collideable:FlxGroup;
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
		
		public function NewPlaystate(force_new:Boolean = false):void {
			super();
			
			if (force_new) {
				saver.clear();
				saver.save();
				saver.hasSave = true;
			}
			else {
				saver.load();
			}
			
			next = saver.next;
			iniX = saver.iniX;
			iniY = saver.iniY;
			
			reg.goldCounter.num = saver.totalGold;
			reg.goldCounter.revive();
			reg.deathCounter.num = saver.rundeath;
			reg.deathCounter.revive();
			reg.treasureGet.revive();
			
			prev = next;
			switching = false;
			didLoad = false;
			didDraw = false;
		}
		
		override public function create():void {
			FlxG.bgColor = 0xffa77bae;
			
			_dp = new FlxGroup();
			overlay = new FlxGroup();
			_objs = new FlxGroup();
			fx = new FlxGroup();
			_collideable = new FlxGroup();
			
			map = new FlxTilemap();
			player = new Hero();
			player.kill();
			player.recycle(4, ["objs.Hero", 0, 13, "Hero"]);
			reg.player = player;
			player.x = iniX;
			player.y = iniY;
			
			add(map);
			super.add(_dp);
			super.add(_objs);
			super.add(player);
			super.add(overlay);
			
			map_loader.loadMap(next, map);
			reg.resetReq = false;
			
			_collideable.add(map);
			_collideable.add(player);
			_collideable.add(_dp);
			_collideable.add(_objs);
			_collideable.add(overlay);
			if (next != 0)
				checkPlayerLadder();
			
			fading = false;
			
			timer = 0;
			FlxG.worldBounds.make( -16, -16, 320 + 32, 240 + 32);
			
			reg.setQuality();
			
			if (saver.goldArr.indexOf(next) >= 0)
				killGold();
			
			saver.next--;
			checkTreasure();
			saver.next++;
		}
		
		override public function destroy():void {
			reg.deathCounter.kill();
			reg.goldCounter.kill();
			reg.treasureGet.kill();
			reg.resetEmitters();
			super.destroy();
		}
		
		override public function update():void {
			if (!active)
				return;
			else if (!player.alive || reg.resetReq) {
				reg.deathCounter.num++;
				saver.rundeath++;
				saver.totaldeath++;
				saver.save();
				
				FlxG.flash(0xffffffff, 0.5);
				reg.resetReq = false;
				var dp:DeadPlayer = recycle(DeadPlayer) as DeadPlayer;
				var dir:uint = player.facing;
				var _x:int = player.x;
				var _y:int = player.y;
				onExit();
				dp.facing = dir;
				dp.reset(_x, _y);
				checkPlayerLadder();
				return;
			}
			else if (switching) {
				if (!didLoad && didDraw) {
					if (gotGold) {
						if (saver.goldArr.indexOf(prev) == -1)
							saver.goldArr.push(prev);
					}
					saver.totalGold = reg.goldCounter.num;
					
					iniX = player.x;
					iniY = player.y;
					onExit();
					
					var e:Exit = findExit(prev);
					// NOTE people may bitch because it's too slow... fuck them!
					reg.transition.wakeup(srcX, srcY, e.x, e.y, e.facing, 3);
					
					saver.next = next;
					if (e.facing == FlxObject.LEFT) {
						saver.iniX = e.x + 16;
						saver.iniY = e.y + 32;
					}
					else if (e.facing == FlxObject.RIGHT) {
						saver.iniX = e.x - 16;
						saver.iniY = e.y + 32;
					}
					else if (e.facing == FlxObject.UP) {
						saver.iniX = e.x;
						saver.iniY = e.y + 16;
					}
					else if (e.facing == FlxObject.DOWN) {
						saver.iniX = e.x;
						saver.iniY = e.y - 16;
					}
					iniX = saver.iniX;
					iniY = saver.iniY;
					saver.save();
					
					didLoad = true;
				}
				if (didDraw && reg.transition.exists == false) {
					switching = false;
					didLoad = false;
					didDraw = false;
				}
				return;
			}
			else if (FlxG.camera.fxActive) {
				if (reg.player.x +reg.player.width > 20*16-4)
					reg.player.x = 20*16-4 - reg.player.width;
				else if (reg.player.x < 4)
					reg.player.x = 4;
				if (reg.player.y +reg.player.height > 15*16-4)
					reg.player.y = 15*16-4 - reg.player.height;
				else if (reg.player.y < 4)
					reg.player.y = 4;
			}
			
			super.update();
			reg.doParticles();
			
			FlxG.overlap(_collideable, null, FlxObject.separate, onSuperOverlap);
			
			if (reg.animatedTilemap) {
				timer -= FlxG.elapsed;
				
				if (timer <= 0) {
					animateTilemap();
					timer += dt;
				}
			}
		}
		
		override public function draw():void {
			if (!switching || didLoad) {
				super.draw();
				reg.drawParticles();
			}
			else if (switching && !didLoad && !didDraw) {
				map.draw();
				_dp.draw();
				_objs.draw();
				overlay.draw();
				reg.drawParticles();
				reg.transition.setGraphic();
				player.draw();
				didDraw = true;
			}
		}
		
		public function onSuperOverlap(obj1:FlxObject, obj2:FlxObject):Boolean {
			// Ensure that objects collides (instead of overlaping) with the map
			if ((obj1 is FlxTilemap) || (obj2 is FlxTilemap))
				return true;
			
			// if necessary, collide player with overlay here!
			
			var other:FlxObject;
			var sp:Spark;
			var pl:Platform;
			
			/*get player*/ {
				var p:Hero;
				if (obj1 == player) {
					p = player;
					other = obj2;
				}
				else if (obj2 == player) {
					p = player;
					other = obj1;
				}
			} /*get player*/
			
			if (p) {
				
				/*get ladder*/ {
					var ladder:Ladder;
					if (other is Ladder)
						ladder = other as Ladder;
					
					if (ladder) {
						if (!(FlxG.keys.DOWN || FlxG.keys.S ) && p.y + p.height <= ladder.y + 3.5)
							return true;
						p.overLadder = true;
						return false;
					}
				} /*get ladder*/
				
				/*get killer floor*/ {
					var killFl:KillerFloor;
					if (other is KillerFloor)
						killFl = other as KillerFloor;
					
					if (killFl) {
						if ((p.x + p.width >= killFl.x - 1 && p.x + p.width < killFl.x + 1.5 || p.x > killFl.x + killFl.width - 1.5 && p.x <= killFl.x + killFl.width + 1) && p.y + p.height > killFl.y - 1)
							return true;
						else if (reg.quality == 1 && (p.x + p.width >= killFl.x - 2 && p.x + p.width < killFl.x + 2.5 || p.x > killFl.x + killFl.width - 2.5 && p.x <= killFl.x + killFl.width + 2) && p.y + p.height > killFl.y - 2)
							return true;
						p.kill();
						return false;
					}
				} /*get killer floor*/
				
				/*get exit*/ {
					var e:Exit;
					if (other is Exit)
						e = other as Exit;
					
					// check player & exit
					if (e && !switching) {
						prev = next;
						next = e.nextLevel;
						switching = true;
						didLoad = false;
						didDraw = false;
						srcX = e.x;
						srcY = e.y;
						player.visible = false;
						return false;
					}
				} /*get exit*/
				
				/*get button*/ {
					var bt:Button;
					if (other is Button)
						bt = other as Button;
					
					// check player & button
					if (bt) {
						if ((!bt.pressed && p.velocity.y > 0) && (p.last.y + p.height) < bt.y) {
							sp = recycle(Spark) as Spark;
							sp.recycle(4, [null, (int(bt.x/16)).toString(), (int(bt.y/16)).toString(), "Spark", "up"]);
							sp.activate();
							bt.activate();
							sfx.button();
							return true;
						}
						return false;
					}
				} /*get button*/
				
				/*get platform*/ {
					if (other is Platform)
						pl = other as Platform;
					
					// check player & platform
					if (pl)
						return true;
				} /*get platform*/
				
				/*get gold*/ {
					var gold:Gold;
					if (other is Gold)
						gold = other as Gold;
					
					if (gold) {
						if (reg.particlesEnabled) {
							reg.kirakiraEmitter.at(gold);
							reg.kirakiraEmitter.start(false, 0.3, 0.0625, 16);
						}
						reg.goldCounter.num++;
						sfx.gold();
						gold.kill();
						return false;
					}
				} /*get gold*/
				
				/*get spark*/ {
					if (other is Spark)
						sp = other as Spark;
					
					if (sp) {
						return false;
					}
				} /*get spark*/
				
				/*get treasure*/ {
					var treasure:Treasure;
					if (other is Treasure)
						treasure = other as Treasure;
					
					if (treasure) {
						var room:int = getTreasureRoom();
						if (room < 0)
							return false;
						
						if (reg.particlesEnabled) {
							reg.kirakiraEmitter.at(treasure);
							reg.kirakiraEmitter.start(true,0.74, 0, 0);
						}
						reg.treasureGet.setTreasure(treasure);
						if (saver.curTreasure == -1) {
							saver.curTreasure = saver.treasures[room];
							saver.treasures[room] = null;
							treasure.kill();
						}
						else {
							var cur:int = saver.curTreasure;
							var tmp:int = treasure.frame;
							saver.treasures[room] = cur;
							saver.curTreasure = tmp;
							treasure.frame = cur;
							treasure.justSwitched();
						}
						FlxG.flash(0xaaf6f4a7, 0.75);
						sfx.treasure();
						return false;
					}
				} /*get treasure*/
				
				/*get taker*/ {
					var taker:Taker;
					if (other is Taker)
						taker = other as Taker;
					
					if (taker) {
						if (saver.totalGold >= taker.needed) {
							if (p.y >= taker.y + 29 && (p.wasTouching & FlxObject.DOWN)) {
								taker.allowCollisions = FlxObject.NONE;
								saver.totalGold -= taker.needed;
								onFinish();
							}
						}
						return false;
					}
				} /*get taker*/
			} // if(p)
			
			/*between sparks*/ {
				var sp1:Spark
				if (obj1 is Spark)
					sp1 = obj1 as Spark;
				var sp2:Spark
				if (obj2 is Spark)
					sp2 = obj2 as Spark;
				
				if (sp1 && sp2) {
					if (sp1.active && sp2.active)
						return false;
					if (sp1.active) {
						sp1.kill();
						sp2.activate();
					}
					else if (sp2.active) {
						sp2.kill();
						sp1.activate();
					}
					return false;
				}
			} /*between sparks*/
			
			/*get spark*/ {
				if (obj1 is Spark)
					sp = obj1 as Spark;
				else if (obj2 is Spark)
					sp = obj2 as Spark;
			} /*get spark*/
			
			/*get platform*/ {
				if (!pl)
					if (obj1 is Platform)
						pl = obj1 as Platform;
					else if (obj2 is Platform)
						pl = obj2 as Platform;
			} /*get platform*/
			
			/*check spark & platform*/ {
				if (sp && pl) {
					pl.activate();
					sp.kill();
					return false;
				}
			}
			
			/*get non-player basic*/ {
				var b:Basic;
				if (obj1 is Basic && obj1 != p && obj1 != sp && obj1 != pl)
					b = obj1 as Basic;
				else if (obj2 is Basic && obj2 != p && obj2 != sp && obj2 != pl)
					b = obj2 as Basic;
			} /*get non-player basic*/
			
			/*check player & basic*/ {
				if (p && b) {
					if (!(b is DeadPlayer)) {
						p.kill();
						return false;
						/*
						var dp:DeadPlayer = recycle(DeadPlayer) as DeadPlayer;
						var dir:uint = player.facing;
						var _x:int = player.x;
						var _y:int = player.y;
						sfx.hit();
						onExit();
						dp.facing = dir;
						dp.reset(_x, _y);
						*/
					}
					// NOTE modify here to make DeadPlayer collideable
				}
			} /*check player & basic*/
			
			/*check basic & platform*/ {
				if (b && pl) {
					return true;
				}
			} /*check basic & platform*/
			
			/*get turn*/ {
				var t:Turn;
				if (obj1 is Turn)
					t = obj1 as Turn;
				else if (obj2 is Turn)
					t = obj2 as Turn;
				
				// check basic & turn
				if (b && t) {
					b.facing = t.direction;
				}
			} /*get turn*/
			
			return false;
		}
		
		public function onExit(doSave:Boolean = true):void {
			_dp.callAll("kill");
			_objs.callAll("kill");
			overlay.callAll("kill");
			reg.lavaEmitter.callAll("kill");
			reg.cloudEmitter.callAll("kill");
			
			reg.setQuality();
			
			map_loader.loadMap(next, map);
			player.recycle(4, ["objs.Hero", 0, 13, "Hero"]);
			player.x = iniX;
			player.y = iniY;
			
			reg.goldCounter.num = saver.totalGold;
			if (saver.goldArr.indexOf(next) >= 0)
				killGold();
			
			timer = 0;
			
			checkTreasure();
		}
		
		override public function add(Object:FlxBasic):FlxBasic {
			if (Object is DeadPlayer)
				return _dp.add(Object);
			
			if ((Object is Cage) || (Object is Help))
				return overlay.add(Object);
			else if (!(Object is FlxTilemap) && !(Object is Hero))
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
			
			//b = fx.getFirstAvailable(ObjectClass);
			//if (b)
			//	return b;
			
			return super.recycle(ObjectClass);
		}
		
		private function animateTilemap():void {
			var data:Array = map.getData();
			var i:int = 0;
			var l:int = data.length;
			
			// what an ugly solution >_<
			while (i < l) {
				// animate the lava
				if (data[i] == 0)
					map.setTileByIndex(i, 1, true);
					//data[i] = 25;
				else if (data[i] == 1)
					map.setTileByIndex(i, 2, true);
					//data[i] = 26;
				else if (data[i] == 2)
					map.setTileByIndex(i, 0, true);
					//data[i] = 24;
				i++;
			}
			
			//map.setDirty(true);
		}
		
		public function onFinish():void {
			active = false;
			FlxG.fade(0xff000000, 1.5, function():void { FlxG.switchState(new NewEndstate()); } );
			active = false;
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
		
		private function findExit(level:int):Exit {
			var e:Exit;
			var i:int = 0;
			
			while (i < _objs.length) {
				if (_objs.members[i] is Exit) {
					e = _objs.members[i] as Exit;
					if (e.nextLevel == level)
						return e;
				}
				i++;
			}
			return null;
		}
		
		private function get gotGold():Boolean {
			var i:int = 0;
			
			while (i < _objs.length) {
				if (_objs.members[i] is Gold) {
					return (_objs.members[i] as Gold).alive == false;
				}
				i++;
			}
			return false;
		}
		
		private function killGold():void {
			var i:int = 0;
			
			while (i < _objs.length) {
				if (_objs.members[i] is Gold) {
					(_objs.members[i] as Gold).kill();
					return;
				}
				i++;
			}
		}
		
		private function checkPlayerLadder():void {
			var i:int = 0;
			while (i < _objs.length) {
				var l:Ladder = _objs.members[i++] as Ladder;
				if (l) {
					if (l.overlaps(reg.player)) {
						reg.player.overLadder = true;
						reg.player.isClimbing = true;
						return;
					}
				}
			}
		}
		
		private function getTreasureRoom():int {
			switch (saver.next) {
				case 13: return 0;
				case 19: return 1;
				case 28: return 2;
				case 30: return 3;
				case 35: return 4;
			}
			return -1;
		}
		
		private function checkTreasure():void {
			switch (next) {
				case 13:
				case 19:
				case 28:
				case 30:
				case 35: {
					(recycle(Treasure) as Basic).reset(0, 0);
					(recycle(Taker) as Taker).revive();
					reg.treasureGet.revive();
				} break;
			}
		}
	}
}
