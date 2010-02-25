package context.components.parts.list
{
	import context.Context;
	
	import mx.containers.Canvas;
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;

	public class PartListClass extends Canvas
	{
		public var parentContext:Context;
		public var partListGrid:DataGrid;
		
		public function PartListClass()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandler);
		}
		
		private function creationCompleteHandler(event:FlexEvent):void
		{
			partListGrid.addEventListener(ListEvent.ITEM_CLICK,function(e:ListEvent):void{
							 parentContext.partId = e.itemRenderer.data.partId;
							 parentContext.updateProteinMenu(false);
							 parentContext.updatePathwaysMenu(false);
							 parentContext.updateSyntheticPartsMenu(true);
							 parentContext.writeTip("Select an option from the SYNTHETIC BIOLOGY/PARTS menu");
			});
		}
		
		public function render(parts:Array):void
		{
			var data:Array = new Array();
			
			if (parts.length){
				parentContext.writeTip("Click the part name to get more information about the part.<br>Use the SEARCH HISTORY panel on the left bar to browse your previous queries.");
				parentContext.listBox.removeAllChildren();
				parentContext.listBox.addChild(this);
				for each (var p:String in parts){
					var tmp:Object = new Object();
					tmp.partId = p;
					data.push(tmp);
				}
				partListGrid.dataProvider = data;
				parentContext.loadingLabel.visible = false;
			}	
		}
		
	}
}