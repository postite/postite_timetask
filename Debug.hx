package ;
#if js
import js.Browser.console;
#end

@:enum
abstract LogLevel(Int) from Int to Int
{
	var Debug = 10;
	var Info = 20;
	var Warning = 30;
	var Error = 40;
	var Critical = 50;

	static var longest:Int = 10;

	public inline function toString():String
	{
		return switch (this)
		{
			default: "DBG";
			case Info: "INF";
			case Warning: "WRN";
			case Error: "ERR";
			case Critical: "!!!";
		}
	}

	public inline function format(s:String, color:Bool = true, ?pos:haxe.PosInfos):String
	{
		var d = Date.now().toString();
		var p = StringTools.lpad(pos.fileName, " ", longest) + ":" + StringTools.lpad(Std.string(pos.lineNumber), " ", 4) + ":";
		var l = toString();
		#if desktop
		var colorize = color && Sys.systemName() != "Windows";
		if (pos.fileName.length > longest) longest = pos.fileName.length;
		if (!colorize) return '$d $p  $l: $s';
		else return switch (this)
		{
			default: '\033[38;5;6m$d $p  $s\033[m';
			case Info: '\033[38;5;12m$d $p  $s\033[m';
			case Warning: '\033[38;5;3m$d $p  $s\033[m';
			case Error: '\033[38;5;1m$d $p  $s\033[m';
			case Critical: '\033[38;5;5m$d $p  $s\033[m';
		}
		#else
		return '$p $l:$s';
		#end
	}
}
class Debug{
    public static function Log<T>(msg:T,level:LogLevel = LogLevel.Info, ?pos:haxe.PosInfos):T{
        #if noDebug
		 trace(msg);
		 return msg;
		#end

        #if neko
			var p:haxe.PosInfos = {fileName: "", lineNumber: 0, customParams: null, methodName: "", className: ""};
			
			#else
           // var p:haxe.PosInfos = {fileName: "", lineNumber: 0, customParams: null, methodName: "", className: ""};
			var p:haxe.PosInfos = pos;
			#end
			#if (js && !nodejs)
			switch (level) {
				case Debug:console.log(level.format(Std.string(msg), true, pos));
				case Info:console.log(level.format(Std.string(msg), true, pos));
				case Warning:console.warn(level.format(Std.string(msg), true, pos));
				case Error:console.error(level.format(Std.string(msg), true, pos));
				case Critical:console.error(level.format(Std.string(msg), true, pos));
			}
			return msg;
			#end
			haxe.Log.trace(level.format(Std.string(msg), true, pos), p);
        	return msg;
    }
	public static function warn<T>(msg:T,level:LogLevel = LogLevel.Info, ?pos:haxe.PosInfos):T
		return Log(msg,LogLevel.Warning,pos);

	public static function error<T>(msg:T,level:LogLevel = LogLevel.Info, ?pos:haxe.PosInfos):T
		return Log(msg,LogLevel.Error,pos);
}