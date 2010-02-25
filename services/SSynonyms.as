package services
{
	import context.Context;
	
	import mx.controls.ProgressBar;
	import mx.rpc.events.FaultEvent;
	
	public class SSynonyms extends Service
	{
		public function SSynonyms(pc:Context)
		{
			super(new ProgressBar);
			parentContext = pc;
		}
		
		/** Get SSynomys **/
		public function getSSynomyms(seq:String,resultHandler:Function):void
		{
			parentContext.writeMessage("Searching for similar sequences, please wait...");
			service.request = {bwsp_service:"ssynonyms",bwsp_response_format:"raw",bwsp_url:"http://ws.bioinfo.cnio.es/rest/ssynonyms/index.php?program=blastx,sequence="+seq};
			service.addEventListener("result",resultHandler);
			service.addEventListener(FaultEvent.FAULT,errorHandler);
			service.send(); 
		}
		
		public function errorHandler(e:FaultEvent):void{
				parentContext.writeError("Sorry, some error ocurred trying to access the NCBI BLAST service.");	
				parentContext.loadingLabel.visible = false;
		}
		
	}
}