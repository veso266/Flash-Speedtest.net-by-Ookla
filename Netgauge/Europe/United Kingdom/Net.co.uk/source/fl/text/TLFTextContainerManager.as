package fl.text
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flashx.textLayout.container.TextContainerManager;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.InlineGraphicElement;
   
   public class TLFTextContainerManager extends TextContainerManager
   {
       
      
      private var _transparentBGButton:SimpleButton;
      
      private var _transparentBGButtonX:Number;
      
      private var _transparentBGButtonHeight:Number;
      
      private var _transparentBGButtonY:Number;
      
      private var _transparentBGButtonWidth:Number;
      
      public function TLFTextContainerManager(param1:Sprite, param2:Configuration = null)
      {
         this._transparentBGButton = null;
         this._transparentBGButtonX = NaN;
         this._transparentBGButtonY = NaN;
         this._transparentBGButtonWidth = NaN;
         this._transparentBGButtonHeight = NaN;
         super(param1,param2);
         param1.mouseChildren = true;
      }
      
      override public function softKeyboardActivatingHandler(param1:Event) : void
      {
         if(Configuration.playerEnablesSpicyFeatures)
         {
            container.softKeyboardInputAreaOfInterest = container.parent.getBounds(container.stage);
         }
         super.softKeyboardActivatingHandler(param1);
      }
      
      private function has3D(param1:DisplayObject) : Boolean
      {
         var _loc3_:int = 0;
         if(param1.transform.matrix3D != null)
         {
            return true;
         }
         var _loc2_:DisplayObjectContainer = param1 as DisplayObjectContainer;
         if(_loc2_ != null)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.numChildren)
            {
               if(this.has3D(_loc2_.getChildAt(_loc3_)))
               {
                  return true;
               }
               _loc3_++;
            }
         }
         return false;
      }
      
      override function factoryUpdateContainerChildren() : void
      {
         super.factoryUpdateContainerChildren();
         if(this._transparentBGButton != null)
         {
            container.addChildAt(this._transparentBGButton,0);
         }
      }
      
      override public function setText(param1:String) : void
      {
         super.setText(param1);
         container.mouseChildren = true;
      }
      
      override public function drawBackgroundAndSetScrollRect(param1:Number, param2:Number) : Boolean
      {
         var _loc4_:Rectangle = null;
         var _loc5_:Graphics = null;
         var _loc3_:Boolean = super.drawBackgroundAndSetScrollRect(param1,param2);
         container.graphics.clear();
         if(this._transparentBGButton == null)
         {
            this._transparentBGButton = new SimpleButton();
            this._transparentBGButton.focusRect = false;
            this._transparentBGButton.tabEnabled = false;
            this._transparentBGButton.useHandCursor = false;
            this._transparentBGButton.hitTestState = new Shape();
            container.addChildAt(this._transparentBGButton,0);
         }
         if(_loc3_)
         {
            _loc4_ = container.scrollRect;
         }
         else
         {
            _loc4_ = getContentBounds();
            if(!isNaN(compositionWidth))
            {
               _loc4_.width = compositionWidth;
            }
            if(!isNaN(compositionHeight))
            {
               _loc4_.height = compositionHeight;
            }
            _loc4_.x = 0;
            _loc4_.y = 0;
         }
         if(_loc4_.x != this._transparentBGButtonX || _loc4_.y != this._transparentBGButtonY || _loc4_.width != this._transparentBGButtonWidth || _loc4_.height != this._transparentBGButtonHeight)
         {
            _loc5_ = Shape(this._transparentBGButton.hitTestState).graphics;
            _loc5_.clear();
            if(_loc4_.width != 0 && _loc4_.height != 0)
            {
               _loc5_.beginFill(0);
               _loc5_.drawRect(_loc4_.x,_loc4_.y,_loc4_.width,_loc4_.height);
               _loc5_.endFill();
            }
            this._transparentBGButtonX = _loc4_.x;
            this._transparentBGButtonY = _loc4_.y;
            this._transparentBGButtonWidth = _loc4_.width;
            this._transparentBGButtonHeight = _loc4_.height;
         }
         return _loc3_;
      }
      
      override function clearContainerChildren(param1:Boolean) : void
      {
         super.clearContainerChildren(param1);
         if(this._transparentBGButton != null)
         {
            container.addChildAt(this._transparentBGButton,0);
         }
      }
      
      override public function mouseWheelHandler(param1:MouseEvent) : void
      {
         var _loc2_:Object = param1.target.parent.parent;
         if(_loc2_ && _loc2_.hasOwnProperty("mouseWheelEnabled") && !_loc2_["mouseWheelEnabled"])
         {
            return;
         }
         super.mouseWheelHandler(param1);
      }
      
      override function addInlineGraphicElement(param1:DisplayObjectContainer, param2:DisplayObject, param3:int) : void
      {
         var _loc5_:InlineGraphicElement = null;
         var _loc6_:Rectangle = null;
         var _loc4_:DisplayObject = DisplayObject(Sprite(param2).getChildAt(0));
         if(_loc4_.hasOwnProperty("ilg"))
         {
            _loc5_ = _loc4_["ilg"];
            _loc6_ = _loc4_.getBounds(param2);
            if(this.has3D(_loc4_))
            {
               if(_loc5_.elementWidth != _loc6_.width || _loc5_.elementHeight != _loc6_.height)
               {
                  _loc5_.elementWidth = Math.max(1,_loc6_.width);
                  _loc5_.elementHeight = Math.max(1,_loc6_.height);
               }
            }
            _loc4_.x = _loc4_.x - _loc6_.x;
            _loc4_.y = _loc4_.y - _loc6_.y;
         }
         super.addInlineGraphicElement(param1,param2,param3);
      }
   }
}
