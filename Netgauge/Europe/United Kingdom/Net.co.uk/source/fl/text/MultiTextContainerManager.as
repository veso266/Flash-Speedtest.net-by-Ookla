package fl.text
{
   import flash.display.Sprite;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.engine.RenderingMode;
   import flashx.textLayout.compose.TextFlowLine;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.conversion.ConversionType;
   import flashx.textLayout.conversion.TextConverter;
   import flashx.textLayout.edit.EditManager;
   import flashx.textLayout.edit.EditingMode;
   import flashx.textLayout.edit.ISelectionManager;
   import flashx.textLayout.edit.SelectionManager;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.events.CompositionCompleteEvent;
   import flashx.textLayout.events.FlowOperationEvent;
   import flashx.textLayout.events.TextLayoutEvent;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   
   class MultiTextContainerManager extends CommonTextContainerManager implements IContainerManager
   {
       
      
      private var _textFlow:TextFlow;
      
      private var _hostFormat:TextLayoutFormat;
      
      function MultiTextContainerManager(param1:Sprite, param2:TLFTextField, param3:ContainerController = null)
      {
         super();
         _container = param1;
         _ownerField = param2;
         this._hostFormat = new TextLayoutFormat();
         _controller = param3 != null?param3:param2.initController(_container);
         _ownerField.addEventListener(FocusEvent.FOCUS_IN,_controller.focusInHandler);
      }
      
      public function get contentHeight() : Number
      {
         return _controller.contentHeight;
      }
      
      public function get firstBaselineOffset() : Object
      {
         return _controller.firstBaselineOffset;
      }
      
      public function setCompositionSize(param1:Number, param2:Number) : void
      {
         _controller.setCompositionSize(param1,param2);
      }
      
      public function set paddingRight(param1:Object) : void
      {
         _controller.paddingRight = param1;
      }
      
      public function get columnWidth() : Object
      {
         return _controller.columnWidth;
      }
      
      public function get numLines() : int
      {
         return this._textFlow.flowComposer.numLines;
      }
      
      public function removeListeners() : void
      {
         this.textFlow.removeEventListener(TextLayoutEvent.SCROLL,_ownerField.textFlow_ScrollHandler);
         this.textFlow.removeEventListener(MouseEvent.CLICK,_ownerField.linkClick);
         this.textFlow.removeEventListener(FlowOperationEvent.FLOW_OPERATION_BEGIN,_ownerField.textFlow_flowOperationBeginHandler);
         this.textFlow.removeEventListener(FlowOperationEvent.FLOW_OPERATION_END,_ownerField.textFlow_flowOperationEndHandler);
         this.textFlow.removeEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE,_ownerField.composeComplete);
         _ownerField.removeEventListener(FocusEvent.FOCUS_IN,_controller.focusInHandler);
      }
      
      public function set columnWidth(param1:Object) : void
      {
         _controller.columnWidth = param1;
      }
      
      public function get contentTop() : Number
      {
         return _controller.contentTop;
      }
      
      override public function isTextStringAndFormat() : Boolean
      {
         return false;
      }
      
      public function set paddingTop(param1:Object) : void
      {
         _controller.paddingTop = param1;
      }
      
      public function get verticalScrollPosition() : Number
      {
         return _controller.verticalScrollPosition;
      }
      
      public function get contentLeft() : Number
      {
         return _controller.contentLeft;
      }
      
      public function set firstBaselineOffset(param1:Object) : void
      {
         _controller.firstBaselineOffset = param1;
      }
      
      public function get text() : String
      {
         if(!this._textFlow)
         {
            return "";
         }
         var _loc1_:String = TextConverter.export(this._textFlow,TextConverter.PLAIN_TEXT_FORMAT,ConversionType.STRING_TYPE) as String;
         _ownerField.generationID = this.textFlow.generation;
         return _loc1_;
      }
      
      public function get absoluteStart() : int
      {
         return _controller.absoluteStart;
      }
      
      public function get compositionWidth() : Number
      {
         return _controller.compositionWidth;
      }
      
      public function set antialiasType(param1:String) : void
      {
         if(this._textFlow)
         {
            this._textFlow.renderingMode = param1 == AntiAliasType.ADVANCED?RenderingMode.CFF:RenderingMode.NORMAL;
         }
      }
      
      public function set paddingBottom(param1:Object) : void
      {
         _controller.paddingBottom = param1;
      }
      
      public function set columnGap(param1:Object) : void
      {
         _controller.columnGap = param1;
      }
      
      public function get verticalAlign() : Object
      {
         return _controller.verticalAlign;
      }
      
      public function set verticalScrollPosition(param1:Number) : void
      {
         _controller.verticalScrollPosition = param1;
      }
      
      public function get columnCount() : Object
      {
         return _controller.columnCount;
      }
      
      public function getLineIndexBounds(param1:int) : Rectangle
      {
         var _loc2_:TextFlowLine = this.textFlow.flowComposer.getLineAt(param1);
         return _loc2_.getBounds();
      }
      
      public function set verticalAlign(param1:Object) : void
      {
         _controller.verticalAlign = param1;
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return _controller.horizontalScrollPosition;
      }
      
      public function set paddingLeft(param1:Object) : void
      {
         _controller.paddingLeft = param1;
      }
      
      override public function get textLength() : int
      {
         return _controller.textLength - 1;
      }
      
      public function get compositionHeight() : Number
      {
         return _controller.compositionHeight;
      }
      
      public function get paddingTop() : Object
      {
         return _controller.paddingTop;
      }
      
      public function set hostFormat(param1:ITextLayoutFormat) : void
      {
         var _loc2_:uint = 0;
         this._hostFormat = TextLayoutFormat(param1);
         if(this._textFlow)
         {
            _loc2_ = this._textFlow.generation;
            this._textFlow.hostFormat = param1;
            this._textFlow.setGeneration(_loc2_);
         }
      }
      
      public function set editModeNoInteraction(param1:String) : void
      {
         this.editMode = param1;
      }
      
      override public function compose() : void
      {
         this._textFlow.flowComposer.composeToPosition();
      }
      
      public function addListeners() : void
      {
         this.textFlow.addEventListener(TextLayoutEvent.SCROLL,_ownerField.textFlow_ScrollHandler,false,0,true);
         this.textFlow.addEventListener(MouseEvent.CLICK,_ownerField.linkClick,false,0,true);
         this.textFlow.addEventListener(FlowOperationEvent.FLOW_OPERATION_BEGIN,_ownerField.textFlow_flowOperationBeginHandler,false,0,true);
         this.textFlow.addEventListener(FlowOperationEvent.FLOW_OPERATION_END,_ownerField.textFlow_flowOperationEndHandler,false,0,true);
         this.textFlow.addEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE,_ownerField.composeComplete,false,0,true);
         _ownerField.addEventListener(FocusEvent.FOCUS_IN,_controller.focusInHandler,false,0,true);
      }
      
      public function get columnGap() : Object
      {
         return _controller.columnGap;
      }
      
      public function set editMode(param1:String) : void
      {
         var _loc2_:ISelectionManager = this._textFlow.interactionManager;
         if(param1 == EditingMode.READ_WRITE)
         {
            if(!(_loc2_ is EditManager))
            {
               this._textFlow.interactionManager = new EditManager();
            }
         }
         else if(param1 == EditingMode.READ_SELECT)
         {
            if(_loc2_ == null || _loc2_ is EditManager)
            {
               this._textFlow.interactionManager = new SelectionManager();
            }
         }
         else
         {
            this._textFlow.interactionManager = null;
         }
      }
      
      public function get controller() : ContainerController
      {
         return _controller;
      }
      
      public function get antialiasType() : String
      {
         if(this._textFlow)
         {
            return this._textFlow.renderingMode == RenderingMode.NORMAL?AntiAliasType.NORMAL:AntiAliasType.ADVANCED;
         }
         return AntiAliasType.NORMAL;
      }
      
      public function get paddingRight() : Object
      {
         return _controller.paddingRight;
      }
      
      public function set columnCount(param1:Object) : void
      {
         _controller.columnCount = param1;
      }
      
      public function convert(param1:Class) : IContainerManager
      {
         if(this is param1)
         {
            return this;
         }
         var _loc2_:SingleTextContainerManager = new SingleTextContainerManager(_container,_ownerField,_controller);
         _loc2_.textFlow = this._textFlow;
         _loc2_.setCompositionSize(this.compositionWidth,this.compositionHeight);
         _loc2_.hostFormat = this.hostFormat;
         _loc2_.paddingBottom = this.paddingBottom;
         _loc2_.paddingLeft = this.paddingLeft;
         _loc2_.paddingRight = this.paddingRight;
         _loc2_.paddingTop = this.paddingTop;
         _loc2_.columnCount = this.columnCount;
         _loc2_.columnGap = this.columnGap;
         _loc2_.columnWidth = this.columnWidth;
         _loc2_.firstBaselineOffset = this.firstBaselineOffset;
         _loc2_.verticalAlign = this.verticalAlign;
         _loc2_.horizontalScrollPosition = this.horizontalScrollPosition;
         _loc2_.verticalScrollPosition = this.verticalScrollPosition;
         _ownerField = null;
         _container = null;
         _controller = null;
         return _loc2_;
      }
      
      public function get paddingLeft() : Object
      {
         return _controller.paddingLeft;
      }
      
      public function set horizontalScrollPosition(param1:Number) : void
      {
         _controller.horizontalScrollPosition = param1;
      }
      
      public function get paddingBottom() : Object
      {
         return _controller.paddingBottom;
      }
      
      override public function get hostFormat() : ITextLayoutFormat
      {
         return this._textFlow.hostFormat;
      }
      
      public function get contentWidth() : Number
      {
         return _controller.contentWidth;
      }
      
      override public function update() : void
      {
         if(this._textFlow)
         {
            this._textFlow.flowComposer.updateAllControllers();
         }
      }
      
      override public function get textFlow() : TextFlow
      {
         return this._textFlow;
      }
      
      override public function set textFlow(param1:TextFlow) : void
      {
         this._textFlow = param1;
      }
   }
}
