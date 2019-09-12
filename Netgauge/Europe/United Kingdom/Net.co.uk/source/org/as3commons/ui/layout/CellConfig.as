package org.as3commons.ui.layout
{
   public class CellConfig
   {
       
      
      private var _width:uint;
      
      private var _height:uint;
      
      private var _marginX:int;
      
      private var _marginY:int;
      
      private var _offsetX:int;
      
      private var _offsetY:int;
      
      private var _hAlign:String = "left";
      
      private var _vAlign:String = "top";
      
      private var _propertiesSet:Object;
      
      public function CellConfig()
      {
         super();
         this._propertiesSet = new Object();
      }
      
      public function set width(param1:uint) : void
      {
         this._width = param1;
         this._propertiesSet["width"] = true;
      }
      
      public function get width() : uint
      {
         return this._width;
      }
      
      public function set height(param1:uint) : void
      {
         this._height = param1;
         this._propertiesSet["height"] = true;
      }
      
      public function get height() : uint
      {
         return this._height;
      }
      
      public function set marginX(param1:int) : void
      {
         this._marginX = param1;
         this._propertiesSet["marginX"] = true;
      }
      
      public function get marginX() : int
      {
         return this._marginX;
      }
      
      public function set marginY(param1:int) : void
      {
         this._marginY = param1;
         this._propertiesSet["marginY"] = true;
      }
      
      public function get marginY() : int
      {
         return this._marginY;
      }
      
      public function set offsetX(param1:int) : void
      {
         this._offsetX = param1;
         this._propertiesSet["offsetX"] = true;
      }
      
      public function get offsetX() : int
      {
         return this._offsetX;
      }
      
      public function set offsetY(param1:int) : void
      {
         this._offsetY = param1;
         this._propertiesSet["offsetY"] = true;
      }
      
      public function get offsetY() : int
      {
         return this._offsetY;
      }
      
      public function set hAlign(param1:String) : void
      {
         this._hAlign = param1;
         this._propertiesSet["hAlign"] = true;
      }
      
      public function get hAlign() : String
      {
         return this._hAlign;
      }
      
      public function set vAlign(param1:String) : void
      {
         this._vAlign = param1;
         this._propertiesSet["vAlign"] = true;
      }
      
      public function get vAlign() : String
      {
         return this._vAlign;
      }
      
      public function propertyExplicitlySet(param1:String) : Boolean
      {
         return this._propertiesSet.hasOwnProperty(param1);
      }
   }
}
