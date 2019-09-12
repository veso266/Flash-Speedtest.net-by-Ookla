package
{
   import flash.events.Event;
   
   public class TestEvent extends Event
   {
      
      public static const START:String = "start";
      
      public static const PROGRESS:String = "progress";
      
      public static const COMPLETE:String = "complete";
      
      public static const FATAL:String = "fatal";
       
      
      private var _data:Object;
      
      public function TestEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._data = param2;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      override public function clone() : Event
      {
         return new TestEvent(type,this._data,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("TestEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
