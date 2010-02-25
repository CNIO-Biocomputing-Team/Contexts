package context.tabs
{
	import context.Context;
	import context.Tab;
	
	import mx.controls.DataGrid;
	import mx.controls.ProgressBar;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.ListEvent;
	import mx.rpc.events.ResultEvent;
	
	import services.Ensembl;

	public class BrowseBacterialGenomes extends Tab
	{
		public var genomeList:DataGrid;
		
		public function BrowseBacterialGenomes(parent:Context)
		{
			super();
			parentContext = parent;
		}
		
		public function render():void
		{
			_buildGenomeList();
			_renderGenomeList();
		}
		
		private function _buildGenomeList():void
		{
			var columns:Array = [];
			
			var col1:DataGridColumn = new DataGridColumn("col1");
			col1.headerText = "Genome";
			var col2:DataGridColumn = new DataGridColumn("col2");
			col2.headerText = "Description";
			var col3:DataGridColumn = new DataGridColumn("col3");
			col3.headerText = "Created";
			
			columns.push(col1);
			columns.push(col2);	
			columns.push(col3);	
			
			genomeList = new DataGrid();
			genomeList.y = 0;
			genomeList.x = 0;
			genomeList.width = 795;
			genomeList.height = 250;
			genomeList.columns = columns;
			
			parentContext.listBox.addChild(genomeList);
		}
		
		public function _renderGenomeList():void{

				var pb:ProgressBar = startLoading("Waiting for response from ensembl.org ...");
				var ensemblServ:Ensembl = new Ensembl(parentContext);
				var data:Array = new Array();
				ensemblServ.getBacterialGenomes(function(e:ResultEvent):void{
					if (e.result){
						for each (var source:Object in e.result.SOURCES.SOURCE){
							var tmp:Object = new Object();
							var title:String = source.title;
							var patern:RegExp = new RegExp(".reference");
							tmp.col1 = title.replace(patern,"");
							tmp.col2 = source.description;
							tmp.col3 = source.VERSION.created;
							data.push(tmp);
						}
						genomeList.addEventListener(ListEvent.ITEM_CLICK,function(e:ListEvent):void{
							 parentContext.genomeEnsemblId = e.itemRenderer.data.col1; 
						});
						genomeList.dataProvider = data;
					}
				});
			
		}
	}
}