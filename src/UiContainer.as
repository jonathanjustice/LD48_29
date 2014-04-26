package {
	import flash.events.MouseEvent;
	import flash.events.*;
	import flash.display.MovieClip;
	import Screens.default_screen;
	import customEvents.SoundEvent;
	import customEvents.StateMachineEvent;
	public class UiContainer extends MovieClip{
		public var desiredX:int=0;
		public var desiredY:int=0;
		private var multiplierX:Number=.1;
		private var multiplierY:Number=.1;
		private var lerping:Boolean=true;
		public function UiContainer (){
			stop();
			//setUp();
		}
		
		
		public function updateLoop():void{
			lerpToPosition();
		
		}
		
		public function setMultiplier(newAmountX:Number,newAmountY:Number):void{
			multiplierX = newAmountX;
			multiplierY = newAmountY;
		}
		
		public function lerpToPosition():void{
			if(lerping){
				var lerpAmountX:Number = (desiredX-this.x)*multiplierX;
				this.x += lerpAmountX;
				var lerpAmountY:Number = (desiredY-this.y)*multiplierY;
				this.y += lerpAmountY;
			}
			if(Math.abs(desiredX-this.x) > 0){
				resumeLerping();
			}
			doSpecial();
		}
		
		public function doSpecial():void{
			//do stuff in descendent classes
			
		}
		
		public function resumeLerping():void{
			lerping = true;
		}
		
		public function pauseLerping():void{
			lerping = false;
		}
		
		public function setDesiredLerpPoint(newX:Number,newY:Number):void{
			desiredX = newX;
			desiredY = newY;
		}
		
		public function setMouseCoordinates(newX:Number,newY:Number):void{
			desiredX = newX;
			desiredY = newY;
		}
		
	}
}