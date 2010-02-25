package context.tabs.parts
{
	import context.Context;
	import context.Tab;
	
	import mx.controls.Alert;
		import mx.events.ListEvent;
	import mx.rpc.events.ResultEvent;
		import mx.utils.StringUtil;
	
	import services.PartRegistry;
	
	public class AddPartToDesign extends Tab
	{
		public function AddPartToDesign(parent:Context)
		{
			super();
			parentContext = parent;
		}
		
/* 		public function render():void
		{
			if (!parentContext.partId)
				Alert.show("Please select a part","Alert");
			else{	
				var partRegistryServ:PartRegistry = new PartRegistry();
				partRegistryServ.getPartRegistrySequence(StringUtil.trim(parentContext.partId),function(e:ResultEvent):void{
					var sequence:String = e.result.DASDNA.SEQUENCE.DNA.value;
					var part:Object = {partName:parentContext.partId,sequence:sequence};
					parentContext.compositePart.push(part);
					Alert.show(parentContext.partId + "Added","Alert");
				});
			
			}
		} */
	} 
}