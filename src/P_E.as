package{
	import flash.display.MovieClip
	import flash.geom.Point;
	public class P_E extends Particle{
		private var scaleMultiplier:Number=1.08
		public function P_E(){
			
		}
		
		public override function setGravity():void{
			gravity=0.1;
			gravityIncrement=-.01;
			//this.alpha=.5;
		}
		
		public override function addSomeRandom():Number{
			var randomValue:Number= (Math.random()*10)-5;
			return randomValue;
		}
		
		public override function doSpecial():void{
			this.scaleX*=scaleMultiplier;
			this.scaleY*=scaleMultiplier;
			scaleMultiplier-=.002;
		}
	}
}