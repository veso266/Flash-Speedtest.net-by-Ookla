package fl.text
{
   import flash.display.Sprite;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.text.engine.FontLookup;
   import flash.text.engine.FontPosture;
   import flash.text.engine.FontWeight;
   import flash.text.engine.Kerning;
   import flash.text.engine.RenderingMode;
   import flash.text.engine.TabAlignment;
   import flash.text.engine.TextLine;
   import flashx.textLayout.compose.TextFlowLine;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.container.TextContainerManager;
   import flashx.textLayout.edit.EditingMode;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.events.CompositionCompleteEvent;
   import flashx.textLayout.events.FlowOperationEvent;
   import flashx.textLayout.events.TextLayoutEvent;
   import flashx.textLayout.events.UpdateCompleteEvent;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.Direction;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.LeadingModel;
   import flashx.textLayout.formats.LineBreak;
   import flashx.textLayout.formats.TabStopFormat;
   import flashx.textLayout.formats.TextDecoration;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.formats.VerticalAlign;
   
   class SingleTextContainerManager extends CommonTextContainerManager implements IContainerManager
   {
      
      private static var _alwaysShowOffConfiguration:Configuration;
      
      private static var initConfiguration:Boolean = true;
      
      private static var _alwaysShowOnConfiguration:Configuration;
       
      
      private var _tcm:TLFTextContainerManager;
      
      function SingleTextContainerManager(param1:Sprite, param2:TLFTextField, param3:ContainerController = null)
      {
         super();
         _controller = param3;
         _container = param1;
         _ownerField = param2;
         if(initConfiguration)
         {
            _alwaysShowOffConfiguration = Configuration(Configuration(TextContainerManager.defaultConfiguration).clone());
            _alwaysShowOffConfiguration.focusedSelectionFormat = TLFTextField.focusedSelectionFormat;
            _alwaysShowOffConfiguration.inactiveSelectionFormat = TLFTextField.inactiveSelectionFormat;
            _alwaysShowOffConfiguration.unfocusedSelectionFormat = TLFTextField.alwaysShowSelectionOffFormat;
            _alwaysShowOnConfiguration = Configuration(Configuration(TextContainerManager.defaultConfiguration).clone());
            _alwaysShowOnConfiguration.focusedSelectionFormat = TLFTextField.focusedSelectionFormat;
            _alwaysShowOnConfiguration.inactiveSelectionFormat = TLFTextField.inactiveSelectionFormat;
            _alwaysShowOnConfiguration.unfocusedSelectionFormat = TLFTextField.alwaysShowSelectionOnFormat;
            initConfiguration = false;
         }
         this._tcm = new TLFTextContainerManager(_container,!!param2._alwaysShowSelection?_alwaysShowOnConfiguration:_alwaysShowOffConfiguration);
         this.addListeners();
         this._tcm.compositionHeight = int.MAX_VALUE;
         this._tcm.compositionWidth = int.MAX_VALUE;
      }
      
      public function get contentHeight() : Number
      {
         return this._tcm.getContentBounds().height;
      }
      
      override public function get textFlow() : TextFlow
      {
         var _loc1_:TextLayoutFormat = !!this.isTextStringAndFormat()?TextLayoutFormat(this.hostFormat):null;
         this._tcm.convertToTextFlowWithComposer();
         this.ConvertHostFormatToController(_loc1_);
         return this._tcm.getTextFlow();
      }
      
      override public function set direction(param1:String) : void
      {
         var _loc2_:TextLayoutFormat = null;
         if(!this.isTextStringAndFormat())
         {
            super.direction = param1;
         }
         else
         {
            _loc2_ = !!this.hostFormat?TextLayoutFormat(this.hostFormat):new TextLayoutFormat();
            switch(param1)
            {
               case Direction.LTR:
               case Direction.RTL:
               case FormatValue.INHERIT:
                  _loc2_.direction = param1;
                  break;
               default:
                  _loc2_.direction = Direction.LTR;
            }
            this.hostFormat = _loc2_;
         }
      }
      
      override public function replaceText(param1:int, param2:int, param3:String) : void
      {
         if(this.isTextStringAndFormat() && param3.search(/[\n\r]/g) == -1)
         {
            _ownerField.text = this.text.slice(0,param1) + param3 + this.text.slice(param2 + 1);
         }
         else
         {
            super.replaceText(param1,param2,param3);
         }
      }
      
      public function setCompositionSize(param1:Number, param2:Number) : void
      {
         this._tcm.compositionWidth = param1;
         this._tcm.compositionHeight = param2;
         if(this.controller)
         {
            this.controller.setCompositionSize(param1,param2);
         }
      }
      
      public function set paddingTop(param1:Object) : void
      {
         var _loc2_:TextLayoutFormat = !!this._tcm.hostFormat?TextLayoutFormat(this._tcm.hostFormat):new TextLayoutFormat();
         _loc2_.paddingTop = !!this.isTextStringAndFormat()?param1:0;
         this._tcm.hostFormat = _loc2_;
         if(!this.isTextStringAndFormat())
         {
            this.controller.paddingTop = param1;
         }
      }
      
      public function set paddingRight(param1:Object) : void
      {
         var _loc2_:TextLayoutFormat = !!this._tcm.hostFormat?TextLayoutFormat(this._tcm.hostFormat):new TextLayoutFormat();
         _loc2_.paddingRight = !!this.isTextStringAndFormat()?param1:0;
         this._tcm.hostFormat = _loc2_;
         if(!this.isTextStringAndFormat())
         {
            this.controller.paddingRight = param1;
         }
      }
      
      public function get numLines() : int
      {
         return this._tcm.getActualNumLines();
      }
      
      public function removeListeners() : void
      {
         this._tcm.removeEventListener(TextLayoutEvent.SCROLL,_ownerField.textFlow_ScrollHandler);
         this._tcm.removeEventListener(MouseEvent.CLICK,_ownerField.linkClick);
         this._tcm.removeEventListener(FlowOperationEvent.FLOW_OPERATION_BEGIN,_ownerField.textFlow_flowOperationBeginHandler);
         this._tcm.removeEventListener(FlowOperationEvent.FLOW_OPERATION_END,_ownerField.textFlow_flowOperationEndHandler);
         this._tcm.removeEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE,_ownerField.composeComplete);
         this._tcm.removeEventListener(UpdateCompleteEvent.UPDATE_COMPLETE,_ownerField.updateComplete);
         _ownerField.removeEventListener(FocusEvent.FOCUS_IN,this._tcm.focusInHandler);
      }
      
      public function get contentTop() : Number
      {
         return this._tcm.getContentBounds().top;
      }
      
      override public function isTextStringAndFormat() : Boolean
      {
         return this._tcm.composeState == TextContainerManager.COMPOSE_FACTORY && this._tcm.sourceState == TextContainerManager.SOURCE_STRING;
      }
      
      public function get contentLeft() : Number
      {
         return this._tcm.getContentBounds().left;
      }
      
      public function get columnWidth() : Object
      {
         if(this._tcm.hostFormat == null)
         {
            return FormatValue.AUTO;
         }
         return this._tcm.hostFormat.columnWidth == FormatValue.INHERIT?FormatValue.AUTO:this._tcm.hostFormat.columnWidth;
      }
      
      public function get firstBaselineOffset() : Object
      {
         if(this._tcm.hostFormat == null)
         {
            return VerticalAlign.TOP;
         }
         return this._tcm.hostFormat.firstBaselineOffset == FormatValue.INHERIT?FormatValue.AUTO:this._tcm.hostFormat.firstBaselineOffset;
      }
      
      public function get absoluteStart() : int
      {
         return 0;
      }
      
      public function get verticalScrollPosition() : Number
      {
         return this._tcm.verticalScrollPosition;
      }
      
      public function get text() : String
      {
         return this._tcm.getText("\n");
      }
      
      override public function get textColor() : uint
      {
         if(!this.isTextStringAndFormat())
         {
            return super.textColor;
         }
         if(this.hostFormat != null)
         {
            return uint(this.hostFormat.color);
         }
         return 0;
      }
      
      public function set paddingBottom(param1:Object) : void
      {
         var _loc2_:TextLayoutFormat = !!this._tcm.hostFormat?TextLayoutFormat(this._tcm.hostFormat):new TextLayoutFormat();
         _loc2_.paddingBottom = !!this.isTextStringAndFormat()?param1:0;
         this._tcm.hostFormat = _loc2_;
         if(!this.isTextStringAndFormat())
         {
            this.controller.paddingBottom = param1;
         }
      }
      
      public function set columnGap(param1:Object) : void
      {
         var _loc2_:TextLayoutFormat = !!this._tcm.hostFormat?TextLayoutFormat(this._tcm.hostFormat):new TextLayoutFormat();
         _loc2_.columnGap = param1;
         this._tcm.hostFormat = _loc2_;
      }
      
      public function set columnWidth(param1:Object) : void
      {
         var _loc2_:TextLayoutFormat = !!this._tcm.hostFormat?TextLayoutFormat(this._tcm.hostFormat):new TextLayoutFormat();
         _loc2_.columnWidth = param1;
         this._tcm.hostFormat = _loc2_;
      }
      
      public function get compositionWidth() : Number
      {
         return this._tcm.compositionWidth;
      }
      
      private function ConvertHostFormatToController(param1:TextLayoutFormat) : void
      {
         if(!param1)
         {
            return;
         }
         this.controller.paddingLeft = param1.paddingLeft;
         this.controller.paddingTop = param1.paddingTop;
         this.controller.paddingRight = param1.paddingRight;
         this.controller.paddingBottom = param1.paddingBottom;
         this.controller.verticalAlign = param1.verticalAlign;
         this.controller.columnCount = param1.columnCount;
         this.controller.columnGap = param1.columnGap;
         this.controller.columnWidth = param1.columnWidth;
      }
      
      public function get verticalAlign() : Object
      {
         if(this._tcm.hostFormat == null)
         {
            return FormatValue.AUTO;
         }
         return this._tcm.hostFormat.verticalAlign;
      }
      
      public function set verticalScrollPosition(param1:Number) : void
      {
         this._tcm.verticalScrollPosition = param1;
      }
      
      override public function set text(param1:String) : void
      {
         var _loc2_:TextLayoutFormat = null;
         if(param1.search(/[\r\n]/g) != -1)
         {
            super.text = param1;
         }
         else
         {
            if(this.isTextStringAndFormat())
            {
               _loc2_ = TextLayoutFormat(this.hostFormat);
            }
            else
            {
               _loc2_ = TextLayoutFormat(this.textFlow.getFirstLeaf().computedFormat);
               this.ConvertContainerValuesToHostFormat(_loc2_);
            }
            if(!_ownerField.displayAsPassword)
            {
               this._tcm.setText(param1);
            }
            else
            {
               this._tcm.setText(TLFTextField.repeat(_ownerField.passwordCharacter,param1));
            }
            this.hostFormat = _loc2_;
         }
      }
      
      public function getLineIndexBounds(param1:int) : Rectangle
      {
         var _loc2_:TextLine = this._tcm.getLineAt(param1);
         if(_loc2_ == null)
         {
            return new Rectangle();
         }
         return TextFlowLine(_loc2_.userData).getBounds();
      }
      
      public function set verticalAlign(param1:Object) : void
      {
         var _loc2_:TextLayoutFormat = !!this._tcm.hostFormat?TextLayoutFormat(this._tcm.hostFormat):new TextLayoutFormat();
         _loc2_.verticalAlign = param1;
         this._tcm.hostFormat = _loc2_;
         if(this.controller)
         {
            this.controller.verticalAlign = param1;
         }
      }
      
      public function get columnCount() : Object
      {
         if(this._tcm.hostFormat == null)
         {
            return FormatValue.AUTO;
         }
         return this._tcm.hostFormat.columnCount == FormatValue.INHERIT?FormatValue.AUTO:this._tcm.hostFormat.columnCount;
      }
      
      override public function appendText(param1:String) : void
      {
         if(this.isTextStringAndFormat() && param1.search(/[\n\r]/g) == -1)
         {
            _ownerField.text = this.text + param1;
         }
         else
         {
            super.appendText(param1);
         }
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return this._tcm.horizontalScrollPosition;
      }
      
      override public function set textColor(param1:uint) : void
      {
         var _loc2_:TextLayoutFormat = null;
         if(this.isTextStringAndFormat())
         {
            _loc2_ = !!this.hostFormat?TextLayoutFormat(this.hostFormat):new TextLayoutFormat();
            _loc2_.color = param1;
            this.hostFormat = _loc2_;
         }
         else
         {
            super.textColor = param1;
         }
      }
      
      public function set paddingLeft(param1:Object) : void
      {
         var _loc2_:TextLayoutFormat = !!this._tcm.hostFormat?TextLayoutFormat(this._tcm.hostFormat):new TextLayoutFormat();
         _loc2_.paddingLeft = !!this.isTextStringAndFormat()?param1:0;
         this._tcm.hostFormat = _loc2_;
         if(!this.isTextStringAndFormat())
         {
            this.controller.paddingLeft = param1;
         }
      }
      
      public function get compositionHeight() : Number
      {
         return this._tcm.compositionHeight;
      }
      
      override public function get lineBreak() : String
      {
         if(!this.isTextStringAndFormat())
         {
            return super.lineBreak;
         }
         if(this.hostFormat)
         {
            return this.hostFormat.lineBreak;
         }
         return LineBreak.EXPLICIT;
      }
      
      override public function get textLength() : int
      {
         return this._tcm.getText().length;
      }
      
      public function set hostFormat(param1:ITextLayoutFormat) : void
      {
         this._tcm.hostFormat = param1;
         if(!this.isTextStringAndFormat())
         {
            this.textFlow.hostFormat = param1;
            this.ConvertHostFormatToController(param1 as TextLayoutFormat);
         }
      }
      
      public function get paddingTop() : Object
      {
         if(!this.isTextStringAndFormat())
         {
            return this.controller.paddingTop;
         }
         if(this._tcm.hostFormat == null)
         {
            return 2;
         }
         return this._tcm.hostFormat.paddingTop;
      }
      
      override public function getTextFormat(param1:int, param2:int) : TextFormat
      {
         var _loc7_:Number = NaN;
         var _loc8_:String = null;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:TabStopFormat = null;
         if(!this.isTextStringAndFormat())
         {
            return super.getTextFormat(param1,param2);
         }
         var _loc3_:TextFormat = new TextFormat();
         var _loc4_:TextLayoutFormat = !!this.hostFormat?TextLayoutFormat(this.hostFormat):new TextLayoutFormat();
         if(_loc4_.textAlign == TextFormatAlign.LEFT || _loc4_.textAlign == TextFormatAlign.CENTER || _loc4_.textAlign == TextFormatAlign.RIGHT || _loc4_.textAlign == TextFormatAlign.JUSTIFY)
         {
            _loc3_.align = _loc4_.textAlign;
         }
         _loc3_.bold = _loc4_.fontWeight == FontWeight.BOLD;
         _loc3_.color = _loc4_.color;
         var _loc5_:Array = String(_loc4_.fontFamily).split(",");
         _loc3_.font = _loc5_[0];
         _loc3_.indent = _loc4_.textIndent;
         _loc3_.italic = _loc4_.fontStyle == FontPosture.ITALIC;
         _loc3_.kerning = _loc4_.kerning == Kerning.ON || _loc4_.kerning == Kerning.AUTO;
         if(_loc4_.lineHeight == undefined || _loc4_.lineHeight < -720)
         {
            _loc3_.leading = null;
         }
         else
         {
            _loc7_ = Number.NaN;
            _loc8_ = _loc4_.lineHeight;
            if(_loc8_)
            {
               if(_loc8_.indexOf("%") == -1)
               {
                  _loc7_ = Number(_loc8_);
               }
               else
               {
                  _loc9_ = _loc4_.fontSize;
                  _loc7_ = Number(_loc8_.replace(/%/,"")) * _loc9_ / 100;
               }
            }
            if(!isNaN(_loc7_))
            {
               _loc3_.leading = _loc7_;
            }
         }
         _loc3_.leftMargin = _loc4_.paragraphStartIndent;
         _loc3_.letterSpacing = _loc4_.trackingRight;
         _loc3_.rightMargin = _loc4_.paragraphEndIndent;
         _loc3_.size = _loc4_.fontSize;
         var _loc6_:Array = [];
         if(_loc4_.tabStops != null)
         {
            _loc10_ = _loc4_.tabStops.length;
            _loc11_ = 0;
            while(_loc11_ < _loc10_)
            {
               _loc12_ = _loc4_.tabStops[_loc11_];
               if(_loc12_.alignment == TabAlignment.DECIMAL)
               {
                  _loc6_.push(_loc12_.position);
               }
               _loc11_++;
            }
            _loc6_.sort(Array.NUMERIC);
         }
         _loc3_.tabStops = _loc6_;
         _loc3_.underline = _loc4_.textDecoration == TextDecoration.UNDERLINE;
         return _loc3_;
      }
      
      override public function setTextFormat(param1:TextFormat, param2:int, param3:int, param4:TextLayoutFormat, param5:TextLayoutFormat) : void
      {
         var _loc8_:Array = null;
         var _loc9_:String = null;
         var _loc10_:TabStopFormat = null;
         if(!this.isTextStringAndFormat() || param1.url != null || param1.target != null || param2 > 0 || param3 > 0 && param3 < this.textLength)
         {
            super.setTextFormat(param1,param2,param3,param4,param5);
            return;
         }
         var _loc6_:TextLayoutFormat = new TextLayoutFormat();
         if(param1.align != null)
         {
            if(param1.align == TextFormatAlign.CENTER || param1.align == TextFormatAlign.JUSTIFY || param1.align == TextFormatAlign.LEFT || param1.align == TextFormatAlign.RIGHT)
            {
               _loc6_.textAlign = param1.align;
            }
            else
            {
               _loc6_.textAlign = TextFormatAlign.RIGHT;
            }
         }
         if(param1.blockIndent != null && param1.leftMargin != null)
         {
            _loc6_.paragraphStartIndent = param1.blockIndent + param1.leftMargin;
         }
         else if(param1.blockIndent != null)
         {
            _loc6_.paragraphStartIndent = param1.blockIndent;
         }
         else if(param1.leftMargin != null)
         {
            _loc6_.paragraphStartIndent = param1.leftMargin;
         }
         if(param1.indent != null)
         {
            _loc6_.textIndent = param1.indent;
         }
         if(param1.leading != null)
         {
            _loc6_.leadingModel = LeadingModel.APPROXIMATE_TEXT_FIELD;
            _loc6_.lineHeight = param1.leading;
         }
         if(param1.rightMargin != null)
         {
            _loc6_.paragraphEndIndent = param1.rightMargin;
         }
         if(param1.tabStops != null)
         {
            _loc8_ = new Array();
            param1.tabStops.sort(Array.NUMERIC);
            for each(_loc9_ in param1.tabStops)
            {
               _loc10_ = new TabStopFormat();
               _loc10_.alignment = TabAlignment.DECIMAL;
               _loc10_.position = int(_loc9_);
               _loc8_.push(_loc10_);
            }
            _loc6_.tabStops = _loc8_;
         }
         if(param1.bold != null)
         {
            _loc6_.fontWeight = !!param1.bold?FontWeight.BOLD:FontWeight.NORMAL;
         }
         if(param1.color != null)
         {
            _loc6_.color = param1.color;
         }
         if(param1.font != null)
         {
            _loc6_.fontFamily = param1.font;
         }
         if(param1.italic != null)
         {
            _loc6_.fontStyle = !!param1.italic?FontPosture.ITALIC:FontPosture.NORMAL;
         }
         if(param1.kerning != null)
         {
            _loc6_.kerning = !!param1.kerning?Kerning.ON:Kerning.OFF;
         }
         if(param1.letterSpacing != null)
         {
            _loc6_.trackingRight = param1.letterSpacing;
         }
         if(param1.size != null)
         {
            _loc6_.fontSize = param1.size;
         }
         if(param1.underline != null)
         {
            _loc6_.textDecoration = !!param1.underline?TextDecoration.UNDERLINE:TextDecoration.NONE;
         }
         var _loc7_:TextLayoutFormat = TextLayoutFormat(this.hostFormat);
         _loc7_.apply(_loc6_);
         this.hostFormat = _loc7_;
      }
      
      override public function get direction() : String
      {
         if(!this.isTextStringAndFormat())
         {
            return super.direction;
         }
         if(this.hostFormat && this.hostFormat.direction)
         {
            return this.hostFormat.direction;
         }
         return Direction.LTR;
      }
      
      public function set editModeNoInteraction(param1:String) : void
      {
         if(this._tcm.editingMode == param1)
         {
            return;
         }
         if(param1 == EditingMode.READ_WRITE)
         {
            this._tcm.editingMode = EditingMode.READ_WRITE;
         }
         else if(param1 == EditingMode.READ_SELECT)
         {
            this._tcm.editingMode = EditingMode.READ_SELECT;
         }
         else
         {
            this._tcm.editingMode = EditingMode.READ_ONLY;
         }
      }
      
      override public function compose() : void
      {
         this._tcm.compose();
         _ownerField.composeComplete(null);
      }
      
      public function set firstBaselineOffset(param1:Object) : void
      {
         var _loc2_:TextLayoutFormat = !!this._tcm.hostFormat?TextLayoutFormat(this._tcm.hostFormat):new TextLayoutFormat();
         _loc2_.firstBaselineOffset = param1;
         this._tcm.hostFormat = _loc2_;
         if(this.controller)
         {
            this.controller.firstBaselineOffset = param1;
         }
      }
      
      public function set editMode(param1:String) : void
      {
         if(this._tcm.editingMode == param1)
         {
            return;
         }
         if(param1 == EditingMode.READ_WRITE)
         {
            if(this._tcm.editingMode != EditingMode.READ_ONLY)
            {
               this._tcm.endInteraction();
            }
            this._tcm.editingMode = EditingMode.READ_WRITE;
            this._tcm.beginInteraction();
         }
         else if(param1 == EditingMode.READ_SELECT)
         {
            if(this._tcm.editingMode != EditingMode.READ_ONLY)
            {
               this._tcm.endInteraction();
            }
            this._tcm.editingMode = EditingMode.READ_SELECT;
            this._tcm.beginInteraction();
         }
         else
         {
            this._tcm.editingMode = EditingMode.READ_ONLY;
            this._tcm.endInteraction();
         }
      }
      
      public function get controller() : ContainerController
      {
         if(this.isTextStringAndFormat() || this._tcm.getTextFlow().flowComposer == null)
         {
            return null;
         }
         return this._tcm.getTextFlow().flowComposer.numControllers > 0?this._tcm.getTextFlow().flowComposer.getControllerAt(0):null;
      }
      
      public function addListeners() : void
      {
         this._tcm.addEventListener(TextLayoutEvent.SCROLL,_ownerField.textFlow_ScrollHandler,false,0,true);
         this._tcm.addEventListener(MouseEvent.CLICK,_ownerField.linkClick,false,0,true);
         this._tcm.addEventListener(FlowOperationEvent.FLOW_OPERATION_BEGIN,_ownerField.textFlow_flowOperationBeginHandler,false,0,true);
         this._tcm.addEventListener(FlowOperationEvent.FLOW_OPERATION_END,_ownerField.textFlow_flowOperationEndHandler,false,0,true);
         this._tcm.addEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE,_ownerField.composeComplete,false,0,true);
         this._tcm.addEventListener(UpdateCompleteEvent.UPDATE_COMPLETE,_ownerField.updateComplete,false,0,true);
         _ownerField.addEventListener(FocusEvent.FOCUS_IN,this._tcm.focusInHandler,false,0,true);
      }
      
      override public function setFormatForAllElements(param1:FlowGroupElement, param2:TextLayoutFormat) : void
      {
         var _loc3_:TextLayoutFormat = null;
         if(this.isTextStringAndFormat())
         {
            _loc3_ = !!this.hostFormat?TextLayoutFormat(this.hostFormat):new TextLayoutFormat();
            _loc3_.apply(param2);
            this.hostFormat = _loc3_;
         }
         else
         {
            super.setFormatForAllElements(param1,param2);
         }
      }
      
      public function get columnGap() : Object
      {
         if(this._tcm.hostFormat == null)
         {
            return 20;
         }
         return this._tcm.hostFormat.columnGap == FormatValue.INHERIT?20:this._tcm.hostFormat.columnGap;
      }
      
      private function ConvertContainerValuesToHostFormat(param1:TextLayoutFormat) : void
      {
         if(param1 != null && this.controller != null)
         {
            param1.paddingLeft = this.controller.paddingLeft;
            param1.paddingTop = this.controller.paddingTop;
            param1.paddingRight = this.controller.paddingRight;
            param1.paddingBottom = this.controller.paddingBottom;
            param1.verticalAlign = this.controller.verticalAlign;
            param1.columnCount = this.controller.columnCount;
            param1.columnGap = this.controller.columnGap;
            param1.columnWidth = this.controller.columnWidth;
         }
      }
      
      public function get paddingRight() : Object
      {
         if(!this.isTextStringAndFormat())
         {
            return this.controller.paddingRight;
         }
         if(this._tcm.hostFormat == null)
         {
            return 2;
         }
         return this._tcm.hostFormat.paddingRight;
      }
      
      public function set columnCount(param1:Object) : void
      {
         var _loc2_:TextLayoutFormat = !!this._tcm.hostFormat?TextLayoutFormat(this._tcm.hostFormat):new TextLayoutFormat();
         _loc2_.columnCount = param1;
         this._tcm.hostFormat = _loc2_;
         if(this.controller)
         {
            this.controller.columnCount = param1;
         }
      }
      
      public function convert(param1:Class) : IContainerManager
      {
         var _loc3_:TextLayoutFormat = null;
         if(this is param1)
         {
            return this;
         }
         if(this.textFlow && this.textFlow.flowComposer && !this.textFlow.flowComposer.composing)
         {
            this.update();
         }
         var _loc2_:MultiTextContainerManager = new MultiTextContainerManager(_container,_ownerField,_controller);
         _loc2_.textFlow = this.textFlow;
         _loc2_.editMode = this._tcm.editingMode;
         _loc2_.setCompositionSize(this.compositionWidth,this.compositionHeight);
         _loc2_.paddingBottom = this.paddingBottom;
         _loc2_.paddingLeft = this.paddingLeft;
         _loc2_.paddingRight = this.paddingRight;
         _loc2_.paddingTop = this.paddingTop;
         _loc2_.columnCount = this.columnCount;
         if(this.hostFormat)
         {
            _loc3_ = this.hostFormat as TextLayoutFormat;
            _loc3_.paddingBottom = 0;
            _loc3_.paddingLeft = 0;
            _loc3_.paddingRight = 0;
            _loc3_.paddingTop = 0;
            _loc2_.hostFormat = _loc3_;
         }
         _loc2_.columnGap = this.columnGap;
         _loc2_.columnWidth = this.columnWidth;
         _loc2_.firstBaselineOffset = this.firstBaselineOffset;
         _loc2_.verticalAlign = this.verticalAlign;
         _loc2_.horizontalScrollPosition = this.horizontalScrollPosition;
         _loc2_.verticalScrollPosition = this.verticalScrollPosition;
         _loc2_.direction = this.direction;
         this._tcm.convertToTextFlowWithComposer();
         if(this.textFlow)
         {
            if(this.textFlow.flowComposer == null)
            {
               this.textFlow.flowComposer = new this.textFlow.configuration.flowComposerClass();
            }
            this.textFlow.flowComposer.removeAllControllers();
            this.textFlow.flowComposer.addController(_loc2_.controller);
         }
         _container.removeEventListener(MouseEvent.MOUSE_OVER,this._tcm.requiredMouseOverHandler);
         _container.removeEventListener(FocusEvent.FOCUS_IN,this._tcm.requiredFocusInHandler);
         _container.removeEventListener(MouseEvent.MOUSE_OVER,this._tcm.requiredMouseOverHandler);
         _container.removeEventListener(MouseEvent.MOUSE_DOWN,this._tcm.mouseDownHandler);
         _container.removeEventListener(MouseEvent.MOUSE_OUT,this._tcm.mouseOutHandler);
         _container.removeEventListener(MouseEvent.MOUSE_WHEEL,this._tcm.mouseWheelHandler);
         _container.removeEventListener("imeStartComposition",this._tcm.imeStartCompositionHandler);
         if(_container.contextMenu)
         {
            _container.contextMenu.removeEventListener(ContextMenuEvent.MENU_SELECT,this._tcm.menuSelectHandler);
         }
         _container.removeEventListener(Event.SELECT_ALL,this._tcm.editHandler);
         this.removeListeners();
         _loc2_.addListeners();
         this._tcm = null;
         _ownerField = null;
         _container = null;
         return _loc2_;
      }
      
      public function get antialiasType() : String
      {
         if(this._tcm.hostFormat)
         {
            return this._tcm.hostFormat.renderingMode == RenderingMode.NORMAL?AntiAliasType.NORMAL:AntiAliasType.ADVANCED;
         }
         return AntiAliasType.NORMAL;
      }
      
      public function get paddingLeft() : Object
      {
         if(!this.isTextStringAndFormat())
         {
            return this.controller.paddingLeft;
         }
         if(this._tcm.hostFormat == null)
         {
            return 2;
         }
         return this._tcm.hostFormat.paddingLeft;
      }
      
      public function set horizontalScrollPosition(param1:Number) : void
      {
         this._tcm.horizontalScrollPosition = param1;
      }
      
      public function get paddingBottom() : Object
      {
         if(!this.isTextStringAndFormat())
         {
            return this.controller.paddingBottom;
         }
         if(this._tcm.hostFormat == null)
         {
            return 2;
         }
         return this._tcm.hostFormat.paddingBottom;
      }
      
      override public function get hostFormat() : ITextLayoutFormat
      {
         var _loc1_:TextLayoutFormat = null;
         if(this.isTextStringAndFormat())
         {
            _loc1_ = this._tcm.hostFormat as TextLayoutFormat;
         }
         else
         {
            _loc1_ = this._tcm.getTextFlow().hostFormat as TextLayoutFormat;
            this.ConvertContainerValuesToHostFormat(_loc1_);
         }
         return _loc1_;
      }
      
      public function get contentWidth() : Number
      {
         return this._tcm.getContentBounds().width;
      }
      
      override public function update() : void
      {
         this._tcm.updateContainer();
         _ownerField.composeComplete(null);
      }
      
      override public function get embedFonts() : Boolean
      {
         if(!this.isTextStringAndFormat())
         {
            return super.embedFonts;
         }
         if(this.hostFormat)
         {
            return this.hostFormat.fontLookup == FontLookup.EMBEDDED_CFF;
         }
         return false;
      }
      
      override public function set embedFonts(param1:Boolean) : void
      {
         var _loc2_:TextLayoutFormat = null;
         if(!this.isTextStringAndFormat())
         {
            super.embedFonts = param1;
         }
         else
         {
            _loc2_ = !!this.hostFormat?TextLayoutFormat(this.hostFormat):new TextLayoutFormat();
            _loc2_.fontLookup = !!param1?FontLookup.EMBEDDED_CFF:FontLookup.DEVICE;
            this.hostFormat = _loc2_;
         }
      }
      
      override public function set lineBreak(param1:String) : void
      {
         var _loc2_:TextLayoutFormat = null;
         if(!this.isTextStringAndFormat())
         {
            super.lineBreak = param1;
         }
         else
         {
            _loc2_ = !!this.hostFormat?TextLayoutFormat(this.hostFormat):new TextLayoutFormat();
            _loc2_.lineBreak = param1;
            this.hostFormat = _loc2_;
         }
      }
      
      public function set antialiasType(param1:String) : void
      {
         var _loc2_:TextLayoutFormat = !!this._tcm.hostFormat?TextLayoutFormat(this._tcm.hostFormat):new TextLayoutFormat();
         _loc2_.renderingMode = param1 == AntiAliasType.ADVANCED?RenderingMode.CFF:RenderingMode.NORMAL;
         this._tcm.hostFormat = _loc2_;
      }
      
      override public function set blockProgression(param1:Object) : void
      {
         if(!this.isTextStringAndFormat())
         {
            super.blockProgression = param1;
            return;
         }
         var _loc2_:TextLayoutFormat = !!this.hostFormat?TextLayoutFormat(this.hostFormat):new TextLayoutFormat();
         switch(param1)
         {
            case BlockProgression.RL:
            case BlockProgression.TB:
            case FormatValue.INHERIT:
               _loc2_.blockProgression = param1;
               break;
            default:
               _loc2_.blockProgression = BlockProgression.TB;
         }
         this.hostFormat = _loc2_;
      }
      
      override public function get blockProgression() : Object
      {
         if(!this.isTextStringAndFormat())
         {
            return super.blockProgression;
         }
         if(this.hostFormat && this.hostFormat.blockProgression)
         {
            return this.hostFormat.blockProgression;
         }
         return BlockProgression.TB;
      }
      
      override public function set textFlow(param1:TextFlow) : void
      {
         this._tcm.setTextFlow(param1);
      }
   }
}
