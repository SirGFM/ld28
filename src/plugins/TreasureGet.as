package plugins {
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author 
	 */
	public class TreasureGet extends Plugin {
		
		private var bg:FlxSprite;
		private var tr:FlxSprite;
		private var goal:FlxSprite;
		private var da:Number;
		
		public function TreasureGet() {
			super();
			
			var X:Number = 2;
			var Y:Number = 2;
			
			bg = new FlxSprite(X, Y);
			tr = new FlxSprite(X+1, Y);
			goal = new FlxSprite(X+1, Y);
			da = 0;
			
			bg.scrollFactor.make();
			tr.scrollFactor.make();
			goal.scrollFactor.make();
			
			gfx.treasureGet(bg);
			gfx.treasures(tr);
			gfx.treasures(goal);
			goal.alpha = 0;
			
			tr.visible = false;
			goal.visible = false;
			
			kill();
		}
		
		override public function update():void {
			super.update();
			if (goal.visible) {
				if (goal.alpha <= 0)
					da = FlxG.elapsed * 0.4;
				else if (goal.alpha >= 0.4)
					da = -FlxG.elapsed * 0.4;
				goal.alpha += da;
			}
		}
		
		override public function draw():void {
			bg.draw();
			if (tr.visible)
				tr.draw();
			if (goal.visible)
				goal.draw();
		}
		
		override public function revive():void {
			super.revive();
			
			if (saver.curTreasure >= 0) {
				tr.frame = saver.curTreasure;
				tr.visible = true;
			}
			else
				tr.visible = false;
			
			if (saver.curTreasure != saver.goalTreasure) {
				goal.frame = saver.goalTreasure;
				goal.visible = true;
				goal.alpha = 0;
			}
		}
		
		public function setTreasure(TR:FlxSprite):void {
			if (TR) {
				tr.visible = true;
				tr.frame = TR.frame;
			}
			else
				tr.visible = false;
			
			if (saver.curTreasure != saver.goalTreasure) {
				goal.frame = saver.goalTreasure;
				goal.visible = true;
				goal.alpha = 0;
			}
		}
	}
}
