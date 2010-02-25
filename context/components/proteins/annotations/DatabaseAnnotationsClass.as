package context.components.proteins.annotations
{
	import context.Context;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.LinkButton;
	import mx.controls.SWFLoader;
	import mx.controls.Text;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	
	import services.UniprotWs;


	public class DatabaseAnnotationsClass extends Canvas
	{
		public var parentContext:Context;
		public var uniprotId:String;
		[Bindable]
		public var annotationCanvas:Canvas;
		public var annotationText:Text;
		public var popup:TitleWindow;
		public var annotationsLoader:SWFLoader;
		
		
		
		public function DatabaseAnnotationsClass()
		{
			super();
		}
		
		public function render():void
		{
			if (!parentContext.uniprotId)
				Alert.show("Please select a protein","Alert");
			else{
				parentContext.workBox.removeAllChildren();
				uniprotId = parentContext.uniprotId;
				parentContext.workBox.addChild(this);
				getAnnotations(annotationCanvas);
			}
		}
		
		
		public function getAnnotations(container:Object,loader:SWFLoader = null,query:String = null):void
		{
			annotationText.htmlText = "";	
			container.removeAllChildren();
			
			if (!query)
				query = uniprotId;
			if (!loader)
				loader = annotationsLoader;
				
			loader.visible = true;
				
			var uniprotAnnotServ:UniprotWs = new UniprotWs(parentContext);
			
			uniprotAnnotServ.getUniprotAnnot(query,function(event:ResultEvent):void{
				if (event.result && event.result.uniprot.entry.hasOwnProperty('name')){
					parentContext.uniprotAnnotationsXML = event.result;
					fillAnnotations(container,event.result);
				}else{
					parentContext.writeMessage("Sorry, no annotations found",container);
				}
				loader.visible = false;
			});
		}
		
		private function fillAnnotations(container:Object,result:Object):void
		{
			/* Clean data */
			var a:RegExp = new RegExp('()','g');
			
			parentContext.accessionList = new Array();
			var name:String;
			var genes:Array = new Array();
			var taxonomy:Array = new Array();
			var tissues:Array = new Array();
			var functions:Array = new Array();
			var slocations:Array = new Array();
			var biologicalProcess:Array = new Array();
			
			
			annotationText.htmlText = "";
			
			var entry:Object = result.uniprot.entry;
			
			
			/* Accessions */
			if (entry.hasOwnProperty('accession')){
				if (entry.accession.hasOwnProperty('0'))	
					for each (var acc:String in entry.accession)
						parentContext.accessionList.push(acc);
				else
					parentContext.accessionList.push(entry.accession);
			}
			
			
			/* Name */
			if (entry.hasOwnProperty('name')){
				name = entry.name; 
			}
			if (entry.hasOwnProperty('protein') && entry.protein.recommendedName.fullName){
				name += ", "+entry.protein.recommendedName.fullName; 
			}
			
			/* Genes */
			if (entry.hasOwnProperty('gene')){
				if (entry.gene.name.hasOwnProperty('0'))	
					for each (var g:String in entry.gene.name)
						genes.push(g.toLowerCase());
				else
					genes.push(entry.gene.name);
					
				parentContext.geneList = genes;
			}		
				
			/* Taxonomy */
				if (entry.hasOwnProperty('organism')){
				if (entry.organism.name.hasOwnProperty('0'))	
					for each (var t:String in entry.organism.name){
						taxonomy.push(t);
					}
				else
					taxonomy.push(entry.organism.name);	
				
				parentContext.organism = taxonomy[0];
			}	
		
			
			/* References */				
			if (entry.hasOwnProperty('reference') && entry.reference.hasOwnProperty('0')){	
				for each (var r:Object in entry.reference){
					
 					if (r.hasOwnProperty('source')){
 						if (r.source.hasOwnProperty('tissue')){
 							if (r.source.tissue.hasOwnProperty('0')){
 								for each (var ti:String in r.source.tissue)
										tissues.push(ti);
 							}else{
									tissues.push(r.source.tissue);	
 							}
 						}
 					}
				}	
			}
			
			/* Comments */				
			if (entry.hasOwnProperty('comment') && entry.comment.hasOwnProperty('0')){	
 				for each (var c:Object in entry.comment){
					
 					switch (c.type){
						case 'function':
							functions.push(c.text);
							break;
						case 'subcellular location':
							if (c.subcellularLocation.hasOwnProperty('location'))
								slocations.push(c.subcellularLocation.location);
							break;	
							
					} 
				}	 
			}	
			
			if (name)
				annotationText.htmlText += "<br><b>NAME:</b> "+name+"<br><br>";
				
			if (genes.length)
				annotationText.htmlText += "<b>GENES:</b> "+genes.join(', ')+"<br><br>";
				
			if (taxonomy.length)
				annotationText.htmlText += "<b>TAXONOMY:</b> "+taxonomy.join(', ')+"<br><br>";		
						
			if (tissues.length)
				annotationText.htmlText += "<b>TISSUE:</b> "+tissues.join(', ')+"<br><br>";	
				
			if (slocations.length)
				annotationText.htmlText += "<b>SUBCELLULAR LOCATION:</b> "+slocations.join(', ')+"<br><br>";		
				
			if (functions.length)
				annotationText.htmlText += "<b>FUNCTION:</b> "+functions.join(', ')+"<br><br>";						
				
		
			container.addChild(annotationText);
			annotationText.x = 20;
			annotationText.width = container.width - 40;
			
			if (container != annotationCanvas && entry.hasOwnProperty('accession')){
				addshortcutsButtons(container);
			}	
		}
		
		private function addshortcutsButtons(container:Object):void
		{
			var shortcutsBar:HBox = new HBox;
			container.addChild(shortcutsBar);
			
			addAnnotationsButton(shortcutsBar);
			addInteractionsButton(shortcutsBar);
		}
		
		private function addAnnotationsButton(container:Object):void
	    {
	    	var select:Button = new Button;
	    	select.label = 'View annotations';
	    	select.styleName = 'blueButton';
	    	select.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
	    		parentContext.uniprotId = parentContext.accessionList[0];
	    		parentContext.uniprotIdList.push(parentContext.uniprotId);
	    		parentContext.updateHistory(parentContext.accessionList[0],"View protein annotations",null,'small-pointer.png');
	    		parentContext.ProteinListTab.render();
	    		parentContext.ProteinListTab.proteinListGrid.selectedIndex = 0;
				parentContext.ProteinAnnotationsTab.render();

	    	});
	    	container.addChild(select);
	    }
	    
	    private function addInteractionsButton(container:Object):void{
	    	var select:Button = new Button;
	    	select.label = 'View Interactions';
	    	select.styleName = 'blueButton';
	    	select.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
	    		parentContext.uniprotId = parentContext.accessionList[0];
				parentContext.StringInteractionsTab.render();
	    	});
	    	container.addChild(select);
	    }
	    
		
		private function str_replace(haystack:String, needle:String, replacement:String):String {
			var temp:Array = haystack.split(needle);
			return temp.join(replacement);
		}
		
		public function textLink(evt:TextEvent):void
		{
			var link:Array = evt.text.split('|');
			var command:String = link[0];
			var label:String = link[1];
			var data:String = link[2];
			switch (command){
				case 'pubmed':
					articlePopup(evt,data,label);
					break;
			}
		}
		
		public function articlePopup(evt:TextEvent,data:String,label:String):void{
			
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
			menu_a.label = 'View article abstract';
			menu_a.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
					
					parentContext.pubmedIdList = new Array;
					parentContext.pubmedIdList.push(data)
					parentContext.ArticleListTab.render();
					parentContext.updateHistory(data,"View article abstract",label,'small-view-paper.png');
					PopUpManager.removePopUp(parentContext.popup);
			});
			
			popup.addChild(menu_a);

		}
		
	}
}