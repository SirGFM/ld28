package objs {
	
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import utils.GFX;
	import utils.Registry;
	import utils.SFX;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Basic extends FlxSprite {
		
		static private const minX:int = -2;
		static private const maxX:int = 322;
		static private const minY:int = -2;
		static private const maxY:int = 242;
		
		static protected var sfx:SFX = SFX.self;
		static protected var reg:Registry = Registry.self;
		static protected var gfx:GFX = GFX.self;
		
		static protected const snakeSpeed:int = 50;
		static public var plSpeed:int = 67.5;
		static protected const climbDelta:Number = 0.425;
		static protected const walkDelta:Number = 0.35;
		static public const grav:int = 550;
		
		public var isAnimSet:Boolean;
		public var turnOnEdge:Boolean;
		public var strid:String;
		
		protected var doEmitOnHit:Boolean;
		
		public function Basic() {
			super();
			isAnimSet = false;
			turnOnEdge = true;
			doEmitOnHit = true;
		}
		
		override public function update():void {
			if (doEmitOnHit && reg.particlesEnabled) {
				if (!(wasTouching & RIGHT) && (touching & RIGHT)) {
					//if (doEmitOnHit && reg.particlesEnabled) {
						x += width - 4;
						last.x += width - 4;
						reg.onHitEmitter.at(this);
						reg.onHitEmitter.emitParticle();
						x -= width - 4;
						last.x -= width - 4;
					//}
					sfx.fall();
				}
				else if (!(wasTouching & LEFT) && (touching & LEFT)) {
					//if (doEmitOnHit && reg.particlesEnabled) {
						x -= 4;
						last.x -= 4;
						reg.onHitEmitter.at(this);
						reg.onHitEmitter.emitParticle();
						x +=  4;
						last.x += 4;
					//}
					sfx.fall();
				}
				else if (!(wasTouching & UP) && (touching & UP)) {
					//if (reg.particlesEnabled) {
						y -= 4;
						last.y -= 4;
						reg.onHitEmitter.at(this);
						reg.onHitEmitter.emitParticle();
						y += 4;
						last.y += 4;
					//}
					sfx.fall();
				}
				else if (acceleration.y == 0 && !(wasTouching & DOWN) && (touching & DOWN)) {
					//if (doEmitOnHit && reg.particlesEnabled) {
						y += height - 4;
						last.y += height - 4;
						reg.onHitEmitter.at(this);
						reg.onHitEmitter.emitParticle();
						y -= height - 4;
						last.y -= height - 4;
					//}
					sfx.fall();
				}
			}
			
			if (velocity.x > 0)
				facing = RIGHT;
			else if (velocity.x < 0)
				facing = LEFT;
			
			if (x < minX)
				if (this is Hero) {
					if (x < minX-16)
						kill();
				}
				else
					velocity.x = FlxU.abs(velocity.x);
			else if (x + width > maxX)
				if (this is Hero) {
					if (x +width > maxX+16)
						kill();
				}
				else
					velocity.x = -FlxU.abs(velocity.x);
			if (y < minY)
				if (this is Hero) {
					if (y < minY-16)
						kill();
				}
				else
					velocity.y = FlxU.abs(velocity.y);
			else if (y + height > maxY)
				if (this is Hero) {
					if (y+height > maxY+16)
						kill();
				}
				else
					velocity.y = -FlxU.abs(velocity.y);
		}
		
		override public function reset(X:Number, Y:Number):void {
			super.reset(X, Y);
			strid = "";
		}
		
		public function recycle(argc:int, argv:Array):void {
			reset(16 * int(argv[1] as String), 16 * int(argv[2] as String));
			
			if (argc > 3)
				strid = argv[3] as String;
			else
				strid = "";
		}
		
		public function fakeKill():void {
			kill();
		}
	}
}
