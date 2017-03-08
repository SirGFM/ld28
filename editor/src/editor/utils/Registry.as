package editor.utils {
	
	import editor.MapPanel;
	import editor.MenuBar;
	import editor.windows.NewMapWindow;
	import editor.windows.ObjectListWindow;
	import editor.windows.ObjectWindow;
	import editor.windows.OptionsWindow;
	import editor.windows.PaletteWindow;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Registry {
		
		static public var menuBar:MenuBar;
		static public var mapPanel:MapPanel;
		
		static public var curPalette:PaletteWindow;
		static public var paletteWindow:PaletteWindow;
		static public var objectWindow:ObjectWindow;
		static public var objectListWindow:ObjectListWindow;
		
		static public var newMapWindow:NewMapWindow;
		static public var optionsWindow:OptionsWindow;
		
		static public var zoom:int = 1;
		
		static public function destroy():void {
			menuBar.destroy();
			menuBar = null;
			mapPanel.destroy();
			mapPanel = null;
			
			if (curPalette)
				curPalette.destroy();
			curPalette = null;
			if (paletteWindow)
				paletteWindow.destroy();
			paletteWindow = null;
			if (objectWindow)
				objectWindow.destroy();
			objectWindow = null;
			if (objectListWindow)
				objectListWindow.destroy();
			objectListWindow = null;
			
			if (newMapWindow)
				newMapWindow.destroy();
			newMapWindow = null;
			if (optionsWindow)
				optionsWindow.destroy();
			optionsWindow = null;
		}
	}
}
