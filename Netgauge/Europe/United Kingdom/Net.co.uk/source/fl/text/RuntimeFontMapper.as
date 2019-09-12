package fl.text
{
   import flash.text.engine.FontDescription;
   import flash.utils.Dictionary;
   
   public class RuntimeFontMapper
   {
      
      private static var fontMapDict:Dictionary = new Dictionary();
       
      
      public function RuntimeFontMapper()
      {
         super();
      }
      
      public static function fontMapper(param1:FontDescription) : void
      {
         var _loc2_:* = "[\'" + param1.fontName + "\',\'" + param1.fontWeight + "\',\'" + param1.fontPosture + "\']";
         var _loc3_:Array = fontMapDict[_loc2_];
         if(_loc3_ != null)
         {
            param1.fontName = _loc3_[0];
            param1.fontWeight = _loc3_[1];
            param1.fontPosture = _loc3_[2];
         }
      }
      
      public static function addFontMapEntry(param1:String, param2:Array) : void
      {
         fontMapDict[param1] = param2;
      }
   }
}
