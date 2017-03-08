package states {
	
	import objs.Basic;
	import objs.Gold;
	import objs.Hero;
	import objs.Treasure;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import utils.FlashingText;
	import utils.MapLoader;
	import utils.SFX;
	
	/**
	 * ...
	 * @author 
	 */
	public class NewIntrostate extends Cutscene {
		
		private var treasure:Treasure;
		private var gold:Gold;
		private var map:FlxTilemap;
		private var pl:Hero;
		
		private var cg_tm:FlxSprite;
		private var cg_map:FlxSprite;
		private var cg_sprite:FlxSprite;
		private var cg_circle:FlxSprite;
		private var tile_map:FlxSprite;
		
		private var skip:FlashingText;
		private var canSkip:Boolean;
		private var wasKeyPressed:Boolean;
		private var skipTime:Number;
		
		private var n:int;
		
		override public function create():void {
			var dt:Number;
			
			super.create();
			
			dt = 1 / 16;
			
			addState(4.5, 1, onState_0);
			addState(2, 2, onState_1);
			addState(1.0, 3, onState_2);
			addState(0.4, 4, onState_3);
			addState(0.4, 3, onState_4);
			addState(1.0, 6, onState_5);
			addState(0.5, 7, onState_6);
			addState(1, 7, onState_7);
			
			map = new FlxTilemap();
			
			pl = new Hero();
			pl.kill();
			var arr:Array = [null, "1", "10", "pl"];
			pl.recycle(arr.length, arr);
			pl.takeControl = true;
			pl.facing = FlxObject.RIGHT;
			pl.acceleration.y = Basic.grav;
			
			tile_map = new FlxSprite(11*16, 12.5*16-31, gfx.cg_map_smallGFX);
			
			add(map);
			MapLoader.self.loadMap( -1, map);
			add(tile_map);
			add(pl);
			
			cg_map = new FlxSprite(111, 8, gfx.cg_mapGFX);
			
			cg_sprite = new FlxSprite( -6, 108, gfx.cg_playerGFX);
			cg_sprite.scale.make(12, 12);
			cg_sprite.x = -6;
			cg_sprite.y += 108 - 20;
			
			cg_tm = new FlxSprite(16*6*2, 0, gfx.cg_darkwallGFX);
			cg_tm.scale.make(6, 6);
			cg_tm.y += 4 * 16 + 8;
			
			cg_circle = new FlxSprite(0, 0, gfx.cg_circleGFX);
			
			treasure = new Treasure();
			gfx.treasures(treasure);
			treasure.visible = false;
			treasure.scale.make(6, 6);
			
			// Make sure the player get a new treasure on each of its 5 first playthroughs
			if (!saver.gottenTreasures || saver.gottenTreasures.length == 0 ||
					saver.gottenTreasures.length == 5) {
				saver.goalTreasure = FlxG.random() * 100 % 5;
			}
			else {
				var locarr:Array = [0, 1, 2, 3, 4];
				
				for each (var item:int in saver.gottenTreasures) {
					var index:int;
					
					index = locarr.indexOf(item);
					if (index >= 0 && index < locarr.length) {
						locarr.splice(index, 1);
					}
				}
				
				if (locarr.length > 0) {
					saver.goalTreasure = FlxG.getRandom(locarr) as int;
				}
				else {
					saver.goalTreasure = FlxG.random() * 100 % 5;
				}
			}
			
			add(cg_tm);
			add(cg_map);
			add(cg_sprite);
			add(treasure);
			add(cg_circle);
			
			cg_tm.visible = false;
			cg_map.visible = false;
			cg_sprite.visible = false;
			cg_circle.visible = false;
			
			SFX.self.playIntroSong();
			FlxG.flash(0xff000000, 0.5);
			
			canSkip = saver.gottenTreasures && saver.gottenTreasures.length > 0;
			if (canSkip) {
				skip = new FlashingText(8, FlxG.height - 12, 200, "Press any key to skip");
				skip.alignment = "left";
				skip.visible = false;
				add(skip);
			}
			
			wasKeyPressed = false;
		}
		
		override public function update():void {
			super.update();
			FlxG.collide(map, pl);
			
			if (state == 2)
				treasure.alpha += FlxG.elapsed/2;
			else if (state == 3)
				cg_circle.alpha += FlxG.elapsed * 5/2;
			else if (state == 4)
				cg_circle.alpha -= FlxG.elapsed * 5/2;
			else if (state == 5)
				treasure.alpha -= FlxG.elapsed/2;
			
			if (canSkip && FlxG.keys.any() && !wasKeyPressed) {
				if (skip.visible) {
					canSkip = false;
					skip.visible = false;
					FlxG.fade(0xff000000, 2, function():void{ FlxG.switchState(new NewPlaystate(true)); } );
				}
				else {
					skip.visible = true;
					skipTime = 0;
				}
			}
			else if (canSkip && skip.visible) {
				skipTime += FlxG.elapsed;
				if (skipTime > 2) {
					skip.visible = false;
				}
			}
			wasKeyPressed = FlxG.keys.any();
		}
		
		override public function draw():void {
			var tmp:Boolean = cg_circle.visible;
			cg_circle.visible = false;
			
			super.draw();
			
			cg_circle.visible = tmp;
			if (tmp) {
				var i:int;
				
				i = 0;
				while (i < 5) {
					//switch (saver.goalTreasure) {
					switch (i) {
						case 0: {
							cg_circle.x = cg_map.x + 9;
							cg_circle.y = cg_map.y + 57;
						} break;
						case 1: {
							cg_circle.x = cg_map.x + 77;
							cg_circle.y = cg_map.y + 55;
						} break;
						case 2: {
							cg_circle.x = cg_map.x + 119;
							cg_circle.y = cg_map.y + 25;
						} break;
						case 3: {
							cg_circle.x = cg_map.x + 159;
							cg_circle.y = cg_map.y + 56;
						} break;
						case 4: {
							cg_circle.x = cg_map.x + 175;
							cg_circle.y = cg_map.y + 71;
						} break;
					}
					cg_circle.draw();
					i++;
				}
			}
		}
		
		private function onState_0():void { pl.velocity.x = Basic.plSpeed/2; }
		private function onState_1():void { 
			FlxG.flash(0xff000000, 0.5);
			pl.velocity.x = 0;
			cg_map.x += 64;
			cg_map.velocity.x = -64/2;
			cg_tm.velocity.x = -64/2;
			cg_sprite.x -= 32;
			cg_sprite.velocity.x = (32*2+18*2-4)/2;
			cg_tm.visible = true;
			cg_map.visible = true;
			cg_sprite.visible = true;
		}
		private function onState_2():void {
			cg_map.velocity.x = 0;
			cg_tm.velocity.x = 0;
			cg_sprite.velocity.x = 0;
			//treasure.reset(100, 100);
			treasure.x = 225;
			treasure.y = 190;
			treasure.y -= 16;
			treasure.scale.make(6, 6);
			treasure.alpha = 0;
			treasure.exists = true;
			treasure.visible = true;
			treasure.frame = saver.goalTreasure;
		}
		private function onState_3():void {
			cg_circle.visible = true;
			cg_circle.alpha = 0;
		}
		private function onState_4():void {
			n++;
			if (n == 4)
				state = 5;
		}
		private function onState_5():void {
			cg_circle.visible = false;
		}
		private function onState_6():void {
			FlxG.flash(0xff000000, 0.5);
			cg_tm.visible = false;
			cg_map.visible = false;
			cg_sprite.visible = false;
		}
		private function onState_7():void {
			pl.velocity.x = Basic.plSpeed/2;
			if (pl.x > FlxG.width) {
				FlxG.fade(0xff000000, 2, function():void{ FlxG.switchState(new NewPlaystate(true)); } );
			}
		}
	}
}
