package services
{
	import context.Context;
	
	import mx.controls.ProgressBar;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class EntrezWs extends Service
	{
		public var loader:URLLoader;
		public function EntrezWs(pc:Context)
		{
			super(new ProgressBar);
			parentContext = pc;	
		}
		
		/** Query Pubmed **/
		public function queryPubmed(query:String,resultHandler:Function):void
		{
			loader = new URLLoader();
            var request:URLRequest = new URLRequest("http://bwsp.bioinfo.cnio.es/bwsp.php?bwsp_service=entrezUtils&bwsp_response_format=raw&bwsp_url=http://www.ncbi.nlm.nih.gov/entrez/eutils/soap/v2.0/eutils.wsdl&service=eSearch&db=pubmed&term="+query);
            loader.addEventListener(Event.COMPLETE,resultHandler);
 
            
            try {
                loader.load(request);
            
            } catch (error:Error) {
                parentContext.writeError("Sorry, some error ocurred trying to access the iHOP server.");	
				parentContext.loadingLabel.visible = false;
            }

		}
		
		public function getArticleInfo(id:String,resultHandler:Function):void
		{
			loader = new URLLoader();
            var request:URLRequest = new URLRequest("http://bwsp.bioinfo.cnio.es/bwsp.php?bwsp_service=entrezUtils&bwsp_response_format=raw&bwsp_url=http://www.ncbi.nlm.nih.gov/entrez/eutils/soap/v2.0/efetch_pubmed.wsdl&service=eFetch&db=pubmed&retmode=xml&rettype=abstract&id="+id);
            loader.addEventListener(Event.COMPLETE,resultHandler);
 
            
            try {
                loader.load(request);
            
            } catch (error:Error) {
                parentContext.writeError("Sorry, some error ocurred trying to access the iHOP server.");	
				parentContext.loadingLabel.visible = false;
            }

		}
	}
}