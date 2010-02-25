package services
{
	import context.Context;
	
	import mx.controls.ProgressBar;
	import mx.rpc.http.HTTPService;

	
	public class Service
	{
		public var service:HTTPService = new HTTPService();
		public var resultsXML:Object;
		public var pb:ProgressBar;
		public var parentContext:Context; 
		
		public function Service(progress:ProgressBar)
		{
			this.pb = progress;
			service.url = "http://bwsp.bioinfo.cnio.es/bwsp.php";
		}
	}
}