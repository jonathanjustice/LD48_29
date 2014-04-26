package{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.*;
	import flash.events.MouseEvent;
	import flash.display.*;
	import flash.ui.Mouse;
	import customEvents.SoundEvent;
	import customEvents.StateMachineEvent;
	import Audio.SoundManager;
	import Audio.SoundObject;
	import Screens.*;
	public class Main extends MovieClip{
		private var soundManager:SoundManager;
		public static var theStage:Object;
		public static var uiContainer:UiContainer;
		public static var gameContainer:GameContainer;
		public static var backgroundContainer:MovieClip;
		private static var enemies:Array;
		private var isPaused:Boolean = false;
		
		
		private var enemyCounter:int=0;
		private var enemyCountMax:int=30;
		
		//Screens
		
		//public static var screen_start:MovieClip;
		public static var screen_start:MovieClip;
		
		//game objects
		public static var avatar:MovieClip;
		public function Main(){
			//trace("hello world");
			if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//once the stage exists, launch the game
        private function init(e:Event = null):void {
            removeEventListener(Event.ADDED_TO_STAGE, init);
			theStage = this.stage;
			uiContainer = new UiContainer();
			gameContainer = new GameContainer();
			backgroundContainer = new MovieClip();
			enemies = new Array();
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			//stage.displayState = StageDisplayState.FULL_SCREEN;
			setUp();
        }
		//Main.theStage.dispatchEvent(new SoundEvent("SOUND_START","ENEMY_PICKED_UP"));
		private function setUp():void{
			stage.addChild(backgroundContainer);
			stage.addChild(gameContainer);
			stage.addChild(uiContainer);
			Main.theStage.addEventListener(StateMachineEvent.CHANGE_GAME_STATE, changeGameState);
			soundManager = new SoundManager(theStage);
			getStage().dispatchEvent(new StateMachineEvent("CHANGE_GAME_STATE","INIT_START_SCREEN"));
		}
		
		public function getStage():Object{
			return theStage;
		}
		
		public function getUiContainer():Object{
			return uiContainer;
		}
		
		public function getMain():Object{
			return this;
		}
		
		public function changeGameState(event:StateMachineEvent):void{
			//trace(event.result);
			switch(event.result){
				case "INIT_START_SCREEN":
					screen_start = new SCREEN_START();
					//getStage().dispatchEvent(new SoundEvent("SOUND_START","TEST_SOUND"));
					//do stuff
					break;
				case "START_NEW_GAME":
					this.addEventListener(Event.ENTER_FRAME, mainUpdateLoop);
					//do stuff
					avatar = new Avatar();
					break;
				case "newGame":
					//do stuff
					break;
				case "resumeUpdateLoop":
					isPaused = false;
					//do stuff
					break;
				case "pauseUpdateLoop":
					isPaused = true;
					//do stuff
					break;
			}
		}
		
		private function mainUpdateLoop(e:Event):void{
			if(!isPaused){
				//trace("gogogo");
				//SPAWN NEW ENEMIES
				enemyCounter+=1;
				if(enemyCounter >= enemyCountMax){
					var enemy:Enemy = new Enemy();
					enemies.push(enemy);
					enemyCounter=0;
				}
				//CHECK FOR COLLISION WITH ENEMIES
				for(var i:int=0;i<enemies.length;i++){
					if(enemies[i].hitbox.hitTestObject(avatar.hitbox)){
						if(enemies[i].isCollisionActive){
							trace("collisions!")
						}
					}
				}
				//SCREEN SHAKE FOR CONTAINERS
				gameContainer.updateLoop();
				uiContainer.updateLoop();
			}
		}
	}
}