package fl.text
{
   import flash.display.CapsStyle;
   import flash.display.DisplayObjectContainer;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flashx.textLayout.container.TextContainerManager;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.Direction;
   
   public class TCMText extends Sprite
   {
      
      static var genericFonts:Array = ["_sans","_serif","_typewriter","_gothic","_gothicMono","_mincho","_ゴシック","_等幅","_明朝"];
       
      
      private var _border:Boolean;
      
      private var _background:Boolean;
      
      private var _backgroundAlpha:Number;
      
      private var _borderAlpha:Number;
      
      private var _borderColor:uint;
      
      private var _bgShape:Shape;
      
      private var _tcmStage:Sprite;
      
      private var _backgroundColor:uint;
      
      private var _inRepaint:Boolean;
      
      private var _tcm:TextContainerManager;
      
      private var _invalid:Boolean;
      
      private var _borderWidth:Number;
      
      public function TCMText()
      {
         var container:DisplayObjectContainer = null;
         super();
         tabEnabled = false;
         focusRect = false;
         this._bgShape = new Shape();
         this._tcmStage = new Sprite();
         addChild(this._bgShape);
         addChild(this._tcmStage);
         this._tcmStage.tabEnabled = true;
         this._tcm = new TLFTextContainerManager(this._tcmStage,Configuration(TCMRuntimeManager.getGlobalConfig()));
         try
         {
            if(this.parent != null)
            {
               container = parent as DisplayObjectContainer;
               if(container != null)
               {
                  TCMRuntimeManager.getSingleton().initInstance(this,container);
               }
            }
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      public function set border(param1:Boolean) : void
      {
         if(this._border != param1)
         {
            this._border = param1;
            this.invalidate();
         }
      }
      
      private function invalidate() : void
      {
         if(this._invalid)
         {
            return;
         }
         if(stage != null)
         {
            try
            {
               stage.addEventListener(Event.RENDER,this.repaint,false,0,true);
               stage.invalidate();
            }
            catch(se:SecurityError)
            {
               addEventListener(Event.FRAME_CONSTRUCTED,repaint,false,0,true);
            }
         }
         else if(parent == null)
         {
            addEventListener(Event.ADDED,this.repaint,false,0,true);
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.repaint,false,0,true);
            addEventListener(Event.FRAME_CONSTRUCTED,this.repaint,false,0,true);
         }
         this._invalid = true;
      }
      
      public function set borderWidth(param1:Number) : void
      {
         if(this._borderWidth != param1)
         {
            this._borderWidth = param1;
            if(this._borderWidth < 1)
            {
               this.borderWidth = 1;
            }
            else if(this._borderWidth > 100)
            {
               this._borderWidth = 100;
            }
            this.invalidate();
         }
      }
      
      public function get border() : Boolean
      {
         return this._border;
      }
      
      public function set borderColor(param1:uint) : void
      {
         if(this._borderColor != param1)
         {
            this._borderColor = param1 & 16777215;
            this.invalidate();
         }
      }
      
      public function get borderWidth() : Number
      {
         return this._borderWidth;
      }
      
      public function get backgroundAlpha() : Number
      {
         return this._backgroundAlpha;
      }
      
      public function set scrollV(param1:int) : void
      {
         var _loc2_:String = !!this.UsingTextFlow()?this._tcm.getTextFlow().blockProgression:this._tcm.hostFormat.blockProgression;
         if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param1 > this.maxScrollV)
         {
            param1 = this.maxScrollV;
         }
         if(_loc2_ == BlockProgression.RL)
         {
            this._tcm.horizontalScrollPosition = -param1;
         }
         else
         {
            this._tcm.verticalScrollPosition = param1;
         }
      }
      
      public function get backgroundColor() : uint
      {
         return this._backgroundColor;
      }
      
      public function get maxScrollH() : int
      {
         var _loc1_:String = !!this.UsingTextFlow()?this._tcm.getTextFlow().blockProgression:this._tcm.hostFormat.blockProgression;
         var _loc2_:Rectangle = this._tcm.getContentBounds();
         var _loc3_:int = _loc1_ == BlockProgression.RL?int(_loc2_.height - this._tcm.compositionHeight):int(_loc2_.width - this._tcm.compositionWidth);
         return _loc3_ > 0?int(_loc3_):0;
      }
      
      public function get borderAlpha() : Number
      {
         return this._borderAlpha;
      }
      
      public function get scrollH() : int
      {
         var _loc1_:String = !!this.UsingTextFlow()?this._tcm.getTextFlow().blockProgression:this._tcm.hostFormat.blockProgression;
         return _loc1_ == BlockProgression.RL?int(Math.abs(this._tcm.verticalScrollPosition)):int(Math.abs(this._tcm.horizontalScrollPosition));
      }
      
      public function set background(param1:Boolean) : void
      {
         if(this._background != param1)
         {
            this._background = param1;
            this.invalidate();
         }
      }
      
      public function get tcm() : TextContainerManager
      {
         return this._tcm;
      }
      
      public function set backgroundAlpha(param1:Number) : void
      {
         if(this._backgroundAlpha != param1)
         {
            this._backgroundAlpha = param1;
            if(this._backgroundAlpha < 0)
            {
               this._backgroundAlpha = 0;
            }
            else if(this._backgroundAlpha > 1)
            {
               this._backgroundAlpha = 1;
            }
            this.invalidate();
         }
      }
      
      function repaint(param1:Event) : void
      {
         var contHeight:Number = NaN;
         var contWidth:Number = NaN;
         var e:Event = param1;
         if(this._inRepaint)
         {
            return;
         }
         this._inRepaint = true;
         if(e != null)
         {
            if(e.type == Event.ADDED && e.target != this)
            {
               this._inRepaint = false;
               return;
            }
            removeEventListener(Event.ADDED,this.repaint);
            removeEventListener(Event.ADDED_TO_STAGE,this.repaint);
            removeEventListener(Event.FRAME_CONSTRUCTED,this.repaint);
            try
            {
               if(stage != null)
               {
                  stage.removeEventListener(Event.RENDER,this.repaint);
               }
               else if(e.type == Event.RENDER)
               {
                  e.target.removeEventListener(Event.RENDER,this.repaint);
               }
            }
            catch(se:SecurityError)
            {
            }
         }
         this._tcm.updateContainer();
         var origin:Number = !!this._border?Number(-this._borderWidth / 2):Number(0);
         if(this._background || this._border)
         {
            graphics.clear();
            if(this._background)
            {
               graphics.beginFill(this._backgroundColor,this._backgroundAlpha);
            }
            if(this._border)
            {
               graphics.lineStyle(this._borderWidth,this._borderColor,this._borderAlpha,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.MITER,10);
            }
            contHeight = this._tcm.compositionHeight;
            if(isNaN(contHeight))
            {
               contHeight = this._tcm.getContentBounds().height;
            }
            if(this._border)
            {
               contHeight = contHeight + this._borderWidth;
            }
            contWidth = this._tcm.compositionWidth;
            if(isNaN(contWidth))
            {
               contWidth = this._tcm.getContentBounds().width;
            }
            if(this._border)
            {
               contWidth = contWidth + this._borderWidth;
            }
            graphics.drawRect(origin,origin,contWidth,contHeight);
            if(this._background)
            {
               graphics.endFill();
            }
         }
         else
         {
            contHeight = this._tcm.compositionHeight;
            if(isNaN(contHeight))
            {
               contHeight = this._tcm.getContentBounds().height;
            }
            contWidth = this._tcm.compositionWidth;
            if(isNaN(contWidth))
            {
               contWidth = this._tcm.getContentBounds().width;
            }
            this._bgShape.graphics.clear();
            this._bgShape.graphics.beginFill(0,0);
            this._bgShape.graphics.drawRect(0,0,contWidth,contHeight);
            this._bgShape.visible = false;
         }
         this._invalid = false;
         this._inRepaint = false;
      }
      
      public function set borderAlpha(param1:Number) : void
      {
         if(this._borderAlpha != param1)
         {
            this._borderAlpha = param1;
            if(this._borderAlpha < 0)
            {
               this._borderAlpha = 0;
            }
            else if(this._borderAlpha > 1)
            {
               this._borderAlpha = 1;
            }
            this.invalidate();
         }
      }
      
      public function get scrollV() : int
      {
         var _loc1_:String = !!this.UsingTextFlow()?this._tcm.getTextFlow().blockProgression:this._tcm.hostFormat.blockProgression;
         return _loc1_ == BlockProgression.RL?int(Math.abs(this._tcm.horizontalScrollPosition)):int(Math.abs(this._tcm.verticalScrollPosition));
      }
      
      public function set backgroundColor(param1:uint) : void
      {
         if(this._backgroundColor != param1)
         {
            this._backgroundColor = param1 & 16777215;
            this.invalidate();
         }
      }
      
      public function get borderColor() : uint
      {
         return this._borderColor;
      }
      
      public function get maxScrollV() : int
      {
         var _loc1_:String = !!this.UsingTextFlow()?this._tcm.getTextFlow().blockProgression:this._tcm.hostFormat.blockProgression;
         var _loc2_:Rectangle = this._tcm.getContentBounds();
         var _loc3_:int = _loc1_ == BlockProgression.RL?int(_loc2_.width - this._tcm.compositionWidth):int(_loc2_.height - this._tcm.compositionHeight);
         return _loc3_ > 0?int(_loc3_):0;
      }
      
      public function get background() : Boolean
      {
         return this._background;
      }
      
      public function set scrollH(param1:int) : void
      {
         var _loc2_:String = !!this.UsingTextFlow()?this._tcm.getTextFlow().blockProgression:this._tcm.hostFormat.blockProgression;
         var _loc3_:String = !!this.UsingTextFlow()?this._tcm.getTextFlow().direction:this._tcm.hostFormat.direction;
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param1 > this.maxScrollH)
         {
            param1 = this.maxScrollH;
         }
         if(_loc3_ == Direction.RTL)
         {
            param1 = -param1;
         }
         if(_loc2_ == BlockProgression.RL)
         {
            this._tcm.verticalScrollPosition = param1;
         }
         else
         {
            this._tcm.horizontalScrollPosition = param1;
         }
      }
      
      private function UsingTextFlow() : Boolean
      {
         return !(this._tcm.composeState == TextContainerManager.COMPOSE_FACTORY && this._tcm.sourceState == TextContainerManager.SOURCE_STRING);
      }
   }
}
