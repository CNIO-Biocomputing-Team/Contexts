package context.tabs.proteins.sequence
{
	import context.Context;
	import context.Tab;
	import context.components.proteins.sequence.ProteinSequenceClass;
	
	import mx.containers.Canvas;
	import mx.containers.VBox;
	import mx.controls.Alert;

	public class ProteinSequence extends Tab
	{
		public var mainCanvas:Canvas;
		public var rightBar:VBox;
		
		public function ProteinSequence(parent:Context)
		{
			super();
		}
		
		public function render():void
		{
			
			if (!parentContext.uniprotId)
				Alert.show("Please select a protein","Alert");
			else{
				parentContext.workBox.removeAllChildren();
			}
		}
	}
}