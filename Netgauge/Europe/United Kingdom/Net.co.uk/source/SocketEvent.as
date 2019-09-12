package
{
   import flash.events.Event;
   
   public class SocketEvent extends Event
   {
      
      public static const SOCKET_READY:String = "ready";
      
      public static const SOCKET_ERROR:String = "error";
      
      public static const DATA_RECEIVED:String = "data";
       
      
      private var _data:Object;
      
      public function SocketEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
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
         trace("cloning " + type);
         return new SocketEvent(type,this._data,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("AnchorEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
