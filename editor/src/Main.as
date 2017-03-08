package {
	
	import editor.MainWindow;
	import editor.utils.Registry;
	import editor.utils.ScrollingTilemap;
	import editor.windows.PaletteWindow;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	[SWF(width = "640", height = "480", backgroundColor = "0x000000")]
	[Frame(factoryClass = "Preloader")]
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Main extends Sprite  {
		
		private var mainWindow:MainWindow;
		
		public function Main():void  {
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.addEventListener(Event.RESIZE, onResize);
			mainWindow = new MainWindow(this, 640, 480);
		}
		
		private function onResize(e:Event):void {
			mainWindow.resize(stage.stageWidth, stage.stageHeight);
			/*
			mainWindow.width = stage.stageWidth;
			mainWindow.height = stage.stageHeight;
			
			Registry.menuBar.width = stage.stageWidth;
			
			Registry.mapPanel.width = stage.stageWidth;
			Registry.mapPanel.height = stage.stageHeight - Registry.menuBar.height;
			*/
		}
	}
}
