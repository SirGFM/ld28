package plugins {
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author 
	 */
	public class TimeStore extends FlxBasic {
		
		private var time:int;
		private var debug:Boolean;
		
		public var runTime:String;
		public var gameTime:String;
		public var totalTime:String;
		
		public function TimeStore(Debug:Boolean = false) {
			super();
			time = 0;
			visible = false;
			
			debug = Debug;
			if (debug) {
				runTime = "";
				gameTime = "";
				totalTime = "";
			}
		}
		
		override public function update():void {
			if (time >= 150) {
				saver.saveTime();
				time = 0;
				
				if (debug) {
					runTime = FlxU.formatTicks(0, saver.runtime);
					gameTime = FlxU.formatTicks(0, saver.gametime);
					totalTime = FlxU.formatTicks(0, saver.totaltime);
					FlxG.watch(this, "runTime");
					FlxG.watch(this, "gameTime");
					FlxG.watch(this, "totalTime");
				}
			}
			time++;
		}
	}
}
