package services
{
	import context.Context;
	
	import mx.controls.ProgressBar;
	import mx.rpc.events.FaultEvent;
	
	public class Ensembl extends Service
	{
		public function Ensembl(pc:Context)
		{
			super(new ProgressBar);
			parentContext = pc;	
		}
		
		
		public function getBacterialGenomes(resultHandler:Function):void
		{
			service.request = {bwsp_service:"bacteria_ensembl_das",bwsp_response_format:"raw",bwsp_url:"http://bacteria.ensembl.org/das/sources"};
			service.addEventListener("result",resultHandler);
			service.addEventListener(FaultEvent.FAULT,errorHandler);
			service.send(); 
		}
		
		public function errorHandler(e:FaultEvent):void{
				parentContext.writeError("Sorry, some error ocurred trying to access the Ensembl DAS server.");	
				parentContext.loadingLabel.visible = false;
		}

	}
}