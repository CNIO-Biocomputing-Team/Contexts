package context.components.proteins.list
{
	import context.Context;
	
	import flash.events.KeyboardEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.rpc.events.ResultEvent;
	
	import services.UniprotWs;

	public class ProteinListClass extends Canvas
	{
		public var proteinListGrid:DataGrid;
		public var parentContext:Context;
		private var completed:int;
		private var proteins:Array;
		private var genes:Array;
		
		
		public function ProteinListClass()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandler);
		}
		
		private function creationCompleteHandler(event:FlexEvent):void
		{
/* 			proteins = new Array("Q13535","P49336","Q05397","P11802","Q96GX5","Q9UQB9","O14965","Q9BUB5","Q9NYY3","Q9H4B4","O00444","P11362","P22607","P12931","O96013","P15056","P04049","P08581","P00533","Q92526","P40227");
			genes = new Array("ATR","CDK8","FAK","CDK4","Gwl/MASTL","AURKC/STK13","AURKA/STK6","Mnk1/MKNK1","PLK2/SNK","PLK3","PLK4","FGFR1","FGFR3","SRC","PAK4","BRAF","C-Raf/RAF1","C-met/MET","EGFR","CCT6B","CCT6A");
			
			var data:Array = new Array();
			var i:int = 0;
			for each (var uniprotId:String in proteins){
				getProteinInfo(uniprotId,genes[i],data);
				i++;
			}
			this.parentContext.loadingLabel.visible = false; */
	
			proteinListGrid.addEventListener(ListEvent.ITEM_CLICK,function(e:ListEvent):void{
							
							if (e.itemRenderer.data.uniprotId.hasOwnProperty('0')){
								parentContext.uniprotId = e.itemRenderer.data.uniprotId[0];
							}else{
								parentContext.uniprotId = e.itemRenderer.data.uniprotId;
							}
							clickOnRow(e.rowIndex);
			});
			
			proteinListGrid.addEventListener(KeyboardEvent.KEY_UP,function(evt:KeyboardEvent):void{
				
				if (evt.keyCode == 17){
				
					parentContext.updateAllMenus(false);
					parentContext.menuBar.dataProvider[parentContext.menuOrder.proteins].menuitem[5].@enabled = true;
 					for each (var row:int in proteinListGrid.selectedIndices){
						if (evt.currentTarget.dataProvider[row].uniprotId.hasOwnProperty('0')){
							parentContext.uniprotIdCompareList.push(evt.currentTarget.dataProvider[row].uniprotId[0]);
						}else if (evt.currentTarget.dataProvider[row].uniprotId){
							parentContext.uniprotIdCompareList.push(evt.currentTarget.dataProvider[row].uniprotId);
						}
					
					}
					if (parentContext.uniprotIdCompareList.length >6){
						parentContext.uniprotIdCompareList = new Array();
						Alert.show("Please select up to 5 proteins","Alert");
					} 
				}
			});
			
		}
		
		public function render():void
		{
			doSearch(parentContext.uniprotIdList);
			
		}
		
		public function doSearch(proteins:Array,callBack:Function = null):void
		{
			if (!callBack)
				callBack = clickOnFirstRow;
			
			parentContext.updateAllMenus(false);
			parentContext.listBox.removeAllChildren();
			parentContext.workBox.removeAllChildren();
			parentContext.listBox.addChild(this);
			proteinListGrid.dataProvider = new Array();
			
			var data:Array = new Array();
			
			parentContext.loadingLabel.visible = true;
			
			//list comes from uniprot search
			if (parentContext.uniprotSearchResults){
			
				var results:Object = parentContext.uniprotSearchResults;
 
					if (results.uniprot.entry.hasOwnProperty('0')){
						
						for each (var entry:Object in results.uniprot.entry){
							
							var tmp:Object = new Object();
						
							if (entry.hasOwnProperty('accession')){
								  tmp.uniprotId =  entry.accession;
							}
							if (entry.hasOwnProperty('gene')){
								  tmp.gene =  entry.gene.name;
							}
							if (entry.hasOwnProperty('name')){
								  tmp.name =  entry.name;
							}
							if (entry.hasOwnProperty('protein')){
								if (entry.protein.hasOwnProperty('recommendedName')){
									  tmp.fullName =  entry.protein.recommendedName.fullName;
								}
							}
							if (entry.hasOwnProperty('organism')){
								  tmp.taxonomy =  entry.organism.name;
							}
								
							
							data.push(tmp);
						} 
						
					}else{
							var entry1:Object = results.uniprot.entry;
						
							var tmp1:Object = new Object();
						
							if (entry1.hasOwnProperty('accession')){
								  tmp1.uniprotId =  entry1.accession;
							}
							if (entry1.hasOwnProperty('gene')){
								  tmp1.gene =  entry1.gene.name;
							}
							if (entry1.hasOwnProperty('name')){
								  tmp1.name =  entry1.name;
							}
							if (entry1.hasOwnProperty('protein')){
								if (entry1.protein.hasOwnProperty('recommendedName')){
									  tmp1.fullName =  entry1.protein.recommendedName.fullName;
								}
							}
							if (entry1.hasOwnProperty('organism')){
								  tmp1.taxonomy =  entry1.organism.name;
							}
							
							data.push(tmp1);

					}
				parentContext.uniprotSearchResults = null;
				proteinListGrid.dataProvider = data;
				proteinListGrid.selectedIndex = 0;
				
				
				callBack(data);

				
			//
			}else if (proteins.length){
			
				for each (var uniprotId:String in proteins){
					if (uniprotId)
						getProteinInfo(uniprotId,"",data);
				}
			}
			
			this.parentContext.loadingLabel.visible = false;
			
		}	
		
		public function clickOnFirstRow(data:Object = null):void{
			clickOnRow(data);
		}
		
		public function clickOnRow(data:Object = null,rowNumber:int = 0):void{
			if (data.hasOwnProperty(rowNumber)){
				if (data[rowNumber].uniprotId.hasOwnProperty('0'))
					parentContext.uniprotId = data[rowNumber].uniprotId[0];
				else
					parentContext.uniprotId = data[rowNumber].uniprotId;
				parentContext.proteinName = data[rowNumber].name;
			}	
			parentContext.updateAllMenus(false);
			parentContext.updateProteinMenu(true);
			parentContext.updateHistory(parentContext.uniprotId,"View protein annotations",null,'small-view-annotations.png');
			parentContext.ProteinAnnotationsTab.render();
		}
		
		private function getProteinInfo(uniprotId:String,geneName:String,data:Array):void
		{
			var tmp:Object = new Object();
			tmp.uniprotId = uniprotId;
			tmp.gene = geneName;
			var name:String;
			var genes:Array = new Array();
			var taxonomy:Array = new Array();
			
			
			var uniprotAnnotServ:UniprotWs = new UniprotWs(parentContext);
			uniprotAnnotServ.getUniprotAnnot(uniprotId,function(event:ResultEvent):void{
				
				if (event.result){
					var entry:Object = event.result.uniprot.entry;	
					
					/* Name */
					if (entry.name){
						tmp.name = entry.name; 
					}
					
					/* Full name */
					if (entry.protein.recommendedName.fullName){
						tmp.fullName = entry.protein.recommendedName.fullName; 
					}
					
					/* Genes */
					if (entry.gene.name.hasOwnProperty('0'))	
						for each (var g:String in entry.gene.name)
							genes.push(g);
					else
						genes.push(entry.gene.name);
						
					tmp.gene = genes.join(',');	
					
					
					/* Taxonomy */
					if (entry.organism.name.hasOwnProperty('0'))	
						for each (var t:String in entry.organism.name){
							taxonomy.push(t);
						}
					else
						taxonomy.push(entry.organism.name);	
					
					tmp.taxonomy = taxonomy.join(',');		
					
					
				}
				data.push(tmp);
				proteinListGrid.dataProvider = data;
				proteinListGrid.selectedIndex = 0;
				clickOnRow(data[0]);
			});
		}
	}
}