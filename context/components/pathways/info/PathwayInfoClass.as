package context.components.pathways.info
{
	import context.Context;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.Image;
    import flash.events.Event;

	public class PathwayInfoClass extends Canvas
	{
		public var parentContext:Context;
		public var pathwayMap:Image;
		
		public function PathwayInfoClass()
		{
			super();
		}
		
		public function render():void
		{
			var img_prefix:String = "http://www.kegg.jp/kegg/pathway/";
			var organism:String;
			
			if (!parentContext.pathwayId)
				Alert.show("Please select a pathway","Alert");
			else{	
				parentContext.loadingLabel.visible = true;
				organism = parentContext.pathwayId.substr(0,3);
				parentContext.workBox.removeAllChildren();
				parentContext.workBox.addChild(this);
				pathwayMap.addEventListener(Event.COMPLETE, imgComplete);
				pathwayMap.load(img_prefix+organism+'/'+parentContext.pathwayId+".png");
			}
		}
		
		private function imgComplete(evt:Event):void
		{
			pathwayMap.visible = true;
			parentContext.loadingLabel.visible = false;
		}		
		
	}
}