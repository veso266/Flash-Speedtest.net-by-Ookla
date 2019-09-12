package
{
   public class Callback
   {
       
      
      public function Callback()
      {
         super();
      }
      
      public static function create(param1:Function, ... rest) : Function
      {
         var handler:Function = param1;
         var args:Array = rest;
         return function(... rest):void
         {
            handler.apply(this,rest.concat(args));
         };
      }
   }
}
