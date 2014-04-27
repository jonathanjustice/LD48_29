package {
	import flash.events.MouseEvent;
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import Screens.default_screen;
	import customEvents.SoundEvent;
	import customEvents.StateMachineEvent;
	import customEvents.GameEvent;
	public class ScreenFlash extends MovieClip{
		
		public function ScreenFlash (){
			stop();
			visible = false;
			//setUp();
			Main.theStage.addEventListener(GameEvent.SCREEN_FLASH_RED, screenFlashRed);
			Main.theStage.addEventListener(GameEvent.SCREEN_FLASH_WHITE, screenFlashWhite);
			Main.theStage.addEventListener(GameEvent.SCREEN_FLASH_OFF, screenFlashOff);
		}
		
		public function screenFlashRed(event:GameEvent):void{
			gotoAndStop("red");
			setScreenFlash(1);
		}
		
		public function screenFlashWhite(event:GameEvent):void{
			gotoAndStop("white");
			setScreenFlash(1);
		}
		
		public function screenFlashOff(event:GameEvent):void{
			resetScreenFlash();
		}
		
		public function resetScreenFlash():void{
			visible=false;
			alpha = 0;
		}
		
		public function setScreenFlash(newAlpha:Number):void{
			alpha = newAlpha;
			visible = true;
		}
		
		public function updateScreenFlash():void{
			//trace("screenFlash",screenFlash );
			if(alpha > 0){
				alpha -= .05;
			}else{
				visible = false;
				alpha = 0;
			}
		}
	
		public function updateLoop():void{
			updateScreenFlash();
		
		}
	}
}