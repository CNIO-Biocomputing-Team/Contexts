package context
{
	import context.components.biomodels.list.BiomodelsList;
	import context.components.parts.list.PartLists;
	import context.components.parts.similarEntities.SimilarEntities;
	import context.components.pathways.info.PathwayInfo;
	import context.components.proteins.annotations.DatabaseAnnotations;
	import context.components.proteins.interactions.StringInteractions;
	import context.components.proteins.notes.PersonalNotes;
	import context.components.pathways.list.ProteinPathways;
	import context.components.proteins.similarSequences.SimilarProteinSequences;
	import context.components.searches.PartRegistrySearch;
	import context.components.searches.UniprotSearch;

	
	import mx.collections.XMLListCollection;
	import mx.controls.Button;
	import mx.events.FlexEvent;
	
	public class CancerMutationsClass extends Context
	{
		public var uniprotSearch:Button;

		
		public function CancerMutationsClass()
		{
			addEventListener(FlexEvent.CREATION_COMPLETE,initApplication);
		}
		
		/**
		 * Init Application
		 * 
		 */
		public function initApplication(event:FlexEvent):void
		{
			//create tabs instances
			/* Searches */
			SearchUniprotTab			= new UniprotSearch;
			SearchUniprotTab.parentContext = this;
			SearchPartsRegistryTab		= new PartRegistrySearch;
			SearchPartsRegistryTab.parentContext = this

			/* Proteins */
				/* Annotations */
				ProteinAnnotationsTab		= new DatabaseAnnotations();
				ProteinAnnotationsTab.parentContext	= this;
				ProteinSequenceTab.parentContext = this;
				/* Interactions */
					StringInteractionsTab	= new StringInteractions;
					StringInteractionsTab.parentContext = this;

				/* Pathways */
				KeggPathwaysTab				= new ProteinPathways();
				KeggPathwaysTab.parentContext = this;
				/* Similar sequences */
				SimilarProteinSequencesTab	= new SimilarProteinSequences; 
				SimilarProteinSequencesTab.parentContext = this;
				BiomodelsTab				= new BiomodelsList();
				BiomodelsTab.parentContext	= this;
				/* Notes */
				PersonalNotesTab			= new PersonalNotes();
				PersonalNotesTab.parentContext	= this;
			
			/* Pathways */
				PathwayInfoTab = new PathwayInfo();
				PathwayInfoTab.parentContext	= this;
				
			/* Parts */
				PartListTab = new PartLists();
				PartListTab.parentContext = this;
				SimilarEntitiesTab = new SimilarEntities();
				SimilarEntitiesTab.parentContext = this;
			
			/*  Menu bar */
			var menuData:XMLList = <>
								<menuitem id="proteins" label="Proteins" data="Proteins" enabled="true">
									<menuitem label="Get protein annotations" data="Protein Annotations" enabled="false"></menuitem>
									<menuitem label="Get sequence information" data="Protein Sequence" enabled="false"></menuitem>
									<menuitem label="Get protein interactions" data="Protein Interactions" enabled="true">
										<menuitem label="String interactions" data="String Interactions" enabled="false"></menuitem>
										<menuitem label="Ihop interactions" data="Ihop Interactions" enabled="false"></menuitem>
									</menuitem>
									<menuitem label="Get pathways" data="Get Pathways" enabled="true">
										<menuitem label="Get KEGG pathways" data="Kegg Pathways" enabled="false"></menuitem>	
									</menuitem>
									<menuitem label="Get Biomodels" data="Biomodels" enabled="false"></menuitem>
									<menuitem label="Notes" data="Personal Notes" enabled="false"></menuitem>
								</menuitem>
								<menuitem id="pathways" label="Pathways" data="Pathways" enabled="true">
									<menuitem label="Get pathway diagram" data="Pathway Info" enabled="false"></menuitem>
								</menuitem>
								<menuitem id="synthetic" label="Synthetic Biology" data="synthetic" enabled="true">
									<menuitem id="parts" label="Parts" data="Parts" enabled="true">
										<menuitem label="Get similar biological entities" data="Similar Entities" enabled="false"></menuitem>
									</menuitem>
								</menuitem>
							   </>;
			var menuBarCollection:XMLListCollection = new XMLListCollection(menuData);
			menuBar.dataProvider = menuBarCollection;
			writeTip("Click the icons in the SEARCH panel to start using CONTEXTS");	
		}
	}
}