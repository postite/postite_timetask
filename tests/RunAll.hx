package ;



import utest.ui.Report;
import utest.Runner;
class RunAll {

static function main ( ) 
{
   
   utest.UTest.run([
      new TestDelayMs(),
       //new TestDelayS()
        ]);

}
   
}