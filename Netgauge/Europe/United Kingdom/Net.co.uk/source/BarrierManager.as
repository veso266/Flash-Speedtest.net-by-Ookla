package
{
   public class BarrierManager
   {
      
      protected static var listeners:Array = new Array();
      
      protected static var barriers:Array = new Array();
       
      
      public function BarrierManager()
      {
         super();
      }
      
      public static function addListener(param1:Object) : *
      {
         listeners.push(param1);
      }
      
      public static function hitBarrier(param1:String) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < listeners.length)
         {
            listeners[_loc2_].barrierHit(param1);
            _loc2_++;
         }
      }
      
      public static function resetBarrier(param1:String) : *
      {
         barriers[param1] = 0;
      }
      
      public static function barrierTouch(param1:String, param2:Number) : Boolean
      {
         if(isNaN(barriers[param1]))
         {
            barriers[param1] = 1;
         }
         else
         {
            barriers[param1]++;
         }
         trace(param1,barriers[param1],param2);
         if(barriers[param1] >= param2)
         {
            hitBarrier(param1);
            barriers[param1] = 0;
            return true;
         }
         return false;
      }
   }
}
