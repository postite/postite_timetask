import utest.Assert;
import utest.Async;
import utest.Test;
import Delayer;
import thx.Time;

using Std;

class TestDelayS extends Test {
	var cancel:Void->Void;
	var d:Delayer;
	var delta:Float;
   final fps=60;
	final errorRange=1;

	function setup() {
		d = new Delayer(fps);
		delta = 0;
		cancel = thx.Timer.frame(function(_delta) {
			delta +=1;
			d.update(1);
			
		});
	}

	function teardown() {
		cancel();
      d=null;
	}

   inline function toDeltaMS(){
      return ((delta / fps)*1000  ).int();
   }  
   inline function toDeltaS(){
      return (delta / fps);
   } 

	public function testtest() {
		Assert.isTrue(1 == 1);
	}

	

	@:timeout(4100)
	function testAddMS(asy:utest.Async) {
		d.addS(function() {
			// Assert.equals(4,Time.fromMilliseconds(Std.int(delta)).totalSeconds);

			Assert.floatEquals(4, toDeltaS(),errorRange);
         
			asy.done();
		}, 4);
	}

	@:timeout(13000)
	function testmoreaddS(asy:Async) {
		d.addS(()->null, 4);
		d.addS(function() {
			// Assert.equals(4,Time.fromMilliseconds(Std.int(delta)).totalSeconds);

			Assert.floatEquals(12, toDeltaS(),errorRange);
			asy.done();
		}, 8);
	}

	@:timeout(40000)
	function testthreeaddS(asy:Async) {
		d.addS(()->null, 4);
		d.addS(()->null, 8);
		d.addS(function() {
			Assert.floatEquals(14, toDeltaS(),errorRange);
			asy.done();
		}, 2);
	}

	@:timeout(50000)
	function testcancelIdddS(asy:Async) {
		d.addS(()->null, 4);
		d.addS("huit",()->null, 8);
		d.addS(function() {
			// Assert.equals(4,Time.fromMilliseconds(Std.int(delta)).totalSeconds);
      
			Assert.floatEquals(6, toDeltaS(),errorRange);
			asy.done();
		}, 2);
		d.cancelById("huit");
	}

	@:timeout(60000)
	function testrunimmediately(asy:Async) {
		
      d.addS(()->null, 4);
		d.addS("huit", ()->null,8);
		d.addS(function() {
         
			Assert.floatEquals(6,toDeltaS(),errorRange);
			asy.done();
		}, 2);
	   d.runImmediatly("huit");

   }

   @:timeout(60000)
	function testPause(asy:Async){
      d.addS(()->null, 4);
		d.addS("huit", function(){
         d.pause();
          haxe.Timer.delay(
             ()->{
                d.wakeup();
             },1000
          );
      },8);
		d.addS(function() {
         
			Assert.floatEquals(15,toDeltaS(),errorRange);
			asy.done();
		}, 2);
	   

   }
   @:timeout(70000)
   public function testSkip(asy:Async)
   {
      d.addS(()->null, 4);
		d.addS("huit", ()->null,8);
		d.addS(function() {
         
			Assert.floatEquals(0,toDeltaS(),errorRange);
			asy.done();
		}, 2);
      d.skip();
   }

   



}
