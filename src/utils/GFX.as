package utils {
	import objs.Basic;
	import objs.helpers.OnHitParticle;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class GFX {
		
		static public const self:GFX = new GFX();
		
		[Embed(source = "../../assets/gfx/tilemap.png")]		public var tilemap:Class;
		[Embed(source = "../../assets/gfx/atlas.png")]			private var atlas:Class;
		[Embed(source = "../../assets/gfx/particles/lava.png")]	private var lavaGFX:Class;
		[Embed(source = "../../assets/gfx/particles/cloud.png")]private var cloudGFX:Class;
		[Embed(source = "../../assets/gfx/particles/hit.png")]	private var hitGFX:Class;
		
		public function hero(b:Basic):void {
			b.loadGraphic(atlas, true, true, 16, 16);
			if (!b.isAnimSet) {
				b.addAnimation("def", [15, 15, 22], 1, true);
				b.addAnimation("walk", [15, 16, 15, 17], 8, true);
				b.addAnimation("ladder", [18], 0, false);
				b.addAnimation("climb", [18, 19], 2, true);
				b.addAnimation("jump", [16, 20], 6, false);
				b.addAnimation("fall", [21], 0, false);
				b.isAnimSet = true;
			}
			b.play("def");
			b.width = 10;
			b.height = 12;
			b.offset.x = 3;
			b.offset.y = 4;
		}
		
		public function he(b:Basic):void {
			b.loadGraphic(atlas, true, true, 16, 16);
			if (!b.isAnimSet) {
				b.addAnimation("def", [3], 0, false);
				b.addAnimation("sad", [53], 0, false);
				b.addAnimation("walk", [3, 55, 3, 56], 8, true);
				b.addAnimation("jump", [55, 57], 6, false);
				b.isAnimSet = true;
			}
			b.play("def");
			b.allowCollisions = 0;
		}
		
		public function she(b:Basic):void {
			b.loadGraphic(atlas, true, true, 16, 16);
			if (!b.isAnimSet) {
				b.addAnimation("def", [8], 0, false);
				b.addAnimation("sad", [54], 0, false);
				b.addAnimation("walk", [8, 60, 8, 61], 8, true);
				b.addAnimation("jump", [60, 62], 6, false);
				b.isAnimSet = true;
			}
			b.play("def");
			b.allowCollisions = 0;
		}
		
		public function button(b:Basic):void {
			b.loadGraphic(atlas, true, true, 16, 16);
			if (!b.isAnimSet) {
				b.addAnimation("def", [4], 0, false);
				b.addAnimation("press", [4, 9, 14], 8, false);
				b.addAnimation("release", [14, 9, 4], 8, false);
				b.isAnimSet = true;
			}
			b.play("def");
			b.width = 12;
			b.height = 6;
			b.offset.x = 2;
			b.offset.y = 4;
		}
		
		public function cage(b:Basic):void {
			b.loadGraphic(atlas, true, true, 48, 48);
			b.frame = 0;
		}
		
		public function chains(b:Basic):void {
			b.loadGraphic(atlas, true, true, 16, 16);
			b.frame = 13;
			b.width = 4;
			b.offset.x = 6;
		}
		
		public function snake(b:Basic):void {
			b.loadGraphic(atlas, true, true, 16, 16);
			if (!b.isAnimSet) {
				b.addAnimation("walk", [25, 26], 4, true);
				b.addAnimation("run", [27, 28], 8, true);
				b.isAnimSet = true;
			}
			b.play("walk");
			b.width = 12;
			b.height = 7;
			b.offset.x = 3;
			b.offset.y = 9;
		}
		
		public function bat(b:Basic):void {
			b.loadGraphic(atlas, true, true, 16, 16);
			if (!b.isAnimSet) {
				b.addAnimation("def", [29, 30, 31, 30], 4, true);
				b.addAnimation("fly", [29, 30, 31, 30], 8, true);
				b.addAnimation("charge", [29], 0, false);
				b.isAnimSet = true;
			}
			b.play("def");
			b.width = 8;
			b.height = 8;
			b.centerOffsets();
		}
		
		public function platform(b:Basic):void {
			b.loadGraphic(atlas, true, true, 16, 16);
			b.frame = 32;
			b.height = 2;
			b.offset.y = 8;
		}
		
		public function help(b:Basic):void {
			b.loadGraphic(atlas, true, true, 16, 16);
			if (!b.isAnimSet) {
				b.addAnimation("right", [33, 34, 35, 36, 36, 36, 36, 36, 36, 35, 37, 38, 39, 40, 40, 40, 40, 40, 40, 39], 12, true);
				b.addAnimation("left",  [33, 34, 41, 42, 42, 42, 42, 42, 42, 41, 37, 38, 43, 44, 44, 44, 44, 44, 44, 43], 12, true);
				b.addAnimation("he", [45, 46, 35, 36, 36, 36, 36, 36, 36, 35, 46], 12, true);
				b.addAnimation("she", [47, 48, 43, 44, 44, 44, 44, 44, 44, 43, 48], 12, true);
			}
		}
		
		public function spark(b:Basic):void {
			b.loadGraphic(atlas, true, true, 16, 16);
			if (!b.isAnimSet)
				b.addAnimation("def", [49, 50, 51, 52, 51, 50], 12, true);
			b.width = 1;
			b.height = 1;
			b.offset.x = 8;
			b.offset.y = 8;
			b.x += 8;
			b.y += 8;
			b.play("def");
		}
		
		public function lava(e:FlxEmitter):void {
			e.makeParticles(lavaGFX, 64, 16, true, 0);
			e.lifespan = 0.5;
			e.gravity = 600;
			e.setRotation( -180, 180);
			e.setXSpeed( -50, 50);
			e.setYSpeed( -160, -120);
		}
		
		public function cloud(e:FlxEmitter):void {
			e.makeParticles(cloudGFX, 32, 16, true, 0);
			e.gravity = 0;
			e.setRotation( -180, 180);
			e.setXSpeed( -20, 20);
			e.setYSpeed( -20, 20);
			/*
			e.lifespan = 0.5;
			e.gravity = 600;
			e.setRotation( -180, 180);
			e.setXSpeed( -50, 50);
			e.setYSpeed( -160, -120);
			*/
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
	}
}
