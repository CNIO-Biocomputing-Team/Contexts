package context.tabs.tools
{
	import context.Context;
	import context.Tab;
	
	import flare.animate.Transitioner;
	import flare.data.DataSet;
	import flare.display.TextSprite;
	import flare.util.Colors;
	import flare.util.Strings;
	import flare.vis.Visualization;
	import flare.vis.controls.ClickControl;
	import flare.vis.controls.DragControl;
	import flare.vis.controls.TooltipControl;
	import flare.vis.data.Data;
	import flare.vis.data.EdgeSprite;
	import flare.vis.data.NodeSprite;
	import flare.vis.events.SelectionEvent;
	import flare.vis.events.TooltipEvent;
	import flare.vis.operator.layout.CirclePackingLayout;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import misc.CheckBoxList;
	import misc.SpriteUIComponent;
	
	import mx.containers.Canvas;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.List;
	import mx.controls.Text;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.ListEvent;
	import mx.rpc.events.ResultEvent;
	
	import services.KeggWs;
	import services.TumorTypesAndPathways;
	
	public class OverrepresentedPathways extends Tab
	{
		public var diagramBox:Canvas = new Canvas;
		public var detailBox:VBox = new VBox;
		private var _colors:Object = {Tumour:Colors.rgba(220, 57, 20),GO:Colors.rgba(255, 153, 0),BIOCARTA:Colors.rgba(51, 102, 204),KEGG:Colors.rgba(16, 150, 24),REACTOME:Colors.rgba(153, 0, 153),INTERPRO:Colors.rgba(0, 153, 197),OMIM:Colors.rgba(221, 68, 119)};
		private var _sizes:Object = {Tumour:2,GO:1,BIOCARTA:1,KEGG:1,REACTOME:1,INTERPRO:1,OMIM:1};
		private var _preserved:Array;
		private var _shared:Array;
		public var _cfilter:String;
		public var graph:Sprite;
		public var vis:Visualization;
		public var searchBox:TextInput;
		public var tumorTypesList:CheckBoxList;
		public var annotationTypesList:CheckBoxList;
		public var selectedTumourTypes:Array;
		public var selectedDatabases:Array;
		public var searchButton:Button;
		public var pvaluesTypesList:List;
		private var _t:Transitioner;
		private var _dur:Number = 1.25; // animation duration
		
		public function OverrepresentedPathways(parent:Context)
		{
			super();
			parentContext = parent;
		}
		
		/**
		 * Render 
		 * 
		 */
		public function render():void
		{
			parentContext.listBox.removeAllChildren();
			parentContext.workBox.removeAllChildren();
			
			_buildSearchBox();
			_buildTumorTypeList();
			_buildAnnotationTypeList();
			_buildQvalueList();
			_renderTumorTypesList();
			_renderAnnotationTypesList();
			_renderQvaluesList();
			_buildDiagramBox();
			_buildDetailBox()
			initData();
		}
		
		/**
		 * Build Search Box 
		 * 
		 */
		private function _buildSearchBox():void
		{
			searchBox = new TextInput();
			searchBox.x = 0;
			searchBox.y = 10;
			searchBox.width = 200;
			searchButton = new Button();
			searchButton.label = "Search";
			searchButton.y = 10;
			searchButton.x = 210;
			searchButton.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
				detailBox.removeAllChildren();
				parentContext.tumorType = new Array();
				parentContext.annotationDatabase = new Array();
				tumorTypesList.selectedItems =  new Array();
		    	annotationTypesList.selectedItems = new Array();
				updateData();
			});
			parentContext.applicationPanel.addChild(searchBox);
			parentContext.applicationPanel.addChild(searchButton);
		}
		
		/**
		 * Build Tumor Type List 
		 * 
		 */
		private function _buildTumorTypeList():void
		{
			var label:Label = new Label();
			label.text = "Tumour Type";
			label.y = 5;
			label.x = 5;
			parentContext.listBox.addChild(label);
			
			tumorTypesList = new CheckBoxList;
			tumorTypesList.y = 30;
			tumorTypesList.x = 5;
			tumorTypesList.width = 255;
			tumorTypesList.height = 220;
			tumorTypesList.allowMultipleSelection = true;
			parentContext.listBox.addChild(tumorTypesList);
		}
		
		/**
		 * Build Annotation Database List 
		 * 
		 */
		private function _buildAnnotationTypeList():void
		{
			var label:Label = new Label();
			label.text = "Annotation Database";
			label.y = 5;
			label.x = 260;
			parentContext.listBox.addChild(label);
			
			annotationTypesList = new CheckBoxList;
			annotationTypesList.y = 30;
			annotationTypesList.x = 260;
			annotationTypesList.width = 260;
			annotationTypesList.height = 220;
			annotationTypesList.allowMultipleSelection = true;
			parentContext.listBox.addChild(annotationTypesList);
		}
		
		/**
		 * Build Q-value List 
		 * 
		 */
		private function _buildQvalueList():void
		{
			var label:Label = new Label();
			label.text = "Statistical Significance Threshold";
			label.y = 5;
			label.x = 520;
			parentContext.listBox.addChild(label);
			
			pvaluesTypesList = new List;
			pvaluesTypesList.y = 30;
			pvaluesTypesList.x = 520;
			pvaluesTypesList.width = 270;
			pvaluesTypesList.height = 220;
			parentContext.listBox.addChild(pvaluesTypesList);
		}
		
		/**
		 * Build Diagram Box 
		 * 
		 */
		private function _buildDiagramBox():void
		{
			vis = new Visualization();
			vis.bounds = new Rectangle(0,0,410,410);
        	vis.x = 0;
        	vis.y = 0;
        	
        	graph = new Sprite();
        	
        	diagramBox.width = 415;
			diagramBox.height	= 415;
			diagramBox.x = 5;
			diagramBox.y = 5;
			diagramBox.styleName = "grayBox";
        	
        	graph.addChild(vis); 
		    diagramBox.addChild(new SpriteUIComponent(graph));	
		    parentContext.workBox.addChild(diagramBox);
		}
		
		/**
		 * Build details box 
		 * 
		 */
		private function _buildDetailBox():void
		{
			var stringLabel:TextArea = new TextArea;
			stringLabel.text = "To start browsing select a tumour type and an annotation database";
			stringLabel.x = 425;
			stringLabel.y = 0;
			stringLabel.width = 360;
			stringLabel.height = 70;
			stringLabel.setStyle("backgroundColor","#7FCEFF");
			stringLabel.setStyle("paddingLeft",10);
			stringLabel.setStyle("paddingRight",10);
			stringLabel.setStyle("paddingTop",10);
			stringLabel.setStyle("paddingBottom",10);
			detailBox.addChild(stringLabel);
			detailBox.width = 360;
			detailBox.height	= 410;
			detailBox.x = 430;
			detailBox.y = 10;
			parentContext.workBox.addChild(detailBox);
		}
		
		/**
		 * Render Tumor Type List 
		 * 
		 */
		private function _renderTumorTypesList():void{

				var tumorTypes:Array = new Array("Bladder","Brain","Leukemia","Lymphoma","Breast","Melanoma","Sarcoma","Stomach","Renal","Ovary","Pancreas","Gastric","Colorectal","HeadNeck");
				tumorTypes = tumorTypes.sort();
				tumorTypesList.dataProvider = tumorTypes;
 				tumorTypesList.addEventListener(ListEvent.ITEM_CLICK,function(e:ListEvent):void{
							 parentContext.tumorType = tumorTypesList.selectedItems;
							 if (parentContext.annotationDatabase.length)
							 	updateData();
						}); 
		}
		
		/**
		 * Render Annotation Type List 
		 * 
		 */
		private function _renderAnnotationTypesList():void{

				var annotationTypes:Array = new Array("GO","BIOCARTA","KEGG","REACTOME","INTERPRO");
				annotationTypesList.dataProvider = annotationTypes;
 				annotationTypesList.addEventListener(ListEvent.ITEM_CLICK,function(e:ListEvent):void{
 							parentContext.annotationDatabase = annotationTypesList.selectedItems;
 							updateData();
						}); 
		}
		
		/**
		 * Render Qvalues List 
		 * 
		 */
		private function _renderQvaluesList():void{

				var pvaluesTypes:Array = new Array({"label":"Q-value < 0.1 (Medium)","value":0.1},{"label":"Q-value < 0.01 (Strong)","value":0.01},{"label":"Q-value < 0.001 (Very strong)","value":0.001});
				pvaluesTypesList.dataProvider = pvaluesTypes;
 				pvaluesTypesList.addEventListener(ListEvent.ITEM_CLICK,function(e:ListEvent):void{
							 parentContext.pvalue = e.itemRenderer.data.value;
							 updateDataByPvalue();
						}); 
		}
		
		/**
		 * First load 
		 * 
		 */
		public function initData():void
		{
			_shared 	= new Array();
		    updateDataByPvalue();
	        vis.operators.add(new CirclePackingLayout(10,false, "depth"));
			vis.controls.add(new TooltipControl(NodeSprite,null,updateNodeTooltip, updateNodeTooltip));
			vis.controls.add(new TooltipControl(EdgeSprite,null,updateEdgeTooltip, updateEdgeTooltip));
			vis.controls.add(new ClickControl(NodeSprite,1,clickNode));
			vis.controls.add(new DragControl(NodeSprite));
		}
		
		/**
		 * Render visualization with a given Q-value 
		 * 
		 */
		public function updateDataByPvalue():void
		{
			if (!parentContext.pvalue)
				parentContext.pvalue = 0.1;

			//progress
			parentContext.pb.alpha = 1;
			parentContext.pb.label = "Loading..." ; 
	       	var tumorTypesServ:TumorTypesAndPathways = new TumorTypesAndPathways();
	       	tumorTypesServ.getData(parentContext.pvalue,function():void{
	       		if (tumorTypesServ.loader.data){
	       			var ds:DataSet = tumorTypesServ.loader.data as DataSet;
	       			vis.data = Data.fromDataSet(ds);
	       			vis.update();
	       			updateData();
	       		}
	       	});
		}
		
		/**
		 * Update Data after filtering 
		 * 
		 */
		public function updateData():void
		{
			parentContext.pb.alpha = 1; 
			selectedTumourTypes = new Array();
			selectedDatabases	= new Array();
			_preserved = new Array();
		    _t = new Transitioner(1);
		    vis.data.visit(filter,Data.EDGES);
			_t.play();
		    if (searchBox.text){
		    	tumorTypesList.selectedItems =  selectedTumourTypes;
		    	annotationTypesList.selectedItems = selectedDatabases;
		    }
		    parentContext.pb.alpha = 0;
		    parentContext.pb.label = "";
		}
		
		/** 
		 * Filter function for determining visibility. 
		 * 
		 */
        private function filter(ed:EdgeSprite):Boolean
        {
         	ed.source.fillColor = _colors[ed.source.data.type];
      		ed.source.size		= _sizes[ed.source.data.type]; 
      		ed.target.fillColor = _colors[ed.target.data.type];
      		ed.target.size		= _sizes[ed.target.data.type];   
      		
			if (sFilter(ed) && fcFilter(ed) && tuFilter(ed) && pFilter(ed)){
    			
    			_t.$(ed).visible = true;
      			_t.$(ed).source.visible =  true;
    			_t.$(ed).target.visible = true;

      			if (ed.data.shared == 1){
    				_t.$(ed).lineColor = Colors.rgba(255, 153, 0);
    			} 
    			_preserved.push(ed.source.data.id);
    			_preserved.push(ed.target.data.id);
    			
    			if (!selectedTumourTypes.hasOwnProperty(ed.source.data.id))
    				selectedTumourTypes.push(ed.source.data.id);
    			if (!selectedDatabases.hasOwnProperty(ed.target.data.type))
    				selectedDatabases.push(ed.target.data.type);	
    			

           	}else{
    			ed.visible = false;
    			if (_preserved.indexOf(ed.source.data.id) == -1){
      				_t.$(ed).source.visible =  false;
      			}
      			if (_preserved.indexOf(ed.target.data.id) == -1){
    				_t.$(ed).target.visible 	= false;
      			}
    		}
    		return false;	
        }
        
        /** 
         * search filter 
         * 
         */
        public  function sFilter(ed:EdgeSprite):Boolean
        {
        	var _sfilter:String = searchBox.text.toLowerCase();
      		if (!_sfilter)
      			return true;
      		if (ed.source.data.id.toLowerCase().search(_sfilter) != -1 || ed.target.data.id.toLowerCase().search(_sfilter) != -1 || ed.source.data.gene.toLowerCase().search(_sfilter) != -1 || ed.target.data.gene.toLowerCase().search(_sfilter) != -1)
        		return true;
       		return false	
        } 
        
        /** 
         * Annotation database filter 
         * 
         */
        public  function fcFilter(ed:EdgeSprite):Boolean
        {
        	if (!parentContext.annotationDatabase.length  && searchBox.text)
        	 return true;
        	for each (var ad:String in parentContext.annotationDatabase)
        	{
        		if (ed.source.data.type.toLowerCase() == ad.toLowerCase() || ed.target.data.type.toLowerCase() == ad.toLowerCase())
        			return true;
        	}
       		return false	
        }
        
        /** 
          *	Tumor type filter. 
          * 
          */
        private function tuFilter(ed:EdgeSprite):Boolean
        {
        	if (!parentContext.tumorType.length && searchBox.text)
        		return true;
        	for each (var tt:String in parentContext.tumorType)
        	{
        		if (ed.source.data.id.toLowerCase() == tt.toLowerCase() || ed.target.data.id.toLowerCase() == tt.toLowerCase())
        			return true;
        	}
       		return false		
        }
        
        /**
          * Q-value filter. 
          * 
          */
        private function pFilter(ed:EdgeSprite):Boolean
        {

       		if (!parentContext.pvalue)
        		return true;
        	if ( Number(ed.data.pvalue).valueOf() <= parentContext.pvalue.valueOf())
        		return true;
        	return false		
        }
        
		/**
		 * Node Tooltip 
		 * @param e
		 * 
		 */
		private function updateNodeTooltip(e:TooltipEvent):void
		{
			TextSprite(e.tooltip).htmlText = Strings.format("<b>{0} {1}</b><br> Click to see more details",e.node.data.type,e.node.data.id);
		}
		
		/**
		 * Edge Tooltip 
		 * @param e
		 * 
		 */
		private function updateEdgeTooltip(e:TooltipEvent):void
		{
			TextSprite(e.tooltip).htmlText = Strings.format("<b>{0} - {1}</b>",e.edge.source.data.id,e.edge.target.data.id);
		} 
		
		/**
		 * On click function 
		 * @param e
		 * 
		 */
		private function clickNode(e:SelectionEvent):void
		{
 			switch (e.item.data.type)
 			{
 				case "Tumour":
 					_getTumourDetails(e.item.data);
 					break;
 				case "KEGG":
 					_getKeggDetails(e.item.data.id);
 					break;
 				default:
 					detailBox.removeAllChildren();
 					detailBox.addChild(addInfo("Sorry no details found",10,10));		
 			}
		}
		
		/**
		 * Ged Tumour details 
		 * @param genes
		 * 
		 */
		private function _getTumourDetails(data:Object):void
		{
			detailBox.removeAllChildren();
			if (!data.gene){
				detailBox.addChild(addInfo("Sorry no genes found",10,10));
			}else{
		
				var geneLabel:Label = new Label();
				geneLabel.text = data.id +" tumour type mutated Genes";
				geneLabel.x = 10;
				geneLabel.y = 10;
				var geneList:List = new List;
				geneList.y = 30;
				geneList.width = 360;
				geneList.height = 380;
				geneList.selectable = false;
				var geneArray:Array = data.gene.split(" ");
				geneArray = geneArray.sort();
				geneList.dataProvider = geneArray;
				detailBox.addChild(geneLabel);
				detailBox.addChild(geneList);
			} 
		}
	
		private function _getKeggDetails(id:String):void{
			
			detailBox.removeAllChildren();
			var keggLabel:Label = new Label();
			keggLabel.text = "Pathway details";
			keggLabel.x = 10;
			keggLabel.y = 10;

			var details:Text = new Text;
			details.width = 340;
			details.y = 30;
			
			if (!id)
				Alert.show("Please select a KEGG node","Alert");
			else{	
				//progress
				detailBox.removeAllChildren();
/* 				var keggServ:KeggWs = new KeggWs(parentContext);
				keggServ.getPathwayById(id,function(event:ResultEvent):void{
					
					if (event.result.response){
						for each (var line:String in event.result.response.split("\n")){
							if (line.substr(0,12) == "NAME        " || line.substr(0,12) == "DESCRIPTION " || line.substr(0,12) == "CLASS       " || line.substr(0,12) == "ORGANISM    "){
									details.htmlText += "<b>"+line.substr(0,12)+"</b><br>"+line.substr(12,line.length) +"<br><br>";		
							}
						}
						detailBox.addChild(keggLabel);
						detailBox.addChild(details);						

					}else{
						detailBox.addChild(addInfo("Sorry no details found",10,10));
					}
					parentContext.pb.alpha = 0;
					parentContext.pb.label = "";
				}); */

			}
		}	

	
		
			
	}
}