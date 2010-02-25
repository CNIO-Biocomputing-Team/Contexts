package context.components.searches
{
	import context.Context;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.TextInput;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;

	public class PartRegistrySearchClass extends Canvas
	{
		public var parentContext:Context;
		public var part:TextInput;
		public var partName:String;
		public var search:Button;
		import services.PartRegistry;
		import services.SSynonyms;
		
		public function PartRegistrySearchClass()
		{
			super();
		}
		
		public function render():void
		{
			/* Tur Off menus */
			parentContext.updateProteinMenu(false);
			parentContext.updateSyntheticPartsMenu(false);
			/* Clean Boxes */
			parentContext.listBox.removeAllChildren();
			parentContext.workBox.removeAllChildren();
			parentContext.listBox.addChild(this);
			this.search.addEventListener(MouseEvent.CLICK,searchPartRegistry);
		}
		
		public function searchPartRegistry(e:MouseEvent):void
		{
			if (!part.text)
				Alert.show("Please enter a part name","Alert");
			else{
				partName = part.text;
				parentContext.updateHistory(partName,"Search Parts Registry");
				doSearch(partName);
			}
		}
		
		public function doSearch(partName:String):void
		{
			parentContext.listBox.removeAllChildren();
			parentContext.workBox.removeAllChildren();
			var partRegistryServ:PartRegistry = new PartRegistry(parentContext);
				
			//check for composite part
			var parts:Array = new Array;
			parentContext.loadingLabel.visible = true;
			parentContext.registryLoader.visible = true;
			partRegistryServ.getPartRegistryFeatures(StringUtil.trim(partName),function(e:ResultEvent):void{
				if (e.result.DASGFF.GFF.SEGMENT){
					
					for each (var feature:Object in e.result.DASGFF.GFF.SEGMENT.FEATURE){
						if (feature.hasOwnProperty("TYPE") && feature.TYPE.value == "BioBrick"){ 
							parts.push(feature.label);
						}
						if (feature.hasOwnProperty("TYPE") && feature.TYPE.id == "description") {
							parts.push(feature.id);
						}
						
					}
					//composite part
					if (parts.length){

					//single part	
					}else{
						parts.push(e.result.DASGFF.GFF.SEGMENT.FEATURE.id);
					}
					parentContext.PartListTab.render(parts);
				}else{
					parentContext.writeMessage("Sorry the part you entered was no found in the Registry");
					parentContext.loadingLabel.visible = false;
					parentContext.registryLoader.visible = false;
				}
				
			});
		}
	}
}