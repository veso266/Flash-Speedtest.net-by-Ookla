package
{
   import flash.events.Event;
   
   public class MultiLoaderEvent extends Event
   {
      
      public static const GROUP_PROGRESS:String = "onGroupProgress";
      
      public static const LOAD_ERROR:String = "loadError";
       
      
      private var _data:Object;
      
      public function MultiLoaderEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
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
         return new MultiLoaderEvent(type,this._data,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("AnchorEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
