package context.components.proteins.sequence
{
	import context.Context;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import mx.containers.Canvas;
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.LinkButton;
	import mx.controls.Menu;
	import mx.controls.PopUpButton;
	import mx.controls.SWFLoader;
	import mx.controls.Text;
	import mx.events.MenuEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	
	import services.Pfam;
	import services.UniprotWs;
	

	public class PsequenceClass extends Canvas
	{
		public var parentContext:Context;
		public var uniprotId:String;
		[Bindable]
		public var proteinLabel:Label;
		public var sequenceLoader:SWFLoader;
		public var sequenceText:Text;	
		public var sequence:String;
		public var variantMenu:Menu;
		public var domainMenu:Menu;
		public var functionalMenu:Menu;
		public var variants:PopUpButton;
		public var domains:PopUpButton;
		public var functional:PopUpButton;
		public var popupFlag:int = 0;
		
		public function PsequenceClass()
		{
			super();
		}
		
		public function initVariantMenu():void {
                variantMenu = new Menu();
                var dp:Object = [
                  {label: "UniProt annotated variants"},
                ];        
                variantMenu.dataProvider = dp;
                variantMenu.addEventListener("itemClick", changeHandler);
                variants.popUp = variantMenu;
        }
        
        public function initDomainMenu():void {
                domainMenu = new Menu();
                var dp:Object = [
                  {label: "Pfam Domains"},
                ];        
                domainMenu.dataProvider = dp;
                domainMenu.addEventListener("itemClick", changeHandler);
                domains.popUp = domainMenu;
        }
        
        public function initFunctionalMenu():void {
                functionalMenu = new Menu();
                var dp:Object = [
                  {label: "Binding Sites"},
                ];        
                functionalMenu.dataProvider = dp;
                functionalMenu.addEventListener("itemClick", changeHandler);
                functional.popUp = functionalMenu;
        }

        // Define the event listener for the Menu control's change event. 
        private function changeHandler(event:MenuEvent):void {
            var label:String = event.label; 
            switch (label){
            	case 'UniProt annotated variants':
            		renderUniprotVariants();
            		break;
            	case 'Pfam Domains':
            		renderPfamDomains();
            		break;	
            	case 'Binding Sites':
            		renderBindingSites();
            		break;		
            }       
        }

		public function render():void
		{
			if (!parentContext.uniprotId)
				Alert.show("Please select a protein","Alert");
			else{
				parentContext.workBox.removeAllChildren();
				uniprotId = parentContext.uniprotId;
				parentContext.workBox.addChild(this);
				renderBasicSequence(); 
				proteinLabel.text = parentContext.proteinName;
				sequenceText.addEventListener(TextEvent.LINK,textLink);
			}
		}
		
		/**
		 * Render basic sequence 
		 * 
		 */
		private function renderBasicSequence():void
		{
			sequenceLoader.visible = true;
			sequenceText.htmlText = "";
			var uniprotSeqServ:UniprotWs = new UniprotWs(parentContext);
			uniprotSeqServ.getUniprotSeq(uniprotId,function(event:ResultEvent):void{
				if (event.result.uniprot.entry.hasOwnProperty('sequence')){
					sequence = event.result.uniprot.entry.sequence;
					sequenceText.text = sequence;
				}
				sequenceLoader.visible = false;
			});
		}
		
		
		/**
		 * Render uniprot variants 
		 * 
		 */
		private function renderUniprotVariants():void
		{
			sequenceLoader.visible = true;
			var xml:Object = parentContext.uniprotAnnotationsXML;
			var highlights:Array = new Array();
			
			/* Features */				
			if (xml.uniprot.entry.feature.hasOwnProperty('0')){	
				for each (var f:Object in xml.uniprot.entry.feature){
					
 					switch (f.type){
						case 'sequence variant':
							var highlight:Object = new Object();	
							highlight.color="#C20D0D";
							if (f.location.hasOwnProperty('position')){
								highlight.start = int(f.location.position.position);
								highlight.end	= int(f.location.position.position);
								if (f.description)
									highlight.data = f.description+' ('+f.original+' to '+f.variation+')';
								else
									highlight.data = f.original+' to '+f.variation;	
								highlight.event = 'sequence_variant|Sequence variant';
								highlights.push(highlight);
							}
							break;
					} 
				}	
			}
			parentContext.renderHighlightedSequence(sequenceText,sequence,highlights);
			sequenceLoader.visible = false;
		} 
		
		
		/**
		 * Render uniprot variants 
		 * 
		 */
		private function renderBindingSites():void
		{
			sequenceLoader.visible = true;
			var xml:Object = parentContext.uniprotAnnotationsXML;
			var highlights:Array = new Array();
			
			/* Features */				
			if (xml.uniprot.entry.feature.hasOwnProperty('0')){	
				for each (var f:Object in xml.uniprot.entry.feature){
					
 					switch (f.type){
						case 'DNA-binding region':
							var highlight:Object = new Object();	
							highlight.color="#C20D0D";
							if (f.location.hasOwnProperty('begin')){
								highlight.start = int(f.location.begin.position);
								highlight.end	= int(f.location.end.position);
								highlight.data = 'DNA binding site';
								highlight.event = 'binding_site|Binding Site';
								highlights.push(highlight);
							}
							break;
						case 'metal ion-binding site':
							var highlight1:Object = new Object();	
							highlight1.color="#00FF00";
							if (f.location.hasOwnProperty('position')){
								highlight1.start = int(f.location.position.position);
								highlight1.end	= int(f.location.position.position);
								highlight1.data = 'Metal ion-binding site: '+f.description;
								highlight1.event = 'binding_site|Binding Site';
								highlights.push(highlight1);
							}
							break;	
					} 
				}	
			}
			parentContext.renderHighlightedSequence(sequenceText,sequence,highlights);
			sequenceLoader.visible = false;
		}
		
		/**
		 * Render Pfam domains 
		 * 
		 */
		private function renderPfamDomains():void
		{
			var highlights:Array = new Array();
			sequenceLoader.visible = true;
			if (parentContext.uniprotId){
				
				var pfamServ:Pfam = new Pfam(parentContext);
				
				pfamServ.getProteinSequenceData(parentContext.uniprotId,function(event:ResultEvent):void{
					if (event.result){
						for each (var pfamDomain:Object in event.result.pfam.entry.matches){
							
							var highlight:Object = new Object();	
							highlight.color="#C20D0D";
							highlight.event = 'pfam_domain|Pfam Domain';
							
							if (pfamDomain.hasOwnProperty('location')){
								 highlight.start = int(pfamDomain.location.start);
								 highlight.end	= int(pfamDomain.location.end);
							}
							if (pfamDomain.hasOwnProperty('accession'))
								highlight.data = pfamDomain.accession;

							highlights.push(highlight);	

						}
						for each (var pfamDomain1:Object in event.result.pfam.entry.matches.match){
							var highlight1:Object = new Object();
							highlight1.color="#C20D0D";
							highlight1.event = 'pfam_domain|Pfam Domain';
								
							if (pfamDomain1.hasOwnProperty('location')){
								 highlight1.start = int(pfamDomain1.location.start);
								 highlight1.end	= int(pfamDomain1.location.end);
							}
							if (pfamDomain1.hasOwnProperty('accession'))
								highlight1.data = pfamDomain1.accession;
							highlights.push(highlight1);
						}
						parentContext.renderHighlightedSequence(sequenceText,sequence,highlights);
						sequenceLoader.visible = false;
					}
				});
			} 
		}

		/**
		 * Define link operation 
		 * @param evt
		 * 
		 */
		public function textLink(evt:TextEvent):void{
			
			var link:Array = evt.text.split('|');
			var command:String = link[0];
			var label:String = link[1];
			var data:String = link[2];
			
			switch (command){
				case 'sequence_variant':
				    variationPopup(evt,data,label);
					break;
				case 'pfam_domain':
				    pfamPopup(evt,data,label);
					break;
				case 'binding_site':
				    bindingPopup(evt,data,label);
					break;		
			}
		}
		
		/**
		 * Variations Popup 
		 * @param evt
		 * @param data
		 * @param label
		 * 
		 */
		public function variationPopup(evt:TextEvent,data:String,label:String):void{
			
			sequenceLoader.visible = true;
			var variations:Array = data.split(',');
			PopUpManager.removePopUp(parentContext.popup);
			parentContext.popup = TitleWindow(PopUpManager.createPopUp(this,TitleWindow,true));
			parentContext.popup.title = "Variations";
			parentContext.popup.width = 400;
			parentContext.popup.height = int(variations.length)*30+50;

			
			
			if (int(evt.currentTarget.contentMouseX)+int(parentContext.popup.width) > parentContext.workBox.width){
				parentContext.popup.x = parentContext.workBox.x+20+evt.currentTarget.contentMouseX-int(parentContext.popup.width);
			}else{
				parentContext.popup.x = parentContext.workBox.x+20+evt.currentTarget.contentMouseX;
			}
			parentContext.popup.y = parentContext.workBox.y+50+evt.currentTarget.contentMouseY;
			
			for each(var variation:String in variations){
				var vText:Text = new Text;
				vText.text = variation;
				parentContext.popup.addChild(vText);
			}
			sequenceLoader.visible = false;
		}
		
		public function bindingPopup(evt:TextEvent,data:String,label:String):void{
			
			sequenceLoader.visible = true;
			var bindingSites:Array = data.split(',');
			PopUpManager.removePopUp(parentContext.popup);
			parentContext.popup = TitleWindow(PopUpManager.createPopUp(this,TitleWindow,true));
			parentContext.popup.title = "Binding sites";
			parentContext.popup.width = 400;
			parentContext.popup.height = int(bindingSites.length)*30+50;

			
			
			if (int(evt.currentTarget.contentMouseX)+int(parentContext.popup.width) > parentContext.workBox.width){
				parentContext.popup.x = parentContext.workBox.x+20+evt.currentTarget.contentMouseX-int(parentContext.popup.width);
			}else{
				parentContext.popup.x = parentContext.workBox.x+20+evt.currentTarget.contentMouseX;
			}
			parentContext.popup.y = parentContext.workBox.y+50+evt.currentTarget.contentMouseY;
			
			for each(var b:String in bindingSites){
				var vText:Text = new Text;
				vText.text = b;
				parentContext.popup.addChild(vText);
			}
			sequenceLoader.visible = false;
		}
		
		public function pfamPopup(evt:TextEvent,data:String,label:String):void{
			
			sequenceLoader.visible = true;
		    var pfams:Array = data.split(',');
			PopUpManager.removePopUp(parentContext.popup);
			parentContext.popup = TitleWindow(PopUpManager.createPopUp(this,TitleWindow,true));
			parentContext.popup.title = "Domains";
			parentContext.popup.width = 500;
			parentContext.popup.height = 280;
			
			if (int(evt.currentTarget.contentMouseX)+int(parentContext.popup.width) > parentContext.workBox.width){
				parentContext.popup.x = parentContext.workBox.x+20+evt.currentTarget.contentMouseX-int(parentContext.popup.width);
			}else{
				parentContext.popup.x = parentContext.workBox.x+20+evt.currentTarget.contentMouseX;
			}
			parentContext.popup.y = parentContext.workBox.y+50+evt.currentTarget.contentMouseY;
			
			
			for each(var pfam:String in pfams){
				
				if (pfam != ''){
					
					var dText:Text = new Text;
					dText.x = 400;
					dText.htmlText = '<b>'+pfam+'</b>';
					
					parentContext.popup.addChild(dText);
					
					var descriptionText:Text = new Text;
					descriptionText.width = 450;
					descriptionText.height = 200;
					parentContext.popup.addChild(descriptionText);
	
					var pfamServ:Pfam = new Pfam(parentContext);
					pfamServ.getPfamAAnnotations(pfam,function(event:ResultEvent):void{
						
						descriptionText.htmlText += '<b>NAME</b><br>';
						if (event.result.pfam.entry.id){
							descriptionText.htmlText += event.result.pfam.entry.id+'<br>';
						}
						descriptionText.htmlText += '<br><b>DESCRIPTION</b><br>';
						if (event.result.pfam.entry.description){
							descriptionText.htmlText += event.result.pfam.entry.description+'<br>';;
						}else{
							descriptionText.htmlText += 'No description found<br>';
						}
						descriptionText.htmlText += '<br><b>COMMENTS</b><br>'
						
						if (event.result.pfam.entry.comment){
							descriptionText.htmlText += event.result.pfam.entry.comment+'<br>';;
						}else{
							descriptionText.htmlText += 'No comments found<br>';
						}
						sequenceLoader.visible = false;
					});
					var getSimilarProteins:Button = new Button;
					var tmp:Object = new Object;
					getSimilarProteins.x = 0;
					getSimilarProteins.y = 250;
					getSimilarProteins.styleName = "blueButton";
					getSimilarProteins.label = "Get proteins with domain "+pfam;
					tmp.pfam = pfam;
					getSimilarProteins.data = tmp;
					getSimilarProteins.addEventListener(MouseEvent.CLICK,getSimilarPfamProteins);
					parentContext.popup.addChild(getSimilarProteins);
				}
				
			}
			
		}
		
		private function getSimilarPfamProteins(e:MouseEvent):void{
			PopUpManager.removePopUp(parentContext.popup);
			var pfam:String = e.target.data.pfam;
			parentContext.SearchUniprotTab.doSearch(pfam);
		}
		
	}
}