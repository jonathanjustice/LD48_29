package {
	import flash.events.MouseEvent;
	import flash.events.*;
	import flash.display.MovieClip;
	import Screens.default_screen;
	import customEvents.SoundEvent;
	import customEvents.StateMachineEvent;
	public class SCREEN_START extends default_screen{
		private var scrollCounter:int=0;
		public function SCREEN_START (){
			//play();
			stop();
			stopAllButtonsFromAnimating();
			setUp();
			this.addEventListener(Event.ENTER_FRAME, backgroundScroll);
		}
		
		public function backgroundScroll(e:Event):void{
			scrollCounter++;
			if(scrollCounter>=10){
				nextFrame();
				scrollCounter=0;
				if(currentFrame ==300){
					trace("100");
					gotoAndStop(1);
				}
			}
		}
		
		public function playRemoveScreenAnimation(e:Event):void{
			this.alpha -=.05;
			if(this.alpha <= 0){
				this.alpha = 0;
				this.removeEventListener(Event.ENTER_FRAME, playRemoveScreenAnimation);
				stage.dispatchEvent(new StateMachineEvent("CHANGE_GAME_STATE","START_NEW_GAME"));
				removeThisScreen();
			}
		}
		
		public override function clickHandler(event:MouseEvent):void{
			//defined in other classes
			//trace("event.target.parent.name:", event.target.parent.name);
			switch(event.target.parent.name){
				case "btn_start":
					//do stuff
					this.addEventListener(Event.ENTER_FRAME, playRemoveScreenAnimation);
					break;
			}
		}
		
		public override function stageClickHandler(event:MouseEvent):void{
			//defined in other classes
		}
		
		public override function downHandler(event:MouseEvent):void {
			//trace(event.target.name);
			if (event.target.name.indexOf("hitbox") != -1) {
				event.target.parent.gotoAndStop("clicked");
			}
		}
		
		public override function upHandler(event:MouseEvent):void {
			//trace(event.target.name);
			if (event.target.name.indexOf("hitbox") != -1) {
				event.target.parent.gotoAndStop("up");
			}
		}
		
		public override function overHandler(event:MouseEvent):void {
			//trace(event.target.name);
			if (event.target.name.indexOf("hitbox") != -1) {
				event.target.parent.gotoAndStop("over");
			}
		}
		
		public override function outHandler(event:MouseEvent):void {
			//trace(event.target.name);
			if (event.target.name.indexOf("hitbox") != -1) {
				event.target.parent.gotoAndStop("up");
			}
		}
	}
}