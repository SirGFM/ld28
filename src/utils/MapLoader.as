package utils {
	
	import objs.Basic;
	import objs.Bat;
	import objs.Button;
	import objs.Cage;
	import objs.He;
	import objs.Help;
	import objs.helpers.Exit;
	import objs.helpers.LavaEmitter;
	import objs.helpers.Turn;
	import objs.Hero;
	import objs.Platform;
	import objs.She;
	import objs.Snake;
	import org.flixel.FlxObject;
	import org.flixel.system.FlxTile;
	
	import org.flixel.FlxG;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class MapLoader {
		
		static private var sfx:SFX = SFX.self;
		static private var gfx:GFX = GFX.self;
		static public const self:MapLoader = new MapLoader();
		
		[Embed(source = "../../assets/maps/level-0_map.txt", mimeType = "application/octet-stream")]		private var _level_0_map:Class;
		[Embed(source = "../../assets/maps/level-0_obj.txt", mimeType = "application/octet-stream")]		private var _level_0_obj:Class;
		[Embed(source = "../../assets/maps/level-1_map.txt", mimeType = "application/octet-stream")]		private var _level_1_map:Class;
		[Embed(source = "../../assets/maps/level-1_obj.txt", mimeType = "application/octet-stream")]		private var _level_1_obj:Class;
		[Embed(source = "../../assets/maps/level-2_map.txt", mimeType = "application/octet-stream")]		private var _level_2_map:Class;
		[Embed(source = "../../assets/maps/level-2_obj.txt", mimeType = "application/octet-stream")]		private var _level_2_obj:Class;
		[Embed(source = "../../assets/maps/level-3_map.txt", mimeType = "application/octet-stream")]		private var _level_3_map:Class;
		[Embed(source = "../../assets/maps/level-3_obj.txt", mimeType = "application/octet-stream")]		private var _level_3_obj:Class;
		[Embed(source = "../../assets/maps/level-4_map.txt", mimeType = "application/octet-stream")]		private var _level_4_map:Class;
		[Embed(source = "../../assets/maps/level-4_obj.txt", mimeType = "application/octet-stream")]		private var _level_4_obj:Class;
		[Embed(source = "../../assets/maps/level-5_map.txt", mimeType = "application/octet-stream")]		private var _level_5_map:Class;
		[Embed(source = "../../assets/maps/level-5_obj.txt", mimeType = "application/octet-stream")]		private var _level_5_obj:Class;
		[Embed(source = "../../assets/maps/level-6_map.txt", mimeType = "application/octet-stream")]		private var _level_6_map:Class;
		[Embed(source = "../../assets/maps/level-6_obj.txt", mimeType = "application/octet-stream")]		private var _level_6_obj:Class;
		[Embed(source = "../../assets/maps/level-7_map.txt", mimeType = "application/octet-stream")]		private var _level_7_map:Class;
		[Embed(source = "../../assets/maps/level-7_obj.txt", mimeType = "application/octet-stream")]		private var _level_7_obj:Class;
		[Embed(source = "../../assets/maps/level-8_map.txt", mimeType = "application/octet-stream")]		private var _level_8_map:Class;
		[Embed(source = "../../assets/maps/level-8_obj.txt", mimeType = "application/octet-stream")]		private var _level_8_obj:Class;
		[Embed(source = "../../assets/maps/level-9_map.txt", mimeType = "application/octet-stream")]		private var _level_9_map:Class;
		[Embed(source = "../../assets/maps/level-9_obj.txt", mimeType = "application/octet-stream")]		private var _level_9_obj:Class;
		[Embed(source = "../../assets/maps/level-10_map.txt", mimeType = "application/octet-stream")]		private var _level_10_map:Class;
		[Embed(source = "../../assets/maps/level-10_obj.txt", mimeType = "application/octet-stream")]		private var _level_10_obj:Class;
		[Embed(source = "../../assets/maps/level-11_map.txt", mimeType = "application/octet-stream")]		private var _level_11_map:Class;
		[Embed(source = "../../assets/maps/level-11_obj.txt", mimeType = "application/octet-stream")]		private var _level_11_obj:Class;
		[Embed(source = "../../assets/maps/level-12_map.txt", mimeType = "application/octet-stream")]		private var _level_12_map:Class;
		[Embed(source = "../../assets/maps/level-12_obj.txt", mimeType = "application/octet-stream")]		private var _level_12_obj:Class;
		//[Embed(source = "../../assets/maps/level-13_map.txt", mimeType = "application/octet-stream")]		private var _level_13_map:Class;
		//[Embed(source = "../../assets/maps/level-13_obj.txt", mimeType = "application/octet-stream")]		private var _level_13_obj:Class;
		//[Embed(source = "../../assets/maps/level-14_map.txt", mimeType = "application/octet-stream")]		private var _level_14_map:Class;
		//[Embed(source = "../../assets/maps/level-14_obj.txt", mimeType = "application/octet-stream")]		private var _level_14_obj:Class;
		//[Embed(source = "../../assets/maps/level-15_map.txt", mimeType = "application/octet-stream")]		private var _level_15_map:Class;
		//[Embed(source = "../../assets/maps/level-15_obj.txt", mimeType = "application/octet-stream")]		private var _level_15_obj:Class;
		[Embed(source = "../../assets/maps/level-final_map.txt", mimeType = "application/octet-stream")]		private var _last_map:Class;
		[Embed(source = "../../assets/maps/level-final_obj.txt", mimeType = "application/octet-stream")]		private var _last_obj:Class;
		[Embed(source = "../../assets/maps/level-intro_map.txt", mimeType = "application/octet-stream")]		private var _intro_map:Class;
		[Embed(source = "../../assets/maps/level-intro_obj.txt", mimeType = "application/octet-stream")]		private var _intro_obj:Class;
		
		public function loadMap(level:int, map:FlxTilemap):void {
			var tilemap:String;
			var objs_str:String;
			var _objs:Array;
			var i:int;
			
			Registry.self.lastLevel = false;
			try {
				if (level == -1) {
					tilemap = new _last_map;
					objs_str = new _last_obj;
					Registry.self.lastLevel = true;
				}
				if (level == -2) {
					tilemap = new _intro_map;
					objs_str = new _intro_obj;
				}
				else {
					tilemap = new (this["_level_"+level.toString()+"_map"]);
					objs_str = new (this["_level_" + level.toString() + "_obj"]);
				}
			}
			catch (e:Error) {
				FlxG.log("Stage not found!");
				tilemap = new _last_map;
				objs_str = new _last_obj;
				Registry.self.lastLevel = true;
			}
			
			map.loadMap(tilemap, gfx.tilemap, 16, 16, FlxTilemap.OFF, 0, 24, 56);
			map.setTileProperties(28, 0, onLadder, Hero, 1);
			map.setTileProperties(33, 0, onLadder, Hero, 3);
			map.setTileProperties(24, 0, onSpike, Hero, 4);
			map.setDirty(true);
			
			// fuck flex!
			new Bat;
			new Button;
			new Cage;
			new He;
			new Help;
			new Hero;
			new Platform;
			new She;
			new Snake;
			
			new Exit;
			new LavaEmitter;
			new Turn;
			
			_objs = objs_str.split("\n");
			i = -1;
			while (++i < _objs.length) {
				if ((_objs[i] as String).length < 1)
					continue;
				
				var arr:Array = (_objs[i] as String).split(",");
				
				if ((arr[0] as String).substr(0, 13) == "objs.helpers.") {
					var fobj:FlxObject;
					fobj = FlxG.state.recycle(FlxU.getClass(arr[0])) as FlxObject;
					fobj.reset(16 * int(arr[1]), 16 * int(arr[2]));
					if (fobj is Turn) {
						if ((arr[3] as String).substr(0, 5) == "right")
							(fobj as Turn).direction = FlxObject.RIGHT;
						else if ((arr[3] as String).substr(0, 4) == "left")
							(fobj as Turn).direction = FlxObject.LEFT;
					}
					else if (fobj is Exit) {
						(fobj as Exit).init(16*int(arr[3]), 16*int(arr[4]), arr[5]);
					}
				}
				else if ((arr[0] as String).substr(0, 5) == "objs.") {
					var b:Basic = FlxG.state.recycle(FlxU.getClass(arr[0])) as Basic;
					b.recycle(arr.length, arr);
				}
			}
			
			if (level < 6)
				sfx.playSongSlow();
			else
				sfx.playSongFast();
			sfx.level_start();
			
			Registry.self.animatedTilemap = (level >= 6 && level <= 12) || Registry.self.lastLevel;
		}
		
		public function onLadder(tile:FlxTile, pl:Hero):Boolean {
			if (tile.index == 28 || tile.index >= 33 && tile.index <= 35) {
				var x:int = tile.width + 16 * (tile.mapIndex % 20);
				var tmp:int = pl.x - x;
				if (tmp > -25)
					pl.overLadder = true;
			}
			return false;
		}
		public function onSpike(tile:FlxTile, pl:Basic):Boolean {
			if (tile.index >= 24 && tile.index <= 27) {
				var x:int = tile.width + 16 * (tile.mapIndex % 20);
				var tmp:int = pl.x - x;
				if (tmp > -22) {
					var y:int = 16 * int(tile.mapIndex / 20) + 8;
					if (pl.y + pl.height >= y)
						pl.fakeKill();
				}
			}
			return false;
		}
	}
}
