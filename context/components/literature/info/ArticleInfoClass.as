package context.components.literature.info
{
	import context.Context;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import mx.containers.Canvas;
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.controls.Text;
	import mx.managers.PopUpManager;
	
	import services.whatizitWs;

	public class ArticleInfoClass extends Canvas
	{
		public var parentContext:Context;
		public var pmid:String;
		public var titleLabel:Label;
		public var infoText:Text;	
		public var organismsButton:Button;
		public var proteinsButton:Button;
		public var proteinInteractionsButton:Button;
		public var diseasesButton:Button;
		
		public function ArticleInfoClass()
		{
			super();
		}
		
		public function render():void
		{
			if (!parentContext.pubmedId)
				Alert.show("Please select an article","Alert");
			else{
				parentContext.workBox.removeAllChildren();
				pmid = parentContext.pubmedId;
				parentContext.workBox.addChild(this);
				 
				this.organismsButton.addEventListener(MouseEvent.CLICK,getOrganismsHighLight);
				this.proteinsButton.addEventListener(MouseEvent.CLICK,getProteinsHighLight);
				/* this.proteinInteractionsButton.addEventListener(MouseEvent.CLICK,getProteinInteractionsHighLight); */
				this.diseasesButton.addEventListener(MouseEvent.CLICK,getDiseasesHighLight);
				titleLabel.text = parentContext.articleTitle;
				if (parentContext.articleAbstract)
			    	infoText.htmlText = parentContext.articleAbstract;
			    	
			    else
			    	parentContext.writeMessage('Sorry, no abstract found in PubMed');	
			   
			}
		}
		
		
		
		private function getOrganismsHighLight(e:MouseEvent = null):void
		{
			infoText.htmlText = "";	
			highLight(parentContext.articleAbstract,infoText,'whatizitOrganisms');	
		}
		
		private function getProteinsHighLight(e:MouseEvent = null):void
		{
			infoText.htmlText = "";	
			highLight(parentContext.articleAbstract,infoText,'whatizitSwissprot');
		}
		
		private function getProteinInteractionsHighLight(e:MouseEvent = null):void
		{
			infoText.htmlText = "";	
			highLight(parentContext.articleAbstract,infoText,'whatizitProteinInteraction');	
		}
		
		private function getDiseasesHighLight(e:MouseEvent = null):void
		{
			infoText.htmlText = "";	
			highLight(parentContext.articleAbstract,infoText,'whatizitDisease');	
		}
		
		private function highLight(text:String,textArea:Text,pipeline:String):void{
			
			parentContext.loadingLabel.visible = true;
			
			var whatizit:whatizitWs = new whatizitWs(parentContext);
			
			whatizit.contact(pipeline,text,function():void{
				var result:String = whatizit.loader.data;
				if (result.match(/error/g).length)
					parentContext.writeError('Sorry, some error ocurred trying to access the Whatizit service.');
				else	
					fillInfo(textArea,result);
				parentContext.loadingLabel.visible = false;
			});	
		}
		
		private function fillInfo(textArea:Text,result:String):void
		{
			var xml:XMLDocument = new XMLDocument();
			xml.ignoreWhite = true;
			xml.parseXML(result);
			
			var content:XMLNode = xml.firstChild.firstChild.firstChild;
			
			var abstract:XMLDocument = new XMLDocument();
			abstract.ignoreWhite = true;
			abstract.parseXML(content.nodeValue);
			
			renderArticleSentence(textArea,abstract.firstChild); 
		}
		
		
		private function renderArticleSentence(text:Text,sentence:XMLNode):void
		{
			for each (var node:XMLNode in sentence.childNodes){
				if (node.localName == 'a'){
					
					/* Proteins */
					var proteinsRE:RegExp = /http:\/\/beta.uniprot.org\/uniprot\/\?query=/gms;
					if (node.attributes.href.search(proteinsRE) != -1){
						var protLink:String = node.attributes.href.replace(proteinsRE,'');
						protLink = protLink.replace(/\+OR\+/g,'');
						protLink = protLink.replace(/key:/g,',');
						var protName:String = node.firstChild.nodeValue;
						text.htmlText += '<font color="#C20D0D" size="+4"><b><a href="event:protein|'+protName+'|'+protLink+'">';
					}
					
					/* Organisms */
					var organismRE:RegExp = /wwwtax.cgi\?id=/gms;
					if (node.attributes.href.search(organismRE) != -1){
						text.htmlText += '<font color="#C20D0D" size="+4"><b><a href="event:organism|">';
					}
					
					/* Diseases */
					var diseaseRE:RegExp = /www.healthcentral.com/gms;
					if (node.attributes.href.search(diseaseRE) != -1){
						text.htmlText += '<font color="#C20D0D" size="+4"><b><a href="event:disease|">';
					}
					
				}
				if (node.nodeValue){
						text.htmlText += " "+node.nodeValue.replace(/\n/g,'');
				}
				else{
					renderArticleSentence(text,node);
				}
				if (node.localName == 'a'){
					text.htmlText += '</a></b></font>';
				}
				
			}
		}
		
		public function textLink(evt:TextEvent):void
		{
			
			
			var link:Array = evt.text.split('|');
			var command:String = link[0];
			var label:String = link[1];
			var data:String = link[2];
			
			switch (command){
				case 'protein':
					
				    proteinPopup(evt,data,label);
					break;
			}
		}
		
		public function proteinPopup(evt:TextEvent,data:String,label:String):void{
			
			parentContext.uniprotIdList = data.split(',');
			PopUpManager.removePopUp(parentContext.popup);
			parentContext.popup = TitleWindow(PopUpManager.createPopUp(this,TitleWindow,true));
			parentContext.popup.title = "Options";
			parentContext.popup.width = 200;
			parentContext.popup.height = 30;
			parentContext.popup.x = parentContext.workBox.x+20+evt.currentTarget.contentMouseX;
			parentContext.popup.y = parentContext.workBox.y+50+evt.currentTarget.contentMouseY;
						
			var menu_a:LinkButton = new LinkButton;
			menu_a.width = 185;
			menu_a.styleName = 'contextLink';
			menu_a.label = 'View proteins';
			menu_a.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
					
					parentContext.ProteinListTab.render();
					parentContext.updateHistory(data,"View Protein List",label,'small-pointer.png');
					PopUpManager.removePopUp(parentContext.popup);
			});
			
			parentContext.popup.addChild(menu_a);

		}
		
		
		
	}
}