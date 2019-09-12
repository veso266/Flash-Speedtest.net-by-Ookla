package fl.text
{
   import fl.text.container.TLFContainerController;
   import flash.display.CapsStyle;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.FontStyle;
   import flash.text.GridFitType;
   import flash.text.StyleSheet;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.text.TextLineMetrics;
   import flash.text.engine.CFFHinting;
   import flash.text.engine.FontDescription;
   import flash.text.engine.FontPosture;
   import flash.text.engine.FontWeight;
   import flash.text.engine.Kerning;
   import flash.text.engine.TabAlignment;
   import flash.text.engine.TextLine;
   import flash.utils.getDefinitionByName;
   import flashx.textLayout.compose.IFlowComposer;
   import flashx.textLayout.compose.TextFlowLine;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.conversion.ConversionType;
   import flashx.textLayout.conversion.ITextImporter;
   import flashx.textLayout.conversion.TextConverter;
   import flashx.textLayout.edit.EditManager;
   import flashx.textLayout.edit.EditingMode;
   import flashx.textLayout.edit.ISelectionManager;
   import flashx.textLayout.edit.SelectionFormat;
   import flashx.textLayout.edit.SelectionManager;
   import flashx.textLayout.edit.SelectionState;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.IFormatResolver;
   import flashx.textLayout.elements.InlineGraphicElement;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.events.CompositionCompleteEvent;
   import flashx.textLayout.events.FlowElementMouseEvent;
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
   import flashx.textLayout.formats.WhiteSpaceCollapse;
   import flashx.textLayout.operations.CutOperation;
   import flashx.textLayout.operations.DeleteTextOperation;
   import flashx.textLayout.operations.FlowOperation;
   import flashx.textLayout.operations.FlowTextOperation;
   import flashx.textLayout.operations.InsertTextOperation;
   import flashx.textLayout.operations.PasteOperation;
   import flashx.textLayout.operations.SplitParagraphOperation;
   
   public class TLFTextField extends Sprite
   {
      
      static const INVALID_SELECTION:uint = 16;
      
      static const INVALID_BORDER:uint = 4;
      
      static const INVALID_TEXT:uint = 1;
      
      static var alwaysShowSelectionOnFormat:SelectionFormat = new SelectionFormat(14937852,1,"normal",0,0,"normal",0);
      
      static const INVALID_ALL:uint = INVALID_TEXT | INVALID_DIMENSIONS | INVALID_BORDER | INVALID_WORD_WRAP | INVALID_SELECTION | INVALID_AUTO_SIZE | INVALID_TYPE;
      
      static var _initialDefaultTextFormat:TextFormat = new TextFormat("Times New Roman",12,0,false,false,false,"","",TextFormatAlign.LEFT,0,0,0,null);
      
      static const INVALID_NONE:uint = 0;
      
      static const INVALID_AUTO_SIZE:uint = 32;
      
      private static var noCondenseWhiteConfig:Configuration;
      
      static const INVALID_TYPE:uint = 64;
      
      static var focusedSelectionFormat:SelectionFormat = new SelectionFormat(12047870,1,"normal",0,1,"normal",500);
      
      static const INVALID_DIMENSIONS:uint = 2;
      
      static var inactiveSelectionFormat:SelectionFormat = new SelectionFormat(12047870,0,"normal",0,0,"normal",0);
      
      private static var condenseWhiteConfig:Configuration;
      
      protected static var useTCM:Boolean = true;
      
      protected static var textImporter:ITextImporter;
      
      protected static var htmlNoCondenseWhite:ITextImporter;
      
      protected static var noCondenseWhiteFormat:TextLayoutFormat;
      
      protected static var condenseWhiteFormat:TextLayoutFormat;
      
      static var alwaysShowSelectionOffFormat:SelectionFormat = new SelectionFormat(12047870,0,"normal",0,0,"normal",0);
      
      protected static var htmlCondenseWhite:ITextImporter;
      
      static var genericFonts:Array = ["_sans","_serif","_typewriter","_gothic","_gothicMono","_mincho","_ゴシック","_等幅","_明朝"];
      
      protected static var xmlNoCondenseWhite:ITextImporter;
      
      protected static var xmlCondenseWhite:ITextImporter;
      
      static const INVALID_WORD_WRAP:uint = 8;
       
      
      private var _generationID:int;
      
      protected var _text:String;
      
      private var _type:String;
      
      private var _restrict:String;
      
      private var _defaultTextFormat:TextFormat;
      
      private var _mouseWheelEnabled:Boolean;
      
      private var _maxChars:int;
      
      private var _embedFonts:Boolean;
      
      protected var _containerManager:IContainerManager;
      
      private var _passwordCharacter:String;
      
      private var _maxScrollVFirstLineIndex:int;
      
      private var originalHeight:Number = 0;
      
      private var _maxScrollVFirstLineRect:Rectangle;
      
      protected var _invalidTextLayoutFormat:TextLayoutFormat;
      
      private var _antiAliasType:String;
      
      private var originalWidth:Number = 0;
      
      var _alwaysShowSelection:Boolean;
      
      private var _inlineInfo;
      
      private var _priorSelectionBeginIndex:int = 0;
      
      private var _backgroundAlpha:Number;
      
      private var _backgroundColor:uint;
      
      private var objInit:Boolean;
      
      private var _htmlTextGenerationID:int;
      
      private var _contentWidth:Number = 0;
      
      private var _bgShape2:Shape;
      
      protected var _invalidState:uint;
      
      private var _maxScrollV:int;
      
      private var _background:Boolean;
      
      protected var _displayAsPassword:Boolean;
      
      private var _borderAlpha:Number;
      
      private var _htmlText:String;
      
      private var _borderColor:uint;
      
      private var _contentHeight:Number = 0;
      
      private var _gridFitType:String;
      
      private var _tlfMarkupGenerationID:int;
      
      private var _maxScrollVCached:Boolean;
      
      private var _isPointText:Boolean;
      
      private var _paddingLock:Boolean;
      
      protected var _multiline:Boolean;
      
      private var _bgShape:Shape;
      
      private var _tlfMarkup:String;
      
      private var _borderWidth:Number;
      
      private var _border:Boolean;
      
      private var _condenseWhite:Boolean;
      
      private var _prevAutoSize:String;
      
      private var _useRichTextClipboard:Boolean;
      
      private var _maxScrollVLastLineRect:Rectangle;
      
      protected var _inRepaint:Boolean;
      
      private var _autoSize:String;
      
      protected var _wordWrap:Boolean;
      
      private var _priorSelectionEndIndex:int = 0;
      
      private var _selectable:Boolean;
      
      public function TLFTextField()
      {
         var container:DisplayObjectContainer = null;
         var rtMgr:Class = null;
         super();
         this._bgShape = new Shape();
         var tlfStage:Sprite = new Sprite();
         addChild(this._bgShape);
         addChild(tlfStage);
         tlfStage.tabEnabled = true;
         tlfStage.focusRect = false;
         this._containerManager = !!useTCM?new SingleTextContainerManager(tlfStage,this):new MultiTextContainerManager(tlfStage,this);
         doubleClickEnabled = true;
         tabEnabled = false;
         focusRect = false;
         this._alwaysShowSelection = false;
         this._antiAliasType = AntiAliasType.NORMAL;
         this._autoSize = TextFieldAutoSize.NONE;
         this._background = false;
         this._backgroundAlpha = 1;
         this._backgroundColor = 16777215;
         this._border = false;
         this._borderAlpha = 1;
         this._borderColor = 0;
         this._borderWidth = 1;
         this._condenseWhite = false;
         this._defaultTextFormat = _initialDefaultTextFormat;
         this._containerManager.hostFormat = createTextLayoutFormat(_initialDefaultTextFormat);
         this._containerManager.antialiasType = AntiAliasType.NORMAL;
         this._containerManager.columnCount = FormatValue.AUTO;
         this._containerManager.columnWidth = FormatValue.AUTO;
         this._containerManager.columnGap = 20;
         this._containerManager.firstBaselineOffset = FormatValue.AUTO;
         this._containerManager.verticalAlign = VerticalAlign.TOP;
         this._displayAsPassword = false;
         this._embedFonts = false;
         this._gridFitType = GridFitType.PIXEL;
         this._maxChars = 0;
         this._mouseWheelEnabled = true;
         this._multiline = false;
         this._paddingLock = false;
         this._passwordCharacter = "*";
         this._restrict = null;
         this._text = "";
         this._htmlText = "";
         this._tlfMarkup = "";
         this._useRichTextClipboard = false;
         this._selectable = true;
         this._type = TextFieldType.DYNAMIC;
         this._wordWrap = false;
         this._containerManager.paddingLeft = 2;
         this._containerManager.paddingRight = 2;
         this._containerManager.paddingTop = 2;
         this._containerManager.paddingBottom = 2;
         this._generationID = -1;
         this._htmlTextGenerationID = -1;
         this._tlfMarkupGenerationID = -1;
         this._isPointText = false;
         this._containerManager.setCompositionSize(100,100);
         this.originalWidth = int.MAX_VALUE;
         this.originalHeight = int.MAX_VALUE;
         this.objInit = true;
         this._invalidState = INVALID_ALL;
         try
         {
            if(this.parent != null)
            {
               container = parent as DisplayObjectContainer;
               if(container != null)
               {
                  rtMgr = Class(getDefinitionByName("fl.text.RuntimeManager"));
                  rtMgr["getSingleton"]().initInstance(this,container);
               }
            }
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      static function repeat(param1:String, param2:String) : String
      {
         var _loc3_:String = "";
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            if(param2.substr(_loc4_,1) == String.fromCharCode(10))
            {
               _loc3_ = _loc3_ + param2.substr(_loc4_,1);
            }
            else
            {
               _loc3_ = _loc3_ + param1;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private static function testCharacter(param1:uint, param2:String) : Boolean
      {
         var _loc9_:uint = 0;
         var _loc11_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:* = true;
         var _loc7_:uint = 0;
         var _loc8_:int = param2.length;
         if(_loc8_ > 0)
         {
            _loc9_ = param2.charCodeAt(0);
            if(_loc9_ == 94)
            {
               _loc3_ = true;
            }
         }
         var _loc10_:int = 0;
         while(_loc10_ < _loc8_)
         {
            _loc9_ = param2.charCodeAt(_loc10_);
            _loc11_ = false;
            if(!_loc4_)
            {
               if(_loc9_ == 45)
               {
                  _loc5_ = true;
               }
               else if(_loc9_ == 94)
               {
                  _loc6_ = !_loc6_;
               }
               else if(_loc9_ == 92)
               {
                  _loc4_ = true;
               }
               else
               {
                  _loc11_ = true;
               }
            }
            else
            {
               _loc11_ = true;
               _loc4_ = false;
            }
            if(_loc11_)
            {
               if(_loc5_)
               {
                  if(_loc7_ <= param1 && param1 <= _loc9_)
                  {
                     _loc3_ = _loc6_;
                  }
                  _loc5_ = false;
                  _loc7_ = 0;
               }
               else
               {
                  if(param1 == _loc9_)
                  {
                     _loc3_ = _loc6_;
                  }
                  _loc7_ = _loc9_;
               }
            }
            _loc10_++;
         }
         return _loc3_;
      }
      
      static function createTextLayoutFormat(param1:TextFormat) : TextLayoutFormat
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:TabStopFormat = null;
         var _loc2_:TextLayoutFormat = new TextLayoutFormat();
         if(param1.align != null)
         {
            if(param1.align == TextFormatAlign.CENTER || param1.align == TextFormatAlign.JUSTIFY || param1.align == TextFormatAlign.LEFT || param1.align == TextFormatAlign.RIGHT)
            {
               _loc2_.textAlign = param1.align;
            }
            else
            {
               _loc2_.textAlign = TextFormatAlign.RIGHT;
            }
         }
         if(param1.blockIndent != null && param1.leftMargin != null)
         {
            _loc2_.paragraphStartIndent = param1.blockIndent + param1.leftMargin;
         }
         else if(param1.blockIndent != null)
         {
            _loc2_.paragraphStartIndent = param1.blockIndent;
         }
         else if(param1.leftMargin != null)
         {
            _loc2_.paragraphStartIndent = param1.leftMargin;
         }
         if(param1.indent != null)
         {
            _loc2_.textIndent = param1.indent;
         }
         if(param1.leading != null)
         {
            _loc2_.lineHeight = param1.leading;
            _loc2_.leadingModel = LeadingModel.APPROXIMATE_TEXT_FIELD;
         }
         if(param1.rightMargin != null)
         {
            _loc2_.paragraphEndIndent = param1.rightMargin;
         }
         if(param1.tabStops != null)
         {
            _loc3_ = new Array();
            param1.tabStops.sort(Array.NUMERIC);
            for each(_loc4_ in param1.tabStops)
            {
               _loc5_ = new TabStopFormat();
               _loc5_.alignment = TabAlignment.START;
               _loc5_.position = int(_loc4_);
               _loc3_.push(_loc5_);
            }
            _loc2_.tabStops = _loc3_;
         }
         if(param1.bold != null)
         {
            _loc2_.fontWeight = !!param1.bold?FontWeight.BOLD:FontWeight.NORMAL;
         }
         if(param1.color != null)
         {
            _loc2_.color = param1.color;
         }
         if(param1.font != null)
         {
            _loc2_.fontFamily = param1.font;
         }
         if(param1.italic != null)
         {
            _loc2_.fontStyle = !!param1.italic?FontPosture.ITALIC:FontPosture.NORMAL;
         }
         if(param1.kerning != null)
         {
            _loc2_.kerning = !!param1.kerning?Kerning.ON:Kerning.OFF;
         }
         if(param1.letterSpacing != null)
         {
            _loc2_.trackingRight = param1.letterSpacing;
         }
         if(param1.size != null)
         {
            _loc2_.fontSize = param1.size;
         }
         if(param1.underline != null)
         {
            _loc2_.textDecoration = !!param1.underline?TextDecoration.UNDERLINE:TextDecoration.NONE;
         }
         return _loc2_;
      }
      
      private static function restrictChar(param1:String, param2:String) : String
      {
         var _loc6_:uint = 0;
         if(param2 == null)
         {
            return param1;
         }
         if(param2 == "")
         {
            return "";
         }
         var _loc3_:Array = [];
         var _loc4_:int = param1.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = param1.charCodeAt(_loc5_);
            if(testCharacter(_loc6_,param2))
            {
               _loc3_.push(_loc6_);
            }
            _loc5_++;
         }
         return String.fromCharCode.apply(null,_loc3_);
      }
      
      private static function splice(param1:String, param2:int, param3:int, param4:String) : String
      {
         return param1.substring(0,param2) + param4 + param1.substring(param3,param1.length);
      }
      
      function set contentHeight(param1:Number) : void
      {
         this._contentHeight = param1;
      }
      
      public function replaceText(param1:int, param2:int, param3:String) : void
      {
         this._containerManager.replaceText(param1,param2,param3);
      }
      
      public function get firstBaselineOffset() : Object
      {
         return this._containerManager.firstBaselineOffset;
      }
      
      function setCompositionSize(param1:Number, param2:Number) : void
      {
         this._containerManager.setCompositionSize(param1,param2);
      }
      
      function repaint(param1:Event = null) : void
      {
         var wmode:String = null;
         var format:TextLayoutFormat = null;
         var tf:TextFlow = null;
         var e:Event = param1;
         if(this._inRepaint)
         {
            return;
         }
         try
         {
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
            if(this._invalidState == INVALID_NONE)
            {
               return;
            }
            wmode = this.blockProgression as String;
            if(this.TCMUsesTextStringAndFormat || this._containerManager.textFlow)
            {
               if(this._invalidState & (INVALID_AUTO_SIZE | INVALID_WORD_WRAP))
               {
                  if(this._prevAutoSize != null && this.originalWidth != int.MAX_VALUE)
                  {
                     if(this._prevAutoSize != TextFieldAutoSize.NONE)
                     {
                        if(this._wordWrap)
                        {
                           if(wmode != BlockProgression.RL)
                           {
                              if(isNaN(this._containerManager.compositionWidth))
                              {
                                 this.originalWidth = this._containerManager.contentWidth;
                              }
                              else
                              {
                                 this.originalWidth = this._containerManager.compositionWidth;
                              }
                              this.originalHeight = this._containerManager.contentHeight;
                           }
                           else
                           {
                              this.originalWidth = this._containerManager.contentWidth;
                              if(isNaN(this._containerManager.compositionWidth))
                              {
                                 this.originalHeight = this._containerManager.contentHeight;
                              }
                              else
                              {
                                 this.originalHeight = this._containerManager.compositionHeight;
                              }
                           }
                        }
                        else
                        {
                           this.originalWidth = this._containerManager.contentWidth;
                           this.originalHeight = this._containerManager.contentHeight;
                        }
                     }
                     else
                     {
                        this.originalWidth = this._containerManager.compositionWidth;
                        this.originalHeight = this._containerManager.compositionHeight;
                     }
                  }
                  if(this._invalidState & INVALID_WORD_WRAP)
                  {
                     if(this._prevAutoSize == null)
                     {
                        if(this._autoSize != TextFieldAutoSize.NONE)
                        {
                           if(!this._wordWrap)
                           {
                              if(wmode != BlockProgression.RL)
                              {
                                 if(isNaN(this._containerManager.compositionWidth))
                                 {
                                    this.originalWidth = this._containerManager.contentWidth;
                                 }
                                 else
                                 {
                                    this.originalWidth = this._containerManager.compositionWidth;
                                 }
                                 this.originalHeight = this._containerManager.contentHeight;
                              }
                              else
                              {
                                 this.originalWidth = this._containerManager.contentWidth;
                                 if(isNaN(this._containerManager.compositionHeight))
                                 {
                                    this.originalHeight = this._containerManager.contentHeight;
                                 }
                                 else
                                 {
                                    this.originalHeight = this._containerManager.compositionHeight;
                                 }
                              }
                           }
                           else
                           {
                              this.originalWidth = this._containerManager.contentWidth;
                              this.originalHeight = this._containerManager.contentHeight;
                           }
                        }
                        else
                        {
                           this.originalWidth = this._containerManager.compositionWidth;
                           this.originalHeight = this._containerManager.compositionHeight;
                        }
                     }
                     this._containerManager.lineBreak = !!this._wordWrap?LineBreak.TO_FIT:LineBreak.EXPLICIT;
                  }
                  else
                  {
                     this._wordWrap = this._containerManager.lineBreak == LineBreak.TO_FIT;
                  }
                  if(this.originalWidth == int.MAX_VALUE)
                  {
                     this.originalWidth = 0;
                     this.originalHeight = 0;
                  }
                  if(this._autoSize != TextFieldAutoSize.NONE)
                  {
                     if(this._wordWrap)
                     {
                        if(wmode != BlockProgression.RL)
                        {
                           if(isNaN(this._containerManager.compositionWidth))
                           {
                              this._containerManager.setCompositionSize(this._containerManager.contentWidth,NaN);
                           }
                           else
                           {
                              this._containerManager.setCompositionSize(this._containerManager.compositionWidth,NaN);
                           }
                        }
                        else if(isNaN(this._containerManager.compositionHeight))
                        {
                           this._containerManager.setCompositionSize(NaN,this._containerManager.contentHeight);
                        }
                        else
                        {
                           this._containerManager.setCompositionSize(NaN,this._containerManager.compositionHeight);
                        }
                     }
                     else
                     {
                        this._containerManager.setCompositionSize(NaN,NaN);
                     }
                  }
                  else if(this._invalidState & INVALID_AUTO_SIZE && this._prevAutoSize != null && this._prevAutoSize != this._autoSize)
                  {
                     if(!this.objInit)
                     {
                        if(this._wordWrap)
                        {
                           if(wmode != BlockProgression.RL)
                           {
                              this._containerManager.setCompositionSize(this._containerManager.compositionWidth,this._containerManager.contentHeight);
                           }
                           else
                           {
                              this._containerManager.setCompositionSize(this._containerManager.contentWidth,this._containerManager.compositionHeight);
                           }
                        }
                        else
                        {
                           this._containerManager.setCompositionSize(this._containerManager.contentWidth,this._containerManager.contentHeight);
                        }
                     }
                  }
                  this.objInit = false;
                  this._prevAutoSize = null;
               }
               else
               {
                  this._wordWrap = this._containerManager.lineBreak == LineBreak.TO_FIT;
               }
               if(this._invalidState & INVALID_TEXT && this._invalidTextLayoutFormat != null)
               {
                  format = this._invalidTextLayoutFormat;
                  this._invalidTextLayoutFormat = null;
                  tf = !!this.TCMUsesTextStringAndFormat?null:this.textFlow;
                  this._containerManager.setFormatForAllElements(tf,format);
               }
            }
            if(this._invalidState & (INVALID_TEXT | INVALID_DIMENSIONS | INVALID_WORD_WRAP | INVALID_AUTO_SIZE))
            {
               this._containerManager.update();
            }
            if(this._invalidState & (INVALID_TEXT | INVALID_DIMENSIONS | INVALID_BORDER | INVALID_WORD_WRAP | INVALID_AUTO_SIZE))
            {
               this.drawBorder(wmode);
            }
            this._invalidState = INVALID_NONE;
            return;
         }
         finally
         {
            while(true)
            {
               this._inRepaint = false;
            }
         }
         break loop1;
      }
      
      function doImport(param1:String, param2:String) : void
      {
         var txtFormat:ITextLayoutFormat = null;
         var cacheAntiAliasType:String = null;
         var cacheEmbedFontsSet:Boolean = false;
         var cacheGridFitType:String = null;
         var resolver:IFormatResolver = null;
         var dataImporter:ITextImporter = null;
         var tmpTextFlow:TextFlow = null;
         var errMsg:String = null;
         var errorString:String = null;
         var i:int = 0;
         var cacheDefaultTextFormat:TextFormat = null;
         var importType:String = param1;
         var value:String = param2;
         if(condenseWhiteConfig == null)
         {
            condenseWhiteConfig = new Configuration();
            condenseWhiteFormat = new TextLayoutFormat();
            condenseWhiteFormat.whiteSpaceCollapse = WhiteSpaceCollapse.COLLAPSE;
            condenseWhiteConfig.textFlowInitialFormat = condenseWhiteFormat;
            noCondenseWhiteConfig = new Configuration();
            noCondenseWhiteFormat = new TextLayoutFormat();
            noCondenseWhiteFormat.whiteSpaceCollapse = WhiteSpaceCollapse.PRESERVE;
            noCondenseWhiteConfig.textFlowInitialFormat = noCondenseWhiteFormat;
            htmlNoCondenseWhite = TextConverter.getImporter(TextConverter.TEXT_FIELD_HTML_FORMAT,noCondenseWhiteConfig);
            htmlCondenseWhite = TextConverter.getImporter(TextConverter.TEXT_FIELD_HTML_FORMAT,condenseWhiteConfig);
            xmlNoCondenseWhite = TextConverter.getImporter(TextConverter.TEXT_LAYOUT_FORMAT,noCondenseWhiteConfig);
            xmlCondenseWhite = TextConverter.getImporter(TextConverter.TEXT_LAYOUT_FORMAT,condenseWhiteConfig);
            textImporter = TextConverter.getImporter(TextConverter.PLAIN_TEXT_FORMAT);
         }
         var cacheEmbedFonts:Boolean = this._embedFonts;
         var tf:TextFlow = this._containerManager.textFlow;
         if(tf)
         {
            this.removeTextFlowEventListeners();
            txtFormat = this._containerManager.hostFormat;
            cacheAntiAliasType = this.antiAliasType;
            cacheEmbedFonts = this.embedFonts;
            cacheEmbedFontsSet = true;
            cacheGridFitType = this.gridFitType;
            this._prevAutoSize = this._autoSize;
            resolver = tf.formatResolver;
         }
         if(importType == TextConverter.TEXT_FIELD_HTML_FORMAT)
         {
            if(this._condenseWhite)
            {
               dataImporter = htmlCondenseWhite;
            }
            else
            {
               dataImporter = htmlNoCondenseWhite;
            }
         }
         else if(importType == TextConverter.TEXT_LAYOUT_FORMAT)
         {
            if(this._condenseWhite)
            {
               dataImporter = xmlCondenseWhite;
            }
            else
            {
               dataImporter = xmlNoCondenseWhite;
            }
         }
         else if(importType == TextConverter.PLAIN_TEXT_FORMAT)
         {
            dataImporter = textImporter;
         }
         dataImporter.throwOnError = false;
         try
         {
            if(this.canUseTCMForTextFlow(tf) && importType == TextConverter.PLAIN_TEXT_FORMAT && value.search(/[\r\n]/g) == -1)
            {
               this._containerManager = this._containerManager.convert(SingleTextContainerManager);
               this._containerManager.text = value;
            }
            else
            {
               tmpTextFlow = dataImporter.importToFlow(value);
            }
            if(dataImporter.errors)
            {
               for each(errorString in dataImporter.errors)
               {
                  errMsg = errMsg + ("Error: " + errorString + "\n");
               }
            }
            if(tmpTextFlow)
            {
               tmpTextFlow.flowComposer.removeAllControllers();
               i = 0;
               while(i < tf.flowComposer.numControllers)
               {
                  tmpTextFlow.flowComposer.addController(tf.flowComposer.getControllerAt(i));
                  i++;
               }
               this.textFlow = tmpTextFlow;
            }
         }
         catch(e:Error)
         {
            dataImporter = textImporter;
            textFlow = dataImporter.importToFlow("");
         }
         if(resolver)
         {
            this.textFlow.formatResolver = resolver;
         }
         if(txtFormat)
         {
            this._containerManager.hostFormat = txtFormat;
         }
         else
         {
            cacheDefaultTextFormat = this._defaultTextFormat;
            this.defaultTextFormat = null;
            this.defaultTextFormat = cacheDefaultTextFormat;
         }
         this.addTextFlowEventListeners();
         if(cacheAntiAliasType != null)
         {
            this.antiAliasType = cacheAntiAliasType;
         }
         else
         {
            this.antiAliasType = this._antiAliasType;
         }
         this.embedFonts = cacheEmbedFonts;
         if(cacheGridFitType != null)
         {
            this.gridFitType = cacheGridFitType;
         }
         else
         {
            this.gridFitType = this._gridFitType;
         }
         this.wordWrap = this._wordWrap;
         var cacheAutoSize:String = this._autoSize;
         this._autoSize = "NA";
         this.autoSize = cacheAutoSize;
         var cacheSelectable:Boolean = this._selectable;
         this._selectable = !this._selectable;
         this.selectable = cacheSelectable;
         this.invalidate(INVALID_ALL);
         this.scrollV = 0;
      }
      
      public function get columnWidth() : Object
      {
         return this._containerManager.columnWidth;
      }
      
      public function set firstBaselineOffset(param1:Object) : void
      {
         var n:Number = NaN;
         var value:Object = param1;
         try
         {
            this._containerManager.firstBaselineOffset = value;
         }
         catch(e:Error)
         {
            n = Number(value);
            if(isNaN(n))
            {
               _containerManager.firstBaselineOffset = "auto";
            }
            else if(n < 0)
            {
               _containerManager.firstBaselineOffset = 0;
            }
            else if(n > 1000)
            {
               _containerManager.firstBaselineOffset = 1000;
            }
            else
            {
               _containerManager.firstBaselineOffset = "auto";
            }
         }
         this.invalidate(INVALID_TEXT);
      }
      
      public function set columnWidth(param1:Object) : void
      {
         var n:Number = NaN;
         var value:Object = param1;
         if(this._containerManager.columnWidth == value)
         {
            return;
         }
         try
         {
            this._containerManager.columnWidth = value;
         }
         catch(e:Error)
         {
            n = Number(value);
            if(n < 0 || isNaN(n))
            {
               _containerManager.columnWidth = 0;
            }
            else if(n > 8000)
            {
               _containerManager.columnWidth = 8000;
            }
         }
         this.invalidate(INVALID_TEXT);
      }
      
      function getEditingMode(param1:ISelectionManager) : String
      {
         return !!param1?param1.editingMode:EditingMode.READ_ONLY;
      }
      
      function get firstField() : TLFTextField
      {
         var _loc2_:TLFContainerController = null;
         var _loc1_:TextFlow = !!this.TCMUsesTextStringAndFormat?null:this._containerManager.textFlow;
         if(_loc1_)
         {
            if(_loc1_.flowComposer == null || _loc1_.flowComposer.numControllers == 0)
            {
               return this;
            }
            _loc2_ = _loc1_.flowComposer.getControllerAt(0) as TLFContainerController;
            if(_loc2_)
            {
               return _loc2_.ownerField;
            }
            if(_loc1_.flowComposer.getControllerAt(0))
            {
               return this;
            }
         }
         return null;
      }
      
      function addNextField(param1:TLFTextField) : void
      {
         this._containerManager = this._containerManager.convert(MultiTextContainerManager);
         param1._containerManager = param1._containerManager.convert(MultiTextContainerManager);
         var _loc2_:IFlowComposer = this.textFlow.flowComposer;
         if(_loc2_.getControllerIndex(this.controller) < 0)
         {
            _loc2_.addControllerAt(this.controller,0);
         }
         if(_loc2_.getControllerIndex(param1.controller) < 0)
         {
            _loc2_.addControllerAt(param1.controller,_loc2_.getControllerIndex(this.controller) + 1);
         }
         param1.textFlow = this.textFlow;
         this.invalidate(INVALID_TEXT);
         param1.invalidate(INVALID_TEXT);
      }
      
      public function get styleSheet() : StyleSheet
      {
         var _loc1_:CSSFormatResolver = null;
         if(!this.TCMUsesTextStringAndFormat && this.textFlow)
         {
            _loc1_ = this.textFlow.formatResolver as CSSFormatResolver;
            if(_loc1_)
            {
               return _loc1_.styleSheet;
            }
         }
         return null;
      }
      
      public function getFirstCharInParagraph(param1:int) : int
      {
         var _loc2_:TextFlowLine = this.textFlow.flowComposer.findLineAtPosition(param1);
         if(_loc2_)
         {
            return _loc2_.paragraph.getAbsoluteStart();
         }
         throw new RangeError("The character index specified is out of range.");
      }
      
      public function get border() : Boolean
      {
         return this._border;
      }
      
      public function set scrollH(param1:int) : void
      {
         var _loc2_:String = !!this.TCMUsesTextStringAndFormat?this.hostFormat.blockProgression:this.textFlow.computedFormat.blockProgression;
         var _loc3_:String = !!this.TCMUsesTextStringAndFormat?this.hostFormat.direction:this.textFlow.computedFormat.direction;
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
            this._containerManager.verticalScrollPosition = param1;
         }
         else
         {
            this._containerManager.horizontalScrollPosition = param1;
         }
      }
      
      public function get textColor() : uint
      {
         return this._containerManager.textColor;
      }
      
      public function isFontCompatible(param1:String, param2:String) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param2 == FontStyle.REGULAR)
         {
            _loc3_ = FontWeight.NORMAL;
            _loc4_ = FontPosture.NORMAL;
         }
         else if(param2 == FontStyle.BOLD)
         {
            _loc3_ = FontWeight.BOLD;
            _loc4_ = FontPosture.NORMAL;
         }
         else if(param2 == FontStyle.ITALIC)
         {
            _loc3_ = FontWeight.NORMAL;
            _loc4_ = FontPosture.ITALIC;
         }
         else if(param2 == FontStyle.BOLD_ITALIC)
         {
            _loc3_ = FontWeight.BOLD;
            _loc4_ = FontPosture.ITALIC;
         }
         else
         {
            throw new ArgumentError("The fontStyle specified is not a member of flash.text.FontStyle.");
         }
         return FontDescription.isFontCompatible(param1,_loc3_,_loc4_);
      }
      
      override public function set height(param1:Number) : void
      {
         if(param1 != this._containerManager.compositionHeight)
         {
            this._containerManager.setCompositionSize(this._containerManager.compositionWidth,param1);
            this.invalidate(INVALID_DIMENSIONS);
         }
      }
      
      public function get autoSize() : String
      {
         return this._autoSize;
      }
      
      public function get selectionBeginIndex() : int
      {
         if(this.textFlow.interactionManager)
         {
            return this.textFlow.interactionManager.absoluteStart < 0?0:int(this.textFlow.interactionManager.absoluteStart);
         }
         return this._priorSelectionBeginIndex;
      }
      
      public function get selectable() : Boolean
      {
         var _loc1_:TLFTextField = this.firstField;
         return !!_loc1_?Boolean(_loc1_._selectable):Boolean(this._selectable);
      }
      
      public function set scrollV(param1:int) : void
      {
         var _loc2_:TextFlow = this._containerManager.textFlow;
         if(_loc2_ == null)
         {
            return;
         }
         if(this._maxScrollVCached && this._maxScrollV == 0)
         {
            return;
         }
         this.repaint();
         if(this._containerManager.container.scrollRect == null)
         {
            return;
         }
         if(!this._maxScrollVCached)
         {
            this.maxScrollV;
            if(!this._maxScrollVCached || this._maxScrollV == 0)
            {
               return;
            }
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param1 > this._maxScrollV)
         {
            param1 = this._maxScrollV;
         }
         if(param1 == 0)
         {
            if(_loc2_.blockProgression == BlockProgression.RL)
            {
               this._containerManager.horizontalScrollPosition = Math.max(0,this._maxScrollVFirstLineRect.right);
            }
            else
            {
               this._containerManager.verticalScrollPosition = Math.min(0,this._maxScrollVFirstLineRect.top);
            }
            return;
         }
         if(param1 == this._maxScrollV)
         {
            if(_loc2_.blockProgression == BlockProgression.RL)
            {
               this._containerManager.horizontalScrollPosition = Math.min(this._containerManager.contentLeft,this._maxScrollVLastLineRect.left);
            }
            else
            {
               this._containerManager.verticalScrollPosition = Math.max(this._containerManager.contentHeight,this._maxScrollVLastLineRect.bottom);
            }
            return;
         }
         var _loc3_:Rectangle = this._containerManager.getLineIndexBounds(param1 + this._maxScrollVFirstLineIndex - 1);
         if(_loc2_.blockProgression == BlockProgression.RL)
         {
            if(Math.abs(this._containerManager.contentLeft - _loc3_.right) < this._containerManager.compositionWidth)
            {
               this._containerManager.horizontalScrollPosition = Math.max(this._containerManager.contentLeft,this._maxScrollVLastLineRect.left);
            }
            else
            {
               this._containerManager.horizontalScrollPosition = _loc3_.right;
            }
         }
         else if(this._containerManager.contentHeight - _loc3_.top < this._containerManager.compositionHeight)
         {
            this._containerManager.verticalScrollPosition = Math.max(this._containerManager.contentHeight,this._maxScrollVLastLineRect.bottom);
         }
         else
         {
            this._containerManager.verticalScrollPosition = _loc3_.top;
         }
      }
      
      public function get pixelMaxScrollV() : int
      {
         var _loc1_:String = !!this.TCMUsesTextStringAndFormat?this.hostFormat.blockProgression:this.textFlow.computedFormat.blockProgression;
         var _loc2_:int = _loc1_ == BlockProgression.RL?int(this._containerManager.contentWidth - this._containerManager.compositionWidth):int(this._containerManager.contentHeight - this._containerManager.compositionHeight);
         return _loc2_ > 0?int(_loc2_):0;
      }
      
      public function set verticalAlign(param1:String) : void
      {
         this._containerManager.verticalAlign = param1;
         this.invalidate(INVALID_TEXT);
      }
      
      function textFlow_ScrollHandler(param1:TextLayoutEvent) : void
      {
         this.invalidate(TLFTextField.INVALID_BORDER);
         this.repaint();
         dispatchEvent(new Event(Event.SCROLL,false,false));
      }
      
      public function set text(param1:String) : void
      {
         if(param1 == null)
         {
            param1 = "";
         }
         this._text = param1;
         this._containerManager.text = param1;
         this.invalidate(INVALID_ALL);
         this.scrollH = 0;
         this.pixelScrollV = 0;
      }
      
      public function set background(param1:Boolean) : void
      {
         if(this._background == param1)
         {
            return;
         }
         this._background = param1;
         this.invalidate(INVALID_BORDER);
      }
      
      public function set border(param1:Boolean) : void
      {
         if(this._border == param1)
         {
            return;
         }
         this._border = param1;
         this.invalidate(INVALID_BORDER);
      }
      
      public function get antiAliasType() : String
      {
         return this._containerManager.antialiasType;
      }
      
      public function get selectionEndIndex() : int
      {
         if(this.textFlow.interactionManager)
         {
            return this.textFlow.interactionManager.absoluteEnd < 0?0:int(this.textFlow.interactionManager.absoluteEnd);
         }
         return this._priorSelectionEndIndex;
      }
      
      public function set styleSheet(param1:StyleSheet) : void
      {
         var _loc2_:IFormatResolver = param1 != null?new CSSFormatResolver(param1):null;
         if(this.textFlow)
         {
            this.textFlow.formatResolver = _loc2_;
            this.invalidate(INVALID_TEXT);
         }
      }
      
      public function set textColor(param1:uint) : void
      {
         param1 = param1 & 16777215;
         var _loc2_:TextFormat = this.defaultTextFormat;
         _loc2_.color = param1;
         this.defaultTextFormat = _loc2_;
         this._containerManager.textColor = param1;
         this.invalidate(INVALID_TEXT);
      }
      
      function set generationID(param1:int) : void
      {
         this._generationID = param1;
      }
      
      function get usesTCM() : Boolean
      {
         return this._containerManager is SingleTextContainerManager;
      }
      
      function textFlow_flowOperationEndHandler(param1:FlowOperationEvent) : void
      {
         var _loc2_:FlowOperation = param1.operation;
         if(_loc2_ is PasteOperation)
         {
            this.handlePasteOperation(PasteOperation(_loc2_));
         }
         dispatchEvent(new Event(Event.CHANGE,false,false));
      }
      
      public function set type(param1:String) : void
      {
         if(param1 != TextFieldType.INPUT && param1 != TextFieldType.DYNAMIC)
         {
            throw new ArgumentError("The type specified is not a member of flash.text.TextFieldType.");
         }
         var _loc2_:TLFTextField = this.firstField;
         if(!_loc2_)
         {
            _loc2_ = this;
         }
         _loc2_._type = param1;
         this.doTypeSet(_loc2_);
      }
      
      function get minScrollV() : int
      {
         var _loc1_:TextFlow = this._containerManager.textFlow;
         if(_loc1_ == null)
         {
            return 0;
         }
         if(!this._maxScrollVCached)
         {
            this.maxScrollV;
            if(!this._maxScrollVCached)
            {
               return 0;
            }
         }
         if(_loc1_.blockProgression == BlockProgression.RL)
         {
            return this._maxScrollVFirstLineRect.right >= 0?1:0;
         }
         return this._maxScrollVFirstLineRect.top <= 0?1:0;
      }
      
      public function get wordWrap() : Boolean
      {
         if(this._invalidState & INVALID_WORD_WRAP)
         {
            return this._wordWrap;
         }
         return this._containerManager.lineBreak == LineBreak.TO_FIT;
      }
      
      public function getLineIndexOfChar(param1:int) : int
      {
         var _loc2_:TextFlowLine = this.textFlow.flowComposer.findLineAtPosition(param1);
         if(_loc2_)
         {
            return this.textFlow.flowComposer.findLineIndexAtPosition(param1);
         }
         throw new RangeError("Character index out of range.");
      }
      
      public function get bottomScrollV() : int
      {
         var _loc7_:TextFlowLine = null;
         var _loc8_:Rectangle = null;
         this.repaint();
         var _loc1_:IFlowComposer = this.textFlow.flowComposer;
         var _loc2_:int = _loc1_.findLineIndexAtPosition(this._containerManager.absoluteStart);
         var _loc3_:int = this.numLines - 1;
         if(_loc3_ < 1)
         {
            return 1;
         }
         var _loc4_:TextFlow = this._containerManager.textFlow;
         if(_loc4_.blockProgression == BlockProgression.RL)
         {
            if(this._containerManager.compositionWidth > this._containerManager.contentWidth)
            {
               return _loc3_ + 1;
            }
         }
         else if(this._containerManager.compositionHeight > this._containerManager.contentHeight)
         {
            return _loc3_ + 1;
         }
         var _loc5_:int = 1;
         var _loc6_:int = _loc3_;
         while(_loc6_ >= _loc2_)
         {
            _loc7_ = _loc1_.getLineAt(_loc6_);
            _loc8_ = _loc7_.getBounds();
            if(_loc7_.textLineExists && _loc7_.getTextLine().parent)
            {
               if(this._containerManager.textFlow.computedFormat.blockProgression == BlockProgression.RL)
               {
                  if(int(_loc7_.x) >= this._containerManager.container.scrollRect.x)
                  {
                     _loc5_ = _loc6_ + 1;
                     break;
                  }
               }
               else if(int(_loc8_.bottom) <= this._containerManager.container.scrollRect.bottom)
               {
                  _loc5_ = _loc6_ + 1;
                  break;
               }
            }
            _loc6_--;
         }
         return _loc5_;
      }
      
      public function set alwaysShowSelection(param1:Boolean) : void
      {
         var _loc4_:SelectionFormat = null;
         if(this.alwaysShowSelection == param1 || this.selectable == false)
         {
            return;
         }
         var _loc2_:TLFTextField = this.firstField;
         if(!_loc2_)
         {
            _loc2_ = this;
         }
         _loc2_._alwaysShowSelection = param1;
         var _loc3_:ISelectionManager = _loc2_.textFlow.interactionManager;
         if(_loc3_ != null)
         {
            if(_loc3_.focusedSelectionFormat != focusedSelectionFormat)
            {
               _loc3_.focusedSelectionFormat = focusedSelectionFormat;
            }
            if(_loc3_.inactiveSelectionFormat != inactiveSelectionFormat)
            {
               _loc3_.inactiveSelectionFormat = inactiveSelectionFormat;
            }
            _loc4_ = !!this.alwaysShowSelection?alwaysShowSelectionOnFormat:alwaysShowSelectionOffFormat;
            if(_loc3_.unfocusedSelectionFormat != _loc4_)
            {
               _loc3_.unfocusedSelectionFormat = _loc4_;
            }
         }
      }
      
      public function set sharpness(param1:Number) : void
      {
      }
      
      function get prevField() : TLFTextField
      {
         var _loc1_:int = 0;
         var _loc2_:TLFContainerController = null;
         if(this.textFlow && this.textFlow.flowComposer)
         {
            _loc1_ = this.textFlow.flowComposer.getControllerIndex(this.controller);
            if(_loc1_ > 0)
            {
               _loc2_ = this.textFlow.flowComposer.getControllerAt(_loc1_ - 1) as TLFContainerController;
               if(_loc2_)
               {
                  return _loc2_.ownerField;
               }
            }
         }
         return null;
      }
      
      private function handlePasteOperation(param1:PasteOperation) : void
      {
         if(!this._restrict && !this._maxChars && !this._displayAsPassword)
         {
            return;
         }
         var _loc2_:String = TextConverter.export(param1.textScrap.textFlow,TextConverter.PLAIN_TEXT_FORMAT,ConversionType.STRING_TYPE) as String;
         if(this._displayAsPassword)
         {
            this._text = splice(this._text,param1.absoluteStart,param1.absoluteStart,_loc2_);
         }
         var _loc3_:EditManager = EditManager(this.textFlow.interactionManager);
         var _loc4_:SelectionState = new SelectionState(param1.textFlow,param1.absoluteStart,param1.absoluteStart + _loc2_.length);
         _loc3_.deleteText(_loc4_);
         this.replaceText(param1.absoluteStart,param1.absoluteStart + 1,_loc2_);
      }
      
      public function get paddingRight() : Object
      {
         return this._containerManager.paddingRight;
      }
      
      protected function drawBorder(param1:String) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Graphics = this._bgShape.graphics;
         _loc3_.clear();
         var _loc4_:Rectangle = null;
         if(this._border && this._borderWidth > 0)
         {
            _loc2_ = this._borderWidth / 2 - this._borderWidth;
            if(this._background)
            {
               _loc3_.beginFill(this._backgroundColor,this._backgroundAlpha);
            }
            _loc3_.lineStyle(this._borderWidth,this._borderColor,this._borderAlpha,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.MITER,10);
            if(this.isPointText || this._autoSize != TextFieldAutoSize.NONE)
            {
               if(this._wordWrap)
               {
                  if(param1 != BlockProgression.RL)
                  {
                     if(!isNaN(this._containerManager.compositionWidth))
                     {
                        _loc4_ = new Rectangle(_loc2_,_loc2_,this._containerManager.compositionWidth + this.borderWidth,this._containerManager.contentHeight + this.borderWidth);
                     }
                  }
                  else if(!isNaN(this._containerManager.compositionHeight))
                  {
                     _loc4_ = new Rectangle(_loc2_,_loc2_,this._containerManager.contentWidth + this.borderWidth,this._containerManager.compositionHeight + this.borderWidth);
                  }
               }
               else
               {
                  _loc4_ = new Rectangle(_loc2_,_loc2_,this._containerManager.contentWidth + this.borderWidth,this._containerManager.contentHeight + this.borderWidth);
               }
            }
            else if(!isNaN(this._containerManager.compositionWidth) && !isNaN(this._containerManager.compositionHeight))
            {
               _loc4_ = new Rectangle(_loc2_,_loc2_,this._containerManager.compositionWidth + this.borderWidth,this._containerManager.compositionHeight + this.borderWidth);
            }
            if(_loc4_ != null)
            {
               _loc3_.drawRect(_loc4_.x,_loc4_.y,_loc4_.width,_loc4_.height);
            }
            if(this._background)
            {
               _loc3_.endFill();
               if(this._bgShape2 != null)
               {
                  removeChild(this._bgShape2);
                  this._bgShape2 = null;
               }
            }
            else
            {
               if(this._bgShape2 == null)
               {
                  this._bgShape2 = new Shape();
                  this._bgShape2.visible = false;
                  addChildAt(this._bgShape2,0);
               }
               _loc3_ = this._bgShape2.graphics;
               _loc3_.clear();
               _loc3_.beginFill(0);
               if(_loc4_ != null)
               {
                  _loc3_.drawRect(_loc4_.x,_loc4_.y,_loc4_.width,_loc4_.height);
               }
               else
               {
                  _loc3_.drawRect(this._bgShape.x,this._bgShape.y,this._bgShape.width,this._bgShape.height);
               }
               _loc3_.endFill();
            }
            this._bgShape.visible = true;
         }
         else
         {
            if(this._bgShape2 != null)
            {
               removeChild(this._bgShape2);
               this._bgShape2 = null;
            }
            _loc3_.beginFill(this._backgroundColor,this._backgroundAlpha);
            if(this.isPointText || this._autoSize != TextFieldAutoSize.NONE)
            {
               _loc3_.drawRect(0,0,this._containerManager.contentWidth,this._containerManager.contentHeight);
            }
            else if(!isNaN(this._containerManager.compositionWidth) && !isNaN(this._containerManager.compositionHeight))
            {
               _loc3_.drawRect(0,0,this._containerManager.compositionWidth,this._containerManager.compositionHeight);
            }
            _loc3_.endFill();
            this._bgShape.visible = this._background;
         }
      }
      
      public function get borderAlpha() : Number
      {
         return this._borderAlpha;
      }
      
      public function get borderColor() : uint
      {
         return this._borderColor;
      }
      
      public function set condenseWhite(param1:Boolean) : void
      {
         this._condenseWhite = param1;
      }
      
      public function get textWidth() : Number
      {
         this.repaint();
         this._containerManager.compose();
         var _loc1_:Number = !!isNaN(Number(this.paddingLeft))?Number(0):Number(Number(this.paddingLeft));
         var _loc2_:Number = !!isNaN(Number(this.paddingRight))?Number(0):Number(Number(this.paddingRight));
         return this._containerManager.contentWidth - (_loc1_ + _loc2_);
      }
      
      public function set autoSize(param1:String) : void
      {
         if(this._autoSize == param1)
         {
            return;
         }
         if(param1 != TextFieldAutoSize.NONE && param1 != TextFieldAutoSize.LEFT && param1 != TextFieldAutoSize.RIGHT && param1 != TextFieldAutoSize.CENTER)
         {
            throw new ArgumentError("The autoSize specified is not a member of flash.text.TextFieldAutoSize.");
         }
         if(this._prevAutoSize == null)
         {
            this._prevAutoSize = this._autoSize;
         }
         this._autoSize = param1;
         this.invalidate(INVALID_AUTO_SIZE);
      }
      
      public function get useRichTextClipboard() : Boolean
      {
         return this._useRichTextClipboard;
      }
      
      public function get embedFonts() : Boolean
      {
         return this._containerManager.embedFonts;
      }
      
      public function get multiline() : Boolean
      {
         return this._multiline;
      }
      
      public function set columnCount(param1:Object) : void
      {
         var n:Number = NaN;
         var value:Object = param1;
         if(this._containerManager.columnCount == value)
         {
            return;
         }
         try
         {
            this._containerManager.columnCount = value;
         }
         catch(e:Error)
         {
            n = Number(value);
            if(n < 1 || isNaN(n))
            {
               _containerManager.columnCount = 1;
            }
            else if(n > 50)
            {
               _containerManager.columnCount = 50;
            }
         }
         this.invalidate(INVALID_TEXT);
      }
      
      public function set selectable(param1:Boolean) : void
      {
         if(this.selectable == param1)
         {
            return;
         }
         var _loc2_:TLFTextField = this.firstField;
         if(!_loc2_)
         {
            _loc2_ = this;
         }
         _loc2_._selectable = param1;
         this.doTypeSet(_loc2_);
      }
      
      public function get defaultTextFormat() : TextFormat
      {
         if(this._defaultTextFormat == _initialDefaultTextFormat)
         {
            this._defaultTextFormat = this.duplicateTextFormat(this._defaultTextFormat);
         }
         return this._defaultTextFormat;
      }
      
      public function set displayAsPassword(param1:Boolean) : void
      {
         if(this._displayAsPassword == param1)
         {
            return;
         }
         if(param1)
         {
            this._text = this.text;
         }
         this._displayAsPassword = param1;
         this.replaceText(0,this._containerManager.textLength,this._text);
      }
      
      public function getLineText(param1:int) : String
      {
         if(param1 < 0 || param1 >= this.numLines)
         {
            throw new RangeError("The line number specified is out of range.");
         }
         var _loc2_:TextFlowLine = this.getValidTextFlowLine(param1);
         var _loc3_:int = _loc2_.absoluteStart - _loc2_.paragraph.getAbsoluteStart();
         return _loc2_.paragraph.getText().substr(_loc3_,_loc2_.textLength);
      }
      
      public function get mouseWheelEnabled() : Boolean
      {
         return this._mouseWheelEnabled;
      }
      
      public function get textHeight() : Number
      {
         this.repaint();
         this._containerManager.compose();
         var _loc1_:Number = !!isNaN(Number(this.paddingTop))?Number(0):Number(Number(this.paddingTop));
         var _loc2_:Number = !!isNaN(Number(this.paddingBottom))?Number(0):Number(Number(this.paddingBottom));
         return this._containerManager.contentHeight - (_loc1_ + _loc2_);
      }
      
      public function get restrict() : String
      {
         return this._restrict;
      }
      
      public function get tlfMarkup() : String
      {
         if(this.textFlow.generation != this._tlfMarkupGenerationID || this._tlfMarkup == "")
         {
            this._tlfMarkup = TextConverter.export(this.textFlow,TextConverter.TEXT_LAYOUT_FORMAT,ConversionType.STRING_TYPE) as String;
            this._tlfMarkupGenerationID = this.textFlow.generation;
         }
         return this._tlfMarkup;
      }
      
      private function canUseTCMForTextFlow(param1:TextFlow) : Boolean
      {
         return useTCM && this.hasSingleContainer(param1);
      }
      
      public function get gridFitType() : String
      {
         if(!this.TCMUsesTextStringAndFormat && this.textFlow.cffHinting == CFFHinting.NONE || this.TCMUsesTextStringAndFormat && this.hostFormat && this.hostFormat.cffHinting == CFFHinting.NONE)
         {
            this._gridFitType = GridFitType.NONE;
         }
         else if(this._gridFitType != GridFitType.SUBPIXEL)
         {
            this._gridFitType = GridFitType.PIXEL;
         }
         return this._gridFitType;
      }
      
      private function getValidTextFlowLineFromCharIndex(param1:int) : TextFlowLine
      {
         if(param1 >= 0 && param1 < this._containerManager.textLength)
         {
            return this.textFlow.flowComposer.findLineAtPosition(param1);
         }
         throw new RangeError("The character index specified is out of range.");
      }
      
      function get passwordCharacter() : String
      {
         return this._passwordCharacter;
      }
      
      function get contentWidth() : Number
      {
         return this._contentWidth;
      }
      
      public function get backgroundColor() : uint
      {
         return this._backgroundColor;
      }
      
      public function get maxChars() : int
      {
         var _loc1_:TLFTextField = this.firstField;
         if(!_loc1_)
         {
            _loc1_ = this;
         }
         return !!_loc1_?int(_loc1_._maxChars):0;
      }
      
      function get isPointText() : Boolean
      {
         return this._isPointText && (this.TCMUsesTextStringAndFormat || this.textFlow != null);
      }
      
      function initController(param1:Sprite) : TLFContainerController
      {
         this._containerManager.addListeners();
         return new TLFContainerController(param1,this);
      }
      
      function get paddingLock() : Boolean
      {
         return this._paddingLock;
      }
      
      public function set antiAliasType(param1:String) : void
      {
         if(this.antiAliasType == param1)
         {
            return;
         }
         if(this._invalidTextLayoutFormat == null)
         {
            this._invalidTextLayoutFormat = new TextLayoutFormat();
         }
         this._invalidTextLayoutFormat.renderingMode = FormatValue.INHERIT;
         this._containerManager.antialiasType = param1;
         this.invalidate(INVALID_TEXT);
      }
      
      public function get length() : int
      {
         return this.text.length;
      }
      
      function get inlineInfo() : *
      {
         return this._inlineInfo;
      }
      
      public function get backgroundAlpha() : Number
      {
         return this._backgroundAlpha;
      }
      
      function composeComplete(param1:CompositionCompleteEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(param1 && !this.TCMUsesTextStringAndFormat && param1.target as TextFlow != this.textFlow)
         {
            return;
         }
         this._maxScrollVCached = false;
         if(this.originalWidth == int.MAX_VALUE || this.originalHeight == int.MAX_VALUE)
         {
            this.invalidate(INVALID_TEXT);
            this.repaint();
         }
         var _loc2_:String = !!this.TCMUsesTextStringAndFormat?this.hostFormat.blockProgression:this.textFlow.computedFormat.blockProgression;
         if(this._autoSize != TextFieldAutoSize.NONE)
         {
            _loc3_ = 0;
            _loc4_ = 0;
            if(_loc2_ != BlockProgression.RL)
            {
               if(!this._wordWrap)
               {
                  if(this._autoSize == TextFieldAutoSize.RIGHT)
                  {
                     _loc3_ = this.originalWidth - this._containerManager.contentWidth;
                  }
                  else if(this._autoSize == TextFieldAutoSize.CENTER)
                  {
                     _loc3_ = (this.originalWidth - this._containerManager.contentWidth) / 2;
                  }
               }
            }
            else
            {
               _loc3_ = this.contentWidth - this.contentWidth;
               if(!this._wordWrap)
               {
                  if(this._autoSize == TextFieldAutoSize.RIGHT)
                  {
                     _loc4_ = this.originalHeight - this._containerManager.contentHeight;
                  }
                  else if(this._autoSize == TextFieldAutoSize.CENTER)
                  {
                     _loc4_ = (this.originalHeight - this._containerManager.contentHeight) / 2;
                  }
               }
            }
            if(_loc3_ != 0)
            {
               this.x = this.x + _loc3_;
            }
            if(_loc4_ != 0)
            {
               this.y = this.y + _loc4_;
            }
            this.contentWidth = this.contentWidth;
            this.contentHeight = this.contentHeight;
         }
         this.originalWidth = this._containerManager.contentWidth;
         this.originalHeight = this._containerManager.contentHeight;
         if(this.isPointText || this._autoSize != TextFieldAutoSize.NONE)
         {
            this.drawBorder(_loc2_);
         }
      }
      
      private function duplicateTextFormat(param1:TextFormat) : TextFormat
      {
         var _loc3_:* = null;
         var _loc2_:TextFormat = new TextFormat();
         for(_loc3_ in param1)
         {
            _loc2_[_loc3_] = param1[_loc3_];
         }
         return _loc2_;
      }
      
      public function set htmlText(param1:String) : void
      {
         var _loc3_:FlowLeafElement = null;
         if(param1 == "")
         {
            this.text = "";
            this.hostFormat = createTextLayoutFormat(_initialDefaultTextFormat);
            return;
         }
         var _loc2_:TextFlow = this._containerManager.textFlow;
         if(this.styleSheet == null)
         {
            _loc3_ = _loc2_.getFirstLeaf();
            if(_loc3_)
            {
               _loc2_.hostFormat = _loc3_.computedFormat;
            }
         }
         this.doImport(TextConverter.TEXT_FIELD_HTML_FORMAT,param1);
         this._htmlText = this.htmlText;
      }
      
      public function set thickness(param1:Number) : void
      {
      }
      
      public function getLineMetrics(param1:int) : TextLineMetrics
      {
         var _loc3_:Number = NaN;
         if(param1 < 0 || param1 >= this.numLines)
         {
            throw new RangeError("The line number specified is out of range.");
         }
         var _loc2_:TextFlowLine = this.getValidTextFlowLine(param1);
         if(_loc2_)
         {
            _loc3_ = _loc2_.height;
            if(_loc3_ < _loc2_.ascent + _loc2_.descent)
            {
               _loc3_ = _loc2_.ascent + _loc2_.descent;
            }
            if(param1 == 0)
            {
               return new TextLineMetrics(_loc2_.x,_loc2_.unjustifiedTextWidth,_loc3_,_loc2_.ascent,_loc2_.descent,0);
            }
            return new TextLineMetrics(_loc2_.x,_loc2_.unjustifiedTextWidth,_loc3_,_loc2_.ascent,_loc2_.descent,_loc2_.height - (_loc2_.ascent + _loc2_.descent));
         }
         return null;
      }
      
      public function get borderWidth() : Number
      {
         return this._borderWidth;
      }
      
      public function set direction(param1:String) : void
      {
         this._containerManager.direction = param1;
         this.invalidate(INVALID_ALL);
      }
      
      function get contentHeight() : Number
      {
         return this._contentHeight;
      }
      
      public function set paddingTop(param1:Object) : void
      {
         var n:Number = NaN;
         var value:Object = param1;
         if(this._containerManager.paddingTop == value)
         {
            return;
         }
         try
         {
            this._containerManager.paddingTop = value;
         }
         catch(e:Error)
         {
            n = Number(value);
            if(isNaN(n))
            {
               _containerManager.paddingTop = value = "auto";
            }
            else if(n < -1000)
            {
               _containerManager.paddingTop = value = -8000;
            }
            else if(n > 1000)
            {
               _containerManager.paddingTop = value = 8000;
            }
            else
            {
               _containerManager.paddingTop = value = "auto";
            }
         }
         if(this._paddingLock)
         {
            this._containerManager.paddingLeft = value;
            this._containerManager.paddingRight = value;
            this._containerManager.paddingBottom = value;
         }
         this.invalidate(INVALID_TEXT);
      }
      
      public function get caretIndex() : int
      {
         if(this.textFlow.interactionManager)
         {
            return this.textFlow.interactionManager.activePosition < 0?0:int(this.textFlow.interactionManager.activePosition);
         }
         return this._priorSelectionBeginIndex;
      }
      
      function switchToEditingMode(param1:TextFlow, param2:String, param3:Boolean = true) : void
      {
         if(param2 == null || this.getEditingMode(param1.interactionManager) == param2)
         {
            return;
         }
         if(param1.interactionManager != null)
         {
            this._priorSelectionBeginIndex = param1.interactionManager.anchorPosition;
            this._priorSelectionEndIndex = param1.interactionManager.activePosition;
         }
         this._containerManager.editMode = param2;
         if(param1.interactionManager)
         {
            this.setSelection(this._priorSelectionBeginIndex,this._priorSelectionEndIndex);
            param1.interactionManager.focusedSelectionFormat = focusedSelectionFormat;
            param1.interactionManager.inactiveSelectionFormat = inactiveSelectionFormat;
            if(this.alwaysShowSelection)
            {
               param1.interactionManager.unfocusedSelectionFormat = alwaysShowSelectionOnFormat;
            }
            else
            {
               param1.interactionManager.unfocusedSelectionFormat = alwaysShowSelectionOffFormat;
            }
         }
         if(param3)
         {
            this.invalidate(INVALID_TEXT);
         }
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         this._wordWrap = param1;
         this.invalidate(INVALID_WORD_WRAP);
      }
      
      public function set paddingRight(param1:Object) : void
      {
         var n:Number = NaN;
         var value:Object = param1;
         if(this._containerManager.paddingRight == value)
         {
            return;
         }
         try
         {
            this._containerManager.paddingRight = value;
         }
         catch(e:Error)
         {
            n = Number(value);
            if(isNaN(n))
            {
               _containerManager.paddingRight = value = "auto";
            }
            else if(n < -1000)
            {
               _containerManager.paddingRight = value = -8000;
            }
            else if(n > 1000)
            {
               _containerManager.paddingRight = value = 8000;
            }
            else
            {
               _containerManager.paddingRight = value = "auto";
            }
         }
         if(this._paddingLock)
         {
            this._containerManager.paddingLeft = value;
            this._containerManager.paddingTop = value;
            this._containerManager.paddingBottom = value;
         }
         this.invalidate(INVALID_TEXT);
      }
      
      public function get maxScrollH() : int
      {
         var _loc1_:String = !!this.TCMUsesTextStringAndFormat?this.hostFormat.blockProgression:this.textFlow.computedFormat.blockProgression;
         var _loc2_:int = _loc1_ == BlockProgression.RL?int(this._containerManager.contentHeight - this._containerManager.compositionHeight):int(this._containerManager.contentWidth - this._containerManager.compositionWidth);
         return _loc2_ > 0?int(_loc2_):0;
      }
      
      public function get numLines() : int
      {
         this.repaint();
         return this._containerManager.numLines;
      }
      
      private function hasSingleContainer(param1:TextFlow) : Boolean
      {
         if(param1 == null)
         {
            return true;
         }
         if(param1.flowComposer == null)
         {
            return true;
         }
         return param1.flowComposer.numControllers <= 1;
      }
      
      public function get maxScrollV() : int
      {
         var _loc9_:Number = NaN;
         var _loc1_:TextFlow = this._containerManager.textFlow;
         if(_loc1_ == null)
         {
            return 0;
         }
         if(this._maxScrollVCached)
         {
            return this._maxScrollV;
         }
         this.repaint();
         this._containerManager.compose();
         var _loc2_:IFlowComposer = _loc1_.flowComposer;
         if(_loc2_.numControllers > 0 && _loc2_.getControllerIndex(this._containerManager.controller) < _loc2_.numControllers - 1)
         {
            this._maxScrollVCached = true;
            this._maxScrollV = 0;
            return this._maxScrollV;
         }
         var _loc3_:int = this._containerManager.numLines;
         var _loc4_:int = !this._containerManager.columnCount || this._containerManager.columnCount == FormatValue.AUTO?1:int(int(this._containerManager.columnCount));
         var _loc5_:int = _loc4_ - 1;
         this._maxScrollVFirstLineIndex = _loc2_.findLineIndexAtPosition(this._containerManager.absoluteStart);
         var _loc6_:TextFlowLine = _loc2_.getLineAt(this._maxScrollVFirstLineIndex);
         if(_loc6_ == null)
         {
            this._maxScrollVCached = true;
            this._maxScrollV = 0;
            return this._maxScrollV;
         }
         while(_loc6_.columnIndex != _loc5_)
         {
            this._maxScrollVFirstLineIndex++;
            if(this._maxScrollVFirstLineIndex >= _loc3_)
            {
               this._maxScrollVCached = true;
               this._maxScrollV = 0;
               return this._maxScrollV;
            }
            _loc6_ = _loc2_.getLineAt(this._maxScrollVFirstLineIndex);
         }
         this._maxScrollVFirstLineRect = _loc6_.getBounds();
         var _loc7_:int = _loc3_ - 1;
         var _loc8_:TextFlowLine = _loc2_.getLineAt(_loc7_);
         this._maxScrollVLastLineRect = _loc8_.getBounds();
         var _loc10_:* = _loc1_.blockProgression == BlockProgression.RL;
         if(_loc10_)
         {
            _loc9_ = Math.round(Math.min(this._maxScrollVLastLineRect.left,this._containerManager.contentLeft) + this._containerManager.compositionWidth);
            if(_loc9_ >= 0)
            {
               this._maxScrollVCached = true;
               this._maxScrollV = 0;
               return this._maxScrollV;
            }
         }
         else
         {
            _loc9_ = Math.round(Math.max(this._maxScrollVLastLineRect.bottom,this._containerManager.contentHeight) - this._containerManager.compositionHeight);
            if(_loc9_ <= 0)
            {
               this._maxScrollVCached = true;
               this._maxScrollV = 0;
               return this._maxScrollV;
            }
         }
         _loc7_--;
         while(_loc7_ > this._maxScrollVFirstLineIndex)
         {
            _loc8_ = _loc2_.getLineAt(_loc7_);
            if(_loc10_)
            {
               if(Math.round(_loc8_.getBounds().right) > _loc9_)
               {
                  break;
               }
            }
            else if(Math.round(_loc8_.getBounds().top) < _loc9_)
            {
               break;
            }
            _loc7_--;
         }
         this._maxScrollV = _loc7_ - this._maxScrollVFirstLineIndex + 2;
         this._maxScrollVCached = true;
         return this._maxScrollV;
      }
      
      public function getImageReference(param1:String) : DisplayObject
      {
         var _loc3_:InlineGraphicElement = null;
         var _loc2_:FlowLeafElement = this.textFlow.getFirstLeaf();
         while(_loc2_)
         {
            if(_loc2_ is InlineGraphicElement)
            {
               _loc3_ = InlineGraphicElement(_loc2_);
               if(String(_loc3_.id).toUpperCase() == param1.toUpperCase())
               {
                  return _loc3_.graphic;
               }
            }
            _loc2_ = _loc2_.getNextLeaf();
         }
         return null;
      }
      
      override public function get height() : Number
      {
         this.repaint();
         return super.height;
      }
      
      public function get scrollV() : int
      {
         var _loc4_:Rectangle = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc1_:TextFlow = this._containerManager.textFlow;
         this.repaint();
         this._containerManager.compose();
         if(!this._maxScrollVCached)
         {
            this.maxScrollV;
            if(!this._maxScrollVCached || this._maxScrollV == 0)
            {
               return 0;
            }
         }
         var _loc2_:int = this._containerManager.numLines;
         var _loc3_:int = this._maxScrollVFirstLineIndex;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._containerManager.getLineIndexBounds(_loc3_);
            if(!_loc4_.isEmpty())
            {
               if(_loc1_.blockProgression == BlockProgression.RL)
               {
                  _loc5_ = Math.round(this._containerManager.horizontalScrollPosition);
                  if(_loc5_ <= Math.round(_loc4_.right) && _loc5_ >= Math.round(_loc4_.left))
                  {
                     return _loc3_ + 1;
                  }
               }
               else
               {
                  _loc6_ = Math.round(this._containerManager.verticalScrollPosition);
                  if(_loc6_ <= Math.round(_loc4_.bottom) && _loc6_ >= Math.round(_loc4_.top))
                  {
                     return _loc3_ + 1;
                  }
               }
            }
            _loc3_++;
         }
         return 0;
      }
      
      public function get scrollH() : int
      {
         var _loc1_:String = !!this.TCMUsesTextStringAndFormat?this.hostFormat.blockProgression:this.textFlow.computedFormat.blockProgression;
         return _loc1_ == BlockProgression.RL?int(Math.abs(this._containerManager.verticalScrollPosition)):int(Math.abs(this._containerManager.horizontalScrollPosition));
      }
      
      public function set borderAlpha(param1:Number) : void
      {
         if(this._borderAlpha == param1)
         {
            return;
         }
         this._borderAlpha = param1;
         if(this._borderAlpha < 0)
         {
            this._borderAlpha = 0;
         }
         else if(this._borderAlpha > 1)
         {
            this._borderAlpha = 1;
         }
         this.invalidate(INVALID_BORDER);
      }
      
      public function get text() : String
      {
         if(this._displayAsPassword || !this.TCMUsesTextStringAndFormat && this.textFlow && this.textFlow.generation == this._generationID)
         {
            return this._text;
         }
         if(this._text == "" || this.TCMUsesTextStringAndFormat || this.textFlow && this.textFlow.generation != this._generationID)
         {
            this._text = this._containerManager.text;
            return this._text;
         }
         return "";
      }
      
      public function get verticalAlign() : String
      {
         return String(this._containerManager.verticalAlign);
      }
      
      function updateComplete(param1:UpdateCompleteEvent) : void
      {
         this.composeComplete(null);
         dispatchEvent(new Event(Event.CHANGE,false,false));
      }
      
      public function getCharBoundaries(param1:int) : Rectangle
      {
         var _loc2_:Rectangle = null;
         var _loc10_:Point = null;
         var _loc11_:Point = null;
         this.repaint();
         var _loc3_:TextFlowLine = this.textFlow.flowComposer.findLineAtPosition(param1);
         var _loc4_:TextLine = _loc3_.getTextLine(true);
         var _loc5_:int = _loc4_.getAtomIndexAtCharIndex(param1 - _loc3_.paragraph.getAbsoluteStart());
         if(_loc5_ > -1)
         {
            _loc2_ = _loc4_.getAtomBounds(_loc5_);
         }
         var _loc6_:TextFlowLine = this.getValidTextFlowLine(this.getLineIndexOfChar(param1));
         var _loc7_:Rectangle = _loc6_.getBounds();
         var _loc8_:String = this.textFlow.computedFormat.blockProgression;
         var _loc9_:* = _loc8_ == BlockProgression.RL;
         if(!_loc9_)
         {
            _loc2_.x = _loc2_.x + _loc7_.x;
            _loc2_.y = _loc7_.y;
            _loc10_ = this._containerManager.container.localToGlobal(new Point(_loc2_.x,_loc2_.y));
            _loc11_ = this.globalToLocal(_loc10_);
            _loc2_.x = _loc11_.x;
            _loc2_.y = _loc11_.y;
         }
         else
         {
            _loc2_.x = _loc2_.x + _loc7_.x;
            _loc2_.y = _loc2_.y + _loc7_.y;
            _loc10_ = this._containerManager.container.localToGlobal(new Point(_loc2_.x,_loc2_.y));
            _loc11_ = this.globalToLocal(_loc10_);
            _loc2_.x = _loc11_.x;
            _loc2_.y = _loc11_.y;
         }
         return _loc2_;
      }
      
      public function set paddingBottom(param1:Object) : void
      {
         var n:Number = NaN;
         var value:Object = param1;
         if(this._containerManager.paddingBottom == value)
         {
            return;
         }
         try
         {
            this._containerManager.paddingBottom = value;
         }
         catch(e:Error)
         {
            n = Number(value);
            if(isNaN(n))
            {
               _containerManager.paddingBottom = value = "auto";
            }
            else if(n < -1000)
            {
               _containerManager.paddingBottom = value = -8000;
            }
            else if(n > 1000)
            {
               _containerManager.paddingBottom = value = 8000;
            }
            else
            {
               _containerManager.paddingBottom = value = "auto";
            }
         }
         if(this._paddingLock)
         {
            this._containerManager.paddingLeft = value;
            this._containerManager.paddingTop = value;
            this._containerManager.paddingRight = value;
         }
         this.invalidate(INVALID_TEXT);
      }
      
      public function get type() : String
      {
         var _loc1_:TLFTextField = this.firstField;
         return !!_loc1_?_loc1_._type:this._type;
      }
      
      public function replaceSelectedText(param1:String) : void
      {
         if(this.textFlow && this.textFlow.formatResolver != null)
         {
            throw new Error("This method cannot be used on a text field with a style sheet.");
         }
         var _loc2_:String = this.getEditingMode(this.textFlow.interactionManager);
         if(_loc2_ != EditingMode.READ_WRITE)
         {
            this.switchToEditingMode(this.textFlow,EditingMode.READ_WRITE);
         }
         var _loc3_:EditManager = EditManager(this.textFlow.interactionManager);
         _loc3_.beginCompositeOperation();
         if(!_loc3_.hasSelection())
         {
            _loc3_.selectRange(int.MAX_VALUE,int.MAX_VALUE);
         }
         var _loc4_:Number = _loc3_.anchorPosition;
         this.insertWithParagraphs(_loc3_,param1);
         this._containerManager.update();
         if(this._defaultTextFormat != null)
         {
            this.setTextFormat(this._defaultTextFormat,_loc4_,_loc4_ + param1.length);
         }
         _loc3_.endCompositeOperation();
         this.invalidate(INVALID_TEXT);
         if(_loc2_ != EditingMode.READ_WRITE)
         {
            this.switchToEditingMode(this.textFlow,_loc2_);
         }
      }
      
      public function get background() : Boolean
      {
         return this._background;
      }
      
      public function get alwaysShowSelection() : Boolean
      {
         var _loc1_:TLFTextField = this.firstField;
         return !!_loc1_?Boolean(_loc1_._alwaysShowSelection):Boolean(this._alwaysShowSelection);
      }
      
      public function get sharpness() : Number
      {
         return 0;
      }
      
      function invalidate(param1:uint) : void
      {
         var type:uint = param1;
         this._maxScrollVCached = false;
         this._invalidState = this._invalidState | type;
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
      }
      
      function insertWithParagraphs(param1:EditManager, param2:String) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         param2 = param2.replace(/\r/g,"");
         if(param2 == "")
         {
            param1.insertText("");
         }
         else
         {
            _loc3_ = param2.split("\n");
            _loc4_ = param1.absoluteStart;
            _loc5_ = _loc3_.shift();
            while(_loc5_ != null)
            {
               if(_loc5_.length)
               {
                  param1.insertText(_loc5_);
               }
               _loc4_ = _loc4_ + _loc5_.length;
               if(_loc3_.length > 0 && !this._displayAsPassword)
               {
                  param1.selectRange(_loc4_,_loc4_);
                  param1.splitParagraph();
                  _loc4_++;
               }
               _loc5_ = _loc3_.shift();
            }
         }
      }
      
      public function set borderColor(param1:uint) : void
      {
         if(this._borderColor == param1)
         {
            return;
         }
         this._borderColor = param1;
         if(this._borderColor > 16777215)
         {
            this._borderColor = 16777215;
         }
         this.invalidate(INVALID_BORDER);
      }
      
      public function set columnGap(param1:Object) : void
      {
         var n:Number = NaN;
         var value:Object = param1;
         if(this._containerManager.columnGap == value)
         {
            return;
         }
         try
         {
            this._containerManager.columnGap = value;
         }
         catch(e:Error)
         {
            n = Number(value);
            if(n < 0 || isNaN(n))
            {
               _containerManager.columnGap = 0;
            }
            else if(n > 1000)
            {
               _containerManager.columnGap = 1000;
            }
         }
         this.invalidate(INVALID_TEXT);
      }
      
      public function set defaultTextFormat(param1:TextFormat) : void
      {
         var _loc2_:TLFTextField = null;
         if(!this.TCMUsesTextStringAndFormat && this.textFlow && this.textFlow.formatResolver != null)
         {
            throw new Error("This method cannot be used on a text field with a style sheet.");
         }
         if(this._defaultTextFormat == param1)
         {
            return;
         }
         this._defaultTextFormat = param1;
         if(param1)
         {
            if(this._defaultTextFormat.font == null)
            {
               this._defaultTextFormat.font = "Times New Roman";
            }
            _loc2_ = this.firstField;
            if(!_loc2_)
            {
               _loc2_ = this;
            }
            _loc2_._containerManager.hostFormat = createTextLayoutFormat(param1);
         }
      }
      
      public function get condenseWhite() : Boolean
      {
         return this._condenseWhite;
      }
      
      public function get displayAsPassword() : Boolean
      {
         return this._displayAsPassword;
      }
      
      public function setSelection(param1:int, param2:int) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param1 > this._containerManager.textLength + 1)
         {
            param1 = this.length + 1;
         }
         if(param2 < 0)
         {
            param2 = 0;
         }
         else if(param2 > this._containerManager.textLength + 1)
         {
            param2 = this.length + 1;
         }
         if(this.textFlow.interactionManager)
         {
            this.textFlow.interactionManager.selectRange(param1,param2);
            this.invalidate(INVALID_TEXT);
         }
         else
         {
            this._priorSelectionBeginIndex = param1;
            this._priorSelectionEndIndex = param2;
         }
      }
      
      public function set useRichTextClipboard(param1:Boolean) : void
      {
         this._useRichTextClipboard = param1;
      }
      
      public function set embedFonts(param1:Boolean) : void
      {
         if(this.embedFonts == param1)
         {
            return;
         }
         this._containerManager.embedFonts = param1;
         this.invalidate(INVALID_TEXT);
      }
      
      public function get columnCount() : Object
      {
         return this._containerManager.columnCount;
      }
      
      public function set multiline(param1:Boolean) : void
      {
         this._multiline = param1;
         this.invalidate(INVALID_TEXT);
      }
      
      function removeTextFlowEventListeners() : void
      {
         this._containerManager.removeListeners();
      }
      
      public function set mouseWheelEnabled(param1:Boolean) : void
      {
         this._mouseWheelEnabled = param1;
      }
      
      public function appendText(param1:String) : void
      {
         this._containerManager.appendText(param1);
      }
      
      public function set tlfMarkup(param1:String) : void
      {
         if(param1 == "")
         {
            this.text = "";
            this.hostFormat = new TextLayoutFormat();
            return;
         }
         this.doImport(TextConverter.TEXT_LAYOUT_FORMAT,param1);
         this._tlfMarkup = this.tlfMarkup;
      }
      
      public function set paddingLeft(param1:Object) : void
      {
         var n:Number = NaN;
         var value:Object = param1;
         if(this._containerManager.paddingLeft == value)
         {
            return;
         }
         try
         {
            this._containerManager.paddingLeft = value;
         }
         catch(e:Error)
         {
            n = Number(value);
            if(isNaN(n))
            {
               _containerManager.paddingLeft = value = "auto";
            }
            else if(n < -1000)
            {
               _containerManager.paddingLeft = value = -8000;
            }
            else if(n > 1000)
            {
               _containerManager.paddingLeft = value = 8000;
            }
            else
            {
               _containerManager.paddingLeft = value = "auto";
            }
         }
         if(this._paddingLock)
         {
            this._containerManager.paddingTop = value;
            this._containerManager.paddingRight = value;
            this._containerManager.paddingBottom = value;
         }
         this.invalidate(INVALID_TEXT);
      }
      
      public function get thickness() : Number
      {
         return 0;
      }
      
      public function getLineIndexAtPoint(param1:Number, param2:Number) : int
      {
         return this.getLineIndexOfChar(this.getCharIndexAtPoint(param1,param2));
      }
      
      public function get htmlText() : String
      {
         if(this.textFlow.generation != this._htmlTextGenerationID || this._htmlText == "")
         {
            this._htmlText = TextConverter.export(this.textFlow,TextConverter.TEXT_FIELD_HTML_FORMAT,ConversionType.STRING_TYPE) as String;
            this._htmlTextGenerationID = this.textFlow.generation;
         }
         return this._htmlText;
      }
      
      public function getTextFormat(param1:int = -1, param2:int = -1) : TextFormat
      {
         if(param1 > this._containerManager.textLength || param1 < -1 || param2 > this._containerManager.textLength || param2 < -1)
         {
            throw new RangeError("The beginIndex or endIndex specified is out of range.");
         }
         return this._containerManager.getTextFormat(param1,param2);
      }
      
      function set hostFormat(param1:ITextLayoutFormat) : void
      {
         this._containerManager.hostFormat = param1;
      }
      
      public function get direction() : String
      {
         return this._containerManager.direction;
      }
      
      public function get paddingTop() : Object
      {
         return this._containerManager.paddingTop;
      }
      
      public function set pixelScrollV(param1:int) : void
      {
         var _loc2_:String = !!this.TCMUsesTextStringAndFormat?this.hostFormat.blockProgression:this.textFlow.computedFormat.blockProgression;
         if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param1 > this.pixelMaxScrollV)
         {
            param1 = this.pixelMaxScrollV;
         }
         if(_loc2_ == BlockProgression.RL)
         {
            this._containerManager.horizontalScrollPosition = -param1;
         }
         else
         {
            this._containerManager.verticalScrollPosition = param1;
         }
      }
      
      public function set restrict(param1:String) : void
      {
         this._restrict = param1;
      }
      
      public function set gridFitType(param1:String) : void
      {
         var _loc2_:TextLayoutFormat = null;
         if(this.gridFitType == param1)
         {
            return;
         }
         if(param1 != GridFitType.NONE && param1 != GridFitType.PIXEL && param1 != GridFitType.SUBPIXEL)
         {
            param1 = GridFitType.PIXEL;
         }
         this._gridFitType = param1;
         if(this._invalidTextLayoutFormat == null)
         {
            this._invalidTextLayoutFormat = new TextLayoutFormat();
         }
         this._invalidTextLayoutFormat.cffHinting = FormatValue.INHERIT;
         if(this.TCMUsesTextStringAndFormat)
         {
            _loc2_ = !!this.hostFormat?TextLayoutFormat(this.hostFormat):new TextLayoutFormat();
            _loc2_.cffHinting = param1 == GridFitType.NONE?CFFHinting.NONE:CFFHinting.HORIZONTAL_STEM;
            this.hostFormat = _loc2_;
         }
         else
         {
            this.textFlow.cffHinting = param1 == GridFitType.NONE?CFFHinting.NONE:CFFHinting.HORIZONTAL_STEM;
         }
         this.invalidate(INVALID_TEXT);
      }
      
      override public function set width(param1:Number) : void
      {
         if(param1 != this._containerManager.compositionWidth)
         {
            this._containerManager.setCompositionSize(param1,this._containerManager.compositionHeight);
            this.invalidate(INVALID_DIMENSIONS);
         }
      }
      
      public function setTextFormat(param1:TextFormat, param2:int = -1, param3:int = -1) : void
      {
         var _loc6_:TextLayoutFormat = null;
         if(param2 > this._containerManager.textLength || param2 < -1 || param3 > this._containerManager.textLength || param3 < -1)
         {
            throw new RangeError("The beginIndex or endIndex specified is out of range.");
         }
         var _loc4_:TextLayoutFormat = new TextLayoutFormat();
         var _loc5_:TextLayoutFormat = new TextLayoutFormat();
         this._containerManager.setTextFormat(param1,param2,param3,_loc4_,_loc5_);
         if(this.canUseTCMForTextFlow(this.textFlow))
         {
            this._containerManager = this._containerManager.convert(SingleTextContainerManager);
            if((param2 == -1 || param2 == 0) && (param3 == -1 || param3 == this._containerManager.textLength))
            {
               _loc6_ = new TextLayoutFormat(this._containerManager.hostFormat);
               _loc6_.concat(_loc5_);
               _loc6_.concat(_loc4_);
               this._containerManager.hostFormat = _loc6_;
               this._containerManager.text = this.text;
            }
         }
         this.invalidate(INVALID_TEXT);
      }
      
      function textFlow_flowOperationBeginHandler(param1:FlowOperationEvent) : void
      {
         var _loc3_:SelectionState = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:InsertTextOperation = null;
         var _loc8_:String = null;
         var _loc9_:SelectionState = null;
         var _loc10_:int = 0;
         var _loc11_:RegExp = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:FlowTextOperation = null;
         var _loc2_:FlowOperation = param1.operation;
         if(_loc2_ is SplitParagraphOperation && !this._multiline)
         {
            param1.preventDefault();
            dispatchEvent(new Event("Enter"));
            return;
         }
         if(_loc2_ is SplitParagraphOperation)
         {
            _loc3_ = (_loc2_ as SplitParagraphOperation).originalSelectionState;
            _loc4_ = _loc3_ == null?0:int(_loc3_.absoluteEnd - _loc3_.absoluteStart);
            if(this.maxChars != 0)
            {
               _loc5_ = this._containerManager.textLength - _loc4_;
               _loc6_ = 1;
               if(_loc5_ + _loc6_ > this.maxChars)
               {
                  param1.preventDefault();
                  return;
               }
            }
         }
         if(_loc2_ is InsertTextOperation)
         {
            _loc7_ = InsertTextOperation(_loc2_);
            _loc8_ = _loc7_.text;
            if(this._displayAsPassword)
            {
               _loc11_ = /\t/g;
               _loc8_ = _loc8_.replace(_loc11_,"");
            }
            if(this._restrict != null)
            {
               _loc8_ = restrictChar(_loc8_,this.restrict);
            }
            _loc9_ = _loc7_.deleteSelectionState;
            _loc10_ = _loc9_ == null?0:int(_loc9_.absoluteEnd - _loc9_.absoluteStart);
            if(this.maxChars != 0)
            {
               _loc12_ = this._containerManager.textLength - _loc10_;
               _loc13_ = _loc8_.length;
               if(_loc12_ + _loc13_ > this.maxChars)
               {
                  _loc8_ = _loc8_.substr(0,this.maxChars - _loc12_);
               }
            }
            if(this._displayAsPassword)
            {
               if(_loc10_ > 0)
               {
                  this._text = splice(this._text,_loc9_.absoluteStart,_loc9_.absoluteEnd,"");
               }
               this._text = splice(this._text,_loc7_.absoluteStart,_loc7_.absoluteEnd,_loc8_);
               _loc8_ = repeat(this._passwordCharacter,_loc8_);
            }
            _loc7_.text = _loc8_;
         }
         else if(!(_loc2_ is PasteOperation))
         {
            if(_loc2_ is DeleteTextOperation || _loc2_ is CutOperation)
            {
               _loc14_ = FlowTextOperation(_loc2_);
               if(_loc14_.absoluteStart == _loc14_.absoluteEnd)
               {
                  param1.preventDefault();
                  return;
               }
               if(this._displayAsPassword)
               {
                  this._text = splice(this._text,_loc14_.absoluteStart,_loc14_.absoluteEnd,"");
               }
            }
         }
      }
      
      public function get controller() : ContainerController
      {
         return ContainerController(this._containerManager.controller);
      }
      
      function get pixelMinScrollV() : int
      {
         return 0;
      }
      
      function set contentWidth(param1:Number) : void
      {
         this._contentWidth = param1;
      }
      
      public function get paddingBottom() : Object
      {
         return this._containerManager.paddingBottom;
      }
      
      public function getLineOffset(param1:int) : int
      {
         if(param1 < 0 || param1 >= this.numLines)
         {
            throw new RangeError("The line number specified is out of range.");
         }
         var _loc2_:TextFlowLine = this.getValidTextFlowLine(param1);
         return _loc2_.absoluteStart;
      }
      
      function addTextFlowEventListeners() : void
      {
         this._containerManager.addListeners();
      }
      
      public function set backgroundColor(param1:uint) : void
      {
         if(this._backgroundColor == param1)
         {
            return;
         }
         if(param1 > 16777215)
         {
            param1 = 16777215;
         }
         this._backgroundColor = param1;
         this.invalidate(INVALID_BORDER);
      }
      
      public function set maxChars(param1:int) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         var _loc2_:TLFTextField = this.firstField;
         if(!_loc2_)
         {
            _loc2_ = this;
         }
         _loc2_._maxChars = param1;
      }
      
      function set isPointText(param1:Boolean) : void
      {
         if(this._isPointText == param1)
         {
            return;
         }
         this._isPointText = param1;
         this._autoSize = !!param1?TextFieldAutoSize.LEFT:TextFieldAutoSize.NONE;
         this.invalidate(INVALID_AUTO_SIZE);
      }
      
      public function set backgroundAlpha(param1:Number) : void
      {
         if(this._backgroundAlpha == param1)
         {
            return;
         }
         this._backgroundAlpha = param1;
         if(this._backgroundAlpha < 0)
         {
            this._backgroundAlpha = 0;
         }
         else if(this._backgroundAlpha > 1)
         {
            this._backgroundAlpha = 1;
         }
         this.invalidate(INVALID_BORDER);
      }
      
      private function doTypeSet(param1:TLFTextField) : void
      {
         var _loc4_:SelectionFormat = null;
         var _loc2_:ISelectionManager = !!param1.TCMUsesTextStringAndFormat?null:param1.textFlow.interactionManager;
         if(_loc2_ != null)
         {
            this._priorSelectionBeginIndex = _loc2_.absoluteStart;
            this._priorSelectionEndIndex = _loc2_.absoluteEnd;
         }
         var _loc3_:String = EditingMode.READ_ONLY;
         if(this.type == TextFieldType.INPUT)
         {
            _loc3_ = EditingMode.READ_WRITE;
         }
         else if(this.selectable)
         {
            _loc3_ = EditingMode.READ_SELECT;
         }
         param1._containerManager.editModeNoInteraction = _loc3_;
         _loc2_ = !!param1.TCMUsesTextStringAndFormat?null:param1.textFlow.interactionManager;
         if(_loc2_ != null)
         {
            this.setSelection(this._priorSelectionBeginIndex,this._priorSelectionEndIndex);
            if(_loc2_.focusedSelectionFormat != focusedSelectionFormat)
            {
               _loc2_.focusedSelectionFormat = focusedSelectionFormat;
            }
            if(_loc2_.inactiveSelectionFormat != inactiveSelectionFormat)
            {
               _loc2_.inactiveSelectionFormat = inactiveSelectionFormat;
            }
            _loc4_ = !!this.alwaysShowSelection?alwaysShowSelectionOnFormat:alwaysShowSelectionOffFormat;
            if(_loc2_.unfocusedSelectionFormat != _loc4_)
            {
               _loc2_.unfocusedSelectionFormat = _loc4_;
            }
         }
      }
      
      function get TCMUsesTextStringAndFormat() : Boolean
      {
         return this._containerManager.isTextStringAndFormat();
      }
      
      function get hostFormat() : ITextLayoutFormat
      {
         return this._containerManager.hostFormat;
      }
      
      public function get columnGap() : Object
      {
         return this._containerManager.columnGap;
      }
      
      public function get pixelScrollV() : int
      {
         var _loc1_:String = !!this.TCMUsesTextStringAndFormat?this.hostFormat.blockProgression:this.textFlow.computedFormat.blockProgression;
         return _loc1_ == BlockProgression.RL?int(Math.abs(this._containerManager.horizontalScrollPosition)):int(Math.abs(this._containerManager.verticalScrollPosition));
      }
      
      public function getParagraphLength(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:TextFlowLine = null;
         if(param1 > this._containerManager.textLength || param1 < 0)
         {
            throw new RangeError("The character index specified is out of range.");
         }
         _loc2_ = -1;
         _loc3_ = this.getValidTextFlowLineFromCharIndex(param1);
         if(_loc3_)
         {
            _loc2_ = _loc3_.paragraph.textLength;
         }
         return _loc2_;
      }
      
      override public function get width() : Number
      {
         this.repaint();
         return super.width;
      }
      
      function get nextField() : TLFTextField
      {
         var _loc1_:int = 0;
         var _loc2_:TLFContainerController = null;
         if(this.textFlow && this.textFlow.flowComposer)
         {
            _loc1_ = this.textFlow.flowComposer.getControllerIndex(this.controller);
            if(_loc1_ + 1 < this.textFlow.flowComposer.numControllers)
            {
               _loc2_ = this.textFlow.flowComposer.getControllerAt(_loc1_ + 1) as TLFContainerController;
               if(_loc2_)
               {
                  return _loc2_.ownerField;
               }
            }
         }
         return null;
      }
      
      function set inlineInfo(param1:*) : void
      {
         this._inlineInfo = param1;
      }
      
      function set paddingLock(param1:Boolean) : void
      {
         this._paddingLock = param1;
         if(this._paddingLock)
         {
            this._containerManager.paddingTop = this.paddingLeft;
            this._containerManager.paddingRight = this.paddingLeft;
            this._containerManager.paddingBottom = this.paddingLeft;
            this.invalidate(INVALID_TEXT);
         }
      }
      
      public function getCharIndexAtPoint(param1:Number, param2:Number) : int
      {
         var _loc4_:Point = null;
         var _loc5_:int = 0;
         var _loc6_:Rectangle = null;
         var _loc3_:TextFlow = this._containerManager.textFlow;
         if(_loc3_)
         {
            _loc4_ = globalToLocal(new Point(param1,param2));
            _loc5_ = SelectionManager.computeSelectionIndex(_loc3_,this,null,_loc4_.x,_loc4_.y);
            _loc6_ = this.getCharBoundaries(_loc5_);
            return !!_loc6_.containsPoint(_loc4_)?int(_loc5_):_loc5_ > 0?int(_loc5_ - 1):int(_loc5_);
         }
         return -1;
      }
      
      public function get paddingLeft() : Object
      {
         return this._containerManager.paddingLeft;
      }
      
      function linkClick(param1:FlowElementMouseEvent) : void
      {
         var _loc2_:String = LinkElement(param1.flowElement).href;
         var _loc3_:int = _loc2_.search("event:");
         if(_loc3_ >= 0)
         {
            _loc2_ = _loc2_.substring(_loc3_ + 6,_loc2_.length - _loc3_ + 5);
            dispatchEvent(new TextEvent(TextEvent.LINK,false,false,_loc2_));
         }
      }
      
      public function set blockProgression(param1:Object) : void
      {
         this._containerManager.blockProgression = param1;
         this.invalidate(INVALID_TEXT);
      }
      
      public function get blockProgression() : Object
      {
         return this._containerManager.blockProgression;
      }
      
      public function getLineLength(param1:int) : int
      {
         if(param1 < 0 || param1 >= this.numLines)
         {
            throw new RangeError("The line number specified is out of range.");
         }
         var _loc2_:TextFlowLine = this.getValidTextFlowLine(param1);
         if(_loc2_)
         {
            return _loc2_.textLength - 1;
         }
         return 0;
      }
      
      public function set borderWidth(param1:Number) : void
      {
         if(this._borderWidth == param1)
         {
            return;
         }
         this._borderWidth = param1;
         if(this._borderWidth < 1)
         {
            this._borderWidth = 1;
         }
         else if(this._borderWidth > 100)
         {
            this._borderWidth = 100;
         }
         this.invalidate(INVALID_BORDER);
      }
      
      public function set textFlow(param1:TextFlow) : void
      {
         var _loc2_:TextFlow = this._containerManager.textFlow;
         if(param1 == _loc2_)
         {
            return;
         }
         this.invalidate(INVALID_ALL);
         if(_loc2_ != null)
         {
            this.removeTextFlowEventListeners();
         }
         this._containerManager.textFlow = param1;
         if(this._containerManager.textFlow != null)
         {
            this._wordWrap = param1.computedFormat.lineBreak == LineBreak.TO_FIT;
            this.addTextFlowEventListeners();
         }
      }
      
      public function get textFlow() : TextFlow
      {
         if(!this._containerManager.textFlow)
         {
            this.text = "";
            this._containerManager.textFlow.lineBreak = !!this._wordWrap?LineBreak.TO_FIT:LineBreak.EXPLICIT;
         }
         return this._containerManager.textFlow;
      }
      
      private function getValidTextFlowLine(param1:int) : TextFlowLine
      {
         var _loc2_:TextFlowLine = null;
         if(param1 >= 0 && param1 < this.numLines)
         {
            _loc2_ = this.textFlow.flowComposer.getLineAt(param1);
            return _loc2_;
         }
         throw new RangeError("The line number specified is out of range.");
      }
   }
}
