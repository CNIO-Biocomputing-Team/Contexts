package context.components.literature.list
{
	import context.Context;
	
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	
	import services.EntrezWs;

	public class ArticleListClass extends Canvas
	{
		public var parentContext:Context;
		public var ArticleListGrid:DataGrid;
		
		public function ArticleListClass()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandler);
		}
		
		private function creationCompleteHandler(event:FlexEvent):void
		{
			ArticleListGrid.addEventListener(ListEvent.ITEM_CLICK,function(e:ListEvent):void{
							 parentContext.pubmedId = e.itemRenderer.data.pmid;
							 parentContext.articleAbstract = e.itemRenderer.data.abstract;
							 parentContext.articleTitle = e.itemRenderer.data.title;
							 parentContext.updateHistory(e.itemRenderer.data.pmid,"View article abstract",e.itemRenderer.data.pmid,'small-view-paper.png');
							 parentContext.updateLiteratureMenu(true);
							 parentContext.ArticleInfoTab.render();
							 
			});
		}
		
		public function render():void
		{
		
			if (!parentContext.pubmedIdList)
				Alert.show("Please provide a pubmed List","Alert");
			else{	
				//parentContext.updateHistory(parentContext.uniprotId,"Get Pathways");
				doSearch(parentContext.pubmedIdList);
			}
		}
		
		public function doSearch(pubmedList:Array):void
		{
			parentContext.updateAllMenus(false);
			parentContext.listBox.removeAllChildren();
			parentContext.workBox.removeAllChildren();
			parentContext.listBox.addChild(this);
			ArticleListGrid.dataProvider = new Array;
			
			var data:Array = new Array();
			
			parentContext.loadingLabel.visible = true;
			
			for each (var pmId:String in pubmedList){
				getPubmedInfo(pmId,data);
			}
			this.parentContext.loadingLabel.visible = false;
		}
		
		private function getPubmedInfo(pmId:String,data:Array):void
		{
			var tmp:Object = new Object();
			tmp.pmid = pmId;

			var entrezServ:EntrezWs = new EntrezWs(parentContext);
			parentContext.loadingLabel.visible = true;
			entrezServ.getArticleInfo(pmId,function():void{
				
				var result:String = entrezServ.loader.data;
				var xml:XMLDocument = new XMLDocument();
				xml.ignoreWhite = true;
				xml.parseXML(result);
				var pupmedInfo:XMLNode = xml.firstChild;
				parsePubmed(tmp,pupmedInfo);	
				data.push(tmp);
				ArticleListGrid.dataProvider = data;
				parentContext.loadingLabel.visible = false;
			});
		}
		
		private function parsePubmed(tmp:Object,xml:XMLNode):void
		{
			for each (var node:XMLNode in xml.childNodes){
				if (node.localName == 'Title')
					tmp.journal = node.firstChild.nodeValue;
				else if (node.localName == 'ArticleTitle')
					tmp.title = node.firstChild.nodeValue;
				else if (node.localName == 'Year')
					tmp.year = node.firstChild.nodeValue;	
				else if (node.localName == 'AbstractText')
					tmp.abstract = node.firstChild.nodeValue;		
				else{
					parsePubmed(tmp,node);
				}
			}	
		}
	}
}