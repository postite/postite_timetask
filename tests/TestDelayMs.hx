import utest.Assert;
import utest.Async;
import utest.Test;
import TimeTask;
import thx.Time;
using Debug;
using Std;

class TestDelayMs extends Test {
	var cancel:Void->Void;
	var d:TimeTask;
	var delta:Float;
   final fps=60;
	var done:Bool=false;
	function setup() {
		d = new TimeTask(fps,function()done=true.Log());
		delta = 0;
		cancel = thx.Timer.frame(function(_delta) {
			delta +=1;
			d.update(1);
			// trace( delta);
		});
	}

	function teardown() {
		cancel();
      d.destroy();
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

	

	@:timeout(110)
	function testAddMS(asy:utest.Async) {
		d.addMs(function() {
			// Assert.equals(4,Time.fromMilliseconds(Std.int(delta)).totalSeconds);

			Assert.floatEquals(40, toDeltaMS(),10);
         
			asy.done();
		}, 40);
	}

	@:timeout(130)
	function testmoreaddS(asy:Async) {
		d.addMs(()->null, 40);
		d.addMs(function() {
			// Assert.equals(4,Time.fromMilliseconds(Std.int(delta)).totalSeconds);

			Assert.floatEquals(120, toDeltaMS(),10);
			asy.done();
		}, 80);
	}

	@:timeout(400)
	function testthreeaddS(asy:Async) {
		d.addMs(()->null, 40);
		d.addMs(()->null, 80);
		d.addMs(function() {
			Assert.floatEquals(140, toDeltaMS(),10);
			asy.done();
		}, 20);
	}

	@:timeout(500)
	function testcancelIdddS(asy:Async) {
		d.addMs(()->null, 40);
		d.addMs("huit",()->null, 80);
		d.addMs(function() {
			// Assert.equals(4,Time.fromMilliseconds(Std.int(delta)).totalSeconds);
      
			Assert.floatEquals(60, toDeltaMS(),10);
			asy.done();
		}, 20);
		d.cancelById("huit");
	}

	@:timeout(600)
	function testrunimmediately(asy:Async) {
		
      d.addMs(()->null, 40);
		d.addMs("huit", ()->null,80);
		d.addMs(function() {
         
			Assert.floatEquals(60,toDeltaMS(),10);
			asy.done();
		}, 20);
	   d.runImmediatly("huit");

   }

   @:timeout(600)
	function testPause(asy:Async){
      d.addMs(()->null, 40);
		d.addMs("huit", function(){
         d.pause();
          haxe.Timer.delay(
             ()->{
                d.wakeup();
             },100
          );
      },80);
		d.addMs(function() {
         
			Assert.floatEquals(240,toDeltaMS(),20);
			asy.done();
		}, 20);
	   

   }
   @:timeout(700)
   public function testSkip(asy:Async)
   {
      d.addMs(()->null, 40);
		d.addMs("huit", ()->null,80);
		d.addMs(function() {
			Assert.floatEquals(0,toDeltaMS(),20); // abit more error range ...
			asy.done();
		}, 20);
      d.skip();
   }

	
   public function testCancelEverything()
   {
      d.addMs(()->null, 40);
		d.addMs("huit", ()->null,80);
		d.addMs(function() {
			Assert.floatEquals(0,toDeltaMS(),10);
			
		}, 20);
      d.cancelEverything();
		Assert.isFalse(d.hasId('huit'));
		
   }
	@:timeout(1000)
	public function testDone(asy:Async)
	{
		d.addMs(()->null, 40);
		d.addMs("huit", ()->null,80);
		d.addMs(function() {
			Assert.floatEquals(140,toDeltaMS(),10);
			
			haxe.Timer.delay(()->{
				Assert.isTrue(done);
				asy.done();
				}
				,10);
			
			
		}, 20);
      
	}

   



}
