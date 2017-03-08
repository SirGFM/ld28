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
		
		static protected var sfx:SFX = SFX.self;
		static protected var reg:Registry = Registry.self;
		static protected var gfx:GFX = GFX.self;
		
		static protected const snakeSpeed:int = 50;
		static protected const plSpeed:int = 67.5;
		static protected const climbDelta:Number = 0.425;
		static protected const walkDelta:Number = 0.35;
		static public const grav:int = 550;
		
		public var isAnimSet:Boolean;
		public var turnOnEdge:Boolean;
		public var strid:String;
		
		public function Basic() {
			super();
			isAnimSet = false;
			turnOnEdge = true;
		}
		
		override public function update():void {
			if (!(wasTouching & RIGHT) && (touching & RIGHT)) {
				x += width - 4;
				last.x += width - 4;
				reg.onHitEmitter.at(this);
				reg.onHitEmitter.emitParticle();
				x -= width - 4;
				last.x -= width - 4;
				sfx.fall();
			}
			else if (!(wasTouching & LEFT) && (touching & LEFT)) {
				x -= 4;
				last.x -= 4;
				reg.onHitEmitter.at(this);
				reg.onHitEmitter.emitParticle();
				x +=  4;
				last.x += 4;
				sfx.fall();
			}
			else if (!(wasTouching & UP) && (touching & UP)) {
				y -= 4;
				last.y -= 4;
				reg.onHitEmitter.at(this);
				reg.onHitEmitter.emitParticle();
				y += 4;
				last.y += 4;
				sfx.fall();
			}
			else if (acceleration.y == 0 && !(wasTouching & DOWN) && (touching & DOWN)) {
				y += height - 4;
				last.y += height - 4;
				reg.onHitEmitter.at(this);
				reg.onHitEmitter.emitParticle();
				y -= height - 4;
				last.y -= height - 4;
				sfx.fall();
			}
			
			if (velocity.x > 0)
				facing = RIGHT;
			else if (velocity.x < 0)
				facing = LEFT;
			
			if (x < 0)
				if (this is Hero)
					x = 0;
				else
					velocity.x = FlxU.abs(velocity.x);
			else if (x + width > 320)
				if (this is Hero)
					x = 320 - width;
				else
					velocity.x = -FlxU.abs(velocity.x);
			if (y < 0)
				if (this is Hero)
					y = 0;
				else
					velocity.y = FlxU.abs(velocity.y);
			else if (y + height > 240)
				if (this is Hero)
					y = 240 - height;
				else
					velocity.y = -FlxU.abs(velocity.y);
		}
		
		public function recycle(argc:int, argv:Array):void {
			reset(16 * int(argv[1] as String), 16 * int(argv[2] as String));
			
			if (argc > 3)
				strid = argv[3] as String;
			else
				strid = "";
			
			if (strid.indexOf("ev") == 0)
				visible = false;
		}
		
		public function fakeKill():void {
			kill();
		}
	}
}
