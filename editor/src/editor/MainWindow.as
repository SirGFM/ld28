package editor {
	
	import com.bit101.components.Panel;
	import com.bit101.components.Style;
	import editor.utils.DrawRectangle;
	import editor.utils.Registry;
	import editor.windows.NewMapWindow;
	import editor.windows.ObjectListWindow;
	import editor.windows.ObjectWindow;
	import editor.windows.OptionsWindow;
	import editor.windows.PaletteWindow;
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class MainWindow extends Panel {
		
		public function MainWindow(parent:DisplayObjectContainer, Width:Number, Height:Number, testCallback:Function = null, exitCallback:Function = null) {
			Style.setStyle(Style.DARK);
			super(parent);
			width = Width;
			height = Height;
			
			Registry.menuBar = new MenuBar(0, 0, this.width, testCallback, exitCallback);
			Registry.mapPanel = new MapPanel(0, Registry.menuBar.height, this.width, Height - Registry.menuBar.height);
			
			Registry.newMapWindow = new NewMapWindow();
			Registry.paletteWindow = new PaletteWindow();
			Registry.objectWindow = new ObjectWindow();
			Registry.objectListWindow = new ObjectListWindow();
			Registry.optionsWindow = new OptionsWindow();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			addChild(Registry.menuBar);
			addChild(Registry.mapPanel);
			addChild(Registry.paletteWindow);
			addChild(Registry.objectWindow);
			addChild(Registry.objectListWindow);
			addChild(Registry.newMapWindow);
			addChild(Registry.optionsWindow);
		}
		
		public function destroy():void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			Registry.destroy();
			if (numChildren > 0)
				removeChildren();
		}
		
		public function resize(Width:int, Height:int):void {
			width = Width;
			height = Height;
			
			Registry.menuBar.width = Width;
			
			Registry.mapPanel.width = Width;
			Registry.mapPanel.height = Height - Registry.menuBar.height;
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			var __x:int;
			var __y:int;
			var kc:uint = e.keyCode;
			var pal:PaletteWindow = Registry.curPalette;
			var menu:MenuBar = Registry.menuBar;
			
			if (kc == Keyboard.NUMBER_1) {
				if (menu.isMidLayerActive)
					menu.onBGLayer(null);
			}
			else if (kc == Keyboard.NUMBER_2) {
				if (menu.isBGLayerActive)
					menu.onMidLayer(null);
			}
			else if (kc == Keyboard.SPACE)
				menu.onPaletteBT(null);
			else if (pal && pal.visible) {
				if (kc == Keyboard.A)
					__x = -1;
				else if (kc == Keyboard.D)
					__x = 1;
				if (kc == Keyboard.W)
					__y = -1;
				else if (kc == Keyboard.S)
					__y = 1;
				
				pal.moveSelection(__x, __y);
			}
		}
		
		public function get tilemap():String {
			if (!Registry.mapPanel)
				return null;
			return Registry.mapPanel.backgroundExportData;
		}
		public function get objects():String {
			return Registry.objectListWindow.exportData;
		}
	}
}
