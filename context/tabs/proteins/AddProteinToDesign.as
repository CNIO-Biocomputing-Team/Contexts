package context.tabs.proteins
{
	import context.Context;
	import context.Tab;
	
	import mx.controls.Alert;
	import mx.rpc.events.ResultEvent;
	
	import services.UniprotWs;

	public class AddProteinToDesign extends Tab
	{
		public function AddProteinToDesign(parent:Context)
		{
			super();
			parentContext = parent;
		}
		
		public function render():void
		{
			if (!parentContext.uniprotId)
				Alert.show("Please select a protein","Alert");
			else{	
				var uniprotSeqServ:UniprotWs = new UniprotWs(parentContext);
				uniprotSeqServ.getUniprotSeq(parentContext.uniprotId,function(event:ResultEvent):void{
					if (event.result){
						var sequence:String	= event.result.DASSEQUENCE.SEQUENCE;
						var part:Object = {partName:parentContext.uniprotId,sequence:sequence};
						parentContext.compositePart.push(part);
						Alert.show(parentContext.uniprotId + "Added","Alert");
					}	
				});
			
			}
		}
		
	}
}