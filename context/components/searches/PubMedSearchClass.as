package context.components.searches
{
	import context.Context;
	
	import flash.events.MouseEvent;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.TextInput;
	import mx.utils.StringUtil;
	
	import services.EntrezWs;

	public class PubMedSearchClass extends Canvas
	{
		public var parentContext:Context;
		public var query:TextInput;
		public var search:Button;
		public var pubmedIds:Array;
		
		public function PubMedSearchClass()
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
			this.search.addEventListener(MouseEvent.CLICK,searchPubmed);
		}
		
		public function searchPubmed(e:MouseEvent):void
		{
			if (!query.text){
				Alert.show("You haven't entered query to search for","Alert");
			}else{	
				parentContext.pubmedQuery = query.text;
				parentContext.updateHistory(query.text,"Search PubMed",null,'small-search.png');
				doSearch(query.text);

		    }
		}
		
		public function doSearch(query:String):void
		{
			parentContext.listBox.removeAllChildren();
			parentContext.workBox.removeAllChildren();
			var entrezServ:EntrezWs = new EntrezWs(parentContext);
				
			//get article list
			pubmedIds = new Array;
			parentContext.loadingLabel.visible = true;
			parentContext.pubmedLoader.visible = true;
			parentContext.writeMessage("Searching PubMed. Please wait...");
			entrezServ.queryPubmed(StringUtil.trim(query),function():void{
				
				var result:String = entrezServ.loader.data;
				var xml:XMLDocument = new XMLDocument();
				xml.ignoreWhite = true;
				xml.parseXML(result);
				if (xml.firstChild.firstChild.firstChild.nodeValue == "0"){
					parentContext.writeMessage("Sorry, no results found");
				}else{
				
					for each (var pubmed:XMLNode in xml.childNodes){
						getPubmedId(pubmed);
					}
					parentContext.pubmedIdList = pubmedIds;
					parentContext.ArticleListTab.render();	
				}
				parentContext.workBox.removeAllChildren();
				parentContext.loadingLabel.visible = false;
				parentContext.pubmedLoader.visible = false;
				
			});
		}
		
		private function getPubmedId(pubmedNode:XMLNode):void
		{
			var pubmedId:String;
			for each (var node:XMLNode in pubmedNode.childNodes){
				if (node.nodeValue && node.nodeValue.length == 8){
						pubmedIds.push(node.nodeValue);
				}
				else{
					getPubmedId(node);
				}
			}
		}    
	}
}