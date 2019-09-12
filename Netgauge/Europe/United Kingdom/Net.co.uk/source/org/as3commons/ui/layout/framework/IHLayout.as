package org.as3commons.ui.layout.framework
{
   public interface IHLayout extends IMultilineLayout
   {
       
      
      function set maxItemsPerRow(param1:uint) : void;
      
      function get maxItemsPerRow() : uint;
      
      function set maxContentWidth(param1:uint) : void;
      
      function get maxContentWidth() : uint;
      
      function get numLayoutRows() : uint;
   }
}
