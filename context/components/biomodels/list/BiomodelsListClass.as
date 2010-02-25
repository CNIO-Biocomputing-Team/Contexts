package context.components.biomodels.list
{
	import context.Context;
	
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.controls.Text;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.rpc.events.ResultEvent;
	
	import services.BioModelsWs;

	public class BiomodelsListClass extends Canvas
	{
		public var parentContext:Context;
		public var biomodelsListGrid:DataGrid;
		public var infoText:Text;
		public var modelAbstract:Text;
		
		public function BiomodelsListClass()
		{
			super();
			modelAbstract = new Text;
			modelAbstract.x = 20;
			modelAbstract.y = 20;
			addEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandler);
		}
		
		
		private function creationCompleteHandler(event:FlexEvent):void
		{
			biomodelsListGrid.addEventListener(ListEvent.ITEM_CLICK,function(e:ListEvent):void{
							 parentContext.biomodelId = e.itemRenderer.data.biomodelId;
							 getModelDetails(parentContext.biomodelId);
			});
		}
		
		public function render():void
		{
			
			if (!parentContext.uniprotId)
				Alert.show("Please select a protein","Alert");
			else{	
				parentContext.updateHistory(parentContext.uniprotId,"Get Biomodels");
				doSearch(parentContext.uniprotId);
			}
		}
		
		public function doSearch(uniprotId:String):void
		{
			parentContext.updateAllMenus(false);
			parentContext.listBox.removeAllChildren();
			parentContext.workBox.removeAllChildren();
			parentContext.listBox.addChild(this);
			biomodelsListGrid.visible = false;
			infoText.visible = false;
			
			parentContext.loadingLabel.visible = true;
			
			var biomodelsServ:BioModelsWs = new BioModelsWs(parentContext);
			var data:Array = new Array();
			biomodelsServ.getModelsIdByUniprotId(uniprotId,function(event:ResultEvent):void{
 				if (event && event.result.response){
					for each (var model:Object in event.result.response.biomodel){
						var tmp:Object = new Object();
						tmp.biomodelId = model;
						data.push(tmp);
					}
					biomodelsListGrid.visible = true;
					biomodelsListGrid.dataProvider = data;
				}else{
 					biomodelsListGrid.visible = false;
					infoText.htmlText = "Sorry, no results found";
					infoText.visible = true; 	
				}
				parentContext.loadingLabel.visible = false;
 			});
		}
		
		
		private function getModelDetails(id:String):void
		{
			var description:String;
			modelAbstract.width = (parentContext.workBox.width)-40;
			parentContext.workBox.removeAllChildren();
			parentContext.loadingLabel.visible = true;
			
			var biomodelsServ:BioModelsWs = new BioModelsWs(parentContext);
			biomodelsServ.getModelByID(id,function():void{
				
				var result:String = biomodelsServ.loader.data;
				var xml:XMLDocument = new XMLDocument();
				xml.ignoreWhite = true;
				xml.parseXML(result);
				var notes:XMLNode = xml.firstChild.firstChild.firstChild.firstChild;
				for each (var t:XMLNode in notes.childNodes) {
						description += t; 
				}

				var nullRe:RegExp = new RegExp(/null/g);
				modelAbstract.htmlText = description.replace(nullRe,"");
				parentContext.workBox.addChild(modelAbstract);
				parentContext.loadingLabel.visible = false;
			});
			
		}
	}	
}