package org.as3commons.ui.layout.framework.core.sizeitem
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public interface ISizeItem
   {
       
      
      function measure() : void;
      
      function get space() : Rectangle;
      
      function get position() : Point;
      
      function render() : void;
      
      function get visibleRect() : Rectangle;
   }
}
