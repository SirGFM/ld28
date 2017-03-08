package objs {
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Hero extends Basic {
		
		public var takeControl:Boolean;
		
		public var overLadder:Boolean;
		public var isClimbing:Boolean;
		private var isJumping:Boolean;
		
		private var walkTimer:Number;
		private var climbTimer:Number;
		private var jumpCounter:int;
		
		public function Hero() {
			super();
			overLadder = false;
			isJumping = false;
			takeControl = false;
		}
		
		override public function update():void {
			// control manager
			if (!takeControl) {
				if (FlxG.keys.LEFT) {
					velocity.x = -plSpeed;
				}
				else if (FlxG.keys.RIGHT) {
					velocity.x = plSpeed;
				}
				else {
					velocity.x = 0;
				}
				
				isClimbing = isClimbing && overLadder || overLadder && (FlxG.keys.UP || FlxG.keys.DOWN);
				isJumping = isJumping && !(touching&DOWN) && (velocity.y < -plSpeed*0.5);
				if (isClimbing && !isJumping) {
					if (FlxG.keys.UP)
						velocity.y = -plSpeed  * 0.65;
					else if (FlxG.keys.DOWN)
						velocity.y = plSpeed * 0.875;
					else {
						velocity.y = 0;
						acceleration.y = 0;
					}
					velocity.x *= 0.5;
				}
				else
					acceleration.y = grav * 0.5;
				
				if (touching & DOWN)
					jumpCounter = 4;
				else if (jumpCounter > 0)
					jumpCounter--;
				
				// jumping on the stairs will probably cause a bug
				if (((jumpCounter > 0) || isClimbing) && (FlxG.keys.justPressed("C") || FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("X") || FlxG.keys.justPressed("Y") || FlxG.keys.justPressed("SPACE"))) {
					isClimbing = false;
					isJumping = true;
					velocity.y = -grav * 0.25;
					sfx.jump();
					reg.cloudEmitter.at(this);
					reg.cloudEmitter.setYSpeed( 200, 300);
					reg.cloudEmitter.start(true, 0.75, 0, 10 + FlxG.random() * 15);
					reg.cloudEmitter.setYSpeed( -20, 20);
				}
				else if (velocity.y < 0 && !FlxG.keys.C && !FlxG.keys.X && !FlxG.keys.Z && !FlxG.keys.Y && !FlxG.keys.SPACE)
					velocity.y *= 0.75;
				
				if (!(wasTouching & DOWN) && (touching & DOWN)) {
					reg.cloudEmitter.at(this);
					reg.cloudEmitter.setYSpeed( 30, 50);
					reg.cloudEmitter.start(true, 0.75, 0, 10 + FlxG.random() * 15);
					reg.cloudEmitter.setYSpeed( -20, 20);
				}
			}
			
			// adjust facing direction
			super.update();
			
			// animation manager
			if (velocity.y == 0 && !isClimbing && velocity.x != 0 && _curAnim.name != "walk")
				play("walk");
			else if (isClimbing) {
				if ((velocity.y == 0 && velocity.x == 0) && _curAnim.name != "ladder")
					play("ladder")
				else ((velocity.y != 0 || velocity.x != 0 ) && _curAnim.name != "climb")
					play("climb")
			}
			else if (velocity.y < 0 && _curAnim.name != "jump")
				play("jump");
			else if (velocity.y > 20 && !overLadder)
				play("fall");
			else if (velocity.x == 0 && velocity.y == 0)
				play("def");
			
			if (isClimbing)
				if (velocity.x != 0 || velocity.y != 0) {
					climbTimer -= FlxG.elapsed;
					if (climbTimer <= 0) {
						sfx.climb();
						climbTimer += climbDelta;
					}
				}
				else
					climbTimer = 0;
			else if (touching & DOWN)
				if (velocity.x != 0) {
					walkTimer -= FlxG.elapsed;
					if (walkTimer <= 0) {
						sfx.walk();
						walkTimer += walkDelta
					}
				}
				else
					walkTimer = 0;
			overLadder = false;
		}
		
		override public function fakeKill():void {
			alive = false;
		}
		
		override public function recycle(argc:int, argv:Array):void {
			super.recycle(argc, argv);
			gfx.hero(this);
			walkTimer = 0;
			climbTimer = 0;
			jumpCounter = 0;
		}
	}
}
