package editor.utils {
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class FileHandler {
		
		static private var _saveFile:FileReference;
		static private var _loadFile:FileReference;
		static private var _callback:Function;
		static private var _useLoader:Boolean;
		static private var _onComplete:Function;
		
		static public function saveFile(data:String, name:String = "save.txt", onComplete:Function = null):void {
			_onComplete = onComplete;
			
			var file:FileReference = new FileReference();
			
			if (onComplete != null) {
				file.addEventListener(Event.COMPLETE, onSaveComplete);
				_saveFile = file;
			}
			
			file.save(data, name);
		}
		static private function onSaveComplete(e:Event):void {
			_saveFile.removeEventListener(Event.COMPLETE, onSaveComplete);
			_saveFile = null;
			_onComplete();
		}
		
		static public function loadFile(typesLabel:String = "Images: (*.bmp, *.jpeg, *.jpg, *.png)", types:String = "*.bmp; *.jpeg; *.jpg; *.png", callback:Function = null, useLoader:Boolean = false):void {
			_callback = callback;
			_useLoader = useLoader;
			
			_loadFile = new FileReference();
			_loadFile.addEventListener(Event.SELECT, onFileSelected);
			var fileFilter:FileFilter = new FileFilter(typesLabel, types);
			_loadFile.browse([fileFilter]);
		}
		
		static private function onFileSelected(ev:Event):void {
			_loadFile.removeEventListener(Event.SELECT, onFileSelected);
			_loadFile.addEventListener(Event.COMPLETE, onFileLoaded);
			_loadFile.load();
		}
		
		static private function onFileLoaded(ev:Event):void {
			_loadFile.removeEventListener(Event.COMPLETE, onFileLoaded);
			
			if (_useLoader) {
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderLoaded);
				
				loader.loadBytes(_loadFile.data);
			}
			else if (_callback != null) {
				_callback(_loadFile.data);
				_loadFile = null;
				_callback = null;
			}
		}
		
		static private function onLoaderLoaded(ev:Event):void {
			var loaderInfo:LoaderInfo = (ev.target as LoaderInfo);
			
			loaderInfo.removeEventListener(Event.COMPLETE, onLoaderLoaded);
			
			if (_callback != null)
				_callback(ev.target.content);
			
			_loadFile = null;
			_callback = null;
		}
		/*
		
		private function loadImageComplete(event:Event):void {
			var loaderInfo:LoaderInfo = (event.target as LoaderInfo);
			
			loaderInfo.removeEventListener(Event.COMPLETE, loadImageComplete);
			
			var bmp:BitmapData = event.target.content.bitmapData;
			
			if (bmp == null) {
				Main.newWindow.call("Error loading the tileset!");
				return;
			}
			
			if (_tileWidth.value == 0 || _tileHeight.value == 0){
				_tileWidth.value = bmp.height;
				_tileHeight.value = bmp.height;
			}
			
			_bmp = bmp;
			Main.mainPanel.tileWidth = _tileWidth.value;
			Main.mainPanel.tileHeight = _tileHeight.value;
			
			Main.mainPanel.clear();
			Main.palettePanel.clear();
			Main.objectPanel.clear(true, Main.mainPanel.tileWidth, Main.mainPanel.tileHeight);
			
			Main.palettePanel.loadPalette(bmp, _tileWidth.value, _tileHeight.value);
			Main.objectPanel.clear(false, _tileWidth.value, _tileHeight.value);
		}
		*/
	}
}
