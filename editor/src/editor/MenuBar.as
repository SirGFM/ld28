package editor {
	
	import com.adobe.serialization.json.JSON;
	import com.bit101.components.Label;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import editor.utils.FileHandler;
	import editor.utils.Registry;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class MenuBar extends Panel {
		
		private var __i__:uint = 0;
		private const NEW:uint = __i__++;
		private const SAVE:uint = __i__++;
		private const LOAD:uint = __i__++;
		private const EXPORT:uint = __i__++;
		private const OPTIONS:uint = __i__++;
		private const PALETTE:uint = __i__++;
			private const TOOLS:uint = 0xffff;//__i__++;
		private const ZOOM:uint = __i__++;
		private const LAYER1:uint = __i__++;
		private const LAYER2:uint = __i__++;
		private const TEST:uint = __i__++;
		private const EXIT:uint = __i__++;
		private const LENGTH:uint = __i__++;
		
		private var _buttons:Vector.<PushButton>;
		private var zoom:NumericStepper;
		
		public function MenuBar(X:Number, Y:Number, Width:int, testCallback:Function = null, exitCallback:Function = null) {
			var bt:PushButton;
			super(null, X, Y);
			width = Width;
			
			_buttons = new Vector.<PushButton>();
			var i:int = -1;
			var _x:Number = 5;
			var _y:Number = 5;
			while (++i < LENGTH) {
				switch(i) {
					case NEW: bt = new PushButton(this, _x, _y, "New", onNewBT); break;
					case SAVE: bt = new PushButton(this, _x, _y, "Save", onSaveBT); break;
					case LOAD: bt = new PushButton(this, _x, _y, "Load", onLoadBT); break;
					case EXPORT: bt = new PushButton(this, _x, _y, "Export", onExportBT); break;
					case OPTIONS: bt = new PushButton(this, _x, _y, "Options", onOptionsBT); break;
					case PALETTE: bt = new PushButton(this, _x, _y, "Palette", onPaletteBT); break;
					case TEST: {
						if (testCallback != null) {
							bt = new PushButton(this, _x, _y, "Test", testCallback);
							bt.width -= 20;
						}
						else
							continue;
					} break;
					case EXIT: {
						if (exitCallback != null) {
							bt = new PushButton(this, _x, _y, "Exit", exitCallback);
							bt.width -= 20;
						}
						else
							continue;
					} break;
					case ZOOM: {
						var label:Label = new Label(this, _x, _y, "Zoom:");
						_x += label.width+3;
						var ns:NumericStepper = new NumericStepper(this, _x, _y, onZoom);
						ns.maximum = 4;
						ns.minimum = 1;
						ns.value = 1;
						ns.width *= 0.625;
						_x += ns.width + 3;
						_buttons.push(null);
						zoom = ns;
						continue;
					}break;
					case LAYER1: {
						_x += 16;
						bt = new PushButton(this, _x, _y, "Tiles layer", onBGLayer);
						bt.toggle = true;
						bt.selected = true;
					}break;
					case LAYER2: {
						bt = new PushButton(this, _x, _y, "Objects layer", onMidLayer);
						bt.width *= 1.25;
						bt.toggle = true;
					}break;
				}
				_buttons.push(bt);
				bt.width *= 0.5;
				_x += bt.width + 3;
			}
			height = bt.height + 10;
		}
		public function destroy():void {
			while (_buttons.length > 0)
				_buttons.pop();
			_buttons = null;
			zoom = null;
			if (numChildren > 0)
				removeChildren();
		}
		
		private function onZoom(ev:Event):void {
			//var zoom:NumericStepper = ev.target as NumericStepper;
			var z:int = zoom.value;
			
			if (z < 1)
				zoom.value = 1;
			else if (z > 4)
				zoom.value = 4;
			
			z = zoom.value;
			Registry.zoom = z;
			
			Registry.mapPanel.zoom = z;
			Registry.paletteWindow.zoom = z;
			Registry.objectWindow.zoom = z;
		}
		
		private function onNewBT(ev:MouseEvent):void {
			Registry.newMapWindow.open();
			Registry.newMapWindow.x = _buttons[NEW].x + 5;
			Registry.newMapWindow.y = _buttons[NEW].y + 5;
		}
		
		private function onSaveBT(ev:MouseEvent):void {
			var str:String = "";
			
			if (!Registry.mapPanel.backgroundData)
				return;
			
			str += "{\n";
			str += "  \"widthInTiles\": \""+Registry.mapPanel.widthInTiles+"\",\n";
			str += "  \"heightInTiles\": \""+Registry.mapPanel.heightInTiles+"\",\n";
			str += "  \"background\": [";
			str += Registry.mapPanel.backgroundData;
			str += "],\n";
			str += "  \"objects\": [";
			str += Registry.mapPanel.objectData;
			str += "]\n";
			str += "}";
			
			FileHandler.saveFile(str);
		}
		
		private function onExportBT(ev:MouseEvent):void {
			if (!Registry.mapPanel.backgroundData)
				return;
			
			FileHandler.saveFile(Registry.mapPanel.backgroundExportData, "tilemap.txt", exportObjects);
		}
		private function exportObjects(e:Event = null):void {
			FileHandler.saveFile(Registry.objectListWindow.exportData, "objects.txt");
		}
		
		private function onLoadBT(ev:MouseEvent):void {
			FileHandler.loadFile("Text: (*.txt)", "*.txt", onLoaded);
		}
		private function onLoaded(data:ByteArray):void {
			var arr:Array;
			var str:String = data.toString();
			var json:Object = com.adobe.serialization.json.JSON.decode(str);
			
			Registry.mapPanel.clear();
			Registry.mapPanel.createMap(json.widthInTiles, json.heightInTiles);
			Registry.mapPanel.setBackgroundData(json.background);
			Registry.mapPanel.setObjectData(json.objects);
			Registry.mapPanel.gridVisibility = Registry.optionsWindow.isGridVisible;
			Registry.menuBar.onBGLayer(null);
			Registry.optionsWindow.onOpaque(null);
		}
		
		private function onOptionsBT(ev:MouseEvent):void {
			Registry.optionsWindow.open();
			Registry.optionsWindow.x = _buttons[OPTIONS].x + 5;
			Registry.optionsWindow.y = _buttons[OPTIONS].y + 5;
		}
		
		public function onPaletteBT(ev:MouseEvent):void {
			if (!Registry.curPalette)
				return;
			Registry.curPalette.open();
			Registry.curPalette.x = _buttons[PALETTE].x + 5;
			Registry.curPalette.y = _buttons[PALETTE].y + 5;
			if (Registry.curPalette == Registry.objectWindow) {
				Registry.objectListWindow.x = Registry.objectWindow.x + Registry.objectWindow.width;
				Registry.objectListWindow.y = Registry.objectWindow.y;
				Registry.objectListWindow.visible = true;
			}
		}
		
		private function onObjectsBT(ev:MouseEvent):void {
			trace("objects button");
		}
		
		public function onBGLayer(ev:MouseEvent):void {
			if (!Registry.mapPanel.setCurrentLayer(0)) {
				_buttons[LAYER1].selected = true;
				return;
			}
			_buttons[LAYER1].selected = true;
			_buttons[LAYER2].selected = false;
			if (Registry.curPalette && Registry.curPalette.visible && Registry.curPalette != Registry.paletteWindow) {
				Registry.paletteWindow.x = Registry.objectWindow.x;
				Registry.paletteWindow.y = Registry.objectWindow.y;
				Registry.objectWindow.visible = false;
				Registry.objectListWindow.visible = false;
				Registry.paletteWindow.visible = true;
			}
			Registry.curPalette = Registry.paletteWindow;
		}
		public function onMidLayer(ev:MouseEvent):void {
			if (!Registry.mapPanel.setCurrentLayer(1)) {
				_buttons[LAYER2].selected = false;
				return;
			}
			_buttons[LAYER1].selected = false;
			_buttons[LAYER2].selected = true;
			if (Registry.curPalette.visible && Registry.curPalette != Registry.objectWindow) {
				Registry.objectWindow.x = Registry.paletteWindow.x;
				Registry.objectWindow.y = Registry.paletteWindow.y;
				Registry.paletteWindow.visible = false;
				Registry.objectWindow.visible = true;
				
				Registry.objectListWindow.x = Registry.objectWindow.x + Registry.objectWindow.width;
				Registry.objectListWindow.y = Registry.objectWindow.y;
				Registry.objectListWindow.visible = true;
			}
			Registry.curPalette = Registry.objectWindow;
		}
		
		public function get isBGLayerActive():Boolean {
			return Registry.paletteWindow && Registry.paletteWindow.visible;
		}
		public function get isMidLayerActive():Boolean {
			return Registry.objectWindow && Registry.objectWindow.visible;
		}
	}
}
