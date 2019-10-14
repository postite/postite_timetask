import haxe.Timer;
import thx.Time;
using Std;
class Main {
	static var delta:Float=0;
	static var i=1000;
	static function main() {
		trace("Hello, world!");
		

			var d = new Delayer(60);
			
			d.addS(function() trace("ok"+ Time.fromMilliseconds(delta.int())),2.,2);
			d.addS(function() trace("then"+Time.fromMilliseconds(delta.int())),5.,5);
			d.addS(function() trace("way "+Time.fromMilliseconds(delta.int())),2.,2);
			
			trace( "pop"+d.delayTime);
			
			var cancel=thx.Timer.frame(
				function(_delta){
					
					delta+=_delta;
					d.update2(1);
					//trace( delta);
				}
			);


	}
}
