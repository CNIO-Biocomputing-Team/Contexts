package services
{
	import context.Context;
	
	import mx.controls.ProgressBar;
	import mx.rpc.events.FaultEvent;
	
	public class StringInteractionsWs extends Service
	{
		public function StringInteractionsWs(pc:Context)
		{
			super(new ProgressBar);
			parentContext = pc;
		}
		
		public function getInteractionNetwork(identifier:String,score:String,handler:Function):void
		{
			service.request = {bwsp_service:"string",bwsp_response_format:"raw",bwsp_url:"http://string-db.org/api/psi-mi/interactions?identifier="+identifier+",required_score="+score};
			service.addEventListener("result",handler);
			service.addEventListener(FaultEvent.FAULT,errorHandler);
			service.send(); 
		}
		
		public function errorHandler(e:FaultEvent):void{
				parentContext.writeError("Sorry, some error ocurred trying to access the STRING server.");	
				parentContext.loadingLabel.visible = false;
		}
	}
}