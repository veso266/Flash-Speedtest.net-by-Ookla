package org.as3commons.ui.layout.framework.core
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.as3commons.ui.framework.core.as3commons_ui;
   import org.as3commons.ui.layout.framework.ILayoutItem;
   import org.as3commons.ui.layout.framework.core.cell.ICell;
   import org.as3commons.ui.layout.framework.core.config.RenderConfig;
   
   public class AbstractLayoutItem implements ILayoutItem
   {
       
      
      protected const FALSE:String = "false";
      
      protected const HIDE:String = "hide";
      
      protected const SHOW:String = "show";
      
      private var _id:String;
      
      protected var _marginX:int;
      
      protected var _marginY:int;
      
      protected var _offsetX:int;
      
      protected var _offsetY:int;
      
      protected var _hAlign:String = "left";
      
      protected var _vAlign:String = "top";
      
      protected var _renderCallback:Function;
      
      protected var _hideCallback:Function;
      
      protected var _showCallback:Function;
      
      protected var _inLayout:Boolean = true;
      
      protected var _showOrHide:String = "false";
      
      protected var _cell:ICell;
      
      protected var _position:Point;
      
      protected var _contentRect:Rectangle;
      
      protected var _visibleRect:Rectangle;
      
      public function AbstractLayoutItem()
      {
         super();
         this._position = new Point();
         this._contentRect = new Rectangle();
         this._visibleRect = new Rectangle();
      }
      
      public function set id(param1:String) : void
      {
         this._id = param1;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function set marginX(param1:int) : void
      {
         this._marginX = param1;
      }
      
      public function get marginX() : int
      {
         return this._marginX;
      }
      
      public function set marginY(param1:int) : void
      {
         this._marginY = param1;
      }
      
      public function get marginY() : int
      {
         return this._marginY;
      }
      
      public function set offsetX(param1:int) : void
      {
         this._offsetX = param1;
      }
      
      public function get offsetX() : int
      {
         return this._offsetX;
      }
      
      public function set offsetY(param1:int) : void
      {
         this._offsetY = param1;
      }
      
      public function get offsetY() : int
      {
         return this._offsetY;
      }
      
      public function set hAlign(param1:String) : void
      {
         this._hAlign = param1;
      }
      
      public function get hAlign() : String
      {
         return this._hAlign;
      }
      
      public function set vAlign(param1:String) : void
      {
         this._vAlign = param1;
      }
      
      public function get vAlign() : String
      {
         return this._vAlign;
      }
      
      public function get inLayout() : Boolean
      {
         return this._inLayout;
      }
      
      public function excludeFromLayout(param1:Boolean = true) : void
      {
         if(!this._inLayout)
         {
            return;
         }
         this._inLayout = false;
         if(param1)
         {
            this._showOrHide = this.HIDE;
         }
      }
      
      public function includeInLayout(param1:Boolean = true) : void
      {
         if(this._inLayout)
         {
            return;
         }
         this._inLayout = true;
         if(param1)
         {
            this._showOrHide = this.SHOW;
         }
      }
      
      public function set renderCallback(param1:Function) : void
      {
         this._renderCallback = param1;
      }
      
      public function get renderCallback() : Function
      {
         return this._renderCallback;
      }
      
      public function set hideCallback(param1:Function) : void
      {
         this._hideCallback = param1;
      }
      
      public function get hideCallback() : Function
      {
         return this._hideCallback;
      }
      
      public function set showCallback(param1:Function) : void
      {
         this._showCallback = param1;
      }
      
      public function get showCallback() : Function
      {
         return this._showCallback;
      }
      
      public function get position() : Point
      {
         return this._position;
      }
      
      public function get contentRect() : Rectangle
      {
         return this._contentRect;
      }
      
      public function get visibleRect() : Rectangle
      {
         return this._visibleRect;
      }
      
      public function toString() : String
      {
         return "" + (!!this.id?" id:" + this.id + ",":"") + " position:" + this.position + ", content:" + this.contentRect + ", visible:" + this.visibleRect;
      }
      
      function parse(param1:RenderConfig) : void
      {
         this.parseLayoutItem(param1);
         this._showOrHide = this.FALSE;
      }
      
      function exclude(param1:RenderConfig) : void
      {
         this.excludeLayoutItem(param1);
         this._showOrHide = this.FALSE;
      }
      
      function createRenderConfig(param1:RenderConfig = null) : RenderConfig
      {
         var _loc2_:RenderConfig = !!param1?param1.clone():new RenderConfig();
         if(this._showOrHide == this.SHOW)
         {
            _loc2_.show = true;
         }
         if(this._showOrHide == this.HIDE)
         {
            _loc2_.hide = true;
         }
         if(this._renderCallback != null)
         {
            _loc2_.renderCallback = this._renderCallback;
         }
         if(this._hideCallback != null)
         {
            _loc2_.hideCallback = this._hideCallback;
         }
         if(this._showCallback != null)
         {
            _loc2_.showCallback = this._showCallback;
         }
         return _loc2_;
      }
      
      function get cell() : ICell
      {
         return this._cell;
      }
      
      as3commons_ui function notifyRenderFinished() : void
      {
         if(!this._cell)
         {
            return;
         }
         this._position = this._cell.position;
         this._contentRect = this._cell.contentRect;
         this._visibleRect = this._cell.visibleRect;
         this._cell = null;
      }
      
      protected function excludeLayoutItem(param1:RenderConfig) : void
      {
      }
      
      protected function parseLayoutItem(param1:RenderConfig) : void
      {
      }
   }
}
