package fl.text
{
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.text.engine.FontLookup;
   import flash.text.engine.FontPosture;
   import flash.text.engine.FontWeight;
   import flash.text.engine.Kerning;
   import flash.text.engine.TabAlignment;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.conversion.TextConverter;
   import flashx.textLayout.edit.EditManager;
   import flashx.textLayout.edit.EditingMode;
   import flashx.textLayout.edit.ElementRange;
   import flashx.textLayout.edit.SelectionState;
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.BlockProgression;
   import flashx.textLayout.formats.Direction;
   import flashx.textLayout.formats.FormatValue;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.LeadingModel;
   import flashx.textLayout.formats.LineBreak;
   import flashx.textLayout.formats.TabStopFormat;
   import flashx.textLayout.formats.TextDecoration;
   import flashx.textLayout.formats.TextLayoutFormat;
   
   class CommonTextContainerManager
   {
       
      
      protected var _container:Sprite;
      
      protected var _controller:ContainerController;
      
      protected var _ownerField:TLFTextField;
      
      function CommonTextContainerManager()
      {
         super();
      }
      
      public function get container() : Sprite
      {
         return this._container;
      }
      
      public function setTextFormat(param1:TextFormat, param2:int, param3:int, param4:TextLayoutFormat, param5:TextLayoutFormat) : void
      {
         var _loc9_:SelectionState = null;
         var _loc10_:Array = null;
         var _loc11_:String = null;
         var _loc12_:TabStopFormat = null;
         if(this.textFlow && this.textFlow.formatResolver != null)
         {
            throw new Error("This method cannot be used on a text field with a style sheet.");
         }
         var _loc6_:SelectionState = null;
         if(param1.align != null)
         {
            if(param1.align == TextFormatAlign.CENTER || param1.align == TextFormatAlign.JUSTIFY || param1.align == TextFormatAlign.LEFT || param1.align == TextFormatAlign.RIGHT)
            {
               param5.textAlign = param1.align;
            }
            else
            {
               param5.textAlign = TextFormatAlign.RIGHT;
            }
         }
         if(param1.blockIndent != null && param1.leftMargin != null)
         {
            param5.paragraphStartIndent = param1.blockIndent + param1.leftMargin;
         }
         else if(param1.blockIndent != null)
         {
            param5.paragraphStartIndent = param1.blockIndent;
         }
         else if(param1.leftMargin != null)
         {
            param5.paragraphStartIndent = param1.leftMargin;
         }
         if(param1.indent != null)
         {
            param5.textIndent = param1.indent;
         }
         if(param1.leading != null)
         {
            param5.leadingModel = LeadingModel.APPROXIMATE_TEXT_FIELD;
            param4.lineHeight = param1.leading;
         }
         if(param1.rightMargin != null)
         {
            param5.paragraphEndIndent = param1.rightMargin;
         }
         if(param1.tabStops != null)
         {
            _loc10_ = new Array();
            param1.tabStops.sort(Array.NUMERIC);
            for each(_loc11_ in param1.tabStops)
            {
               _loc12_ = new TabStopFormat();
               _loc12_.alignment = TabAlignment.START;
               _loc12_.position = int(_loc11_);
               _loc10_.push(_loc12_);
            }
            param5.tabStops = _loc10_;
         }
         if(param1.bold != null)
         {
            param4.fontWeight = !!param1.bold?FontWeight.BOLD:FontWeight.NORMAL;
         }
         if(param1.color != null)
         {
            param4.color = param1.color;
         }
         if(param1.font != null)
         {
            param4.fontFamily = param1.font;
         }
         if(param1.italic != null)
         {
            param4.fontStyle = !!param1.italic?FontPosture.ITALIC:FontPosture.NORMAL;
         }
         if(param1.kerning != null)
         {
            param4.kerning = !!param1.kerning?Kerning.ON:Kerning.OFF;
         }
         if(param1.letterSpacing != null)
         {
            param4.trackingRight = param1.letterSpacing;
         }
         if(param1.size != null)
         {
            param4.fontSize = param1.size;
         }
         if(param1.underline != null)
         {
            param4.textDecoration = !!param1.underline?TextDecoration.UNDERLINE:TextDecoration.NONE;
         }
         var _loc7_:String = this._ownerField.getEditingMode(this.textFlow.interactionManager);
         if(_loc7_ != EditingMode.READ_ONLY && _loc7_ != null)
         {
            if(this.textFlow.interactionManager.hasSelection())
            {
               _loc6_ = this.textFlow.interactionManager.getSelectionState();
            }
         }
         if(_loc7_ != EditingMode.READ_WRITE)
         {
            this._ownerField.switchToEditingMode(this.textFlow,EditingMode.READ_WRITE);
         }
         var _loc8_:EditManager = EditManager(this.textFlow.interactionManager);
         _loc8_.beginCompositeOperation();
         if(param2 < 0 || param3 < 0)
         {
            _loc9_ = new SelectionState(this.textFlow,this.textFlow.getAbsoluteStart(),this.textLength);
            _loc8_.applyLeafFormat(param4,_loc9_);
            _loc8_.applyParagraphFormat(param5,_loc9_);
            if(param1.url != null)
            {
               if(param1.url != "")
               {
                  _loc8_.applyLink(param1.url,param1.target,false,_loc9_);
               }
               else
               {
                  _loc8_.applyLink("",param1.target,false,_loc9_);
               }
            }
         }
         else
         {
            _loc9_ = new SelectionState(this.textFlow,param2,param3);
            _loc8_.applyLeafFormat(param4,_loc9_);
            _loc8_.applyParagraphFormat(param5,_loc9_);
            if(param1.url != null)
            {
               if(param1.url != null)
               {
                  _loc8_.applyLink(param1.url,param1.target,false,_loc9_);
               }
               else
               {
                  _loc8_.applyLink("",param1.target,false,_loc9_);
               }
            }
         }
         _loc8_.endCompositeOperation();
         if(this.textFlow.interactionManager)
         {
            if(_loc6_)
            {
               this.textFlow.interactionManager.selectRange(_loc6_.anchorPosition,_loc6_.activePosition);
            }
            else
            {
               this.textFlow.interactionManager.selectRange(-1,-1);
            }
         }
         if(_loc7_ != EditingMode.READ_WRITE)
         {
            this._ownerField.switchToEditingMode(this.textFlow,_loc7_);
         }
      }
      
      public function replaceText(param1:int, param2:int, param3:String) : void
      {
         if(this.textFlow && this.textFlow.formatResolver != null && (param1 > 0 || param2 < length))
         {
            throw new Error("This method cannot be used on a text field with a style sheet.");
         }
         this.compose();
         if(param1 < 0)
         {
            param1 = 0;
         }
         var _loc4_:String = this._ownerField.getEditingMode(this.textFlow.interactionManager);
         this._ownerField.switchToEditingMode(this.textFlow,EditingMode.READ_WRITE);
         var _loc5_:EditManager = EditManager(this.textFlow.interactionManager);
         _loc5_.beginCompositeOperation();
         _loc5_.selectRange(param1,param2);
         this._ownerField.insertWithParagraphs(_loc5_,param3);
         _loc5_.endCompositeOperation();
         this.update();
         this._ownerField.switchToEditingMode(this.textFlow,_loc4_);
      }
      
      public function update() : void
      {
      }
      
      public function get hostFormat() : ITextLayoutFormat
      {
         return null;
      }
      
      public function setFormatForAllElements(param1:FlowGroupElement, param2:TextLayoutFormat) : void
      {
         var _loc5_:FlowElement = null;
         var _loc6_:TextLayoutFormat = null;
         var _loc3_:int = param1.numChildren;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.getChildAt(_loc4_);
            if(_loc5_ is FlowGroupElement)
            {
               this.setFormatForAllElements(FlowGroupElement(_loc5_),param2);
            }
            else
            {
               _loc6_ = new TextLayoutFormat(_loc5_.format);
               _loc6_.apply(param2);
               _loc5_.format = _loc6_;
            }
            _loc4_++;
         }
      }
      
      public function compose() : void
      {
      }
      
      public function set lineBreak(param1:String) : void
      {
         if(!this.textFlow)
         {
            this.textFlow = new TextFlow();
         }
         this.textFlow.lineBreak = param1;
      }
      
      public function set text(param1:String) : void
      {
         var _loc3_:FlowLeafElement = null;
         var _loc2_:TextFlow = !!this.isTextStringAndFormat()?null:this.textFlow;
         if(!_loc2_)
         {
            this._ownerField.doImport(TextConverter.PLAIN_TEXT_FORMAT,param1);
         }
         else
         {
            _loc3_ = _loc2_.getFirstLeaf();
            if(_loc3_)
            {
               _loc2_.hostFormat = _loc3_.computedFormat;
            }
            this._ownerField.replaceText(0,this._ownerField.length,param1);
         }
      }
      
      public function set blockProgression(param1:Object) : void
      {
         switch(param1)
         {
            case BlockProgression.RL:
            case BlockProgression.TB:
            case FormatValue.INHERIT:
               this.textFlow.blockProgression = param1;
               break;
            default:
               this.textFlow.blockProgression = BlockProgression.TB;
         }
      }
      
      public function set embedFonts(param1:Boolean) : void
      {
         if(!this.textFlow)
         {
            this.textFlow = new TextFlow();
         }
         this.textFlow.fontLookup = !!param1?FontLookup.EMBEDDED_CFF:FontLookup.DEVICE;
      }
      
      public function appendText(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc4_:SelectionState = null;
         if(!this.textFlow.interactionManager)
         {
            _loc2_ = EditingMode.READ_ONLY;
         }
         else
         {
            _loc2_ = this.textFlow.interactionManager.editingMode;
            _loc4_ = null;
         }
         if(_loc2_ != EditingMode.READ_ONLY && _loc2_ != null)
         {
            if(this.textFlow.interactionManager.hasSelection())
            {
               _loc4_ = this.textFlow.interactionManager.getSelectionState();
            }
         }
         if(_loc2_ != EditingMode.READ_WRITE)
         {
            this._ownerField.switchToEditingMode(this.textFlow,EditingMode.READ_WRITE);
         }
         var _loc3_:EditManager = EditManager(this.textFlow.interactionManager);
         _loc3_.selectRange(int.MAX_VALUE,int.MAX_VALUE);
         _loc3_.beginCompositeOperation();
         this._ownerField.insertWithParagraphs(_loc3_,param1);
         _loc3_.endCompositeOperation();
         this.update();
         if(this.textFlow.interactionManager)
         {
            if(_loc4_)
            {
               this.textFlow.interactionManager.selectRange(_loc4_.anchorPosition,_loc4_.activePosition);
            }
            else
            {
               this.textFlow.interactionManager.selectRange(-1,-1);
            }
         }
         if(_loc2_ != EditingMode.READ_WRITE && _loc2_ != null)
         {
            this._ownerField.switchToEditingMode(this.textFlow,_loc2_);
         }
      }
      
      public function get embedFonts() : Boolean
      {
         if(this.textFlow)
         {
            return this.textFlow.fontLookup == FontLookup.EMBEDDED_CFF;
         }
         return false;
      }
      
      public function set textColor(param1:uint) : void
      {
         this.textFlow.color = param1;
         var _loc2_:TextLayoutFormat = new TextLayoutFormat();
         _loc2_.color = param1;
         this.setFormatForAllElements(this.textFlow,_loc2_);
      }
      
      public function isTextStringAndFormat() : Boolean
      {
         return false;
      }
      
      public function get blockProgression() : Object
      {
         if(this.textFlow && this.textFlow.computedFormat.blockProgression)
         {
            return this.textFlow.computedFormat.blockProgression;
         }
         return BlockProgression.TB;
      }
      
      public function get lineBreak() : String
      {
         if(this.textFlow)
         {
            return this.textFlow.lineBreak;
         }
         return LineBreak.EXPLICIT;
      }
      
      public function get textLength() : int
      {
         return 0;
      }
      
      public function set textFlow(param1:TextFlow) : void
      {
      }
      
      public function getTextFormat(param1:int, param2:int) : TextFormat
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc12_:Array = null;
         var _loc13_:Number = NaN;
         var _loc14_:String = null;
         var _loc15_:Number = NaN;
         var _loc16_:Array = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:TabStopFormat = null;
         var _loc20_:ElementRange = null;
         var _loc21_:FlowLeafElement = null;
         var _loc22_:LinkElement = null;
         var _loc3_:TextFormat = new TextFormat();
         var _loc4_:SelectionState = null;
         var _loc5_:String = this._ownerField.getEditingMode(this.textFlow.interactionManager);
         if(_loc5_ != EditingMode.READ_ONLY && _loc5_ != null)
         {
            if(this.textFlow.interactionManager.hasSelection())
            {
               _loc4_ = this.textFlow.interactionManager.getSelectionState();
            }
         }
         else
         {
            this._ownerField.switchToEditingMode(this.textFlow,EditingMode.READ_SELECT);
         }
         if(param1 < 0)
         {
            _loc6_ = this.textFlow.getAbsoluteStart();
            _loc7_ = this.textLength;
         }
         else if(param1 >= 0 && param2 < 0)
         {
            _loc6_ = param1;
            _loc7_ = param1;
         }
         else
         {
            _loc6_ = param1;
            _loc7_ = param2;
         }
         this._ownerField.setSelection(_loc6_,_loc7_);
         var _loc8_:TextLayoutFormat = TextLayoutFormat(this.textFlow.interactionManager.getCommonCharacterFormat());
         var _loc9_:TextLayoutFormat = TextLayoutFormat(this.textFlow.interactionManager.getCommonParagraphFormat());
         if(_loc4_)
         {
            this.textFlow.interactionManager.selectRange(_loc4_.anchorPosition,_loc4_.activePosition);
         }
         else
         {
            this.textFlow.interactionManager.selectRange(-1,-1);
         }
         if(_loc5_ == EditingMode.READ_ONLY)
         {
            this._ownerField.switchToEditingMode(this.textFlow,_loc5_);
         }
         if(_loc9_.textAlign == TextFormatAlign.LEFT || _loc9_.textAlign == TextFormatAlign.CENTER || _loc9_.textAlign == TextFormatAlign.RIGHT || _loc9_.textAlign == TextFormatAlign.JUSTIFY)
         {
            _loc3_.align = _loc9_.textAlign;
         }
         else
         {
            _loc3_.align = null;
         }
         if(_loc8_.fontWeight == undefined)
         {
            _loc3_.bold = null;
         }
         else
         {
            _loc3_.bold = _loc8_.fontWeight == FontWeight.BOLD;
         }
         _loc3_.color = _loc8_.color;
         if(_loc8_.fontFamily == undefined)
         {
            _loc3_.font = null;
         }
         else
         {
            _loc12_ = String(_loc8_.fontFamily).split(",");
            _loc3_.font = _loc12_[0];
         }
         _loc3_.indent = _loc9_.textIndent;
         if(_loc8_.fontStyle == undefined)
         {
            _loc3_.italic = null;
         }
         else
         {
            _loc3_.italic = _loc8_.fontStyle == FontPosture.ITALIC;
         }
         if(_loc8_.kerning == undefined)
         {
            _loc3_.kerning = null;
         }
         else
         {
            _loc3_.kerning = _loc8_.kerning == Kerning.ON || _loc8_.kerning == Kerning.AUTO;
         }
         if(_loc8_.lineHeight == undefined || _loc8_.lineHeight < -720)
         {
            _loc3_.leading = null;
         }
         else
         {
            _loc13_ = Number.NaN;
            _loc14_ = _loc8_.lineHeight;
            if(_loc14_)
            {
               if(_loc14_.indexOf("%") == -1)
               {
                  _loc13_ = Number(_loc14_);
               }
               else
               {
                  _loc15_ = this.textFlow.findLeaf(_loc6_).computedFormat.fontSize;
                  _loc13_ = Number(_loc14_.replace(/%/,"")) * _loc15_ / 100;
               }
            }
            if(!isNaN(_loc13_))
            {
               _loc3_.leading = _loc13_;
            }
         }
         _loc3_.leftMargin = _loc9_.paragraphStartIndent;
         _loc3_.letterSpacing = _loc8_.trackingRight;
         _loc3_.rightMargin = _loc9_.paragraphEndIndent;
         _loc3_.size = _loc8_.fontSize;
         if(_loc9_.tabStops == undefined)
         {
            _loc3_.tabStops = null;
         }
         else
         {
            _loc16_ = [];
            if(_loc9_.tabStops != null)
            {
               _loc17_ = _loc9_.tabStops.length;
               _loc18_ = 0;
               while(_loc18_ < _loc17_)
               {
                  _loc19_ = _loc9_.tabStops[_loc18_];
                  if(_loc19_.alignment == TabAlignment.START)
                  {
                     _loc16_.push(_loc19_.position);
                  }
                  _loc18_++;
               }
               _loc16_.sort(Array.NUMERIC);
            }
            _loc3_.tabStops = _loc16_;
         }
         if(_loc8_.textDecoration == undefined)
         {
            _loc3_.underline = null;
         }
         else
         {
            _loc3_.underline = _loc8_.textDecoration == TextDecoration.UNDERLINE;
         }
         var _loc10_:String = null;
         var _loc11_:String = null;
         if(_loc6_ <= _loc7_)
         {
            _loc20_ = ElementRange.createElementRange(this.textFlow,_loc6_,_loc7_);
            _loc21_ = _loc20_.firstLeaf;
            while(_loc21_)
            {
               _loc22_ = _loc21_.getParentByType(LinkElement) as LinkElement;
               if(_loc22_ != null)
               {
                  if(_loc10_ == null)
                  {
                     _loc10_ = _loc22_.href;
                  }
                  else if(_loc10_ != _loc22_.href)
                  {
                     _loc10_ = "";
                  }
                  if(_loc11_ == null)
                  {
                     if(_loc22_.target == null)
                     {
                        _loc11_ = "";
                     }
                     else
                     {
                        _loc11_ = _loc22_.target;
                     }
                  }
                  else if(_loc11_ != _loc22_.target)
                  {
                     _loc11_ = "";
                  }
               }
               else
               {
                  _loc10_ = "";
                  _loc11_ = "";
               }
               if(_loc21_ == _loc20_.lastLeaf)
               {
                  break;
               }
               _loc21_ = _loc21_.getNextLeaf();
            }
         }
         _loc3_.url = _loc10_ == ""?null:_loc10_;
         _loc3_.target = _loc11_ == ""?null:_loc11_;
         return _loc3_;
      }
      
      public function get textFlow() : TextFlow
      {
         return null;
      }
      
      public function get textColor() : uint
      {
         if(this.textFlow)
         {
            return uint(this.textFlow.getFirstLeaf().computedFormat.color);
         }
         return 0;
      }
      
      public function set direction(param1:String) : void
      {
         switch(param1)
         {
            case Direction.LTR:
            case Direction.RTL:
            case FormatValue.INHERIT:
               break;
            default:
               param1 = Direction.LTR;
         }
         var _loc2_:TextLayoutFormat = new TextLayoutFormat();
         _loc2_.direction = param1;
         var _loc3_:ParagraphElement = this.textFlow.getFirstLeaf().getParagraph();
         while(_loc3_)
         {
            _loc3_.direction = param1;
            _loc3_ = _loc3_.getNextParagraph();
         }
         this.textFlow.direction = param1;
      }
      
      public function get direction() : String
      {
         if(this.textFlow.direction != null)
         {
            return this.textFlow.direction;
         }
         return Direction.LTR;
      }
   }
}
