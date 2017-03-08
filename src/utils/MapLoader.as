package utils {
	
	import objs.Basic;
	import objs.Bat;
	import objs.Button;
	import objs.Cage;
	import objs.Gold;
	import objs.He;
	import objs.Help;
	import objs.helpers.Instructions;
	import objs.MyEvent;
	import objs.helpers.Exit;
	import objs.helpers.KillerFloor;
	import objs.helpers.Ladder;
	import objs.helpers.LavaEmitter;
	import objs.helpers.Turn;
	import objs.Hero;
	import objs.Platform;
	import objs.RedSnake;
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
		
		public var editorTilemap:String;
		public var editorObjects:String;
		
		[Embed(source = "../../assets/maps/ch0-intro-map.txt", mimeType = "application/octet-stream")]		private var _level_intro_map:Class;
		[Embed(source = "../../assets/maps/ch0-intro-obj.txt", mimeType = "application/octet-stream")]		private var _level_intro_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg00-map.txt", mimeType = "application/octet-stream")]		private var _level_0_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg00-obj.txt", mimeType = "application/octet-stream")]		private var _level_0_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg01-map.txt", mimeType = "application/octet-stream")]		private var _level_1_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg01-obj.txt", mimeType = "application/octet-stream")]		private var _level_1_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg02-map.txt", mimeType = "application/octet-stream")]		private var _level_2_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg02-obj.txt", mimeType = "application/octet-stream")]		private var _level_2_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg03-map.txt", mimeType = "application/octet-stream")]		private var _level_3_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg03-obj.txt", mimeType = "application/octet-stream")]		private var _level_3_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg04-map.txt", mimeType = "application/octet-stream")]		private var _level_4_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg04-obj.txt", mimeType = "application/octet-stream")]		private var _level_4_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg05-map.txt", mimeType = "application/octet-stream")]		private var _level_5_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg05-obj.txt", mimeType = "application/octet-stream")]		private var _level_5_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg06-map.txt", mimeType = "application/octet-stream")]		private var _level_6_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg06-obj.txt", mimeType = "application/octet-stream")]		private var _level_6_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg07-map.txt", mimeType = "application/octet-stream")]		private var _level_7_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg07-obj.txt", mimeType = "application/octet-stream")]		private var _level_7_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg08-map.txt", mimeType = "application/octet-stream")]		private var _level_8_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg08-obj.txt", mimeType = "application/octet-stream")]		private var _level_8_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg09-map.txt", mimeType = "application/octet-stream")]		private var _level_9_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg09-obj.txt", mimeType = "application/octet-stream")]		private var _level_9_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg10-map.txt", mimeType = "application/octet-stream")]		private var _level_10_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg10-obj.txt", mimeType = "application/octet-stream")]		private var _level_10_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg11-map.txt", mimeType = "application/octet-stream")]		private var _level_11_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg11-obj.txt", mimeType = "application/octet-stream")]		private var _level_11_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg12-map.txt", mimeType = "application/octet-stream")]		private var _level_12_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg12-obj.txt", mimeType = "application/octet-stream")]		private var _level_12_obj:Class;
			[Embed(source = "../../assets/maps/ch0-stg13-map.txt", mimeType = "application/octet-stream")]		private var _level_13_map:Class;
			[Embed(source = "../../assets/maps/ch0-stg13-obj.txt", mimeType = "application/octet-stream")]		private var _level_13_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg14-map.txt", mimeType = "application/octet-stream")]		private var _level_14_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg14-obj.txt", mimeType = "application/octet-stream")]		private var _level_14_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg15-map.txt", mimeType = "application/octet-stream")]		private var _level_15_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg15-obj.txt", mimeType = "application/octet-stream")]		private var _level_15_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg16-map.txt", mimeType = "application/octet-stream")]		private var _level_16_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg16-obj.txt", mimeType = "application/octet-stream")]		private var _level_16_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg17-map.txt", mimeType = "application/octet-stream")]		private var _level_17_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg17-obj.txt", mimeType = "application/octet-stream")]		private var _level_17_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg18-map.txt", mimeType = "application/octet-stream")]		private var _level_18_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg18-obj.txt", mimeType = "application/octet-stream")]		private var _level_18_obj:Class;
			[Embed(source = "../../assets/maps/ch0-stg19-map.txt", mimeType = "application/octet-stream")]		private var _level_19_map:Class;
			[Embed(source = "../../assets/maps/ch0-stg19-obj.txt", mimeType = "application/octet-stream")]		private var _level_19_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg20-map.txt", mimeType = "application/octet-stream")]		private var _level_20_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg20-obj.txt", mimeType = "application/octet-stream")]		private var _level_20_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg21-map.txt", mimeType = "application/octet-stream")]		private var _level_21_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg21-obj.txt", mimeType = "application/octet-stream")]		private var _level_21_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg22-map.txt", mimeType = "application/octet-stream")]		private var _level_22_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg22-obj.txt", mimeType = "application/octet-stream")]		private var _level_22_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg23-map.txt", mimeType = "application/octet-stream")]		private var _level_23_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg23-obj.txt", mimeType = "application/octet-stream")]		private var _level_23_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg24-map.txt", mimeType = "application/octet-stream")]		private var _level_24_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg24-obj.txt", mimeType = "application/octet-stream")]		private var _level_24_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg25-map.txt", mimeType = "application/octet-stream")]		private var _level_25_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg25-obj.txt", mimeType = "application/octet-stream")]		private var _level_25_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg26-map.txt", mimeType = "application/octet-stream")]		private var _level_26_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg26-obj.txt", mimeType = "application/octet-stream")]		private var _level_26_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg27-map.txt", mimeType = "application/octet-stream")]		private var _level_27_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg27-obj.txt", mimeType = "application/octet-stream")]		private var _level_27_obj:Class;
			[Embed(source = "../../assets/maps/ch0-stg28-map.txt", mimeType = "application/octet-stream")]		private var _level_28_map:Class;
			[Embed(source = "../../assets/maps/ch0-stg28-obj.txt", mimeType = "application/octet-stream")]		private var _level_28_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg29-map.txt", mimeType = "application/octet-stream")]		private var _level_29_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg29-obj.txt", mimeType = "application/octet-stream")]		private var _level_29_obj:Class;
			[Embed(source = "../../assets/maps/ch0-stg30-map.txt", mimeType = "application/octet-stream")]		private var _level_30_map:Class;
			[Embed(source = "../../assets/maps/ch0-stg30-obj.txt", mimeType = "application/octet-stream")]		private var _level_30_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg31-map.txt", mimeType = "application/octet-stream")]		private var _level_31_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg31-obj.txt", mimeType = "application/octet-stream")]		private var _level_31_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg32-map.txt", mimeType = "application/octet-stream")]		private var _level_32_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg32-obj.txt", mimeType = "application/octet-stream")]		private var _level_32_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg33-map.txt", mimeType = "application/octet-stream")]		private var _level_33_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg33-obj.txt", mimeType = "application/octet-stream")]		private var _level_33_obj:Class;
		[Embed(source = "../../assets/maps/ch0-stg34-map.txt", mimeType = "application/octet-stream")]		private var _level_34_map:Class;
		[Embed(source = "../../assets/maps/ch0-stg34-obj.txt", mimeType = "application/octet-stream")]		private var _level_34_obj:Class;
			[Embed(source = "../../assets/maps/ch0-stg35-map.txt", mimeType = "application/octet-stream")]		private var _level_35_map:Class;
			[Embed(source = "../../assets/maps/ch0-stg35-obj.txt", mimeType = "application/octet-stream")]		private var _level_35_obj:Class;
		
		public function loadMap(level:int, map:FlxTilemap):void {
			var tilemap:String = null;
			var objs_str:String;
			var _objs:Array;
			var i:int;
			var j:int;
			var arr:Array;
			var arr2:Array;
			var item:uint;
			
			Registry.self.lastLevel = false;
			var str:String = null;
			
			if (level == -1)
				str = "intro";
			else if (level == -10) {
				tilemap = editorTilemap;
				objs_str = editorObjects;
			}
			else
				str = level.toString();
			
			if (str != null || tilemap == null)
				try {
					var asdfgh:String = "_level_"+str+"_map";
					tilemap = new (this[asdfgh]);
					asdfgh = "_level_"+str+"_obj";
					objs_str = new (this[asdfgh]);
				}
				catch (e:Error) {
					FlxG.log("Stage not found!");
					tilemap = new _level_0_map;
					objs_str = new _level_0_obj;
				}
			
			map.loadMap(tilemap, gfx.tilemap, 16, 16, FlxTilemap.OFF, 0, 0, 47);
			
			new Ladder;
			new KillerFloor;
			// horizontal stairs
			arr = map.getTileInstances(9);
			if (arr) {
				arr = arr.sort(Array.DESCENDING, Array.NUMERIC);
				arr = arr.reverse();
			}
			for each (item in arr) {
				i = 0;
				var tmpTile:uint = map.getTileByIndex(item + i +1);
				while (i < 18 && tmpTile == 10) {
					tmpTile = map.getTileByIndex(item + i + 1);
					i++;
				}
				if (tmpTile != 11)
					i--;
				
				(FlxG.state.recycle(Ladder) as Ladder).recycle(item % 20, item/20, i + 1, 1);
			}
			// vertical stairs
			arr = [];
			arr2 = map.getTileInstances(4);
			if (arr2)
				arr = arr.concat(arr2);
			arr2 = map.getTileInstances(18);
			if (arr2)
				arr = arr.concat(arr2);
			arr2 = map.getTileInstances(26);
			if (arr2)
				arr = arr.concat(arr2);
			arr2 = map.getTileInstances(32);
			if (arr2)
				arr = arr.concat(arr2);
			arr2 = null;
			j = 0;
			while (j < arr.length) {
				item = arr[j++];
				i = 1;
				// check if it's stair tile on exit
				var __tile:uint = map.getTileByIndex(item + 20 * i);
				while (__tile == 4 || __tile == 18 || __tile == 26 || __tile == 32) {
					arr.splice(arr.indexOf(item + 20 * i), 1);
					i++;
					__tile = map.getTileByIndex(item + 20 * i);
				}
				(FlxG.state.recycle(Ladder) as Ladder).recycle(item % 20, item / 20, 1, i);
			}
			// lava + spikes
			Registry.self.animatedTilemap = false;
			arr = [];
			arr2 = map.getTileInstances(0);
			if (arr2) {
				Registry.self.animatedTilemap = true;
				arr = arr.concat(arr2);
			}
			arr2 = map.getTileInstances(1);
			if (arr2) {
				Registry.self.animatedTilemap = true;
				arr = arr.concat(arr2);
			}
			arr2 = map.getTileInstances(2);
			if (arr2) {
				Registry.self.animatedTilemap = true;
				arr = arr.concat(arr2);
			}
			arr2 = map.getTileInstances(3);
			if (arr2)
				arr = arr.concat(arr2);
			arr2 = null;
			arr = arr.sort(Array.DESCENDING, Array.NUMERIC);
			arr = arr.reverse();
			j = 0;
			while (j < arr.length) {
				// working here!
				item = arr[j++];
				i = 1;
				while (true) {
					var item2:uint = map.getTileByIndex(item + i);
					if (item2 != 0 && item2 != 1 && item2 != 2 && item2 != 3 && arr.indexOf(item+i >= 0))
						break;
					arr.splice(arr.indexOf(item+i), 1);
					i++;
				}
				(FlxG.state.recycle(KillerFloor) as KillerFloor).recycle(item % 20, item / 20, i, 1);
			}
			map.setDirty(true);
			
			// fuck flex!
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
			new MyEvent;
			new LavaEmitter;
			new Turn;
			
			_objs = objs_str.split("\n");
			i = -1;
			while (++i < _objs.length) {
				if ((_objs[i] as String).length <= 1)
					continue;
				
				arr = (_objs[i] as String).split(",");
				
				if ((arr[0] as String).substr(0, 13) == "objs.helpers.") {
					var fobj:FlxObject;
					fobj = FlxG.state.recycle(FlxU.getClass(arr[0])) as FlxObject;
					
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
						var b:Basic = FlxG.state.recycle(FlxU.getClass(arr[0])) as Basic;
						b.recycle(arr.length, arr);
					}
				}
				else {
					var bas:Basic = FlxG.state.recycle(Basic) as Basic;
					bas.recycle(arr.length, arr);
				}
			}
			
			if (level >= 0 && level < 3) {
				var inst:Instructions = FlxG.state.recycle(Instructions) as Instructions;
				inst.wakeup(level);
			}
			
			if (level < 0) { }
			else if (checkTreasure(level))
				sfx.playTreasureSong();
			else if (level < 4)
				sfx.playIntroSong();
			else if (level < 11)
				sfx.playBeginSong();
			else if (level < 21)
				sfx.playHarderSong();
			/** 
			else if (level != 27 && level != 29 && level < 33)
				sfx.playBossSong();
			/**/
			else
				sfx.playLaterSong();
			sfx.level_start();
		}
		
		private function checkTreasure(level:int ):Boolean {
			switch (level) {
				case 13:
				case 19:
				case 28:
				case 30:
				case 35: return true; break;
			}
			return false;
		}
	}
}
