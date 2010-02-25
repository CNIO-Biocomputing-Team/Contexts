package services
{
	import context.Context;
	
	import mx.controls.ProgressBar;
	
	public class Pfam extends Service
	{
		public function Pfam(pc:Context)
		{
			super(new ProgressBar);
			parentContext = pc;		
		}
		
		public function getProteinSequenceData(protein:String,handler:Function):void
		{
			service.request = {bwsp_service:"pfam",bwsp_response_format:"raw",bwsp_url:"http://pfam.sanger.ac.uk/protein/"+protein+"?output=xml"};
			service.addEventListener("result",handler);
			service.send(); 
		}
		
		public function getPfamAAnnotations(pfamACC:String,handler:Function):void
		{
			service.request = {bwsp_service:"pfam",bwsp_response_format:"raw",bwsp_url:"http://pfam.sanger.ac.uk/family?output=xml;acc="+pfamACC};
			service.addEventListener("result",handler);
			service.send(); 
		}


	}
}