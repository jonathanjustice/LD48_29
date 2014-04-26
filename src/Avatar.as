package {
	import flash.events.MouseEvent;
	import flash.events.*;
	import flash.display.MovieClip;
	import Screens.default_screen;
	import customEvents.SoundEvent;
	import customEvents.StateMachineEvent;
	import flash.geom.Point;
	public class Avatar extends default_screen{
		private var KEY_LEFT:Boolean=false;
		private var KEY_RIGHT:Boolean=false;
		private var KEY_UP:Boolean=false;
		private var KEY_DOWN:Boolean=false;
		private var velocity:Point = new Point();
		private var maxVelocity:Point = new Point();
		private var defaultMaxVelocity:int = 5;
		private var desiredXVelocity:int = 0;
		private var desiredYVelocity:int = 0;
		private var lerpingToVelocity:Boolean=true;
		private var multiplierX:Number=.01;
		private var multiplierY:Number=.01;
		public function Avatar (){
			stop();
			stopAllButtonsFromAnimating();
			setUp();
		}
		
		public override function setUp():void {
			this.x = 275;
			this.y = 200;
			//addDynamicBlocker();
			mouseEnabledHandler();
			addAllListeners();
			//addScreenToUIContainer();
			addScreenToGameContainerAtTop();
			addKeyListeners();
			this.addEventListener(Event.ENTER_FRAME, updateloop);
			resetVelocity();
			setMaxVelocity(0,0);
			velocity.x = 0;
			velocity.y = 0;
			maxVelocity.x = defaultMaxVelocity;
			maxVelocity.y = defaultMaxVelocity;
			lerpingToVelocity = false;
			hitbox.visible=false;
		}
		
		public function resetVelocity():void{
			velocity.x = 0;
			velocity.y = 0;
		}
		
		public function setMaxVelocity(newX:int,newY:int):void{
			
			maxVelocity.x = newX;
			maxVelocity.y = newY;
		}
		
		public function lerpToVelocity():void{
			if(lerpingToVelocity){
				var lerpAmountX:Number = (desiredXVelocity-velocity.x)*multiplierX;
				velocity.x += lerpAmountX;
				var lerpAmountY:Number = (desiredYVelocity-velocity.y)*multiplierY;
				velocity.y += lerpAmountY;
			}
			/*if(Math.abs(desiredX-this.x) > 0){
				resumeLerping();
			}*/
			this.x += velocity.x;
			this.y += velocity.y;
			this.pilots.x += velocity.x *.5;
			this.pilots.y += velocity.y *.5;
			if(this.x < 225){
				this.x = 225;
				velocity.x=0;
			}
			if(this.x > 325){
				this.x = 325;
				velocity.x=0;
			}
			if(this.y < 150){
				this.y = 150;
				velocity.y=0;
			}
			if(this.y > 250){
				this.y = 250;
				velocity.y=0;
			}
			doSpecial();
		}
		
		private function addKeyListeners():void{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
		}
		
		private function keyPressed(e:KeyboardEvent){
			switch(e.keyCode){
				case 37:
					//trace("37");
					KEY_LEFT = true;
					break;
				case 38:
					//trace("38");
					KEY_UP = true;
					break;
				case 39:
					//trace("39");
					KEY_RIGHT = true;
					break;
				case 40:
					//trace("40");
					KEY_DOWN = true;
					break;
			}
		}
		
		private function keyReleased(e:KeyboardEvent){
			switch(e.keyCode){
				case 37:
					//trace("37");
					KEY_LEFT = false;
					desiredXVelocity = 0;
					break;
				case 38:
					//trace("38");
					KEY_UP = false;
					desiredYVelocity = 0;
					break;
				case 39:
					//trace("39");
					KEY_RIGHT = false;
					desiredXVelocity = 0;
					break;
				case 40:
					//trace("40");
					KEY_DOWN = false;
					desiredYVelocity = 0;
					break;
			}
		}
		
		public function updateloop(e:Event):void{
			if(KEY_LEFT){
				desiredXVelocity = -maxVelocity.x;
				lerpingToVelocity = true;
				//this.x -=3;
			}
			if(KEY_RIGHT){
				desiredXVelocity = maxVelocity.x;
				lerpingToVelocity = true;
				//this.x +=3;
			}
			if(KEY_UP){
				 desiredYVelocity = -maxVelocity.y;
				lerpingToVelocity = true;
				//this.y -=3;
			}
			if(KEY_DOWN){
				desiredYVelocity = maxVelocity.y;
				lerpingToVelocity = true;
				//this.y +=3;
			}
			lerpToVelocity();
		}
		
		public override function clickHandler(event:MouseEvent):void{
			//defined in other classes
			trace("event.target.parent.name:", event.target.parent.name);
			switch(event.target.parent.name){
				case "btn_start":
					//do stuff
					trace("start");
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