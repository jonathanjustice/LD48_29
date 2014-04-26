package customEvents {
import flash.events.Event;
	public class GameEvent extends Event {
		public static const TEST_EVENT:String = "TEST_EVENT";
		public static const GAME_OBJECT_DEAD:String = "GAME_OBJECT_DEAD";
		public static const GAME_OBJECT_DEAD_DISPATCHER_ONLY:String = "GAME_OBJECT_DEAD_DISPATCHER_ONLY";
		
		// this is the object you want to pass through your event.
		public var result:String;
		public var dispatcherID:int;
		
		
		public function GameEvent(type:String,result:String,dispatcherID:int=999,bubbles:Boolean=true) {
			super(type, bubbles, cancelable);
			this.result = result;
			this.dispatcherID = dispatcherID;
		}
	}
}
