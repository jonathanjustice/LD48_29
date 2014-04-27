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
		public static var particleContainer:ParticleContainer;
		public static var backgroundContainer:MovieClip;
		public static var enemies = new Array();;
		private static var screenFlash:ScreenFlash;
		private var isPaused:Boolean = false;
		private var gameOverTimer:int=0;
		private var gameOverMaxTime:int=30;
		private var difficulty:int=0;
		private var enemiesToSpawn:Array;
		private var enemiesToSpawnTimes:Array;
		private var easy_1:Array
		private var easy_2:Array
		private var easy_3:Array
		private var easy_4:Array
		private var easy_5:Array
		private var easy_6:Array
		private var easy_7:Array
		private var easy_8:Array
		private var easy_9:Array
		private var easy_10:Array
		private var medium_1:Array
		private var medium_2:Array
		private var medium_3:Array
		private var medium_4:Array
		private var medium_5:Array
		private var medium_6:Array
		private var medium_7:Array
		private var medium_8:Array
		private var medium_9:Array
		private var medium_10:Array
		private var hard_1:Array
		private var hard_2:Array
		private var hard_3:Array
		private var hard_4:Array
		private var hard_5:Array
		private var hard_6:Array
		private var hard_7:Array
		private var hard_8:Array
		private var hard_9:Array
		private var hard_10:Array
		private var easy_times_1:Array
		private var easy_times_2:Array
		private var easy_times_3:Array
		private var easy_times_4:Array
		private var easy_times_5:Array
		private var easy_times_6:Array
		private var easy_times_7:Array
		private var easy_times_8:Array
		private var easy_times_9:Array
		private var easy_times_10:Array
		private var medium_times_1:Array
		private var medium_times_2:Array
		private var medium_times_3:Array
		private var medium_times_4:Array
		private var medium_times_5:Array
		private var medium_times_6:Array
		private var medium_times_7:Array
		private var medium_times_8:Array
		private var medium_times_9:Array
		private var medium_times_10:Array
		private var hard_times_1:Array
		private var hard_times_2:Array
		private var hard_times_3:Array
		private var hard_times_4:Array
		private var hard_times_5:Array
		private var hard_times_6:Array
		private var hard_times_7:Array
		private var hard_times_8:Array
		private var hard_times_9:Array
		private var hard_times_10:Array
		
		private var enemySpawnSequenceCount:int=0;
		private var enemyCounter:int=0;
		private var enemyCountMax:int=30;
		private var difficultyMode:String="easy";
		
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
			particleContainer = new ParticleContainer();
			screenFlash = new ScreenFlash();
			backgroundContainer = new MovieClip();
			enemies = new Array();
			enemiesToSpawn = new Array();
			enemiesToSpawnTimes = new Array();
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//stage.scaleMode = StageScaleMode.EXACT_FIT;
			//stage.displayState = StageDisplayState.FULL_SCREEN;
			setUp();
        }
		//Main.theStage.dispatchEvent(new SoundEvent("SOUND_START","ENEMY_PICKED_UP"));
		private function setUp():void{
			defineLevels();
			stage.addChild(backgroundContainer);
			stage.addChild(gameContainer);
			stage.addChild(uiContainer);
			stage.addChild(particleContainer);
			stage.addChild(screenFlash);
			Main.theStage.addEventListener(StateMachineEvent.CHANGE_GAME_STATE, changeGameState);
			soundManager = new SoundManager(theStage);
			getStage().dispatchEvent(new StateMachineEvent("CHANGE_GAME_STATE","INIT_START_SCREEN"));
		}
		
		public function getGameContainer():MovieClip{
			return gameContainer;
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
					selectNewEnemySequence();
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
				enemies[i].removeThisGameObject();
				i--;
			}
			avatar.removeThisGameObject();
			dispatchEvent(new GameEvent("SCREEN_FLASH_OFF","SCREEN_FLASH_OFF"));
			dispatchEvent(new StateMachineEvent("CHANGE_GAME_STATE","INIT_START_SCREEN"));
			enemySpawnSequenceCount=0;
			difficulty=1;
			enemyCounter=0;
			enemiesToSpawn=[];
			enemiesToSpawnTimes=[];
			selectNewEnemySequence();
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
		}
		
		
			
		private function selectNewEnemySequence():void{
			difficultyMode="easy"
			selectEasySequence();
			/*if(difficulty <= 5){
				difficultyMode="easy"
				selectEasySequence();
			}else if(difficulty > 6 && difficulty <= 10){
				
			}else if(difficulty > 11 && difficulty <= 20){
				
			}else if(difficulty > 21 && difficulty <= 35){
				
			}else if(difficulty > 36 && difficulty <= 50){
				
			}else if(difficulty > 51 && difficulty <= 75){
				
			}else if(difficulty > 76 && difficulty <= 100){
				
			}else if(difficulty > 101){
				
			}*/
		}
		
		private function selectEasySequence():void{
			//trace("selectEasySequence");
			var randomSequence:int= 1+Math.random()*7;
			//trace(randomSequence);
			switch(randomSequence){
				case 1:
					enemiesToSpawn = easy_1;
					enemiesToSpawnTimes = easy_times_1;
				case 2:
					enemiesToSpawn = easy_2;
					enemiesToSpawnTimes =easy_times_2;
				case 3:
					enemiesToSpawn = easy_3;
					enemiesToSpawnTimes =easy_times_3;
				case 3:
					enemiesToSpawn = easy_4;
					enemiesToSpawnTimes =easy_times_4;
				case 3:
					enemiesToSpawn = easy_5;
					enemiesToSpawnTimes =easy_times_5;
			}
			
					//trace(enemiesToSpawn);
					//trace(enemiesToSpawnTimes);
		}
		
			
		
		private function defineLevels():void{
			easy_1 = new Array();
			easy_2 = new Array();
			easy_3 = new Array();
			easy_4 = new Array();
			easy_5 = new Array();
			easy_6 = new Array();
			easy_7 = new Array();
			easy_8 = new Array();
			easy_9 = new Array();
			easy_10 = new Array();
			medium_1 = new Array();
			medium_2 = new Array();
			medium_3 = new Array();
			medium_4 = new Array();
			medium_5 = new Array();
			medium_6 = new Array();
			medium_7 = new Array();
			medium_8 = new Array();
			medium_9 = new Array();
			medium_10 = new Array();
			hard_1 = new Array();
			hard_2 = new Array();
			hard_3 = new Array();
			hard_4 = new Array();
			hard_5 = new Array();
			hard_6 = new Array();
			hard_7 = new Array();
			hard_8 = new Array();
			hard_9 = new Array();
			hard_10 = new Array();
			easy_times_1 = new Array();
			easy_times_2 = new Array();
			easy_times_3 = new Array();
			easy_times_4 = new Array();
			easy_times_5 = new Array();
			easy_times_6 = new Array();
			easy_times_7 = new Array();
			easy_times_8 = new Array();
			easy_times_9 = new Array();
			easy_times_10 = new Array();
			medium_times_1 = new Array();
			medium_times_2 = new Array();
			medium_times_3 = new Array();
			medium_times_4 = new Array();
			medium_times_5 = new Array();
			medium_times_6 = new Array();
			medium_times_7 = new Array();
			medium_times_8 = new Array();
			medium_times_9 = new Array();
			medium_times_10 = new Array();
			hard_times_1 = new Array();
			hard_times_2 = new Array();
			hard_times_3 = new Array();
			hard_times_4 = new Array();
			hard_times_5 = new Array();
			hard_times_6 = new Array();
			hard_times_7 = new Array();
			hard_times_8 = new Array();
			hard_times_9 = new Array();
			hard_times_10 = new Array();
			
			easy_1 = [1,2,3,4,5];
			easy_times_1 = [5,35,58,85,102];
			easy_2 = [2,3,2,3,2];
			easy_times_2 = [1,30,50,90,125];
			easy_3 = [1,5,4,1,9,4];
			easy_times_3 = [1,10,50,87,122,150];
			easy_4 = [6,7,8,9];
			easy_times_4 = [30,59,95,120];
			easy_5 = [1,7,4,2,9,2,6];
			easy_times_5 = [19,49,75,100,125,150,175];
			easy_6 = [1,9,8,9,5];
			easy_times_6 = [5,35,58,85,102];
			easy_7 = [9,5,4,9,5,4];
			easy_times_7 = [1,10,50,87,122,150];
			easy_8 = [];
			easy_times_8 = [];
			easy_9 = [];
			easy_times_9 = [];
			easy_10 = [];
			easy_times_10 = [];
			
			medium_1 = [];
			medium_times_1 = [];
			medium_2 = [];
			medium_times_2 = [];
			medium_3 = [];
			medium_times_3 = [];
			medium_4 = [];
			medium_times_4 = [];
			medium_5 = [];
			medium_times_5 = [];
			medium_6 = [];
			medium_times_6 = [];
			medium_7 = [];
			medium_times_7 = [];
			medium_8 = [];
			medium_times_8 = [];
			medium_9 = [];
			medium_times_9 = [];
			medium_10 = [];
			medium_times_10 = [];
		}
			
		
		private function mainUpdateLoop(e:Event):void{
			if(!isPaused){
				//SPAWN ENEMIES
				enemyCounter+=1;
				if(enemyCounter == enemiesToSpawnTimes[enemySpawnSequenceCount]){
					//trace("enemyCounter matches enemiesToSpawnTimes[enemySpawnSequenceCount]");
					var enemy:Enemy = new Enemy();
					enemy.setType(difficultyMode,enemiesToSpawn[enemySpawnSequenceCount]);
					enemies.push(enemy);
					enemySpawnSequenceCount++;
				}
				if(enemySpawnSequenceCount == enemiesToSpawn.length){
					enemySpawnSequenceCount=0;
					//trace("enemySpawnSequenceCount matches enemiesToSpawn.length");
					difficulty++;
					enemyCounter=0;
					enemiesToSpawn=[];
					enemiesToSpawnTimes=[];
					selectNewEnemySequence();
				}
				
				//CHECK FOR COLLISION WITH ENEMIES
				for(var i:int=0;i<enemies.length;i++){
					for each(var enemyHitbox:MovieClip in enemies[i].hitboxes){
						if(enemyHitbox.hitTestObject(avatar.hitbox)){
							if(enemies[i].isCollisionActive){
								//trace("collisions!",i);
								dispatchEvent(new GameEvent("SCREEN_SHAKE","SCREEN_SHAKE"));
								dispatchEvent(new GameEvent("SCREEN_FLASH_WHITE","SCREEN_FLASH_WHITE"));
								//dispatchEvent(new GameEvent("SCREEN_FLASH_RED","SCREEN_FLASH_RED"));
								avatar.deductHealth(enemies[i].collisionDamage);
							}
						}
					}
				}
				//SCREEN SHAKE FOR CONTAINERS
				gameContainer.updateLoop();
				screenFlash.updateLoop();
			}
		}
	}
}