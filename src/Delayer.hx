package ;
using Lambda;

// mostly inspired by deepnightLibs

@:allow(Delayer)
private class Task { //classes are faster

	//public var t	: Float;
	 public var id	: String;
	 public var cb	: Void->Void;
    var secs:Int;
    var dby:Int;

	public inline function new(id,cb,secs) { //inline new classes are faster faster
		//this.t = t;
		this.cb = cb;
		this.id = id;
      this.secs=secs;
	}

	public inline function toString() return secs + " " + cb;
}

class Delayer {
	var delays	: Array<Task>;
	var now		: Float;
	var fps		: Float;
   public var delayTime:Int;

	public function new(fps:Float) { //no need for nullability because no other nullable args
		now = 0;
		this.fps = fps;
		delays = new Array();
	}

	public function toString() {
		return "Delayer(now="+now+",timers="+delays.map(function(d) return d.secs).join(",")+")";
	}

	public inline function isDestroyed() return delays == null;

	public function destroy() {
		delays = null;
	}

	public function skip() {
		var limit = delays.length+100;
		while( delays.length>0 && limit-->0 ) {
			var d = delays.shift();
			d.cb();
			d.cb = null;//help garbage
		}
	}

	public function cancelEverything() {
		delays = [];
	}

	public function hasId(id:String) {
		for(e in delays)
			if( e.id==id )
				return true;
		return false;
	}

	public function cancelById(id:String) {
		var i = 0;
		while( i<delays.length )
			if( delays[i].id==id )
				delays.splice(i,1);
			else
				i++;
      calcdelayTime();
	}

	public function runImmediatly(id:String) {
		var i = 0;
		while( i<delays.length )
			if( delays[i].id==id ) {
				var cb = delays[i].cb;
				delays.splice(i,1);
				cb();
			}
			else
				i++;
      calcdelayTime();
	}

	inline function cmp(a:Task, b:Task) {
		return
			if ( a.secs < b.secs ) -1
			else if ( a.secs > b.secs ) 1;
			else 0;
	}

   var paused:Bool=false;
   public function pause(){
      paused=true;
   }  
   public function wakeup(){
      paused=false;
   }


	public function addMs(?id:String, cb:Void->Void, msecs:Int) {
		delays.push( new Task(id,cb,Std.int((msecs/1000*fps))));
      calcdelayTime();
		
	}

	public function addS(?id:String, cb:Void->Void,secs:Int) {
      
		delays.push( new Task( id,cb,Std.int((secs*fps))) );
     
      calcdelayTime();
      
	}

   function calcdelayTime(){
      delayTime=0;
      var p=delays.fold(function(a:Task,b:Task){
                 // trace( delays.length+"-" + a.secs);
                  delayTime+=a.secs;
                  a.dby=delayTime;
                  return a;
      },delays[0]);

    }

   public function update(dt:Float){
      
         if(paused)
             return;
        // trace( '$delayTime of $now');
        // while( delays.length>0  ) {
         if( delays.length>0 && delays[0].dby<=now){
            //trace( 'update length=${delays.length} delays[0]:${delays[0].dby} now:$now');
			//trace('now=$now');
         var d = delays.shift();
         d.cb();
			d.cb = null;//help garbage
		   }
         now+=dt;
   }
}
