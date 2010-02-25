package
{
	import context.Context;
	import context.components.biomodels.info.BiomodelsInfo;
	import context.components.biomodels.list.BiomodelsList;
	import context.components.literature.biomodels.Biomodels;
	import context.components.literature.info.ArticleInfo;
	import context.components.literature.list.ArticleList;
	import context.components.parts.list.PartLists;
	import context.components.parts.similarEntities.SimilarEntities;
	import context.components.pathways.info.PathwayInfo;
	import context.components.pathways.list.ProteinPathways;
	import context.components.proteins.annotations.DatabaseAnnotations;
	import context.components.proteins.compare.Compare;
	import context.components.proteins.interactions.StringInteractions;
	import context.components.proteins.interactions.iHopInteractions;
	import context.components.proteins.list.ProteinList;
	import context.components.proteins.notes.PersonalNotes;
	import context.components.proteins.sequence.Psequence;
	import context.components.proteins.similarSequences.SimilarProteinSequences;
	import context.components.searches.PartRegistrySearch;
	import context.components.searches.PubMedSearch;
	import context.components.searches.UniprotSearch;
	
	import flash.events.MouseEvent;
	
	import mx.collections.XMLListCollection;
	import mx.controls.Button;
	import mx.core.FlexSprite;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	public class RegistryConnectionClass extends Context
	{
		public var uniprotSearch:Button;
		
		
		public function RegistryConnectionClass():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE,initApplication);
		}
		
		/**
		 * Init Application
		 * 
		 */
		public function initApplication(event:FlexEvent):void
		{
			//Get flash paramters 
			var partNameParmeter:String 	= application.parameters.part;
			
			
			//create component instances
			/* Searches */
			SearchPubmedTab										= new PubMedSearch();
			SearchPubmedTab.parentContext						= this;
			SearchUniprotTab									= new UniprotSearch();
			SearchUniprotTab.parentContext 						= this;
			SearchPartsRegistryTab								= new PartRegistrySearch();
			SearchPartsRegistryTab.parentContext 				= this

			/* Proteins */
				/* Lists*/
				ProteinListTab									= new ProteinList();
				ProteinListTab.parentContext					= this;
				/* Annotations */
				ProteinAnnotationsTab							= new DatabaseAnnotations();
				ProteinAnnotationsTab.parentContext				= this;
				/* Sequence */
				ProteinSequenceTab								= new Psequence();
				ProteinSequenceTab.parentContext 				= this;
				/* Interactions */
					StringInteractionsTab						= new StringInteractions();
					StringInteractionsTab.parentContext 		= this;
					IhopInteractionsTab							= new iHopInteractions();
					IhopInteractionsTab.parentContext			= this;
				/* Pathways */
				KeggPathwaysTab									= new ProteinPathways();
				KeggPathwaysTab.parentContext 					= this;
				/* Similar sequences */
				SimilarProteinSequencesTab						= new SimilarProteinSequences(); 
				SimilarProteinSequencesTab.parentContext 		= this;
				BiomodelsTab									= new BiomodelsList();
				BiomodelsTab.parentContext						= this;
				/* Compare proteins */
				CompareProteinsTab								= new Compare();
				CompareProteinsTab.parentContext				= this;
				/* Notes */
				PersonalNotesTab								= new PersonalNotes();
				PersonalNotesTab.parentContext					= this;
			
			/* Literature*/
				ArticleListTab										= new ArticleList();
				ArticleListTab.parentContext						= this;
				ArticleInfoTab										= new ArticleInfo();
				ArticleInfoTab.parentContext						= this;
				ArticleBiomodelsTab									= new Biomodels();
				ArticleBiomodelsTab.parentContext					= this;
			
			/* Pathways */
				PathwayInfoTab 									= new PathwayInfo();
				PathwayInfoTab.parentContext					= this;
				
			/* Synthetic Biology */
				BiomodelsInfoTab								= new BiomodelsInfo();
				BiomodelsInfoTab.parentContext					= this;
				PartListTab 									= new PartLists();
				PartListTab.parentContext 						= this;
				SimilarEntitiesTab 								= new SimilarEntities();
				SimilarEntitiesTab.parentContext 				= this;
			
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
									<menuitem label="Compare Proteins" data="Compare Proteins" enabled="false"></menuitem>
									<menuitem label="Notes" data="Personal Notes" enabled="false"></menuitem>
								</menuitem>
								<menuitem id="pathways" label="Pathways" data="Pathways" enabled="true">
									<menuitem label="Get pathway diagram" data="Pathway Info" enabled="false"></menuitem>
								</menuitem>
								<menuitem id="literature" label="Literature" data="Literature" enabled="true">
									<menuitem label="Build Biomodel" data="Article Biomodels" enabled="false"></menuitem>
									<menuitem label="Create Digital Abstract" data="Create Digital Abstract" enabled="false"></menuitem>
								</menuitem>
								<menuitem id="synthetic" label="Synthetic Biology" data="synthetic" enabled="true">
									<menuitem id="parts" label="Parts Registry" data="Parts" enabled="true">
										<menuitem label="Get similar biological entities" data="Similar Entities" enabled="false"></menuitem>
									</menuitem>
								</menuitem>
							   </>;
			var menuBarCollection:XMLListCollection = new XMLListCollection(menuData);
			menuBar.dataProvider = menuBarCollection;
			writeTip("Click the icons in the SEARCH panel to start using CONTEXTS");	
			
			if (partNameParmeter){
				SearchPartsRegistryTab.doSearch(partNameParmeter);
			}
			
			this.systemManager.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
			if(e.target is FlexSprite) {
                    if(FlexSprite(e.target).name == "modalWindow") {
                        PopUpManager.removePopUp(popup);
                    }
                }

			});
				
		}
	}
}