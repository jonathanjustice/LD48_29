package{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.*;
	import flash.events.MouseEvent;
	import flash.display.*;
	import flash.ui.Mouse;
	import customEvents.SoundEvent;
	import customEvents.StateMachineEvent;
	import customEvents.GameEvent;
	import Audio.SoundManager;
	import Audio.SoundObject;
	import Screens.*;
	public class Main extends MovieClip{
		private var soundManager:SoundManager;
		public static var theStage:Object;
		public static var uiContainer:UiContainer;
		public static var gameContainer:GameContainer;
		public static var backgroundContainer:MovieClip;
		public static var enemies:Array;
		private static var screenFlash:ScreenFlash;
		private var isPaused:Boolean = false;
		private var gameOverTimer:int=0;
		private var gameOverMaxTime:int=30;
		
		
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
			screenFlash = new ScreenFlash();
			backgroundContainer = new MovieClip();
			enemies = new Array();
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//stage.scaleMode = StageScaleMode.EXACT_FIT;
			//stage.displayState = StageDisplayState.FULL_SCREEN;
			setUp();
        }
		//Main.theStage.dispatchEvent(new SoundEvent("SOUND_START","ENEMY_PICKED_UP"));
		private function setUp():void{
			stage.addChild(backgroundContainer);
			stage.addChild(gameContainer);
			stage.addChild(uiContainer);
			stage.addChild(screenFlash);
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
					isPaused = false;
					this.addEventListener(Event.ENTER_FRAME, mainUpdateLoop);
					//do stuff
					avatar = new Avatar();
					break;
				case "GAME_OVER":
					//this.addEventListener(Event.ENTER_FRAME, mainUpdateLoop);
					//do stuff
					isPaused = true;
					for(var i:int=0;i<enemies.length;i++){
						enemies[i].isPaused = true;
					}
					startGameOverAnimation();
					break;
				case "newGame":
					//do stuff
					break;
				case "RESET_GAME":
					trace("reset game");
					removeAndDisableEverything();
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
		
		private function removeAndDisableEverything():void{
			for(var i:int=0;i<enemies.length;i++){
				trace(enemies);
				trace(i);
				enemies[i].removeThisGameObject();
				i--;
			}
			avatar.removeThisGameObject();
			dispatchEvent(new GameEvent("SCREEN_FLASH_OFF","SCREEN_FLASH_OFF"));
			dispatchEvent(new StateMachineEvent("CHANGE_GAME_STATE","INIT_START_SCREEN"));
			//uiContainer.visible=false;
			//gameContainer.visible=false;
			//screenFlash.visible=false;
			//backgroundContainer.visible=false;
		}
		
		private function startGameOverAnimation():void{
			this.addEventListener(Event.ENTER_FRAME, gameOverUpdateLoop);
		}
		
		private function gameOverUpdateLoop(e:Event):void{
			gameOverTimer++;
			if(gameOverTimer >= gameOverMaxTime){
				gameOverTimer = 0;
				this.removeEventListener(Event.ENTER_FRAME, gameOverUpdateLoop);
				getStage().dispatchEvent(new StateMachineEvent("CHANGE_GAME_STATE","RESET_GAME"));
			}
			
			//
			
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
							//trace("collisions!")
							dispatchEvent(new GameEvent("SCREEN_SHAKE","SCREEN_SHAKE"));
							dispatchEvent(new GameEvent("SCREEN_FLASH_WHITE","SCREEN_FLASH_WHITE"));
							//dispatchEvent(new GameEvent("SCREEN_FLASH_RED","SCREEN_FLASH_RED"));
							avatar.deductHealth(enemies[i].collisionDamage);
						}
					}
				}
				//SCREEN SHAKE FOR CONTAINERS
				gameContainer.updateLoop();
				uiContainer.updateLoop();
				screenFlash.updateLoop();
			}
		}
	}
}