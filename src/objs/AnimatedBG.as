package objs {
	
	import objs.helpers.Exit;
	import objs.helpers.LavaEmitter;
	import objs.helpers.Turn;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	import utils.GFX;
	import utils.Registry;
	
	/**
	 * ...
	 * @author 
	 */
	public class AnimatedBG extends FlxGroup {
		
		static private const gfx:GFX = GFX.self;
		static private const reg:Registry = Registry.self;
		
		static public const MENU:int = 0;
		static public const MUSICBOX:int = 1;
		static public const OPTIONS:int = 2;
		static public const ACHIEVEMENTS:int = 3;
		
		[Embed(source = "../../assets/bgs/menu-map.txt", mimeType = "application/octet-stream")]		private var menu_map:Class;
		[Embed(source = "../../assets/bgs/menu-obj.txt", mimeType = "application/octet-stream")]		private var menu_obj:Class;
		[Embed(source = "../../assets/bgs/options-map.txt", mimeType = "application/octet-stream")]		private var opts_map:Class;
		[Embed(source = "../../assets/bgs/options-obj.txt", mimeType = "application/octet-stream")]		private var opts_obj:Class;
		[Embed(source = "../../assets/bgs/musicbox-map.txt", mimeType = "application/octet-stream")]		private var mbox_map:Class;
		[Embed(source = "../../assets/bgs/musicbox-obj.txt", mimeType = "application/octet-stream")]		private var mbox_obj:Class;
		[Embed(source = "../../assets/bgs/achievements-map.txt", mimeType = "application/octet-stream")]		private var achi_map:Class;
		[Embed(source = "../../assets/bgs/achievements-obj.txt", mimeType = "application/octet-stream")]		private var achi_obj:Class;
		
		private var map:FlxTilemap;
		private var dummy:Hero;
		
		public function AnimatedBG() {
			super();
			
			map = new FlxTilemap();
			add(map);
			
			dummy = new Hero();
			dummy.x = 10000;
			dummy.y = 10000;
			reg.player = dummy;
		}
		override public function destroy():void {}
		public function doDestroy():void {
			super.destroy();
			map = null;
			dummy.destroy();
			dummy = null;
		}
		
		override public function update():void {
			super.update();
			FlxG.collide(this);
			reg.doParticles();
		}
		
		override public function draw():void {
			super.draw();
			reg.drawParticles();
		}
		
		public function setBG(i:int):void {
			kill();
			
			var tilemap:String;
			var objs_str:String
			switch(i) {
				case MENU: {
					tilemap = new menu_map;
					objs_str = new menu_obj;
				} break;
				case OPTIONS: {
					tilemap = new opts_map;
					objs_str = new opts_obj;
				} break;
				case MUSICBOX: {
					tilemap = new mbox_map;
					objs_str = new mbox_obj;
				} break;
				case ACHIEVEMENTS: {
					tilemap = new achi_map;
					objs_str = new achi_obj;
				} break;
				default:
					return;
			}
			
			revive();
			map.revive();
			loadMap(tilemap, objs_str);
		}
		
		public function loadMap(tilemap:String, objs_str:String):void {
			var i:int;
			
			map.loadMap(tilemap, gfx.tilemap, 16, 16, FlxTilemap.OFF, 0, 0, 42);
			map.setDirty(true);
			
			// fuck flex!
			/*
			new Bat;
			new Button;
			new Cage;
			new Gold;
			new He;
			new Help;
			new Hero;
			new Platform;
			new She;
			new Snake;
			new RedSnake;
			
			new Exit;
			//new MyEvent;
			new LavaEmitter;
			new Turn;
			*/
			
			var _objs:Array = objs_str.split("\n");
			i = -1;
			while (++i < _objs.length) {
				if ((_objs[i] as String).length <= 1)
					continue;
				
				var arr:Array = (_objs[i] as String).split(",");
				
				if ((arr[0] as String).substr(0, 13) == "objs.helpers.") {
					var fobj:FlxObject;new FlxObject
					fobj = recycle(FlxU.getClass(arr[0])) as FlxObject;
					
					fobj.reset(16 * int(arr[1]), 16 * int(arr[2]));
					
					if (fobj is Turn) {
						if ((arr[4] as String).substr(0, 5) == "right")
							(fobj as Turn).direction = FlxObject.RIGHT;
						else if ((arr[4] as String).substr(0, 4) == "left")
							(fobj as Turn).direction = FlxObject.LEFT;
					}
					else if (fobj is Exit) {
						(fobj as Exit).init(arr[4], 16*int(arr[5]), 16*int(arr[6]), arr[7]);
					}
				}
				else if (((arr[0] as String).substr(0, 5) == "objs.")) {
					if ((arr[0] as String).indexOf("Hero") < 0) {
						var b:Basic = recycle(FlxU.getClass(arr[0])) as Basic;
						b.recycle(arr.length, arr);
					}
				}
				else {
					var bas:Basic = recycle(Basic) as Basic;
					bas.recycle(arr.length, arr);
				}
			}
		}
	}
}
