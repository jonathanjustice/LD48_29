﻿package {
	import flash.events.MouseEvent;
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import Screens.default_screen;
	import customEvents.SoundEvent;
	import customEvents.StateMachineEvent;
	import customEvents.GameEvent;
	public class ParticleContainer extends MovieClip{
		public var desiredX:int=0;
		public var desiredY:int=0;
		private var multiplierX:Number=.1;
		private var multiplierY:Number=.1;
		private var lerping:Boolean=true;
		private var shakeTimer:int=0;
		private var maxShakeTime=30;
		private var originalMaxShakeTime:int=30;
		private var shakeCount:int=0;
		private var isShaking:Boolean=false;
		private var shakeMode:String="NONE";
		private var previousShakeMode:String="NONE";
		private var shakeRandomNess:Point = new Point();
		private var screenFlash;
		public function ParticleContainer (){
			stop();
			//setUp();
			Main.theStage.addEventListener(GameEvent.SCREEN_SHAKE, shakeScreen);
		}
		
		private function resetShakeRandomNess():void{
			shakeRandomNess.x=20;
			shakeRandomNess.y=10;
		}
		
		private function resetShake():void{
			maxShakeTime = originalMaxShakeTime;
			setMultiplier(.37,.37);
			desiredX = 0;
			desiredY = 0;
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
					shakeRandomNess.x=20;
					shakeRandomNess.y=10;
					break;
			}
		}
		
		public function screenShake():void{
			//trace("screenShake");
			if(isShaking == true){
				shakeTimer++
				desiredX = Math.random()*shakeRandomNess.x - shakeRandomNess.y;
				desiredY = Math.random()*shakeRandomNess.x - shakeRandomNess.y;
			}
			if(shakeTimer >= maxShakeTime){
				screenShakeComplete();
			}
		}
		
		public function screenShakeComplete():void{
			//trace("screenShakeComplete",shakeMode);
			switch(shakeMode){
				case "NONE":
					//sdfjsd;fjsd
					break;
				case "C_RECT":
					setScreenShake(true,"NONE");
					break;
			}
		}
		
		
		
		
		
		
		public function updateLoop():void{
			screenShake();
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