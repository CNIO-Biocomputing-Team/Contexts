package context.tabs.parts
{
	import context.Context;
	import context.Tab;
	
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.ListEvent;
	import mx.rpc.events.ResultEvent;
		import mx.utils.StringUtil;
	
	import services.PartRegistry;

	public class SaveDesign extends Tab
	{
		public var partsList:DataGrid;
		
		public function SaveDesign(parent:Context)
		{
			super();
			parentContext = parent;
		}
		
		public function render():void
		{
			var columns:Array = [];
			
			var col1:DataGridColumn = new DataGridColumn("col1");
			col1.headerText = "Entity";
			var col2:DataGridColumn = new DataGridColumn("col2");
			col2.headerText = "Sequence";
			
			columns.push(col1);
			columns.push(col2);
			
			partsList = new DataGrid();
			partsList.y = 0;
			partsList.x = 0;
			partsList.width = 795;
			partsList.height = 250;
			partsList.columns = columns;
			
			parentContext.listBox.addChild(partsList);
			var data:Array = new Array();
			for each (var part:Object in parentContext.compositePart){
				var tmp:Object = new Object;
				tmp.col1 = part.partName;
				tmp.col2 = part.sequence;
				data.push(tmp);
				
			}
			partsList.addEventListener(ListEvent.ITEM_CLICK,function(e:ListEvent):void{
				 //parentContext.genomeEnsemblId = e.itemRenderer.data.col1; 
			});
			partsList.dataProvider = data;
		}
		
	}
}