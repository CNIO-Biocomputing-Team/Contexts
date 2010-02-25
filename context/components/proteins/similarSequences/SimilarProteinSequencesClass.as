package context.components.proteins.similarSequences
{
	import context.Context;
	
	import mx.containers.Canvas;
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;

	public class SimilarProteinSequencesClass extends Canvas
	{
		public var parentContext:Context;
		public var proteinListGrid:DataGrid;
		
		public function SimilarProteinSequencesClass()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandler);
		}
		
		private function creationCompleteHandler(event:FlexEvent):void
		{
			proteinListGrid.addEventListener(ListEvent.ITEM_CLICK,function(e:ListEvent):void{
							 parentContext.uniprotId = e.itemRenderer.data.uniprotId;
							 parentContext.updateProteinMenu(true);
							 parentContext.updatePathwaysMenu(false);
							 parentContext.updateSyntheticPartsMenu(false);
							 parentContext.writeTip("Select an option from the PROTEINS menu");
			});
		}
		
		public function render(xml:Object):void
		{
			var data:Array = new Array();
			
			if (xml){
				if (xml.info){

				}else{
					parentContext.listBox.removeAllChildren();
					parentContext.workBox.removeAllChildren();
					parentContext.listBox.addChild(this);
					for each (var synonym:Object in xml.synonyms.synonym){
						var tmp:Object = new Object();
						tmp.uniprotId = synonym.blast.ac;
						tmp.description = synonym.blast.description;
						tmp.length = synonym.blast.length;
						tmp.identity = synonym.blast.identity;
						tmp.score = synonym.blast.score;
						tmp.expectation = synonym.blast.expectation; 
						if (synonym.ncbi)
							tmp.taxonomy = synonym.ncbi.organism;
						data.push(tmp);
					}
					proteinListGrid.dataProvider = data;
					parentContext.loadingLabel.visible = false;
					parentContext.uniprotLoader.visible = false;
				}
			}	
		}
		
	}
}