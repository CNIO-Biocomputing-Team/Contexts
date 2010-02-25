package services
{
	import mx.controls.ProgressBar;
	
	public class Genomestatistics extends Service
	{
		public function Genomestatistics()
		{
			super(new ProgressBar);
		}
		
		/** Get genome statistics **/
		public function getGenomeStatistics(genome:String,resultHandler:Function):void
		{
			service.request = {bwsp_service:"genomestatistics",bwsp_response_format:"raw",bwsp_url:"http://ws.bioinfo.cnio.es/rest/genomestatistics/index.php?genome="+genome};
			service.addEventListener("result",resultHandler);
			service.send(); 
		}
		
	}
}