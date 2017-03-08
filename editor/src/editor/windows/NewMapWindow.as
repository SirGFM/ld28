package editor.windows {
	
	import com.bit101.components.Label;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	import editor.utils.Registry;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class NewMapWindow extends Window {
		
		private var _nsWidth:NumericStepper;
		private var _nsHeight:NumericStepper;
		
		public function NewMapWindow() {
			var _x:Number;
			var _y:Number;
			var label:Label;
			var ns:NumericStepper;
			var bt:PushButton;
			
			super(null, 0, 0);
			
			title = "Create a new map...";
			hasCloseButton = true;
			
			_x = 10;
			_y = 10;
			label = new Label(this, _x, _y, "Creates a new map with the specified width and height.\nIt'll clear the previous map without prompting!");
			width = label.width + 20;
			
			_y += label.height + 30;
			label = new Label(this, _x, _y, "Width in tiles");
			
			_x = 16;
			_y += label.height + 2;
			ns = new NumericStepper(this, _x, _y, null);
			ns.minimum = 1;
			_nsWidth = ns;
			
			_x = 10;
			_y += ns.height + 10;
			label = new Label(this, _x, _y, "Height in tiles");
			
			_x = 16;
			_y += label.height + 2;
			ns = new NumericStepper(this, _x, _y, null);
			ns.minimum = 1;
			_nsHeight =  ns;
			
			_y += ns.height + 16;
			bt = new PushButton(this, 0, _y, "Create", onCreate);
			bt.x = (width - bt.width) / 2;
			
			height = _y + bt.height + 10 + 20;
			visible = false;
		}
		public function destroy():void {
			_nsWidth = null;
			_nsHeight = null;
			if (numChildren > 0)
				removeChildren();
		}
		
		public function open():void {
			visible = true;
			_nsWidth.value = 20;
			_nsHeight.value = 15;
		}
		override protected function onClose(event:MouseEvent):void {
			super.onClose(event);
			visible = false;
		}
		
		protected function onCreate(event:MouseEvent):void {
			Registry.mapPanel.clear();
			Registry.mapPanel.createMap(_nsWidth.value, _nsHeight.value);
			Registry.mapPanel.gridVisibility = Registry.optionsWindow.isGridVisible;
			Registry.menuBar.onBGLayer(null);
			Registry.optionsWindow.onOpaque(null);
			visible = false;
		}
	}
}
