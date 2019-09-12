package org.as3commons.ui.layout.framework
{
   import flash.display.DisplayObject;
   
   public interface IDisplay extends ILayoutItem
   {
       
      
      function set displayObject(param1:DisplayObject) : void;
      
      function get displayObject() : DisplayObject;
   }
}
