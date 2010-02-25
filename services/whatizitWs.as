package services
{
	import context.Context;
	
	import mx.controls.ProgressBar;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class whatizitWs extends Service
	{
		public var loader:URLLoader;
		public function whatizitWs(pc:Context)
		{
			super(new ProgressBar);
			parentContext = pc;
		}
		
		/** Query PMID **/
		public function queryPmid(pipeline:String,pmId:String,resultHandler:Function):void
		{
			loader = new URLLoader();
            var request:URLRequest = new URLRequest("http://bwsp.bioinfo.cnio.es/bwsp.php?bwsp_response_format=raw&bwsp_service=whatizit&bwsp_url=http://www.ebi.ac.uk/webservices/whatizit/ws?wsdl&service=queryPmid&pipelineName="+pipeline+"&pmid="+pmId);
            loader.addEventListener(Event.COMPLETE,resultHandler);
 
            try {
                loader.load(request);
            
            } catch (error:Error) {
                parentContext.writeError("Sorry, some error ocurred trying to access the Whatizit service.");	
				parentContext.loadingLabel.visible = false;
            }
		}
		
		public function contact(pipeline:String,text:String,resultHandler:Function):void
		{
			loader = new URLLoader();
            var request:URLRequest = new URLRequest("http://bwsp.bioinfo.cnio.es/bwsp.php?bwsp_response_format=raw&bwsp_service=whatizit&bwsp_url=http://www.ebi.ac.uk/webservices/whatizit/ws?wsdl&service=contact&convertToHtml=false&pipelineName="+pipeline+"&text="+text);
            loader.addEventListener(Event.COMPLETE,resultHandler);
 
            try {
                loader.load(request);
            
            } catch (error:Error) {
                parentContext.writeError("Sorry, some error ocurred trying to access the Whatizit service.");	
				parentContext.loadingLabel.visible = false;
            }
		}

		
	}
}