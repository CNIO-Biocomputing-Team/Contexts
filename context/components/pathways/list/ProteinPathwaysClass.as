package context.components.pathways.list
{
	import context.Context;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.controls.Text;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.rpc.events.ResultEvent;
	
	import services.KeggWs;

	public class ProteinPathwaysClass extends Canvas
	{
		public var parentContext:Context;
		public var pathwaysListGrid:DataGrid;
		
		public function ProteinPathwaysClass()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandler);
		}
		
		private function creationCompleteHandler(event:FlexEvent):void
		{
			pathwaysListGrid.addEventListener(ListEvent.ITEM_CLICK,function(e:ListEvent):void{
							 parentContext.pathwayId = e.itemRenderer.data.id;
							 parentContext.pathwaySource = e.itemRenderer.data.source;
							 parentContext.updatePathwaysMenu(true);
							 parentContext.writeTip("Select an option from the PATHWAYS menu");
							 
			});
		}
		
		public function render():void
		{
		
			if (!parentContext.uniprotId)
				Alert.show("Please select a protein","Alert");
			else{	
				parentContext.updateHistory(parentContext.uniprotId,"Get Pathways");
				doSearch(parentContext.uniprotId);
			}
		}
		
		public function doSearch(uniprotId:String):void
		{
			parentContext.updateAllMenus(false);
			parentContext.listBox.removeAllChildren();
			parentContext.workBox.removeAllChildren();
			parentContext.listBox.addChild(this);
			
			var keggServ:KeggWs = new KeggWs(parentContext);
			var data:Array = new Array();
			
			parentContext.loadingLabel.visible = true;
			keggServ.getPathways(uniprotId,function(event:ResultEvent):void{
 				if (event && event.result.response){
					for each (var pathway:Object in event.result.response.pathway){
						var tmp:Object = new Object();
						tmp.source = 'KEGG';
						tmp.id = pathway;
						data.push(tmp);
					}
					pathwaysListGrid.dataProvider = data;
					parentContext.workBox.removeAllChildren();
				}else{
 					parentContext.writeMessage("Sorry, no results found");
				}
				
				parentContext.loadingLabel.visible = false;
 			});
		}
		
	}
}