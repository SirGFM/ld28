package states {
	
	import objs.Basic;
	import objs.Hero;
	import objs.Treasure;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	import utils.MapLoader;
	import utils.SFX;
	
	/**
	 * ...
	 * @author 
	 */
	public class NewEndstate extends Cutscene {
		
		[Embed(source = "../../assets/gfx/treasure-get.png")]		private var treasure_get:Class;
		
		private const sfx:SFX = SFX.self;
		
		private var treasure:Treasure;
		private var map:FlxTilemap;
		private var pl:Hero;
		
		private var text1:FlxSprite;
		private var text2:FlxText;
		private var text3:FlxText;
		private var text4:FlxText;
		private var text5:FlxText;
		
		private var fade:FlxSprite;
		private var gold:FlxSprite;
		private var head:FlxSprite;
		
		private var timeNum:Number;
		private var goldNum:Number;
		private var deathNum:Number;
		
		override public function create():void {
			super.create();
			
			addState(0.5, 1, onState_0);
			addState(0.5, 2, null);
			addState(2, 3, null);
			addState(1, 4, null);
			addState(1, 5, null);
			addState(1, 6, onState_5);
			addState(0.25, 7, onState_6);
			addState(0.5, 8, onState_7);
			addState(1.5, 9, null);
			addState(0.5, 10, null);
			addState(0.5, 11, null);
			addState(0.25, 12, onState_11);
			addState(0.925, 13, onState_12);
			addState(1.41, 14, onState_12);
			addState(10, 15, onState_12);
			addState(10, 15, null);
			
			map = new FlxTilemap();
			
			pl = new Hero();
			pl.kill();
			var arr:Array = [null, "19", "13", "pl"];
			pl.recycle(arr.length, arr);
			pl.takeControl = true;
			pl.facing = FlxObject.LEFT;
			pl.acceleration.y = Basic.grav;
			
			add(map)
			MapLoader.self.loadMap( -1, map);
			add(pl);
			add(treasure);
			
			if (saver.goalTreasure == saver.curTreasure) {
				text1 = new FlxSprite(90, 15, treasure_get);
			}
			else {
				var t:FlxText
				t = new FlxText(48, 16-8, FlxG.width, "GAME\n  OVER");
				t.setFormat(null, 32, 0xffedde8d, "left", 0x88b48e6d);
				text1 = t as FlxSprite;
			}
			text1.alpha = 0;
			text2 = new FlxText(83, 96-8, FlxG.width, "Time:");
			text2.setFormat(null, 16, 0xffedde8d, "left", 0x88b48e6d);
			text2.alpha = 0;
			text3 = new FlxText(143, 96-8, FlxG.width, "00:00.000");
			text3.setFormat(null, 16, 0xffedde8d, "left", 0x88b48e6d);
			text3.alpha = 0;
			text4 = new FlxText(131, 126-8, FlxG.width, "x00");
			text4.setFormat(null, 16, 0xffedde8d, "left", 0x88b48e6d);
			text4.alpha = 0;
			text5 = new FlxText(131, 156-8, FlxG.width, "x0000");
			text5.setFormat(null, 16, 0xffedde8d, "left", 0x88b48e6d);
			text5.alpha = 0;
			
			gold = new FlxSprite(97, 120-8);
			gfx.gold(gold);
			gold.scale.make(2, 2);
			gold.alpha = 0;
			
			head = new FlxSprite(99, 150);
			gfx.deadHead(head);
			head.scale.make(2, 2);
			head.alpha = 0;
			
			treasure = new Treasure();
			gfx.treasures(treasure);
			treasure.alpha = 0;
			
			fade = new FlxSprite();
			fade.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			fade.alpha = 0;
			
			add(fade);
			add(text1);
			add(text2);
			add(text3);
			add(text4);
			add(text5);
			add(gold);
			add(head);
			add(treasure);
			
			timeNum = 0;
			goldNum = 0;
			deathNum = 0;
			
			if (saver.curTreasure != saver.goalTreasure) {
				sfx.playBadendSong();
			}
			else {
				sfx.playWinSong();
			}
			
			saver.uploadAchievements(true);
		}
		
		override public function update():void {
			var step:Number = FlxG.elapsed;
			super.update();
			
			switch(state) {
				case 0: { fade.alpha += step; }break;
				case 1: { text1.alpha += step*2; }break;
				case 2: {
					text2.alpha += 0.5 * step;
					text3.alpha += 0.5 * step;
					timeNum += saver.runtime * 0.5 * step;
					if (timeNum > saver.runtime)
						timeNum = saver.runtime;
					text3.text = FlxU.formatTime(timeNum / 1000, true);
				}break;
				case 3: {
					text4.alpha += step;
					gold.alpha += step;
					goldNum += saver.totalGold * step;
					if (goldNum > saver.totalGold)
						goldNum = saver.totalGold;
					text4.text = "x"+FlxU.floor(goldNum).toString();
				}break;
				case 4:
				case 5: {
					text5.alpha += 0.5 * FlxG.elapsed;
					head.alpha += 0.5 * FlxG.elapsed;
					deathNum += saver.rundeath * 0.5 * step;
					if (deathNum > saver.rundeath)
						deathNum = saver.rundeath;
					text5.text = "x"+FlxU.floor(deathNum).toString();
				}break;
				case 7: {
					treasure.alpha += 2 * FlxG.elapsed;
				} break;
				case 9: {
					treasure.alpha -= 2 * FlxG.elapsed;
				} break;
				case 14:
				case 15: {
					if (sfx.finished || sfx.playing && pl.x + pl.width < 0)
						FlxG.fade(0xff000000, 0.5, function():void {
							saver.finalSave();
							FlxG.switchState(new Menustate());
						} );
				} break;
			}
			
			FlxG.collide(map, pl);
		}
		
		private function onState_0():void {
			pl.velocity.x = -Basic.plSpeed / 2;
		}
		private function onState_5():void {
			pl.velocity.x = 0;
		}
		private function onState_6():void {
			if (saver.curTreasure != saver.goalTreasure)
				state = 12;
			else
				pl.jump = true;
		}
		private function onState_7():void {
			pl.moves = false;
			treasure.frame = saver.curTreasure;
			treasure.x = pl.x - 3;
			treasure.y = pl.y - treasure.height - 4;
			reg.kirakiraEmitter.at(treasure);
			reg.kirakiraEmitter.start(false, 0.75, 0.035, 64);
		}
		private function onState_11():void {
			pl.moves = true;
		}
		private function onState_12():void {
			pl.velocity.x = -Basic.plSpeed / 2;
			pl.jump = true;
		}
	}
}
