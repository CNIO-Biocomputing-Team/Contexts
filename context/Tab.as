package context
{
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import mx.containers.Canvas;
	import mx.containers.VBox;
	import mx.controls.DataGrid;
	import mx.controls.ProgressBar;
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.utils.XMLUtil;
	
	public class Tab
	{

		public var container:Canvas;
		public var lastY:int;
		public  var parentContext:Context;

		public function Tab()
		{
			container 		= new Canvas();
			lastY 			= -20;
		}
		
		public function str_replace(haystack:String, needle:String, replacement:String):String {
			var temp:Array = haystack.split(needle);
			return temp.join(replacement);
		}
		
		public function buildHelp(text:String):VBox
		{
			var helpContainer:VBox = new VBox;
			helpContainer.verticalScrollPolicy = "auto";
			helpContainer.width = 930;
			helpContainer.height = 45;
			helpContainer.styleName = "help";
			
			var helpText:Text = new Text;
			helpText.width = 870;
			helpText.htmlText = text;
			helpText.styleName = "helpText";
			helpContainer.addChild(helpText);	
			
			return helpContainer;
		}
		
		public function startLoading(text:String = ""):ProgressBar
		{
			var progress:ProgressBar = new ProgressBar;
			progress.id = 'pb';
			progress.indeterminate = true;
			progress.x = 10;
			progress.y = 10;
			if (text)
				progress.label = text;
			return progress;
		}
		
		public function addInfo(text:String,x:int,y:int):Text
		{
			var info:Text = new Text;
			info.htmlText = text;
			info.x = x;
			info.y = y;
			return info;
		}
		

	}
}