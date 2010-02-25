package context
{
	import context.tabs.searches.BrowseTumorTypes;
	
	import mx.containers.Panel;

	public class CancerResearch extends Context
	{
		public function CancerResearch(panel:Panel)
		{
			super();
			panel.title = "Cancer Research Context";
		}
		
		public function initContext():void
		{
			//create tabs instances
			BrowseTumorTypesTab	= new BrowseTumorTypes(this);
			BrowseTumorTypesTab.render();
		}
	}
}