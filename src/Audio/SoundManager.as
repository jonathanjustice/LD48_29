package Audio{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	import flash.net.URLRequest; 
	import customEvents.SoundEvent;
	//import JSON;
	import customEvents.*;
	public class SoundManager extends MovieClip{
		
		public static var soundObjects:Array = new Array();
		
		
		private var EXPLOSION:explosion_002 = new explosion_002();
		private var METEOR_FALL:meteorFall_001 = new meteorFall_001();
		
		public var theStage;
		private var numerbOfPlays:int=1;
		//sdfsdfsdf
		
		
		
		public static var channelCount:int = 0;
		//file paths for sound
		//EVENT FORMAT FOR CALLING SONG EVENT:
		//Main.theStage.dispatchEvent(new SoundEvent("SOUND_START","SOUNDNAME"));
		//imports needed for firing custom events
		//import utilities.customEvents.*;
		
		private var filePath;
		private static var _instance:SoundManager;
		
		public function SoundManager(newStage){
			theStage = newStage;
			//trace(theStage);
			//createNewSoundObject(filePath);
			//trace("filePath",filePath);
			//stop_a_sound_channel(filePath);
			addSoundListeners();
		}
		
		private function addSoundListeners():void {
			Main.theStage.addEventListener(SoundEvent.SOUND_START, startSound);
		}
	
		public function startSound(event:SoundEvent):void {
			var myResult:String = event.result;
			var dispatcherID:int = event.dispatcherID;
			trace(myResult);
			
			switch(event.result) {
				case "METEOR_FALL":
					filePath = METEOR_FALL;
					numerbOfPlays = 1;
					break;
				case "TEST_SOUND":
					filePath = METEOR_FALL;
					numerbOfPlays = 1;
					break;
			}
			if(channelCount >= 32){
				//trace("sketti");
				//trace("channelCount",channelCount);
			}else{
				channelCount++;
				createNewSoundObject(filePath,myResult,dispatcherID);
				//trace("channelCount",channelCount);
			}
		}
		
		
		public static function reduceChannelCount():void{
			channelCount-=1;
		}
		
		public function createNewSoundObject(file_path,soundID,dispatcherID):void {
			var newSoundObject:SoundObject = new SoundObject(filePath,soundID,dispatcherID,numerbOfPlays);
			soundObjects.push(newSoundObject);
		}
		
		public function stop_a_sound_channel(channel_to_stop:String):void {
			for each(var soundObject:SoundObject in soundObjects) {
				if (soundObject.name == channel_to_stop) {
					soundObject.stopSound();
				}				
			}
		}
		
		public function stopAllSounds():void{
			for each(var soundObject:SoundObject in soundObjects) {
				soundObject.stopSound();				
			}
		}
		
		public static function destroySoundObject(soundObject:SoundObject):void {
			var index:int = soundObjects.lastIndexOf(soundObject);
			//trace("index", index);
			soundObjects.splice(index, 1);
			soundObject = null;
			reduceChannelCount();
			//trace(soundObjects);
		}
	}
}
