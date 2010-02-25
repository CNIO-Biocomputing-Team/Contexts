package services
{
	import context.Context;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.controls.ProgressBar;

	public class Ihop extends Service
	{
		public var loader:URLLoader;
		
		public function Ihop(pc:Context)
		{
			super(new ProgressBar);
			parentContext = pc;
		}
		
		/** Get SSynomys **/
		public function getSymbolInteractions(name:String,resultHandler:Function):void
		{
			loader = new URLLoader();
            var request:URLRequest = new URLRequest("http://bwsp.bioinfo.cnio.es/bwsp.php?bwsp_service=ihop&bwsp_response_format=raw&bwsp_url=http://ubio.bioinfo.cnio.es/biotools/iHOP/cgi-bin/getSymbolInteractions?gene="+name);
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