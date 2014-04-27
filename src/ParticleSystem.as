package{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Point;
	import flash.errors.*;
	public class ParticleSystem extends MovieClip{
		private var particleMode:String = "";
		private var fireParticles:Array = new Array();
		private var loveParticles:Array = new Array();
		private var liftParticles:Array = new Array();
		private var meteorParticles:Array = new Array();
		private var spawnDelay:int=5;
		private var spawnDelay_DEFAULT:int=5;
		private var spawnDelay_LOVE:int=55;
		private var spawnDelay_EXPLODED_FAST_MODE:int=1;
		private var spawnDelayCounter:int=0;
		private var myFollower:MovieClip;
		private var lifeTime:int=300;
		private var timeExisted:int=0;
		private var isSpawningEnabled:Boolean=true;
		private var isActive:Boolean=false;
		public function ParticleSystem(follower:MovieClip){
			myFollower = follower;
		}
		
		public function playMode(newMode:String):void{
			particleMode = newMode;
			if(particleMode == "LOVE"){
				spawnDelay = spawnDelay_LOVE;
			}if(particleMode == "EXPLODED_FAST_MODE"){
				spawnDelay = spawnDelay_EXPLODED_FAST_MODE;
				particleMode = "COIN";
			}else{
				spawnDelay = spawnDelay_DEFAULT;
			}
			enableParticles();
		}
		
		public function enableParticles():void{
			this.addEventListener(Event.ENTER_FRAME, spawnParticles);
			isSpawningEnabled = true;
			isActive = true;
		}
		
		public function abortAll():void{
			disableParticles();
			for(var i:int=0;i<fireParticles.length;i++){
				Main.particleContainer.removeChild(fireParticles[i]);
				fireParticles.splice(i,1);
				i--;
			}
		}
		
		public function disableParticles():void{
			isActive=false;
			isSpawningEnabled = false;
			this.removeEventListener(Event.ENTER_FRAME, spawnParticles);
		}
		
		public function disableSpawning():void{
			isSpawningEnabled=false;
		}
		
		private function spawnParticles(e:Event):void{
			if(isActive == true){
				for(var i:int=0;i<fireParticles.length;i++){
					fireParticles[i].updateLoop();
					if(fireParticles[i].getMarkedForDeletion()==true){
						Main.particleContainer.removeChild(fireParticles[i]);
						fireParticles.splice(i,1);
					}
				}
				//trace("particleMode",particleMode);
				if(timeExisted > lifeTime){
					//disableSpawning();
				}
				if(spawnDelayCounter >= spawnDelay){
					spawnDelayCounter=0;
					var index:int = 0;
					try{
						index = myFollower.parent.getChildIndex(myFollower);
					}catch(e : Error){
						//if this throws an error, I should kill the particle immediately
						/*trace("myFollower",myFollower);
						trace("myFollower.parent",myFollower.parent);
						trace("myFollower.parent.getChildIndex(myFollower)",myFollower.parent.getChildIndex(myFollower));
						trace("remember to kill this particle");
						trace("index");*/
					}
					
					switch(particleMode){
						
						case "null":
							//trace("newState passed was null");
							break;
						case "NONE":
							//trace("newState passed was none");
							break;
						case "FIRE":
							var p_F:P_F = new P_F();
							p_F.defineSpawnPoint(myFollower.getLocation(),myFollower.getVelocity(),myFollower.getScale());
							//Main.getGameContainer().addChildAt(p_F,index);
							Main.particleContainer.addChildAt(p_F,index);
							fireParticles.push(p_F);
							break;
						case "EXPLODE":
							for(var a:int=0;a<15;a++){
								var p_e:P_E = new P_E();
								p_e.defineSpawnPoint(myFollower.getLocationEXPLOSION(),myFollower.getVelocityEXPLOSION(),myFollower.getScaleEXPLOSION());
								//Main.getGameContainer().addChildAt(p_F,index);
								Main.particleContainer.addChildAt(p_e,index);
								fireParticles.push(p_e);
							}
							break;
					}
				}
				//if(isSpawningEnabled){
				//timeExisted++;
				spawnDelayCounter++;
			}
		}
	}
}