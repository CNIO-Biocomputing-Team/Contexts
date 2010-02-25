package context.components.searches
{
	import context.Context;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	import services.SSynonyms;
	import services.UniprotWs;

	public class UniprotSearchClass extends Canvas
	{
		public var parentContext:Context;
		public var acc:TextInput;
		public var fastaSequence:String;
		[Bindable]
		public var fasta:TextArea;
		public var search:Button;
		
		public function UniprotSearchClass()
		{
			super();
		}
		
		public function render():void
		{
			/* Tur Off menus */
			parentContext.updateProteinMenu(false);
			parentContext.updateSyntheticPartsMenu(false);
			/* Clean Boxes */
			parentContext.listBox.removeAllChildren();
			parentContext.workBox.removeAllChildren();
			parentContext.listBox.addChild(this);
			this.search.addEventListener(MouseEvent.CLICK,searchProtein);
		}
		
		public function searchProtein(e:MouseEvent):void
		{
			var uniprotServ:UniprotWs = new UniprotWs(parentContext);
			var uniprotIds:Array = new Array;
						
			if (acc.text){
				
				doSearch(acc.text);
			
			}else{
		
				if (!fasta.text)
					Alert.show("You haven't entered protein ID or a sequence to blast for","Alert");
				else{	
					fastaSequence = fasta.text;
					parentContext.listBox.removeAllChildren();
					parentContext.workBox.removeAllChildren();
						
					var ssynonymsXML:Object = new Object;
					var ssynonymsServ:SSynonyms = new SSynonyms(parentContext);
									
			
					//get similar sequences
					parentContext.loadingLabel.visible = true;
					parentContext.uniprotLoader.visible = true;
					parentContext.writeMessage("Searching UniProt. Please wait...");
					ssynonymsServ.getSSynomyms(fastaSequence,function(e:ResultEvent):void{
						if (e){
							ssynonymsXML = e.result;
							parentContext.workBox.removeAllChildren();
							parentContext.SimilarProteinSequencesTab.render(ssynonymsXML);
						}
					});
				}
			}
		}
		
		public function doSearch(query:String):void{
			
			parentContext.uniprotLoader.visible = true;
			parentContext.writeMessage("Searching UniProt. Please wait...");
			var uniprotServ:UniprotWs = new UniprotWs(parentContext);
			uniprotServ.searchUniprot(StringUtil.trim(query),function(e:ResultEvent):void{
						
					parentContext.uniprotSearchResults = e.result;
					parentContext.workBox.removeAllChildren();
					parentContext.ProteinListTab.render(); 
					parentContext.uniprotLoader.visible = false;
					var history:Object = new Object;
					history.uniprotSearchResults = e.result; 
					parentContext.updateHistory(query,"Search UniProt",null,'small-search.png',history);
 			});
		}
		
	}
}