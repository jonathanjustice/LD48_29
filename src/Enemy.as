package {
	import flash.events.MouseEvent;
	import flash.events.*;
	import flash.display.MovieClip;
	import Screens.default_screen;
	import customEvents.SoundEvent;
	import customEvents.StateMachineEvent;
	import customEvents.GameEvent;
	import flash.geom.Point;
	public class Enemy extends default_screen{
		public var isPaused:Boolean=false;
		private var KEY_LEFT:Boolean=false;
		private var KEY_RIGHT:Boolean=false;
		private var KEY_UP:Boolean=false;
		private var KEY_DOWN:Boolean=false;
		private var velocity:Point = new Point();
		private var maxVelocity:Point = new Point();
		private var defaultMaxVelocity:int = 5;
		private var desiredXVelocity:Number = 0;
		private var desiredYVelocity:Number = 0;
		private var lerpingToVelocity:Boolean=true;
		private var multiplierX:Number=.15;
		private var multiplierY:Number=.15;
		private var fallHeight:Number=1;
		private var fallHeightMax:Number=100;
		private var fallVelocity:Number=1.0001;
		private var fallVelocityMultiplier:Number=1.0001;
		private var heightMultiplier:Number=0;
		public var isCollisionActive:Boolean=false;
		public var collisionDamage:int=1;
		private var hasCollided:Boolean=false;
		public var hitboxes:Array;
		public function Enemy (){
			stop();
			stopAllButtonsFromAnimating();
			setUp();
		}
		
		public override function setUp():void {
			hitboxes = new Array();
			selectEnemyType();
			this.scaleX = 0;
			this.scaleY = 0;
			seedRandomSpawnPoint();
			//this.x = 275;
			//this.y = 200;
			//addDynamicBlocker();
			mouseEnabledHandler();
			addAllListeners();
			//addScreenToUIContainer();
			//addScreenToGameContainer();
			addScreenToGameContainerAtBottom();
			addKeyListeners();
			this.addEventListener(Event.ENTER_FRAME, updateloop);
			resetVelocity();
			setMaxVelocity(0,0);
			velocity.x = 0;
			velocity.y = 0;
			maxVelocity.x = defaultMaxVelocity;
			maxVelocity.y = defaultMaxVelocity;
			lerpingToVelocity = false;
			assignHitboxes();
		}
		
		private function assignHitboxes():void{
			for(var i:int=0;i<this.numChildren;i++){
				if(this.getChildAt(i).name.indexOf("hitbox") != -1){
					hitboxes.push(this.getChildAt(i));
					this.getChildAt(i).visible=false;
				}
			}
		}
		
		private function selectEnemyType():void{
			var newType:int = Math.random()*10;
			this.gotoAndStop(newType);
		}
		
		private function seedRandomSpawnPoint():void{
			this.x = 275+(Math.random()*500-250);
			this.y = 200+(Math.random()*500-250);
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
			if(!isPaused){
				if(KEY_LEFT){
					desiredXVelocity = .25+ maxVelocity.x*heightMultiplier*1.25;
					lerpingToVelocity = true;
					//this.x -=3;
				}
				if(KEY_RIGHT){
					desiredXVelocity = -.25+ -maxVelocity.x*heightMultiplier*1.25;
					lerpingToVelocity = true;
					//this.x +=3;
				}
				if(KEY_UP){
					 desiredYVelocity = .25+ maxVelocity.y*heightMultiplier*1.25;
					lerpingToVelocity = true;
					//this.y -=3;
				}
				if(KEY_DOWN){
					desiredYVelocity = -.25+ -maxVelocity.y*heightMultiplier*1.25;
					lerpingToVelocity = true;
					//this.y +=3;
				}
				lerpToVelocity();
				fall();
			}
		}
		
		public function fall():void{
			fallVelocityMultiplier = fallVelocityMultiplier*fallVelocity;
			fallHeight = fallHeight * fallVelocityMultiplier;
			this.scaleX = fallHeight / fallHeightMax;
			this.scaleY = this.scaleX;
			heightMultiplier = this.scaleX;
			if(fallHeight > 950){
				if(!hasCollided){
					isCollisionActive = true;
				}
			}else{
				isCollisionActive = false;
			}
			
			
			if(fallHeight > 1000){
				isCollisionActive = false;
				this.removeEventListener(Event.ENTER_FRAME, updateloop);
				removeThisGameObject();
			}
			//weird shit
			//this.x += fallVelocityMultiplier*1.5*(this.x - 275)/100;
			//this.y += fallVelocityMultiplier*1.5*(this.y - 200)/100;
			/*if(this.x < 275){
				
			}else{
				
			}*/
			
		}
		
		public override function removeThisGameObject():void{
			var index:int = Main.enemies.indexOf(this);
			Main.enemies.splice(index,1);
			Main.gameContainer.removeChild(this);
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