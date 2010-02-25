package services
{
	import context.Context;
	
	import flash.net.URLLoader;
	
	import mx.controls.ProgressBar;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class KeggWs extends Service
	{
		public var loader:URLLoader;
		
		public function KeggWs(pc:Context)
		{
			super(new ProgressBar);
			parentContext = pc;
		}
		
		/** Get pathway by ID **/
		public function getPathwayById(pathId:String,resultHandler:Function):void
		{
			parentContext.writeMessage("Sending request to KEGG database, please wait ...");
			service.request = {bwsp_service:"bget",bwsp_response_format:"raw",bwsp_url:"http://soap.genome.jp",feature:"pathway",id:pathId};
			service.addEventListener(FaultEvent.FAULT,errorHandler);
			service.addEventListener("result",function(e:ResultEvent):void{
				if (e.result.response){
					resultHandler(e);
				}else{
					var object:ResultEvent;
					resultHandler(object);
				}
			});
			service.send(); 
		}


		/** Get pathways **/
		public function getPathways(acc:String,resultHandler:Function):void
		{
			parentContext.writeMessage("Loading information, please wait ...");
			service.request = {bwsp_service:"bconv",bwsp_response_format:"raw",bwsp_url:"http://soap.genome.jp",database:"uniprot",id:acc};
			service.addEventListener(FaultEvent.FAULT,errorHandler);
			service.addEventListener("result",function(e:ResultEvent):void{
				if (e.result.response){
					var response:String = e.result.response;
					var temp:Array = response.split("\t");
					var gene:String = temp[1];
					if (gene){
						service.request = {bwsp_service:"get_pathways_by_genes",bwsp_response_format:"raw",bwsp_url:"http://soap.genome.jp",genes:gene};
						service.addEventListener("result",resultHandler);
						service.send();
					}
				}else{
					var object:ResultEvent;
					resultHandler(object);
				}
			});
			service.send(); 
		}
		
		public function errorHandler(e:FaultEvent):void{
				parentContext.writeError("Sorry, some error ocurred trying to access the KEGG database.");	
				parentContext.loadingLabel.visible = false;
		}
		
	}
}