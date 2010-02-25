package context
{
	import context.components.proteins.annotations.DatabaseAnnotations;
	import context.components.proteins.interactions.StringInteractions;
	import context.tabs.BrowseBacterialGenomes;
	import context.tabs.GetGenomeStatistics;
	import context.tabs.parts.AddPartToDesign;
	import context.tabs.parts.SaveDesign;
	import context.tabs.proteins.AddProteinToDesign;


	
	import mx.containers.Panel;
	
	public class SyntheticBiology extends Context
	{
		
		public function SyntheticBiology(panel:Panel,partName:String)
		{
			super();
			panel.title = "Synthetic Biology Context";

		}
		
		/**
		 * Init Context 
		 * 
		 */
		public function initContext():void
		{
			//create tabs instances
			/* Searches */
			BrowseBacterialGenomesTab			= new BrowseBacterialGenomes(this);
			/* Genomes */
			GetGenomeStatisticsTab				= new GetGenomeStatistics(this);
			/* Proteins */
			ProteinAnnotationsTab				= new DatabaseAnnotations();

			
				/* Interactions */
				StringInteractionsTab	= new StringInteractions();
				StringInteractionsTab.parentContext = this;

			AddProteinToDesignTab		= new AddProteinToDesign(this);	
			/* Parts */
			AddPartToDesignTab = new AddPartToDesign(this);
			SaveDesignTab  = new SaveDesign(this);
			
			/* Build menu bar */
			var menuData:XMLList = <>
								<menuitem label="Search" data="Search">
									<menuitem label="Browse Bacterial Genomes" data="Browse Bacterial Genomes"></menuitem>
									<menuitem label="Search Parts Registry" data="Search Parts Registry"></menuitem>
									<menuitem label="Search Biological Databases" data="Search Biological Databases"></menuitem>
								</menuitem>
								<menuitem label="Genomes" data="Genomes">
									<menuitem label="Get Genome Statistics" data="Get genome statistics"></menuitem>
								</menuitem>
								<menuitem label="Proteins" data="Proteins">
									<menuitem label="Protein Annotations" data="Protein annotations"></menuitem>
									<menuitem label="Protein Sequence" data="Protein sequence"></menuitem>
									<menuitem label="Protein Interactions" data="Protein interactions">
										<menuitem label="String Interactions" data="String interactions"></menuitem>
										<menuitem label="Ihop Interactions" data="Ihop interactions"></menuitem>
									</menuitem>
									<menuitem label="Search similar in the Part Registry" data="Search similar in the Part Registry"></menuitem>
									<menuitem label="Add Protein To Design" data="Add Protein To Design"></menuitem>
								</menuitem>
								<menuitem label="Pathways" data="Pathways">
									<menuitem label="Kegg Pathways" data="Kegg Pathways"></menuitem>
								</menuitem>
								<menuitem label="Parts" data="Parts">
									<menuitem label="Get Similar Biological Entities" data="Get Similar Biological Entities"></menuitem>
									<menuitem label="Add Part To Design" data="Add To Design"></menuitem>
									<menuitem label="Save Design" data="Save Design"></menuitem>
								</menuitem>
								<menuitem label="Models" data="Models">
									<menuitem label="Get BioModels" data="Get BioModels"></menuitem>
								</menuitem>
							   </>;
		}
	}
}