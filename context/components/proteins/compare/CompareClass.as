package context.components.proteins.compare
{
	import context.Context;
	
	import mx.containers.Canvas;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.rpc.events.ResultEvent;
	
	import services.UniprotWs;

	public class CompareClass extends Canvas
	{
		public var compareProteinGrid:DataGrid;
		public var parentContext:Context;
		public var totalProtein:int;
		public var proteinCount:int;
		public var tmpTissue:Object;
		public var tmpSlocation:Object;
		public var tmpFunction:Object;
		public var compareData:Array;
		
		public function CompareClass()
		{
			super();
		}
		
		public function render():void
		{
			doSearch(parentContext.uniprotIdList);
			
		}
		
		
		public function doSearch(proteins:Array):void
		{
			parentContext.workBox.removeAllChildren();
			parentContext.workBox.addChild(this);
			compareProteinGrid.dataProvider = new Array();
			compareProteinGrid.columns = new Array();
			
			compareData = new Array();
			tmpTissue = new Object();
			tmpSlocation = new Object();
			tmpFunction = new Object();
			totalProtein = parentContext.uniprotIdCompareList.length;
			proteinCount = 0;
			tmpTissue.feature = 'Tissue';
			tmpSlocation.feature = 'Subcellular location';
			tmpFunction.feature = 'Function';
			
			parentContext.loadingLabel.visible = true;
			
			if (totalProtein){
				
				for each (var uniprotId:String in parentContext.uniprotIdCompareList){
						if (uniprotId){
							addProteinColumn(uniprotId);
							getProteinInfo(uniprotId);
						}	
				}
				
				
				parentContext.loadingLabel.visible = false;
			}
		}
		
		private function addProteinColumn(uniprotId:String):void
		{
			 var dgc:DataGridColumn = new DataGridColumn(uniprotId);
			 dgc.wordWrap = true;
                var cols:Array = compareProteinGrid.columns;
                cols.push(dgc);
                compareProteinGrid.columns = cols;
		}
		
		private function getProteinInfo(uniprotId:String):void
		{
			var functions:Array = new Array();
			var tissues:Array = new Array();
			var slocations:Array = new Array();
			
			var uniprotAnnotServ:UniprotWs = new UniprotWs(parentContext);
			uniprotAnnotServ.getUniprotAnnot(uniprotId,function(event:ResultEvent):void{
				
				if (event.result){
					
					
					var entry:Object = event.result.uniprot.entry;	
					
					/* References */				
					if (entry.reference.hasOwnProperty('0')){	
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
					if (entry.comment.hasOwnProperty('0')){	
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
					
					if (tissues.length)
						tmpTissue[uniprotId] = tissues.join(',');
					if (slocations.length)
						tmpSlocation[uniprotId] = slocations.join(',');
					if (functions.length)
						tmpFunction[uniprotId] = functions.join(',');		

					proteinCount++;
					if (proteinCount == totalProtein){
						compareData.push(tmpTissue);
						compareData.push(tmpSlocation);
						compareData.push(tmpFunction);
						compareProteinGrid.dataProvider = compareData;
						parentContext.uniprotIdCompareList = new Array();
					}
					
				}
			});
		}
	}
}