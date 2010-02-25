package services
{
	import context.Context;
	
	import mx.controls.ProgressBar;
	import mx.rpc.events.FaultEvent;
	
	public class PartRegistry extends Service
	{
		public function PartRegistry(pc:Context)
		{
			super(new ProgressBar);
			parentContext = pc;
		}
		
		/** Get Parts Registry sequence **/
		public function getPartRegistrySequence(partName:String,resultHandler:Function):void
		{
			service.request = {bwsp_service:"partsRegistry_das",bwsp_response_format:"raw",bwsp_url:"http://partsregistry.org/das/parts/dna/?segment="+partName};
			service.addEventListener("result",resultHandler);
			service.addEventListener(FaultEvent.FAULT,errorHandler);
			service.send(); 
		}
		
		/** Get Parts Registry Features **/
		public function getPartRegistryFeatures(partName:String,resultHandler:Function):void
		{
			service.request = {bwsp_service:"partsRegistry_das",bwsp_response_format:"raw",bwsp_url:"http://partsregistry.org/das/parts/features/?segment="+partName};
			service.addEventListener("result",resultHandler);
			service.addEventListener(FaultEvent.FAULT,errorHandler);
			service.send(); 
		}
		
		public function errorHandler(e:FaultEvent):void{
				parentContext.writeError("Sorry, some error ocurred trying to access the Parts Registry  DAS server.");	
				parentContext.loadingLabel.visible = false;
		}
		
	}
}