package objs {
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import states.NewPlaystate;
	
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
			health = 0;
			
			if ((FlxG.state is NewPlaystate) && saver.difficulty == saver.NOOB) {
				plSpeed = 67.5 * 1.225;
			}
			else {
				plSpeed = 67.5;
			}
		}
		
		override public function update():void {
			var min:Number;
			var max:Number;
			
			// control manager
			if (!takeControl) {
				if (FlxG.keys.LEFT || FlxG.keys.A) {
					velocity.x = -plSpeed;
				}
				else if (FlxG.keys.RIGHT || FlxG.keys.D) {
					velocity.x = plSpeed;
				}
				else {
					velocity.x = 0;
				}
				
				isClimbing = isClimbing && overLadder || overLadder && (FlxG.keys.UP || FlxG.keys.W || FlxG.keys.DOWN || FlxG.keys.S);
				isJumping = isJumping && !(touching&DOWN) && (velocity.y < -plSpeed*0.5);
				if (isClimbing && !isJumping) {
					if (FlxG.keys.UP || FlxG.keys.W)
						velocity.y = -plSpeed  * 0.65;
					else if (FlxG.keys.DOWN || FlxG.keys.S)
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
				if (((jumpCounter > 0) || isClimbing) && (FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("Y") || FlxG.keys.justPressed("J") || FlxG.keys.justPressed("SPACE"))) {
					isClimbing = false;
					isJumping = true;
					onJump();
					velocity.y = -grav * 0.25;
				}
				else if (velocity.y < 0 && !FlxG.keys.Z && !FlxG.keys.Y && !FlxG.keys.J && !FlxG.keys.SPACE)
					velocity.y *= 0.75;
			}
			else if (isJumping) {
				onJump();
				velocity.y = -grav * 0.25;
				isJumping = false;
			}
			
			if (!(wasTouching & DOWN) && (touching & DOWN)) {
				if (reg.particlesEnabled) {
					var hh:int = height / 2;
					y += hh;
					reg.cloudEmitter.at(this);
					y -= hh;
					if (velocity.x != 0) {
						min = FlxU.min( velocity.x / 20, velocity.x/4);
						max = FlxU.max( velocity.x / 20, velocity.x/4);
						reg.cloudEmitter.setXSpeed(min, max);
					}
					reg.cloudEmitter.setYSpeed( 15, 22.5);
					reg.cloudEmitter.explode(0.75, reg.particlesQuantity + FlxG.random() * reg.particlesRandom);
					reg.resetCloudEmitter();
				}
				sfx.fall();
			}
			
			Game::debug {
				if (FlxG.mouse.pressed()) {
					x = FlxG.mouse.x - width / 2;;
					y = FlxG.mouse.y - height / 2;
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
		
		private function onJump():void {
			var min:Number;
			var max:Number;
			sfx.jump();
			if (reg.particlesEnabled) {
				reg.cloudEmitter.at(this);
				if (velocity.x != 0) {
					min = FlxU.min( -velocity.x / 15, -velocity.x/3);
					max = FlxU.max( -velocity.x / 15, -velocity.x/3);
					reg.cloudEmitter.setXSpeed(min, max);
				}
				reg.cloudEmitter.setYSpeed( 20, 45);
				reg.cloudEmitter.explode(0.75, reg.particlesQuantity + FlxG.random() * reg.particlesRandom);
				reg.resetCloudEmitter();
			}
		}
		
		override public function kill():void {
			if (flickering)
				return;
			
			if (!(this is DeadPlayer) && health > 0) {
				health--;
				alpha -= 0.15;
				flicker(1.2);
				
				reg.deathCounter.num++;
				saver.rundeath++;
				saver.totaldeath++;
				
				return;
			}
			
			super.kill();
			
			if (saver.difficulty != saver.HARD) {
				alpha = 1;
				flicker(1.2);
			}
		}
		
		override public function fakeKill():void {
			alive = false;
		}
		
		override public function recycle(argc:int, argv:Array):void {
			if (!alive || (reg.transition && !reg.transition.alive)) {
				super.recycle(argc, argv);
				gfx.hero(this);
				walkTimer = 0;
				climbTimer = 0;
				jumpCounter = 0;
			}
			flicker(0);
			health = 0;
			
			if (saver.difficulty == saver.EASY || saver.difficulty == saver.NOOB) {
				health = 2;
				alpha = 1;
			}
			else if (saver.difficulty == saver.NORMAL) {
				health = 1;
				alpha = 1;
			}
		}
		
		public function get jump():Boolean {
			return isJumping;
		}
		public function set jump(val:Boolean):void {
			if (takeControl)
				isJumping = val;
		}
	}
}
