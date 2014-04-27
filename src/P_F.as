package{
	import flash.display.MovieClip
	import flash.geom.Point;
	public class P_F extends Particle{
		private var scaleMultiplier:Number=1.08
		public function P_F(){
			
		}
		
		public override function setGravity():void{
			gravity=0.1;
			gravityIncrement=-.01;
			//this.alpha=.5;
		}
		
		public override function addSomeRandom():Number{
			var randomValue:Number= .5-(Math.random()*1);
			return randomValue;
		}
		
		public override function doSpecial():void{
			this.scaleX*=scaleMultiplier;
			this.scaleY*=scaleMultiplier;
			scaleMultiplier-=.003;
		}
	}
}