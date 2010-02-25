package services
{
	import context.Context;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.controls.ProgressBar;
	import mx.rpc.events.FaultEvent;

	public class BioModelsWs extends Service
	{
		public var loader:URLLoader;
		
		public function BioModelsWs(pc:Context)
		{
			super(new ProgressBar);
			parentContext = pc;
		}
		
		/** GetModelsByUniprotId **/
		public function getModelsIdByUniprotId(uniprotId:String,resultHandler:Function):void
		{
			service.request = {bwsp_service:"getModelsIdByUniprotId",bwsp_response_format:"raw",bwsp_url:"http://biomodels.caltech.edu/services",uniprotId:uniprotId};
			service.addEventListener("result",resultHandler);
			service.addEventListener(FaultEvent.FAULT,errorHandler);
			service.send(); 

		}
		
		public function getModelByID(id:String,resultHandler:Function):void
		{
			loader = new URLLoader();
            var request:URLRequest = new URLRequest("http://bwsp.bioinfo.cnio.es/bwsp.php?bwsp_service=getModelByID&bwsp_response_format=raw&bwsp_url=http://biomodels.caltech.edu/services/BioModelsWebServices&id="+id);
            loader.addEventListener(Event.COMPLETE,resultHandler);
            service.addEventListener(FaultEvent.FAULT,errorHandler);
   
            try {
                loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document.");
            }
		}
		
		public function errorHandler(e:FaultEvent):void{
				parentContext.writeError("Sorry, some error ocurred trying to access the BioModels Database.");	
				parentContext.loadingLabel.visible = false;
		}
		
	}
}