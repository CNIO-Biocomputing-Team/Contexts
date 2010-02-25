package context.components.literature.biomodels
{
	import context.Context;
	
	import flash.events.TextEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.controls.Text;

	public class BiomodelsClass extends Canvas
	{
		public var parentContext:Context;
		public var pmid:String;
		public var titleLabel:Label;
		public var titleLabelShadow:Label;
		public var infoText:Text;	
		
		public function BiomodelsClass()
		{
			super();
		}
		
		public function render():void
		{
			if (!parentContext.pubmedId)
				Alert.show("Please select an article","Alert");
			else{
				parentContext.listBox.removeAllChildren();
				parentContext.workBox.removeAllChildren();
				pmid = parentContext.pubmedId;
				parentContext.listBox.addChild(this);
				parentContext.workBox.addChild(parentContext.BiomodelsInfoTab);
				
				titleLabel.text = parentContext.articleTitle;
				titleLabelShadow.text = titleLabel.text;
				if (parentContext.articleAbstract)
			    	infoText.htmlText = parentContext.articleAbstract;
			    	
			    else
			    	parentContext.writeMessage('Sorry, no abstract found in PubMed');	
			   
			}
		}
		
		public function textLink(evt:TextEvent):void
		{
/* 			
			
			var link:Array = evt.text.split('|');
			var command:String = link[0];
			var label:String = link[1];
			var data:String = link[2];
			
			switch (command){
				case 'protein':
					
				    proteinPopup(evt,data,label);
					break;
			} */
		}
		
	}
}