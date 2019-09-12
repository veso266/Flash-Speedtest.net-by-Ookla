package org.as3commons.ui.layout.framework
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public interface ILayoutItem
   {
       
      
      function set id(param1:String) : void;
      
      function get id() : String;
      
      function set marginX(param1:int) : void;
      
      function get marginX() : int;
      
      function set marginY(param1:int) : void;
      
      function get marginY() : int;
      
      function set offsetX(param1:int) : void;
      
      function get offsetX() : int;
      
      function set offsetY(param1:int) : void;
      
      function get offsetY() : int;
      
      function set hAlign(param1:String) : void;
      
      function get hAlign() : String;
      
      function set vAlign(param1:String) : void;
      
      function get vAlign() : String;
      
      function get inLayout() : Boolean;
      
      function excludeFromLayout(param1:Boolean = true) : void;
      
      function includeInLayout(param1:Boolean = true) : void;
      
      function set renderCallback(param1:Function) : void;
      
      function get renderCallback() : Function;
      
      function set hideCallback(param1:Function) : void;
      
      function get hideCallback() : Function;
      
      function set showCallback(param1:Function) : void;
      
      function get showCallback() : Function;
      
      function get position() : Point;
      
      function get contentRect() : Rectangle;
      
      function get visibleRect() : Rectangle;
   }
}
