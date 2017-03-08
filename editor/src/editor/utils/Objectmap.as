package editor.utils {
	import editor.windows.PaletteWindow;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Objectmap extends Tilemap {
		
		public function Objectmap(WidthInTiles:int, HeightInTiles:int) {
			super(WidthInTiles, HeightInTiles, 0);
		}
		
		override public function redraw():void {
			var tmp:PaletteWindow = Registry.curPalette;
			Registry.curPalette = Registry.objectWindow;
			super.redraw();
			Registry.curPalette = tmp;
		}
		
		override public function editCSV(arr:Array, X:int, Y:int, Width:int, Height:int, WidthInTiles:int):void {
			var i:int;
			var j:int;
			var max:int = _widthInTiles * _heightInTiles;
			
			i = 0;
			while (i < Width) {
				j = 0;
				while (j < Height) {
					var pos:int = (X + i) + (Y + j) * _widthInTiles;
					var prev:uint = _data[pos];
					if (pos < max) {
						var val:int = arr[i + j * WidthInTiles];
						if (val != prev) {
							Registry.objectListWindow.removeObject(___name(prev), X + i, Y + j);
							if (val != 0)
								Registry.objectListWindow.addObject(___name(val), X + i, Y + j);
						}
					}
					j++;
				}
				i++;
			}
			
			super.editCSV(arr, X, Y, Width, Height, WidthInTiles);
		}
		
		private function ___name(i:int):String {
			switch(i) {
				case 1: return "objs.Hero"; break;
				case 2: return "objs.She"; break;
				case 3: return "objs.He"; break;
				case 4: return "objs.helpers.Exit"; break;
				case 5: return "objs.Snake"; break;
				case 6: return "objs.Bat"; break;
				case 7: return "objs.helpers.Turn"; break;
				case 8: return "objs.Button"; break;
				case 9: return "objs.Platform"; break;
				case 10: return "objs.helpers.LavaEmitter"; break;
				case 11: return "objs.Help"; break;
				case 12: return "objs.Cage"; break;
				case 13: return "objs.Spark"; break;
				case 14: return "objs.MyEvent"; break;
				case 15: return "objs.Gold"; break;
				case 16: return "objs.RedSnake"; break;
			}
			return "";
		}
		
		override public function get data():String {
			var str:String = super.data;
			
			str += ",\""+Registry.objectListWindow.data+"\"";
			
			return str;
		}
		override public function setData(val:Array):void {
			var objs:Array = [];
			var str:String;
			
			str = val.pop();
			objs = str.split(",");
			
			super.setData(val);
			Registry.objectListWindow.setData(objs);
		}
	}
}
