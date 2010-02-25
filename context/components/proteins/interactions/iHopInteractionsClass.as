package context.components.proteins.interactions
{
	import context.Context;
	
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.controls.Text;
	
	import services.Ihop;


	public class iHopInteractionsClass extends Canvas
	{
		public var parentContext:Context;
		public var uniprotId:String;
		public var message:Canvas;
		public var messageText:Text;
		public var interactionsLabel:Label;
		public var interactions:VBox;
		
		
		public function iHopInteractionsClass()
		{
			super();
		}
		
		public function render():void
		{
			if (!parentContext.uniprotId)
				Alert.show("Please select a protein","Alert");
			else{
				parentContext.workBox.removeAllChildren();
				parentContext.workBox.addChild(this);
				message.visible = true;
				messageText.htmlText = "<br>Sending request to iHOP server, please wait...<br><br>";
				interactionsLabel.visible = false;
				interactions.removeAllChildren();
				
				getInteractions();
			}
		}
		
		public function getInteractions():void
		{
			parentContext.loadingLabel.visible = true;
			
			var ihopServ:Ihop = new Ihop(parentContext);
			ihopServ.getSymbolInteractions(parentContext.uniprotId,function():void
			{
				var result:String = ihopServ.loader.data;
				var xml:XMLDocument = new XMLDocument();
				xml.ignoreWhite = true;
				xml.parseXML(result);
				message.visible = false;
				interactionsLabel.visible = true;
				interactions.removeAllChildren();				
				var addedSentences:int = 0;
				
				for each (var sentence:XMLNode in xml.firstChild.childNodes){
					if (sentence.nodeName != "iHOPsymbolInfo"){
					
						var details:HBox = new HBox;
						var impact:Text = new Text;
						impact.htmlText = "<b>Journal Impact:</b> " + sentence.attributes.journalImpact;
						var year:Text = new Text;
						year.htmlText = "<b>Year:</b> "+ sentence.attributes.year;
						
						var text:Text = new Text;
						text.width = interactions.width-20;
						_renderIhopSentence(text,sentence);
						interactions.addChild(text);
						
						var pmidButton:LinkButton = new LinkButton;
						pmidButton.label = "PMID "+ sentence.attributes.pmid;
						var temp:Object = new Object;
						temp.pmid = sentence.attributes.pmid;
						pmidButton.data = temp;
						
						pmidButton.addEventListener(MouseEvent.CLICK,_openArticle);
											
						details.addChild(impact);
						details.addChild(year);
						details.addChild(pmidButton);
						
						interactions.addChild(details);
						addedSentences++;
						
					}
				}
				if (!addedSentences)
						parentContext.writeMessage("Sorry, no results found");
				parentContext.loadingLabel.visible = false;
			})	
		}
		
		private function _renderIhopSentence(text:Text,sentence:XMLNode):void
		{
			for each (var node:XMLNode in sentence.childNodes){
				if (node.nodeValue){
						text.text += " "+node.nodeValue;
				}
				else{
					_renderIhopSentence(text,node);
				}
			}
		}
		
		private function _openArticle(e:MouseEvent):void{
			var pmid:String = e.currentTarget.data.pmid;
			var u:URLRequest = new URLRequest("http://www.ncbi.nlm.nih.gov/pubmed/"+pmid);
			navigateToURL(u,"_blank"); 
		}	
	}
}