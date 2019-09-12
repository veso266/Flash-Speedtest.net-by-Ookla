package fl.text.container
{
   import fl.text.TLFTextField;
   import flash.desktop.Clipboard;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.system.IME;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.container.ScrollPolicy;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.InlineGraphicElement;
   import flashx.textLayout.formats.BlockProgression;
   
   public class TLFContainerController extends ContainerController
   {
       
      
      private var _transparentBGButton:SimpleButton;
      
      private var _transparentBGButtonX:Number;
      
      private var _transparentBGButtonY:Number;
      
      private var _transparentBGButtonHeight:Number;
      
      private var _owner:TLFTextField;
      
      private var _transparentBGButtonWidth:Number;
      
      public function TLFContainerController(param1:Sprite, param2:TLFTextField)
      {
         this._transparentBGButton = null;
         this._transparentBGButtonX = NaN;
         this._transparentBGButtonY = NaN;
         this._transparentBGButtonWidth = NaN;
         this._transparentBGButtonHeight = NaN;
         this._owner = param2;
         super(param1);
      }
      
      override public function editHandler(param1:Event) : void
      {
         if((param1.type == Event.COPY || param1.type == Event.CUT) && this._owner.displayAsPassword)
         {
            return;
         }
         super.editHandler(param1);
         if((param1.type == Event.COPY || param1.type == Event.CUT) && !this._owner.useRichTextClipboard)
         {
            Clipboard.generalClipboard.clearData("TEXT_LAYOUT_MARKUP");
         }
      }
      
      override function attachTransparentBackgroundForHit(param1:Boolean) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Boolean = false;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Graphics = null;
         if(attachTransparentBackground)
         {
            _loc2_ = container;
            if(_loc2_ != null)
            {
               if(param1)
               {
                  if(this._transparentBGButton != null)
                  {
                     Shape(this._transparentBGButton.hitTestState).graphics.clear();
                     this._transparentBGButtonX = this._transparentBGButtonY = this._transparentBGButtonWidth = this._transparentBGButtonHeight = NaN;
                  }
               }
               else
               {
                  if(this._transparentBGButton == null)
                  {
                     this._transparentBGButton = new SimpleButton();
                     this._transparentBGButton.focusRect = false;
                     this._transparentBGButton.tabEnabled = false;
                     this._transparentBGButton.addEventListener(MouseEvent.MOUSE_DOWN,this.abandonComposition,false,0,true);
                     this._transparentBGButton.useHandCursor = false;
                     this._transparentBGButton.hitTestState = new Shape();
                     _loc2_.addChildAt(this._transparentBGButton,0);
                  }
                  _loc3_ = !!measureWidth?Number(contentWidth):Number(compositionWidth);
                  _loc4_ = !!measureHeight?Number(contentHeight):Number(compositionHeight);
                  _loc5_ = effectiveBlockProgression == BlockProgression.RL && horizontalScrollPolicy != ScrollPolicy.OFF;
                  _loc6_ = !!_loc5_?Number(horizontalScrollPosition - _loc3_):Number(horizontalScrollPosition);
                  _loc7_ = verticalScrollPosition;
                  if(_loc6_ != this._transparentBGButtonX || _loc7_ != this._transparentBGButtonY || _loc3_ != this._transparentBGButtonWidth || _loc4_ != this._transparentBGButtonHeight)
                  {
                     _loc8_ = Shape(this._transparentBGButton.hitTestState).graphics;
                     _loc8_.clear();
                     if(_loc3_ != 0 && _loc4_ != 0)
                     {
                        _loc8_.beginFill(0);
                        _loc8_.drawRect(_loc6_,_loc7_,_loc3_,_loc4_);
                        _loc8_.endFill();
                     }
                     this._transparentBGButtonX = _loc6_;
                     this._transparentBGButtonY = _loc7_;
                     this._transparentBGButtonWidth = _loc3_;
                     this._transparentBGButtonHeight = _loc4_;
                  }
               }
            }
         }
      }
      
      public function get ownerField() : TLFTextField
      {
         return this._owner;
      }
      
      override public function softKeyboardActivatingHandler(param1:Event) : void
      {
         if(Configuration.playerEnablesSpicyFeatures)
         {
            container.softKeyboardInputAreaOfInterest = this._owner.getBounds(this._owner.stage);
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
      
      override public function mouseWheelHandler(param1:MouseEvent) : void
      {
         if(!this._owner.mouseWheelEnabled)
         {
            return;
         }
         super.mouseWheelHandler(param1);
      }
      
      private function abandonComposition(param1:MouseEvent) : void
      {
         var _loc2_:Function = IME["compositionAbandoned"];
         if(IME["compositionAbandoned"] !== undefined)
         {
            _loc2_();
         }
      }
      
      override protected function addInlineGraphicElement(param1:DisplayObjectContainer, param2:DisplayObject, param3:int) : void
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
