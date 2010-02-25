package context.components.parts.similarEntities
{
	import context.Context;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.Text;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	import services.PartRegistry;
	import services.SSynonyms;

	public class SimilarEntitiesClass extends Canvas
	{
		public var infoText:Text;
		public var parentContext:Context;
		
		public function SimilarEntitiesClass()
		{
			super();
		}


		public function render():void
		{
			if (!parentContext.partId)
				Alert.show("Please select a part","Alert");
			else{	
				
				parentContext.updateHistory(parentContext.partId,"Get Similar Entities");
				var partName:String = parentContext.partId;
				doSearch(partName);
			}
		} 
		
	    public function doSearch(partName:String):void
	    {
	    	parentContext.listBox.removeAllChildren();
	    	parentContext.workBox.removeAllChildren();
	    	parentContext.listBox.addChild(this);
	    	var partRegistryServ:PartRegistry = new PartRegistry(parentContext);
			var ssynonymsXML:Object = new Object;
				
			//get sequence from registry
			parentContext.loadingLabel.visible = true;
			partRegistryServ.getPartRegistrySequence(StringUtil.trim(partName),function(e:ResultEvent):void{
				
				if (e){
					parentContext.listBox.removeAllChildren();
					if (e.result.hasOwnProperty("DASGFF") || !e.result.DASDNA.SEQUENCE.DNA.value){
						
						//not found
						parentContext.loadingLabel.visible = false;
						infoText.htmlText 	= "Sorry, no sequence found in the Parts Registry for this part";
						
					}else{
						infoText.htmlText = "Found sequence in the Registry. Performing BLAST search...";
						var sequence:String = e.result.DASDNA.SEQUENCE.DNA;	
						searchFasta(sequence);
					} 
				}
			});
	    }


		
		private function searchFasta(fastaSequence:String):void
		{
			parentContext.listBox.removeAllChildren();
					
			var ssynonymsXML:Object = new Object;
			var ssynonymsServ:SSynonyms = new SSynonyms(parentContext);
							
	
			//get similar sequences
			parentContext.loadingLabel.visible = true;
			ssynonymsServ.getSSynomyms(fastaSequence,function(e:ResultEvent):void{
				if (e){
					ssynonymsXML = e.result;
					parentContext.SimilarProteinSequencesTab.render(ssynonymsXML);
				}
			});
		}
		
	}
}