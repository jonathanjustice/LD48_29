package {
	import flash.events.MouseEvent;
	import flash.events.*;
	import flash.display.MovieClip;
	import Screens.default_screen;
	import customEvents.SoundEvent;
	import customEvents.StateMachineEvent;
	import customEvents.GameEvent;
	import flash.geom.Point;
	public class SCREEN_START extends default_screen{
		private var scrollCounter:int=0;
		private var particleSystem:ParticleSystem;
		private var countdownTimer:int=0;
		public function SCREEN_START (){
			//play();
			stop();
			stopAllButtonsFromAnimating();
			setUp();
			particleSystem = new ParticleSystem(this);
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
		
		public function getLocation():Point{
			var spawnPoint:Point = new Point();
			spawnPoint.x = 245;
			spawnPoint.y = 185;
			return spawnPoint;
		}
		
		public function getVelocity():Point{
			var spawnPoint:Point = new Point();
			spawnPoint.x = -50;
			spawnPoint.y = -30;
			return spawnPoint;
		}
		
		public function getScale():Number{
			var spawnPoint:Number=1;
			return spawnPoint;
		}
		
		
		public function getLocationEXPLOSION():Point{
			var spawnPoint:Point = new Point();
			spawnPoint.x = 245;
			spawnPoint.y = 185;
			return spawnPoint;
		}
		
		public function getVelocityEXPLOSION():Point{
			var spawnPoint:Point = new Point();
			spawnPoint.x = -10;
			spawnPoint.y = -10;
			return spawnPoint;
		}
		
		public function getScaleEXPLOSION():Number{
			var spawnPoint:Number=1;
			return spawnPoint;
		}
		
		public function playRemoveScreenAnimation(e:Event):void{
			//this.alpha -=.001;
			countdownTimer++;
			particleSystem.playMode("FIRE");
			if(countdownTimer >= 190){
				particleSystem.playMode("EXPLODE");
				dispatchEvent(new GameEvent("SCREEN_SHAKE","SCREEN_SHAKE"));
			}
			if(countdownTimer == 199){
				this.btn_start.spaceship.gotoAndPlay("explosion");
				particleSystem.playMode("EXPLODE");
				dispatchEvent(new GameEvent("SCREEN_SHAKE","SCREEN_SHAKE"));
			}
			if(countdownTimer >= 200){
				particleSystem.playMode("EXPLODE");
				dispatchEvent(new GameEvent("SCREEN_SHAKE","SCREEN_SHAKE"));
			}
			if(countdownTimer >= 240){
				dispatchEvent(new GameEvent("SCREEN_SHAKE","SCREEN_SHAKE"));
				dispatchEvent(new GameEvent("SCREEN_FLASH_WHITE","SCREEN_FLASH_WHITE"));
				this.alpha = 0;
				this.removeEventListener(Event.ENTER_FRAME, playRemoveScreenAnimation);
				stage.dispatchEvent(new StateMachineEvent("CHANGE_GAME_STATE","START_NEW_GAME"));
				removeThisScreen();
				particleSystem.playMode("NONE");
				particleSystem.abortAll();
			}
		}
		
		public override function clickHandler(event:MouseEvent):void{
			//defined in other classes
			//trace("event.target.parent.name:", event.target.parent.name);
			switch(event.target.parent.name){
				case "btn_start":
					//do stuff
					removeAllListeners();
					this.btn_start.gotoAndStop("clicked");
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