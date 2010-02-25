package context
{
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
	import context.tabs.BrowseBacterialGenomes;
	import context.tabs.GetGenomeStatistics;
	import context.tabs.parts.AddPartToDesign;
	import context.tabs.parts.SaveDesign;
	import context.tabs.proteins.AddProteinToDesign;
	import context.tabs.searches.BrowseTumorTypes;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.Panel;
	import mx.containers.TitleWindow;
	import mx.containers.VBox;
	import mx.containers.ViewStack;
	import mx.controls.Button;
	import mx.controls.DataGrid;
	import mx.controls.Image;
	import mx.controls.LinkButton;
	import mx.controls.MenuBar;
	import mx.controls.ProgressBar;
	import mx.controls.SWFLoader;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.events.MenuEvent;
	import mx.utils.StringUtil;

	
	public class Context extends Application
	{
		public 	var applicationPanel:Panel;
		public var popup:TitleWindow;
		public  var menuBar:MenuBar;
		public  var history:Array;  
		public  var views:ViewStack;
		[Bindable]
		public  var leftBar:Canvas; 
		[Bindable]
		public var historyHeader:VBox;
		[Bindable] 
		public var historyBox:VBox;
		[Bindable]
		public  var leftBar1:Canvas;
		[Bindable] 
		public 	var listBox:Canvas;
		[Bindable] 
		public  var workBox:Canvas;
		public var loadingLabel:Text;
		
		 
		public 	var searchButton:Button; 
		public  var ssynonymsXML:Object;
		public  var results:Object;
		public  var pb:ProgressBar;
		public  var pubmedLoader:SWFLoader;
		public  var uniprotLoader:SWFLoader;
		public  var registryLoader:SWFLoader; 
		//Searches
		public var SearchPubmedTab:PubMedSearch;
		public var SearchUniprotTab:UniprotSearch;
		public var SearchPartsRegistryTab:PartRegistrySearch;
		
		public var BrowseBacterialGenomesTab:BrowseBacterialGenomes;

		
		public var BrowseTumorTypesTab:BrowseTumorTypes;
		//Genomes
		public var GetGenomeStatisticsTab:GetGenomeStatistics;
		//Proteins
		public var ProteinListTab:ProteinList;
		public var SimilarProteinSequencesTab:SimilarProteinSequences;
		public var ProteinAnnotationsTab:DatabaseAnnotations;
		public var ProteinSequenceTab:Psequence;
		public var StringInteractionsTab:StringInteractions;
		public var IhopInteractionsTab:iHopInteractions;
		public var KeggPathwaysTab:ProteinPathways;
		public var AddProteinToDesignTab:AddProteinToDesign;
		public var CompareProteinsTab:Compare;
		public var BiomodelsTab:BiomodelsList;
		public var PersonalNotesTab:PersonalNotes;
		//Pathways
		public var PathwayInfoTab:PathwayInfo;
		//Pubmed
		public var ArticleListTab:ArticleList;
		public var ArticleInfoTab:ArticleInfo;
		public var ArticleBiomodelsTab:Biomodels;
		//Syntetic Biology
		public var BiomodelsInfoTab:BiomodelsInfo;
		public var PartListTab:PartLists;
		public var SimilarEntitiesTab:SimilarEntities;
		public var AddPartToDesignTab:AddPartToDesign;
		public var SaveDesignTab:SaveDesign;

	
		//general
		public var organism:String;
	
		//Genome 
		private var _genomeEnsemblId:String;
		
		// Genes
		public var geneList:Array = new Array();
		
		//Proteins 
		private var _seq:String;
		public var uniprotId:String;
		public var proteinName:String;
		public var accessionList:Array = new Array();
		public var uniprotIdList:Array = new Array;
		public var uniprotIdCompareList:Array = new Array;
		public var uniprotSearchResults:Object;
		private var _uniprotAnnotationsXML:Object;
		
		  
		//Pathways
		public var pathwayId:String;
		public var pathwaySource:String;
		//Pubmeds
		public var pubmedId:String;
		public var pubmedIdList:Array;
		public var pubmedQuery:String;
		public var articleTitle:String;
		public var articleAbstract:String;
		//Parts
		public var partId:String;
		public var compositePart:Array = new Array;
		//Biomodels
		public var biomodelId:String;
		//Tumors
		private var _tumorType:Array = new Array;
		private var _annotationDatabase:Array = new Array;
		private var _pvalue:Number;
		
		
		public var menuOrder:Object = new Object();

				
		/**
		 * 
		 * @param panel
		 * 
		 */
		public function Context()
		{
			menuOrder.proteins = 0;
			menuOrder.pathways = 1;
			menuOrder.literature = 2;
			menuOrder.synthetic = 3;
			history = new Array();
		}
		
		/**
		 * Set genome Ensembl Id 
		 * @param value
		 * 
		 */
		public function set genomeEnsemblId(value:String):void
		{
			_genomeEnsemblId = value;
		}
		
		/**
		 * get genome Ensembl Id 
		 * @return 
		 * 
		 */
		public function get genomeEnsemblId():String
		{
			return _genomeEnsemblId;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get tumorType():Array
		{
			return _tumorType;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function set tumorType(value:Array):void
		{
			_tumorType = value;
		}
		
		public function get annotationDatabase():Array
		{
			return _annotationDatabase;
		}

		public function set annotationDatabase(value:Array):void
		{
			_annotationDatabase = value;
		}
		
		public function get pvalue():Number
		{
			return _pvalue;
		}

		public function set pvalue(value:Number):void
		{
			_pvalue = value;
		}
		

		
		
		/**
		 * Set Selected Sequence 	  
		 * @param value
		 * 
		 */
		public function set seq(value:String):void
		{
			var fasta:RegExp = /^>.*/;
			var pattern:RegExp = /[\r,\r, ,]/g;
			var t:String = value.replace(fasta,"");
			t = t.replace(pattern,"");
			_seq = t;
		}
		
		/**
		 * Get Selected Sequence 
		 * @return 
		 * 
		 */
		public function get seq():String{
			return _seq;
		}
		
		/**
		 * Set current UniProt annotations 
		 * @param value
		 * 
		 */
		public function set uniprotAnnotationsXML(value:Object):void
		{
			_uniprotAnnotationsXML = value;
		}
		
		/**
		 * Get current UniProt annotations
		 * @return 
		 * 
		 */
		public function get uniprotAnnotationsXML():Object
		{
			return _uniprotAnnotationsXML;
		}
		
		
		/**
		 * str_replace 
		 * @param haystack
		 * @param needle
		 * @param replacement
		 * @return 
		 * 
		 */
		public function str_replace(haystack:String, needle:String, replacement:String):String {
			var temp:Array = haystack.split(needle);
			return temp.join(replacement);
		}
		

		/**
		 * _menuTrigger 
		 * @param event
		 * 
		 */
		public function menuTrigger(event:MenuEvent):void
		{
			var instanceName:String =  event.item.@data+"Tab";
			var pattern:RegExp = / /g;
			instanceName = instanceName.replace(pattern,"");
			if (this.hasOwnProperty(instanceName))
				this[instanceName].render();
		}
		
		public function updateProteinMenu(state:Boolean):void
		{
			menuBar.dataProvider[menuOrder.proteins].menuitem[0].@enabled = state;
			menuBar.dataProvider[menuOrder.proteins].menuitem[1].@enabled = state;
			menuBar.dataProvider[menuOrder.proteins].menuitem[2].menuitem[0].@enabled = state;
			menuBar.dataProvider[menuOrder.proteins].menuitem[2].menuitem[1].@enabled = state;
			menuBar.dataProvider[menuOrder.proteins].menuitem[3].menuitem[0].@enabled = state;
			menuBar.dataProvider[menuOrder.proteins].menuitem[4].@enabled = state;
			menuBar.dataProvider[menuOrder.proteins].menuitem[5].@enabled = false;
			menuBar.dataProvider[menuOrder.proteins].menuitem[6].@enabled = state;
		}
		
		public function updatePathwaysMenu(state:Boolean):void
		{
			menuBar.dataProvider[menuOrder.pathways].menuitem[0].@enabled = state;
		}
		
		public function updateLiteratureMenu(state:Boolean):void
		{
			menuBar.dataProvider[menuOrder.literature].menuitem[0].@enabled = state;
		}
		
		public function updateSyntheticPartsMenu(state:Boolean):void
		{
			menuBar.dataProvider[menuOrder.synthetic].menuitem[0].menuitem[0].@enabled = state;
		}
		
		public function updateBiomodelsMenu(state:Boolean):void
		{
			//menuBar.dataProvider[menuOrder.synthetic].menuitem[1].menuitem[0].@enabled = state;
		}
		
		public function updateAllMenus(state:Boolean):void
		{
			updateProteinMenu(state);
			updatePathwaysMenu(state);
			updateLiteratureMenu(state);
			updateSyntheticPartsMenu(state);
			updateBiomodelsMenu(state);
			
		}
		
		/**
		 * updateHistory  
		 * @param term
		 * @param termType
		 * @param label
		 * @param img
		 * @param value
		 * 
		 */
		public function updateHistory(term:String,termType:String,label:String = null,img:String = null,value:Object = null):void
		{
			var historyLine:HBox= new HBox;
			
			/* check if exists */
			for each (var h:Object in history){
				if (h.term == term && h.type == termType)
					return
			} 
			var tmp:Object = new Object;
			tmp.term = StringUtil.trim(term);
			tmp.type = termType;
			if (value)
				tmp.value = value; 
			history.push(tmp);
			
			var historyImage:Image = new Image;
 			if (img){
				historyImage.source = 'style/icons/'+img;
				historyLine.addChild(historyImage);
			} 
			
			var historyTerm:LinkButton = new LinkButton;
			if (label)
				historyTerm.label = label;
			else
				historyTerm.label = tmp.term;	
				
			if 	(historyTerm.label.length >11)
				historyTerm.label = historyTerm.label.substr(0,11)+"...";
			historyTerm.toolTip = tmp.type;
			historyTerm.data = tmp;
			historyTerm.addEventListener(MouseEvent.CLICK,launchHistory);
			historyLine.addChild(historyTerm);
			
			historyBox.addChildAt(historyLine,0);
		}
		
		public function launchHistory(e:MouseEvent):void{
			
			switch (e.currentTarget.data.type){
				case "Search PubMed":
					SearchPubmedTab.doSearch(e.currentTarget.data.term);
					break;
				case "Search UniProt":
					SearchUniprotTab.doSearch(e.currentTarget.data.term);
					break;
				case "Search Parts Registry":
					SearchPartsRegistryTab.doSearch(e.currentTarget.data.term);
					break;
				case "Get Similar Entities":
					SimilarEntitiesTab.doSearch(e.currentTarget.data.term);
					break;	
				case "Get Pathways":
					KeggPathwaysTab.doSearch(e.currentTarget.data.term);
					break;	
				case "Get Biomodels":
					BiomodelsTab.doSearch(e.currentTarget.data.term);
					break;	
				case "View Protein List":
					var temp2:Array = e.currentTarget.data.term.split(',');
					ProteinListTab.doSearch(temp2);
					break;	
				case "View article abstract":
				    var temp3:Array = new Array();
					temp3.push(e.currentTarget.data.term);
					ArticleListTab.doSearch(temp3);
					break;	
				case "View protein annotations":
					
					var tUniprotId:String = e.currentTarget.data.term;
					if (!updateGrid(ProteinListTab,ProteinListTab.proteinListGrid,'uniprotId',tUniprotId,true)){
					    
					    var tHistory:Object = searchHistory('Search UniProt',tUniprotId);
					    if (tHistory){
					    	uniprotSearchResults = tHistory.value.uniprotSearchResults;
					    	ProteinListTab.doSearch(null,function(data:Array):void{
					    				updateGrid(ProteinListTab,ProteinListTab.proteinListGrid,'uniprotId',tUniprotId,true);
				    		});
					    }else{
						    var temp4:Array = new Array();
							temp4.push(tUniprotId);
							ProteinListTab.doSearch(temp4);
					    }
					}
					break;	
				case "View protein interactions":
				    uniprotId = e.currentTarget.data.term;
				    //updateGrid(ProteinListTab.proteinListGrid,'uniprotId',uniprotId);
				    StringInteractionsTab.render();
					break;					
			}
		}
		
		/**
		 * Select a row in a grid and trigger the clickRow function 
		 * @param tab
		 * @param grid
		 * @param key
		 * @param value
		 * @param clickSelected
		 * @return 
		 * 
		 */
		private function updateGrid(tab:Object,grid:DataGrid,key:String,value:String,clickSelected:Boolean = false):Boolean
		{
			var i:int = 0;
			for each (var row:Object in grid.dataProvider)
			{
				if ((row[key] == value) || ((row[key].hasOwnProperty('0') && row[key].getItemAt(0) == value))){
					
					grid.selectedIndex = i;
					if (clickSelected && "clickOnRow" in tab)
						tab.clickOnRow(row);
					return true;	
				}
				i++;
			}
			return false;
		}
		
		
		private function searchHistory(termType:String,term:String):Object
		{
			for each (var h:Object in history){
				
				switch (h.type){
					
					case 'Search UniProt':
						if (h.value.uniprotSearchResults.uniprot.entry.hasOwnProperty('0')){
						
							for each (var entry:Object in h.value.uniprotSearchResults.uniprot.entry){
								
								if (checkAccInUniprotEntry(term,entry))
									return h;
							} 
							
						}else{
								if (checkAccInUniprotEntry(term,h.value.uniprotSearchResults.uniprot.entry))
									return h;
						}
						break;
				}
			}
			return null;	
		}
		
		public function checkAccInUniprotEntry(acc:String,entry:Object):Boolean
		{
			if (entry.hasOwnProperty('accession')){
				if (entry.accession.hasOwnProperty('0')){
					for each (var a:String in entry.accession){
						if (a == acc)
							return true;
					}
				}else{
					if (entry.accession == acc)
						return true;
				}
			}
			return false; 
		}
		
		
		public function writeTip(text:String):void
		{
			var tipCanvas:Canvas = new Canvas();
			tipCanvas.styleName = "tipCanvas";
			tipCanvas.width = 600;
			tipCanvas.y = 30;
			tipCanvas.x = (workBox.width-tipCanvas.width)/2;
			
			var tip:Text = new Text;
			tip.width = 560;
			tip.x = 20;
			tip.y = 0;
			tip.htmlText = "<br>"+text+"<br><br>";
			tip.styleName="tip";
			
			tipCanvas.addChild(tip);
			workBox.removeAllChildren();
			workBox.addChild(tipCanvas);
		}
		
		public function writeMessage(text:String,container:Object = null):void
		{
			if (!container)
				container = workBox;
			
			var tipCanvas:Canvas = new Canvas();
			tipCanvas.styleName = "messageCanvas";
			tipCanvas.width = 600;
			tipCanvas.y = 30;
			tipCanvas.x = (container.width-tipCanvas.width)/2;
			
			var tip:Text = new Text;
			tip.width = 560;
			tip.x = 20;
			tip.y = 0;
			tip.htmlText = "<br>"+text+"<br><br>";
			tip.styleName ="message";
			
			tipCanvas.addChild(tip);
	
			container.removeAllChildren();
			container.addChild(tipCanvas);
		}
		
		public function writeError(text:String):void
		{
			var tip:Text = new Text;
			tip.width = 600;
			tip.x = (workBox.width-tip.width)/2;
			tip.y= 30;
			tip.htmlText = text;
			tip.styleName="error";
			workBox.removeAllChildren();
			workBox.addChild(tip);
		}
		
		public function renderHighlightedSequence(sequenceText:Text,sequence:String,highlights:Array):void{
			
			var tempText:String = "";
			
			for (var i:int=0;i<sequence.length;i++){
				var startflag:int = 0;
				var endflag:int = 0;
				var color:String;
				var start:int;
				var end:int;
				var event:String;
				var data:Array = new Array;
				for each (var h:Object in highlights){
						if (h.start){
							if (i == int(h.start-1)){
								start = int(h.start)-1;
								end	= int(h.end)-1;
								color = h.color;
								if (h.event)
									event = StringUtil.trim(h.event);
								if (h.data){
									data.push(StringUtil.trim(h.data));						
								}
								startflag = 1;
							}
						}
						if (h.end){
							if (i == int(h.end)-1)
								endflag = 1;
						}				
						
						
				}
				if (startflag)
					tempText += '<font color="'+color+'" size="+4"><b><a href="event:'+event+'|'+data.join(',')+'">';
					
				tempText += sequence.substr(i,1);
				
				if (endflag)
					tempText += '</a></b></font>';	
			}
			sequenceText.htmlText = tempText;
		}

	}
}