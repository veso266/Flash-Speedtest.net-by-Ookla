package org.as3commons.ui.layout.framework
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import org.as3commons.collections.framework.IIterable;
   import org.as3commons.collections.framework.IRecursiveIterator;
   import org.as3commons.ui.layout.CellConfig;
   
   public interface ILayout extends ILayoutItem, IIterable
   {
       
      
      function setCellConfig(param1:CellConfig, param2:int = -1, param3:int = -1) : void;
      
      function getCellConfig(param1:int = -1, param2:int = -1) : CellConfig;
      
      function set minWidth(param1:uint) : void;
      
      function get minWidth() : uint;
      
      function set minHeight(param1:uint) : void;
      
      function get minHeight() : uint;
      
      function add(... rest) : void;
      
      function addFirst(... rest) : void;
      
      function addAll(param1:Sprite) : void;
      
      function getLayoutItem(... rest) : ILayoutItem;
      
      function getDisplayObject(... rest) : DisplayObject;
      
      function recursiveIterator() : IRecursiveIterator;
      
      function remove(param1:*) : void;
      
      function get numItems() : uint;
      
      function layout(param1:Sprite, param2:Boolean = false) : void;
   }
}
