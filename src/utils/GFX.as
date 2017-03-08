package utils {
	import objs.Basic;
	import objs.helpers.Instructions;
	import objs.helpers.OnHitParticle;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class GFX {
		
		[Embed(source = "../../editor/assets/gfx/tilemap.png")]	static public var tileset:Class;
		[Embed(source = "../../editor/assets/gfx/objects.png")]	static public var objects:Class;
		[Embed(source = "../../assets/gfx/font-numbers.png")]	public var font_number:Class;
		[Embed(source = "../../assets/gfx/objs/door-numbers.png")]	public var doorNumGFX:Class;
		[Embed(source = "../../assets/gfx/title/01-enter.png")]			public var title_01GFX:Class;
		[Embed(source = "../../assets/gfx/title/02-the-dungeon.png")]	public var title_02GFX:Class;
		[Embed(source = "../../assets/gfx/title/03-grab.png")]			public var title_03GFX:Class;
		[Embed(source = "../../assets/gfx/title/04-the-treasure.png")]	public var title_04GFX:Class;
		[Embed(source = "../../assets/gfx/title/05-and.png")]			public var title_05GFX:Class;
		[Embed(source = "../../assets/gfx/title/06-beware.png")]		public var title_06GFX:Class;
		[Embed(source = "../../assets/gfx/title/07-the-dangers.png")]	public var title_07GFX:Class;
		[Embed(source = "../../assets/gfx/options.png")]			public var optionsGFX:Class;
		[Embed(source = "../../assets/gfx/paused.png")]			public var pausedGFX:Class;
		[Embed(source = "../../assets/gfx/achievements.png")]			public var achievementsGFX:Class;
		[Embed(source = "../../assets/gfx/music-box.png")]			public var musicboxGFX:Class;
		[Embed(source = "../../assets/gfx/cg-circle.png")]			public var cg_circleGFX:Class;
		[Embed(source = "../../assets/gfx/cg-map.png")]			public var cg_mapGFX:Class;
		[Embed(source = "../../assets/gfx/cg-map-small.png")]			public var cg_map_smallGFX:Class;
		[Embed(source = "../../assets/gfx/cg-darkwall.png")]			public var cg_darkwallGFX:Class;
		[Embed(source = "../../assets/gfx/cg-player.png")]		public var cg_playerGFX:Class;
		static public const self:GFX = new GFX();
		
		[Embed(source = "../../assets/gfx/tilemap.png")]		public var tilemap:Class;
		[Embed(source = "../../assets/gfx/objs/bat.png")]		private var batGFX:Class;
		[Embed(source = "../../assets/gfx/objs/button.png")]	private var buttonGFX:Class;
		[Embed(source = "../../assets/gfx/objs/cage.png")]		private var cageGFX:Class;
		[Embed(source = "../../assets/gfx/objs/chains.png")]	private var chainsGFX:Class;
		[Embed(source = "../../assets/gfx/objs/gold.png")]		private var goldGFX:Class;
		[Embed(source = "../../assets/gfx/objs/he.png")]		private var heGFX:Class;
		[Embed(source = "../../assets/gfx/objs/HELP.png")]		private var helpGFX:Class;
		[Embed(source = "../../assets/gfx/objs/platform.png")]	private var platformGFX:Class;
		[Embed(source = "../../assets/gfx/objs/player.png")]	private var playerGFX:Class;
		[Embed(source = "../../assets/gfx/objs/she.png")]		private var sheGFX:Class;
		[Embed(source = "../../assets/gfx/objs/snake.png")]		private var snakeGFX:Class;
		[Embed(source = "../../assets/gfx/objs/spark.png")]		private var sparkGFX:Class;
		[Embed(source = "../../assets/gfx/particles/lava.png")]	private var lavaGFX:Class;
		[Embed(source = "../../assets/gfx/particles/cloud.png")]private var cloudGFX:Class;
		[Embed(source = "../../assets/gfx/particles/hit.png")]	private var hitGFX:Class;
		[Embed(source = "../../assets/gfx/particles/kirakira.png")]	private var kirakiraGFX:Class;
		[Embed(source = "../../assets/gfx/objs/deadhead.png")]	private var deadHeadGFX:Class;
		[Embed(source = "../../assets/gfx/objs/door.png")]			private var doorGFX:Class;
		[Embed(source = "../../assets/gfx/objs/door-way.png")]			private var doorwayGFX:Class;
		[Embed(source = "../../assets/gfx/objs/door-jewel.png")]	private var doorJewelGFX:Class;
		[Embed(source = "../../assets/gfx/gui/treasure-get.png")]		private var treasureGetGFX:Class;
		[Embed(source = "../../assets/gfx/objs/treasures.png")]	private var treasuresGFX:Class;
		[Embed(source = "../../assets/gfx/objs/treasure-balloon.png")]	private var treasureBalloonGFX:Class;
		
		[Embed(source = "../../assets/gfx/instr-00.png")]		private var inst00GFX:Class;
		[Embed(source = "../../assets/gfx/instr-01.png")]		private var inst01GFX:Class;
		[Embed(source = "../../assets/gfx/instr-02.png")]		private var inst02GFX:Class;
		[Embed(source = "../../assets/gfx/instr-03.png")]		private var inst03GFX:Class;
		
		public function hero(b:Basic):void {
			b.loadGraphic(playerGFX, true, true, 16, 16);
			if (!b.isAnimSet) {
				b.addAnimation("def", [0, 0, 7], 1, true);
				b.addAnimation("walk", [0, 1, 0, 2], 8, true);
				b.addAnimation("ladder", [3], 0, false);
				b.addAnimation("climb", [3, 4], 4, true);
				b.addAnimation("jump", [1, 5], 6, false);
				b.addAnimation("fall", [6], 0, false);
				b.isAnimSet = true;
			}
			b.play("def");
			b.width = 10;
			b.height = 12;
			b.offset.x = 3;
			b.offset.y = 4;
		}
		
		public function he(b:Basic):void {
			b.loadGraphic(heGFX, true, true, 16, 16);
			if (!b.isAnimSet) {
				b.addAnimation("def", [0], 0, false);
				b.addAnimation("sad", [1], 0, false);
				b.addAnimation("walk", [0, 2, 0, 3], 8, true);
				b.addAnimation("jump", [2, 4], 6, false);
				b.isAnimSet = true;
			}
			b.play("def");
			b.allowCollisions = 0;
		}
		
		public function she(b:Basic):void {
			b.loadGraphic(sheGFX, true, true, 16, 16);
			if (!b.isAnimSet) {
				b.addAnimation("def", [0], 0, false);
				b.addAnimation("sad", [1], 0, false);
				b.addAnimation("walk", [0, 2, 0, 3], 8, true);
				b.addAnimation("jump", [2, 4], 6, false);
				b.isAnimSet = true;
			}
			b.play("def");
			b.allowCollisions = 0;
		}
		
		public function button(b:Basic):void {
			b.loadGraphic(buttonGFX, true, true, 16, 16);
			if (!b.isAnimSet) {
				b.addAnimation("def", [0], 0, false);
				b.addAnimation("press", [0, 1, 2], 8, false);
				b.addAnimation("release", [2, 1, 0], 8, false);
				b.isAnimSet = true;
			}
			b.play("def");
			b.width = 12;
			b.height = 6;
			b.offset.x = 2;
			b.offset.y = 4;
		}
		
		public function cage(b:Basic):void {
			b.loadGraphic(cageGFX, false, false, 48, 48);
		}
		
		public function chains(b:Basic):void {
			b.loadGraphic(chainsGFX, false, false, 16, 16);
			b.width = 4;
			b.offset.x = 6;
		}
		
		public function snake(b:Basic):void {
			b.loadGraphic(snakeGFX, true, true, 16, 16);
			if (!b.isAnimSet) {
				b.addAnimation("walk", [0, 1], 4, true);
				b.addAnimation("run", [2, 3], 8, true);
				b.addAnimation("redwalk", [4, 5], 4, true);
				b.addAnimation("redrun", [6, 7], 8, true);
				b.isAnimSet = true;
			}
			b.play("walk");
			b.width = 12;
			b.height = 7;
			b.offset.x = 3;
			b.offset.y = 9;
		}
		
		public function bat(b:Basic):void {
			b.loadGraphic(batGFX, true, true, 16, 16);
			if (!b.isAnimSet) {
				b.addAnimation("def", [0, 1, 2, 1], 4, true);
				b.addAnimation("fly", [0, 1, 2, 1], 8, true);
				b.addAnimation("charge", [0], 0, false);
				b.isAnimSet = true;
			}
			b.play("def");
			b.width = 8;
			b.height = 8;
			b.centerOffsets();
		}
		
		public function platform(b:Basic):void {
			b.loadGraphic(platformGFX, false, true, 16, 16);
			b.height = 2;
			//b.offset.y = 8;
		}
		
		public function help(b:Basic):void {
			b.loadGraphic(helpGFX, true, true, 16, 16);
			if (!b.isAnimSet) {
				b.addAnimation("right", [0, 1, 2, 3, 3, 3, 3, 3, 3, 2, 4, 5, 6, 7, 7, 7, 7, 7, 7, 6], 12, true);
				b.addAnimation("left",  [0, 1, 8, 9, 9, 9, 9, 9, 9, 8, 4, 5, 10, 11, 11, 11, 11, 11, 11, 10], 12, true);
				b.addAnimation("he", [12, 13, 2, 3, 3, 3, 3, 3, 3, 2, 13], 12, true);
				b.addAnimation("she", [14, 15, 10, 11, 11, 11, 11, 11, 11, 10, 15], 12, true);
				b.isAnimSet = true;
			}
		}
		
		public function spark(b:Basic):void {
			b.loadGraphic(sparkGFX, true, true, 16, 16);
			if (!b.isAnimSet)
				b.addAnimation("def", [0, 1, 2, 3, 2, 1], 12, true);
			b.width = 1;
			b.height = 1;
			b.offset.x = 8;
			b.offset.y = 8;
			b.x += 8;
			b.y += 8;
			b.play("def");
		}
		
		public function gold(b:FlxSprite):void {
			b.loadGraphic(goldGFX, false, false);
		}
		
		public function lava(e:FlxEmitter):void {
			e.makeParticles(lavaGFX, 128, 16, true, 0);
			e.length = Registry.self.maxLava;
			e._maxSize = Registry.self.maxLava;
			e.lifespan = 0.5;
			e.gravity = 600;
			e.setRotation( -180, 180);
			e.setXSpeed( -50, 50);
			e.setYSpeed( -160, -120);
		}
		
		public function cloud(e:FlxEmitter):void {
			e.makeParticles(cloudGFX, 64, 16, true, 0);
			e.length = Registry.self.maxCloud;
			e._maxSize = Registry.self.maxCloud;
			e.gravity = 0;
			e.setRotation( -180, 180);
			e.setXSpeed( -20, 20);
			e.setYSpeed( -20, 20);
		}
		
		public function onHit(e:FlxEmitter):void {
			while (e.length < 24) {
				var p:OnHitParticle;
				p = new OnHitParticle();
				p.loadGraphic(hitGFX, true, false, 8, 8);
				p.addAnimation("def", [0, 1, 2, 3, 4, 5, 6, 7], 16, false);
				p.kill();
				e.add(p);
				//(e.add(new OnHitParticle()) as OnHitParticle).loadGraphic(hitGFX, true, false, 8, 8).addAnimation("def", [0, 1, 2, 3, 4, 5, 6, 7], 12, false);
			}
			e.gravity = 0;
			e.setRotation(0, 0);
			e.setXSpeed(0, 0);
			e.setYSpeed(0, 0);
		}
		
		public function inst00(i:Instructions):void {
			i.loadGraphic(inst00GFX);
			i.x = 42;
			i.y = 174;
		}
		public function inst01(i:Instructions):void {
			i.loadGraphic(inst01GFX);
			i.x = 210;
			i.y = 178;
		}
		public function inst02(i:Instructions):void {
			i.loadGraphic(inst02GFX);
			i.x = 133;
			i.y = 154;
		}
		public function inst03(i:Instructions):void {
			i.loadGraphic(inst03GFX);
			i.x = 147;
			i.y = 188;
		}
		
		public function deadHead(s:FlxSprite):void {
			s.loadGraphic(deadHeadGFX, true, false, 16, 12);
			s.addAnimation("def", [0,0,0,0,0,1], 2, true);
			s.play("def");
		}
		
		public function door(s:FlxSprite):void {
			s.loadGraphic(doorGFX, false, false);
		}
		public function doorway(s:FlxSprite):void {
			s.loadGraphic(doorwayGFX, false, false);
		}
		public function doorJewel(s:FlxSprite):void {
			s.loadGraphic(doorJewelGFX, true, false, 4, 3);
		}
		
		public function treasures(s:FlxSprite):void {
			s.loadGraphic(treasuresGFX, true, false, 16, 16);
		}
		
		public function treasureGet(s:FlxSprite):void {
			s.loadGraphic(treasureGetGFX, false, false);
		}
		public function treasureBalloon(s:FlxSprite):void {
			s.loadGraphic(treasureBalloonGFX, true, true, 26, 26);
		}
		
		public function kirakira(e:FlxEmitter):void {
			e.makeParticles(kirakiraGFX, 32, 16, true, 0);
			e.gravity = 0;
			e.setRotation(-180, 180);
			e.setXSpeed(-32, 32);
			e.setYSpeed(-32, 32);
		}
	}
}
