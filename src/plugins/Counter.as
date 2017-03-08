package plugins {
	
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author 
	 */
	public class Counter extends Plugin {
		
		private var sprite:FlxSprite;
		private var cnt:FlxTilemap;
		private var _n:int;
		private var d:int;
		private var u:int;
		private var digs:int;
		
		public function Counter(baseIcon:FlxSprite = null, i:int = 0, Digs:int = 2) {
			super();
			
			digs = Digs;
			var tmp:String = "10,";
			while (Digs > 0) {
				tmp += "0";
				Digs--;
				if (Digs > 0)
					tmp += ",";
			}
			
			sprite = baseIcon;
			sprite.moves = false;
			sprite.scrollFactor.make();
			
			cnt = new FlxTilemap();
			
			setDefaultPosition(i);
			
			cnt.loadMap(tmp, gfx.font_number, 8, 10, FlxTilemap.OFF, 0, 0);
			cnt.scrollFactor.make();
			
			num = 0;
		}
		
		override public function draw():void {
			sprite.postUpdate();
			sprite.draw();
			cnt.draw();
		}
		
		public function setPosition(X:Number, Y:Number):void {
			sprite.x = X;
			sprite.y = Y;
			
			cnt.x = sprite.x+14;
			cnt.y = Y+6;
		}
		public function setDefaultPosition(i:int):void {
			setPosition(22+38*i, 0);
		}
		
		public function get num():int {
			return _n;
		}
		public function set num(val:int):void {
			var i:int = digs;
			var n:int = val;
			while (i > 0) {
				var u:int = n % 10;
				cnt.setTileByIndex(i, u);
				n /= 10;
				i--;
			}
			_n = val;
		}
	}
}
