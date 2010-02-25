package services
{
	import flare.data.DataSource;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	
	import mx.controls.ProgressBar;


	public class TumorTypesAndPathways extends Service
	{
		public var loader:URLLoader;
		public function TumorTypesAndPathways()
		{
			super(new ProgressBar);
		}
		
		public function getData(pvalue:Number,resultHandler:Function):void
		{
			var ds:DataSource = new DataSource(
                "http://bwsp.bioinfo.cnio.es/bwsp.php?bwsp_service=tumor-pathways&bwsp_response_format=raw&bwsp_url=http://ws.bioinfo.cnio.es/rest/diseases/interactions/tab2graphml.php?threshold="+pvalue, "graphml");
            loader = ds.load();
			loader.addEventListener(Event.COMPLETE,resultHandler);
		}
		
	}
}