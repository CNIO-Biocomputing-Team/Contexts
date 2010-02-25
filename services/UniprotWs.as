package services
{
	import context.Context;
	
	import mx.controls.ProgressBar;
	import mx.rpc.events.FaultEvent;
	
	public class UniprotWs extends Service
	{
		
		public function UniprotWs(pc:Context)
		{
			super(new ProgressBar);	
			parentContext = pc;	
		}
		

		public function searchUniprot(query:String,resultHandler:Function):void
		{
			service.request = {bwsp_service:"uniprot",bwsp_response_format:"raw",bwsp_url:"http://www.uniprot.org/uniprot/?query="+query+",sort=score,limit=20,format=xml"};
			service.addEventListener("result",resultHandler);
			service.addEventListener(FaultEvent.FAULT,errorHandler);
			service.send(); 
		}

		/** Get Uniprot Sequence **/
		public function getUniprotSeq(acc:String,resultHandler:Function):void
		{
			service.request = {bwsp_service:"uniprot",bwsp_response_format:"raw",bwsp_url:"http://www.uniprot.org/uniprot/?query="+acc+",format=xml"};
			service.addEventListener("result",resultHandler);
			service.addEventListener(FaultEvent.FAULT,errorHandler);
			service.send(); 
		}
		
		/** Get Uniprot Annotations **/
		public function getUniprotAnnot(query:String,resultHandler:Function):void
		{
			service.request = {bwsp_service:"uniprot",bwsp_response_format:"raw",bwsp_url:"http://www.uniprot.org/uniprot/?query="+query+",format=xml"};
			service.addEventListener("result",resultHandler);
			service.addEventListener(FaultEvent.FAULT,errorHandler);
			service.send(); 
		}
		
		public function errorHandler(e:FaultEvent):void{
				parentContext.writeError("Sorry, some error ocurred trying to access UniProt database.");	
				parentContext.loadingLabel.visible = false;
		}
	}
}