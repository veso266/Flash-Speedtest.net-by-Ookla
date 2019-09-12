package org.as3commons.ui.layout.framework.core.sizeitem
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class SizeItem implements ISizeItem
   {
       
      
      protected var _space:Rectangle;
      
      protected var _position:Point;
      
      public function SizeItem()
      {
         super();
         this._position = new Point();
      }
      
      public function measure() : void
      {
      }
      
      public function get space() : Rectangle
      {
         return this._space;
      }
      
      public function get position() : Point
      {
         return this._position;
      }
      
      public function render() : void
      {
      }
      
      public function get visibleRect() : Rectangle
      {
         return null;
      }
   }
}
