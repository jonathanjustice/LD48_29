package {
	import flash.events.MouseEvent;
	import flash.events.*;
	import flash.display.MovieClip;
	import Screens.default_screen;
	import customEvents.SoundEvent;
	import customEvents.StateMachineEvent;
	import customEvents.GameEvent;
	import flash.geom.Point;
	public class Avatar extends default_screen{
		private var KEY_LEFT:Boolean=false;
		private var KEY_RIGHT:Boolean=false;
		private var KEY_UP:Boolean=false;
		private var KEY_DOWN:Boolean=false;
		private var velocity:Point = new Point();
		private var pilotVelocity:Point = new Point();
		private var maxVelocity:Point = new Point();
		private var defaultMaxVelocity:int = 5;
		private var desiredXVelocity:Number = 0;
		private var desiredYVelocity:Number = 0;
		private var pilotDesiredX:Number = 0;
		private var pilotDesiredY:Number = 0;
		private var lerpingToVelocity:Boolean=true;
		private var multiplierX:Number=.01;
		private var multiplierY:Number=.01;
		//screenshake crap
		private var shakeTimer:int=0;
		private var maxShakeTime=30;
		private var originalMaxShakeTime:int=30;
		private var shakeCount:int=0;
		private var isShaking:Boolean=false;
		private var shakeMode:String="NONE";
		private var previousShakeMode:String="NONE";
		private var shakeRandomNess:Point = new Point();
		private var health:int = 0;
		private var maxHealth:int = 10;
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
			pilotVelocity.x = 0;
			pilotVelocity.y = 0;
			maxVelocity.x = defaultMaxVelocity;
			maxVelocity.y = defaultMaxVelocity;
			lerpingToVelocity = false;
			hitbox.visible=false;
			Main.theStage.addEventListener(GameEvent.SCREEN_SHAKE, shakeScreen);
			windshield.stop();
		}
		
		public function resetVelocity():void{
			velocity.x = 0;
			velocity.y = 0;
			pilotVelocity.x = 0;
			pilotVelocity.y = 0;
		}
		
		public function setMaxVelocity(newX:int,newY:int):void{
			maxVelocity.x = newX;
			maxVelocity.y = newY;
		}
		
		public function lerpToVelocity():void{
			if(lerpingToVelocity){
				var lerpAmountX:Number = (desiredXVelocity-velocity.x)*multiplierX;
				var lerpAmountY:Number = (desiredYVelocity-velocity.y)*multiplierY;
				velocity.x += lerpAmountX;
				velocity.y += lerpAmountY;
				//pilotVelocity.x = lerpAmountX + pilotDesiredX-pilots.x;
				//pilotVelocity.y = lerpAmountY + pilotDesiredY-pilots.y;
			}
			/*if(Math.abs(desiredX-this.x) > 0){
				resumeLerping();
			}*/
			//trace("p",pilotVelocity);
			//trace("v",velocity);
			//this.seats.x += velocity.x*.5;
			//this.seats.y += velocity.y*.5;
			//this.pilots.x += pilotVelocity.x*1;
			//this.pilots.y += pilotVelocity.y*1;
			//this.seats.x += pilotVelocity.x *.2;
			//this.seats.y += pilotVelocity.y *.2;
			this.x += velocity.x;
			this.y += velocity.y;
			this.pilots.x += velocity.x*.5;
			this.pilots.y += velocity.y*.5;
			this.seats.x += velocity.x*.25;
			this.seats.y += velocity.y*.25;
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
			screenShake();
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
		
		
		
		
		//SCREENSHAKE
		
		private function resetShakeRandomNess():void{
			shakeRandomNess.x=60;
			shakeRandomNess.y=30;
		}
		
		private function resetShake():void{
			maxShakeTime = originalMaxShakeTime;
			setMultiplier(.37,.37);
			pilotDesiredX = 0;
			pilotDesiredX = 0;
		}
		
		public function shakeScreen(event:GameEvent):void{
			setScreenShake(true,"C_RECT");
		}
		
		public function setScreenShake(newState:Boolean,newMode:String="NONE"):void{
			//trace("setScreenShake",shakeMode);
			isShaking = newState;
			previousShakeMode = shakeMode;
			shakeMode = newMode;
			switch(shakeMode){
				case "NONE":
				
					shakeTimer=0;
					isShaking = false;
					resetShake();
					break;
				case "C_RECT":
					shakeTimer=0;
					maxShakeTime = 10;
					shakeRandomNess.x=60;
					shakeRandomNess.y=30;
					break;
			}
		}
		
		public function screenShake():void{
			//trace("screenShake");
			if(isShaking == true){
				shakeTimer++;
				desiredXVelocity += Math.random()*shakeRandomNess.x - shakeRandomNess.y;
				desiredXVelocity += Math.random()*shakeRandomNess.x - shakeRandomNess.y;
			}
			if(shakeTimer >= maxShakeTime){
				screenShakeComplete();
				pilotDesiredX = 0;
				pilotDesiredY = 0;
			}
		}
		
		public function screenShakeComplete():void{
			//trace("screenShakeComplete",shakeMode);
			switch(shakeMode){
				case "NONE":
					//sdfjsd;fjsd
					resetShake();
					break;
				case "C_RECT":
					setScreenShake(true,"NONE");
					break;
			}
		}
		
		public function deductHealth(amountToDeduct:int):void{
			health += amountToDeduct;
			windshield.gotoAndStop(health);
			if(health >= maxHealth){
				Main.theStage.dispatchEvent(new StateMachineEvent("CHANGE_GAME_STATE","GAME_OVER"));
			}
		}
	}
}