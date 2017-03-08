package utils {
	import objs.Hero;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import plugins.Reset;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Registry {
		
		static public const self:Registry = new Registry();
		
		public var player:Hero;
		public var lavaEmitter:FlxEmitter;
		public var cloudEmitter:FlxEmitter;
		public var onHitEmitter:FlxEmitter;
		
		public var resetReq:Boolean;
		public var animatedTilemap:Boolean = false;
		public var lastLevel:Boolean;
		
		public var reset:Reset;
		
		public function initPlugins():void {
			reset = (FlxG.addPlugin(new Reset()) as Reset);
		}
	}
}
