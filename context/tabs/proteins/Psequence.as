package context.tabs.proteins
{
	import context.Context;
	import context.Tab;
	
	import flare.util.Colors;
	import flare.vis.data.DataSprite;
	
	import flash.text.Font;
	
	import misc.SpriteUIComponent;
	
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.Label;
	import mx.controls.ProgressBar;
	import mx.controls.Text;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import services.Pfam;
	import services.UniprotWs;
	
	public class Psequence extends Tab
	{
		public var esequenceBox:VBox;
		public var legendBox:VBox;
		public var sequenceBox:Canvas;
		public var sequenceOptions:Canvas;
		public var pfamCheckBox:CheckBox;
		private var sequenceLength:int;
		private var sequence:String;
		
		public function Psequence(parent:Context)
		{
			super();
			parentContext = parent; 
		}

		/**
		 * Render Sequence 
		 * @param canvas
		 * 
		 */
		public function render():void
		{
			if (!parentContext.uniprotId)
				Alert.show("Please select a protein","Alert");
			else{
				parentContext.workBox.removeAllChildren();
				//progress
				/* parentContext.pb.label = "Waiting for response from uniprot.org ..."; */
				parentContext.pb.alpha = 1; 

				var uniprotSeqServ:UniprotWs = new UniprotWs();
				uniprotSeqServ.getUniprotSeq(parentContext.uniprotId,function(event:ResultEvent):void{
					if (event.result){
						parentContext.seq	= event.result.DASSEQUENCE.SEQUENCE;
						sequence			= parentContext.seq;
						sequenceLength		= parentContext.seq.length;
						parentContext.workBox.removeAllChildren();
						_buildLegendBox();
						_buildSequenceBox();
						/* Render tracks */
						renderProteinSequence();
						var uniprotAnnotServ:UniprotWs = new UniprotWs();
						uniprotAnnotServ.getUniprotAnnot(parentContext.uniprotId,function(event1:ResultEvent):void{
							if (event1.result){
									parentContext.uniprotAnnotationsXML = event1.result;
									renderPfamDomains();
									renderUniprotVariants(parentContext.uniprotAnnotationsXML);
									renderUniprotCrosslinkedResidues(parentContext.uniprotAnnotationsXML);
									renderUniprotAlternativeSequenceSite(parentContext.uniprotAnnotationsXML);
									
							}
						});
						parentContext.pb.alpha = 0;
					}
				});

			}	
		}

		/**
		 * Build Legend Box 
		 * 
		 */
		private function _buildLegendBox():void
		{
			legendBox = new VBox();
			legendBox.removeAllChildren();
			legendBox.x = 0;
			legendBox.y = 0;
			legendBox.styleName = "darkBox";
			legendBox.width = 165;
			legendBox.height = 428;
			var label:Label = new Label;
			label.text = "LEGEND";
			label.x = 30;
			label.styleName = "blackText12";
			legendBox.addChild(label);
			legendBox.addChild(_buildLegendElement("Pfam Domain",51,102,204));
			legendBox.addChild(_buildLegendElement("Natural Variants",111,210,35));
			legendBox.addChild(_buildLegendElement("Crosslinked Residues",220,57,18));
			legendBox.addChild(_buildLegendElement("Alternative Sequence",255,162,0));
			
			parentContext.workBox.addChild(legendBox);
		}
		
		private function _buildLegendElement(text:String,r:int,g:int,b:int):HBox
		{
			var canvas:HBox = new HBox;
			var circle:DataSprite = new DataSprite();
			circle.fillColor =  Colors.rgba(r,g,b);
			circle.lineColor =  Colors.rgba(r,g,b); 
			circle.x = 10;
			circle.y = 10
			var label:Text = new Text;
			label.htmlText = " "+text;
			label.y = 10;
			label.styleName = "blackText10";
			canvas.addChild(new SpriteUIComponent(circle));
			canvas.addChild(label);
			return canvas;
		}
		
		
		/**
		 * Build Sequence Box 
		 * 
		 */
		private function _buildSequenceBox():void
		{
			sequenceBox = new Canvas();
			sequenceBox.removeAllChildren();
			sequenceBox.x = 165;
			sequenceBox.y = 0;
			sequenceBox.width = 630;
			sequenceBox.height = 428;
			sequenceBox.horizontalScrollPolicy = "auto";
			sequenceBox.styleName = "grayBox";
			parentContext.workBox.addChild(sequenceBox);
		}
		
		/**
		 * Render Protein sequence 
		 * 
		 */		
		private function renderProteinSequence():void
		{
			var formated:String ="";
			var fText:Text = new Text;
			fText.styleName = "rawSequence";
			fText.htmlText = sequence;
			sequenceBox.addChild(fText);
			lastY = fText.y+12+7;
		}
		
		/**
		 * Render Uniprot Natural Variants 
		 * @param xml
		 * 
		 */
		public function renderUniprotVariants(xml:Object):void
		{
			var positions:Object = new Object();
			
			for each (var feature:Object in xml.DASGFF.GFF.SEGMENT.FEATURE)
			{
				
				if (feature.TYPE == "natural_variant_site"){
					var start:int = feature.START;
					var end:int	= feature.END;
					for (var c:int=start; c<=end; c++){
						
						if (!positions[c])
							positions[c] = {tooltip:"Natural variant\n"+feature.NOTE}
						else
							positions[c].tooltip = positions[c].tooltip+"\n"+feature.NOTE;  		
					}  											
				}
			}
			_addHighlightedSequence(positions,"#6FD223");
			
		}
		
		/**
		 * Render Uniprot Crosslinked residues
		 * @param xml
		 * 
		 */
		public function renderUniprotCrosslinkedResidues(xml:Object):void
		{
			var positions:Object = new Object();
			
			for each (var feature:Object in xml.DASGFF.GFF.SEGMENT.FEATURE)
			{
				
				if (feature.TYPE == "crosslinked residues"){
					var start:int = feature.START;
					var end:int	= feature.END;
					for (var c:int=start; c<=end; c++){
						
						if (!positions[c])
							positions[c] = {tooltip:"Crosslinked Residue\n"+ feature.NOTE}
						else
							positions[c].tooltip = positions[c].tooltip+"\n"+feature.NOTE;  		
					}											
				}
			}
			_addHighlightedSequence(positions,"#DC3912");
			
		}
		
		/**
		 * Render Uniprot Alternative Sequence Site
		 * @param xml
		 * 
		 */
		public function renderUniprotAlternativeSequenceSite(xml:Object):void
		{
			var positions:Object = new Object();
			
			for each (var feature:Object in xml.DASGFF.GFF.SEGMENT.FEATURE)
			{
				
				if (feature.TYPE == "alternative_sequence_site"){
					var start:int = feature.START;
					var end:int	= feature.END;
					
					for (var c:int=start; c<=end; c++){
						
						if (!positions[c])
							positions[c] = {tooltip:"Alternative sequence\n"+feature.NOTE}
						else
							positions[c].tooltip = positions[c].tooltip+"\n"+feature.NOTE;  		
					}
															
				}
			}
			_addHighlightedSequence(positions,"#FF9900");
			
		}
		
		/**
		 *	 
		 * Draw Pfam domains 
		 * 
		 */
		private function renderPfamDomains():void
		{
			var pb:ProgressBar = new ProgressBar;
 			var pfamServ:Pfam = new Pfam(pb);
			if (parentContext.uniprotId){
				pfamServ.getProteinSequenceData(parentContext.uniprotId,function(event:ResultEvent):void{
					if (event.result){
						for each (var pfamDomain:Object in event.result.pfam.entry.matches){
							var start:int;
							var end:int;
							var label:String;
							
							if (pfamDomain.hasOwnProperty('location')){
								 start 	= pfamDomain.location.start;
								 end	= pfamDomain.location.end;
							}
							if (pfamDomain.hasOwnProperty('id'))
								label = pfamDomain.id;
	
							_addHighlightedBox(start,end,"#3366CC",label);
							_addHighlightedVline(start,"#F0F0F0");
							_addHighlightedVline(end,"#F0F0F0");
						}
						for each (var pfamDomain1:Object in event.result.pfam.entry.matches.match){
							var start1:int;
							var end1:int;
							var label1:String;
							
							if (pfamDomain1.hasOwnProperty('location')){
								 start1 	= pfamDomain1.location.start;
								 end1	= pfamDomain1.location.end;
							}
							if (pfamDomain1.hasOwnProperty('id'))
								label1 = pfamDomain1.id;
	
							_addHighlightedBox(start1,end1,"#3366CC",label1);
							_addHighlightedVline(start1,"#F0F0F0");
							_addHighlightedVline(end1,"#F0F0F0");
						}
					}
				});
			} 
		}
		
		/**
		 * 
		 * @param positions
		 * @param color
		 * 
		 */
		private function _addHighlightedSequence(positions:Object,color:String):void{
			
			var track:Text = new Text;
			track.y = lastY;
			track.setStyle("fontFamily","Courier New");
			track.setStyle("fontSize",12);
			sequenceBox.addChild(track); 
			lastY = track.y+12+7;
			
			
			var tempText:String = "";
			var font:Font = new Font;

 			for(var i:int = 1;i <= sequenceLength.valueOf() ;i++){
				
				if (i in positions){
					tempText += "<font color='"+color+"'><b>"+sequence.substring(i-1,i)+"</b></font>";
					_addTooltip(i-1,track,positions[i]);		
				}else{
					tempText += " ";
				}	
			}
			track.htmlText = tempText;
			
		}
		
		private function _addHighlightedBox(start:int,end:int,color:String,label:String):void{
			
			
			var box:Canvas = new Canvas();
			box.y = lastY;
			box.x = start*7;
			box.width = (end-start)*7;
			box.height = 12;
			box.setStyle("backgroundColor",color);
			
			var text:Text = new Text;
			text.y = lastY;
			text.x = start*7+2;
			text.styleName = "whiteText8";
			text.text = label;
			sequenceBox.addChild(box);
			sequenceBox.addChild(text);
		}
		
		
		private function _addHighlightedVline(start:int,color:String):void{
			
			var box:Canvas = new Canvas();
			box.y = 0;
			box.x = start*7;
			box.width = 1;
			box.height = 410;
			box.alpha = 0.5;
			box.setStyle("backgroundColor",color)
			sequenceBox.addChild(box);
		}
		
		
		
		
		/**
		 * 
		 * @param i
		 * @param track
		 * @param object
		 * 
		 */
		private function _addTooltip(i:int,track:Text,object:Object):void
		{
			var box:Canvas = new Canvas();
			var label:String = (object.tooltip)?object.tooltip:"Not description found";
			box.y = track.y;
			box.x = i*7;
			box.width = 7;
			box.height = 12;
			//box.setStyle("backgroundColor","transparent");
			
			box.toolTip = label;
			sequenceBox.addChild(box);
		}

	}
}