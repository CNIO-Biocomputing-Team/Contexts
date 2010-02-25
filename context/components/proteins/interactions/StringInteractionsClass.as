package context.components.proteins.interactions
{
	import context.Context;
	
	import flare.display.TextSprite;
	import flare.scale.ScaleType;
	import flare.util.Colors;
	import flare.util.Strings;
	import flare.vis.Visualization;
	import flare.vis.controls.ClickControl;
	import flare.vis.controls.TooltipControl;
	import flare.vis.data.Data;
	import flare.vis.data.NodeSprite;
	import flare.vis.events.SelectionEvent;
	import flare.vis.events.TooltipEvent;
	import flare.vis.operator.encoder.ColorEncoder;
	import flare.vis.operator.layout.CirclePackingLayout;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import misc.SpriteUIComponent;
	
	import mx.containers.Box;
	import mx.containers.Canvas;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.controls.SWFLoader;
	import mx.controls.Text;
	import mx.rpc.events.ResultEvent;
	
	import services.StringInteractionsWs;

	public class StringInteractionsClass extends Canvas
	{
		public var parentContext:Context;
		public var uniprotId:String;
		public var interactionsBox:Box;
		public var detailsBox:VBox;
		[Bindable]
		public var proteinLabel:Label;
		public var interactionLoader:SWFLoader;
		public var note:Label;
		
		public function StringInteractionsClass()
		{
			super();
		}
		
		public function render():void
		{
			
			if (!parentContext.uniprotId)
				Alert.show("Please select a protein","Alert");
			else{
				//progress
				parentContext.updateHistory(parentContext.uniprotId,"View protein interactions",null,'small-interactions.png');
				parentContext.workBox.removeAllChildren();
				uniprotId = parentContext.uniprotId;
				parentContext.workBox.addChild(this);
				note.visible = false;
				interactionsBox.removeAllChildren();
				detailsBox.removeAllChildren();
				proteinLabel.text = parentContext.proteinName+ " PROTEIN INTERACTION NETWORK";

				var graph:Sprite = new Sprite();
				var vis:Visualization = new Visualization();
						vis.bounds = new Rectangle(0,0,300,300);
		            	vis.x = 5;
		            	vis.y = 5;
		        graph.addChild(vis); 
		       	interactionsBox.addChild(new SpriteUIComponent(graph));	
				
				var stringServ:StringInteractionsWs = new StringInteractionsWs(parentContext);
				interactionLoader.visible = true;
				stringServ.getInteractionNetwork(uniprotId,"300",function(event:ResultEvent):void{
					
					if (event.result.entrySet){
						var network:Data = _buildFlareData(event.result);
						
						
						network.nodes.setProperty("fillColor", Colors.rgba(34, 103, 139));
						network.nodes.setProperty("lineColor", Colors.rgba(34, 103, 139));
						network.edges.setProperty("lineColor", Colors.rgba(225, 225, 225));
						network.edges.setProperty("lineWidth", 2); 
						
						
		            	vis.data = network;
		            	//Operators
		            	vis.operators.add(new CirclePackingLayout(40,false,"depth"));
		            	vis.operators.add(new ColorEncoder("data.isQuery",Data.NODES,"fillColor"));
		            	vis.operators.add(new ColorEncoder("data.confidenceList.confidence.value",Data.EDGES,"lineColor",ScaleType.LINEAR));
		             	//Controls
		             	vis.controls.add(new TooltipControl(NodeSprite,null,_updateNodeTooltip, _updateNodeTooltip));
		             	vis.controls.add(new ClickControl(NodeSprite,1,_proteinDetails,null));
		             	vis.update();
		             	note.visible = true;
		             	
	    			}else{
	    				parentContext.writeMessage("Sorry, no interactions found");
	    			}
	    			interactionLoader.visible = false;
	    			parentContext.loadingLabel.visible = false;
				});
			}
		}
		
		/**
		 * _buildFlareData 
		 * @param xml
		 * @return 
		 * 
		 */
		private function _buildFlareData(xml:Object):Data{
			
			var network:Data = new Data;
			var added:Array = new Array();
			//Add nodes
			for each (var interactor:Object in xml.entrySet.entry.interactorList.interactor){
				if (interactor.hasOwnProperty('names')){
					if (parentContext.geneList.indexOf(interactor.names.shortLabel.toLowerCase()) != -1)
						interactor.isQuery = true;
					else
						interactor.isQuery = false;	
					
					network.addNode(interactor);
				}
			}
			//Add Edges			
			for each (var interaction:Object in xml.entrySet.entry.interactionList.interaction){
				var i:int = 0;
				var interactors:Array = new Array();
				for each( var participant:Object in interaction.participantList.participant){
					
					var interactorId:String = participant.interactorRef;
					for each (var node:Object in network.nodes){
						if (node.data.id == interactorId){
							interactors.push(node);
						} 
					}
					i++;
				}
			 	network.addEdgeFor(interactors[0],interactors[1],null,interaction);
			}
			return network;
		}
		
		/**
		 * _updateNodeTooltip 
		 * @param e
		 * 
		 */
		private function _updateNodeTooltip(e:TooltipEvent):void
		{
			TextSprite(e.tooltip).htmlText =  Strings.format("<b>{0}</b>",e.node.data.names.shortLabel);
		}
		
		/**
		 * _proteinDetails 
		 * @param e
		 * 
		 */
		private function _proteinDetails(e:SelectionEvent):void
		{
			//parentContext.updateHistory(e.node.data.names.shortLabel,"Protein Name");

			parentContext.ProteinAnnotationsTab.annotationText.width = detailsBox.width-40;
			parentContext.ProteinAnnotationsTab.getAnnotations(detailsBox,interactionLoader,'gene:'+e.node.data.names.shortLabel+' AND organism:"'+parentContext.organism+'" AND reviewed:yes');
			
		}
		
	}
}