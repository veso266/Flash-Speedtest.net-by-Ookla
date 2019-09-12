package fl.text
{
   import fl.timeline.TimelineManager;
   import fl.timeline.timelineManager.InstanceInfo;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.text.TextFieldType;
   import flash.utils.getDefinitionByName;
   import flashx.textLayout.conversion.TextConverter;
   import flashx.textLayout.edit.EditingMode;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.GlobalSettings;
   import flashx.textLayout.elements.IConfiguration;
   import flashx.textLayout.elements.InlineGraphicElement;
   import flashx.textLayout.elements.InlineGraphicElementStatus;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.TCYElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.events.StatusChangeEvent;
   import flashx.textLayout.formats.BackgroundColor;
   import flashx.textLayout.formats.Direction;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.LineBreak;
   import flashx.textLayout.formats.TextLayoutFormat;
   
   public class RuntimeManager extends TimelineManager
   {
      
      private static var singleton:RuntimeManager = new RuntimeManager();
      
      private static var globalConfig:Object;
       
      
      public function RuntimeManager()
      {
         super();
         _supportNextPrevAcrossFrames = true;
      }
      
      public static function checkTLFFontsLoaded(param1:Event, param2:String = null, param3:Function = null) : Boolean
      {
         var fontClass:Class = null;
         var e:Event = param1;
         var fontName:String = param2;
         var fn:Function = param3;
         if(fontName == null && e != null)
         {
            try
            {
               if(e.target.hasOwnProperty("__checkFontName_"))
               {
                  fontName = e.target["__checkFontName_"];
               }
            }
            catch(te1:TypeError)
            {
               fontName = null;
            }
         }
         if(fontName == null)
         {
            if(e != null)
            {
               e.target.removeEventListener(Event.FRAME_CONSTRUCTED,checkTLFFontsLoaded,false);
            }
            return false;
         }
         var loaded:Boolean = true;
         try
         {
            fontClass = Class(getDefinitionByName(fontName));
            if(new fontClass()["fontName"] == null)
            {
               loaded = false;
            }
         }
         catch(re:ReferenceError)
         {
            loaded = false;
         }
         catch(te2:TypeError)
         {
            loaded = false;
         }
         if(loaded)
         {
            if(fn != null)
            {
               fn();
            }
            else if(e != null)
            {
               e.target.removeEventListener(Event.FRAME_CONSTRUCTED,checkTLFFontsLoaded,false);
               if(e.target.hasOwnProperty("__registerTLFFonts"))
               {
                  try
                  {
                     e.target["__registerTLFFonts"]();
                  }
                  catch(te3:TypeError)
                  {
                  }
               }
            }
         }
         return loaded;
      }
      
      private static function getGlobalConfig() : Object
      {
         if(globalConfig != null)
         {
            return globalConfig;
         }
         globalConfig = new Configuration(true);
         globalConfig.inlineGraphicResolverFunction = resolveInlines;
         return globalConfig;
      }
      
      public static function getSingleton() : RuntimeManager
      {
         return singleton;
      }
      
      public static function ColorStringToUint(param1:String) : uint
      {
         if(param1.substr(0,1) == "#")
         {
            param1 = "0x" + param1.substr(1);
         }
         return uint(param1);
      }
      
      private static function recomposeOnLoadComplete(param1:Event) : void
      {
         var _loc2_:StatusChangeEvent = param1 as StatusChangeEvent;
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:TextFlow = _loc2_.element.getTextFlow();
         if(_loc3_ && (_loc2_.status == InlineGraphicElementStatus.SIZE_PENDING || _loc2_.status == InlineGraphicElementStatus.READY))
         {
            _loc3_.flowComposer.updateAllControllers();
            _loc3_.removeEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE,recomposeOnLoadComplete);
         }
      }
      
      private static function resolveInlines(param1:Object) : DisplayObject
      {
         var _loc5_:Object = null;
         var _loc6_:* = undefined;
         var _loc7_:TextFlow = null;
         var _loc8_:Class = null;
         var _loc9_:Bitmap = null;
         var _loc2_:InlineGraphicElement = param1 as InlineGraphicElement;
         if(_loc2_ == null)
         {
            return null;
         }
         var _loc3_:Object = _loc2_.userStyles;
         var _loc4_:* = null;
         if(_loc3_ != null)
         {
            _loc5_ = _loc3_["customSource"];
            _loc6_ = _loc3_["extraInfo"];
            _loc7_ = _loc2_.getTextFlow();
            if(_loc6_ != undefined)
            {
               _loc8_ = _loc6_[_loc5_];
               _loc4_ = new _loc8_();
               if(_loc4_ is BitmapData)
               {
                  _loc9_ = new Bitmap(_loc4_);
                  _loc4_ = new DynamicSprite();
                  _loc4_.addChild(_loc9_);
               }
            }
            if(_loc4_)
            {
               _loc4_["ilg"] = _loc2_;
               _loc7_.addEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE,recomposeOnLoadComplete,false,0,true);
            }
         }
         return _loc4_ as DisplayObject;
      }
      
      public function configureInstance(param1:TLFTextField, param2:InstanceInfo) : void
      {
         var _loc6_:TextFlow = null;
         var _loc21_:Object = null;
         var _loc22_:Object = null;
         var _loc23_:InstanceInfo = null;
         var _loc24_:Boolean = false;
         var _loc25_:ITextLayoutFormat = null;
         TLFRuntimeTabManager.InitTabHandler(param1);
         GlobalSettings.fontMapperFunction = RuntimeFontMapper.fontMapper;
         param1.contentWidth = 0;
         param1.contentHeight = 0;
         var _loc3_:XML = param2.data;
         var _loc4_:String = _loc3_.@type;
         var _loc5_:String = _loc3_.@editPolicy;
         if(_loc5_ == "selectable")
         {
            _loc5_ = EditingMode.READ_SELECT;
         }
         if(_loc5_ == null || _loc5_.length == 0)
         {
            _loc5_ = EditingMode.READ_WRITE;
         }
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:InstanceInfo = param2;
         while(_loc9_.prev != null)
         {
            _loc7_++;
            _loc9_ = _loc9_.prev;
         }
         if(param2.prev != null)
         {
            _loc6_ = TextFlow(TLFTextField(_loc9_.content).textFlow);
            TLFTextField(param2.prev.content).addNextField(param1);
         }
         else
         {
            _loc6_ = TextConverter.importToFlow(param2.data,TextConverter.TEXT_LAYOUT_FORMAT,IConfiguration(getGlobalConfig()));
            _loc8_ = true;
         }
         var _loc10_:FlowLeafElement = _loc6_.getFirstLeaf();
         while(_loc10_)
         {
            if(_loc10_ as InlineGraphicElement)
            {
               _loc21_ = _loc10_.userStyles;
               _loc22_ = _loc21_["customSource"];
               _loc23_ = _loc9_;
               _loc24_ = false;
               while(_loc23_ && !_loc24_)
               {
                  if(_loc23_.extraInfo != undefined && _loc23_.extraInfo[_loc22_] != null)
                  {
                     _loc24_ = true;
                     _loc21_["extraInfo"] = _loc23_.extraInfo;
                     _loc10_.userStyles = _loc21_;
                  }
                  _loc23_ = _loc23_.next;
               }
            }
            _loc10_ = _loc10_.getNextLeaf();
         }
         var _loc11_:Boolean = param2.prev || param2.next;
         var _loc12_:* = false;
         var _loc13_:* = false;
         var _loc14_:* = false;
         var _loc15_:ITextLayoutFormat = _loc6_.getFirstLeaf().computedFormat;
         var _loc16_:Boolean = _loc6_.direction == undefined?_loc15_.direction == Direction.RTL:_loc6_.direction != _loc15_.direction;
         var _loc17_:FlowLeafElement = _loc6_.getFirstLeaf();
         var _loc18_:ParagraphElement = _loc6_.getChildAt(0) as ParagraphElement;
         var _loc19_:* = _loc18_.getNextParagraph() != null;
         if(!_loc16_ && !_loc11_ && !_loc19_)
         {
            while(_loc17_)
            {
               _loc25_ = _loc17_.computedFormat;
               _loc16_ = !TextLayoutFormat.isEqual(_loc25_,_loc15_) || _loc25_.backgroundColor != undefined && _loc25_.backgroundColor != BackgroundColor.TRANSPARENT;
               _loc12_ = _loc17_.getParentByType(TCYElement) as TCYElement != null;
               _loc13_ = _loc17_.getParentByType(LinkElement) as LinkElement != null;
               _loc14_ = _loc17_.getParentByType(InlineGraphicElement) as InlineGraphicElement != null;
               if(_loc16_ || _loc12_ || _loc13_ || _loc14_)
               {
                  break;
               }
               _loc17_ = _loc17_.getNextLeaf();
            }
         }
         if(_loc11_ || _loc16_ || _loc19_ || _loc12_ || _loc13_ || _loc14_)
         {
            param1.textFlow = _loc6_;
         }
         else
         {
            param1.text = _loc6_.getText(0,-1,"\n");
            param1.hostFormat = _loc6_.getFirstLeaf().computedFormat;
            param1.wordWrap = _loc6_.computedFormat.lineBreak == LineBreak.TO_FIT?true:false;
         }
         if(_loc8_)
         {
            param1.type = TextFieldType.DYNAMIC;
            param1.selectable = false;
            switch(_loc5_)
            {
               case EditingMode.READ_WRITE:
                  param1.type = TextFieldType.INPUT;
                  param1.selectable = true;
                  break;
               case EditingMode.READ_SELECT:
                  param1.type = TextFieldType.DYNAMIC;
                  param1.selectable = true;
            }
         }
         if(_loc4_ == "Paragraph")
         {
            param1.isPointText = false;
            param1.width = param2.bounds.width;
            param1.height = param2.bounds.height;
            param1.setCompositionSize(param2.bounds.width,param2.bounds.height);
         }
         else
         {
            param1.isPointText = true;
            param1.setCompositionSize(NaN,NaN);
         }
         param1.direction = _loc6_.direction;
         var _loc20_:String = _loc3_.@columnCount;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.columnCount = _loc20_;
         }
         _loc20_ = _loc3_.@columnGap;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.columnGap = Number(_loc20_);
         }
         _loc20_ = _loc3_.@verticalAlign;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.verticalAlign = _loc20_;
         }
         _loc20_ = _loc3_.@background;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.background = _loc20_.toLowerCase() == "true";
         }
         _loc20_ = _loc3_.@backgroundColor;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.backgroundColor = ColorStringToUint(_loc20_);
         }
         _loc20_ = _loc3_.@backgroundAlpha;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.backgroundAlpha = Number(_loc20_);
         }
         _loc20_ = _loc3_.@border;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.border = _loc20_.toLowerCase() == "true";
         }
         _loc20_ = _loc3_.@borderColor;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.borderColor = ColorStringToUint(_loc20_);
         }
         _loc20_ = _loc3_.@borderAlpha;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.borderAlpha = Number(_loc20_);
         }
         _loc20_ = _loc3_.@borderWidth;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.borderWidth = Number(_loc20_);
         }
         _loc20_ = _loc3_.@paddingLock;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.paddingLock = _loc20_.toLowerCase() == "true";
         }
         _loc20_ = _loc3_.@paddingLeft;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.paddingLeft = Number(_loc20_);
         }
         _loc20_ = _loc3_.@paddingTop;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.paddingTop = Number(_loc20_);
         }
         _loc20_ = _loc3_.@paddingRight;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.paddingRight = Number(_loc20_);
         }
         _loc20_ = _loc3_.@paddingBottom;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.paddingBottom = Number(_loc20_);
         }
         _loc20_ = _loc3_.@firstBaselineOffset;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.firstBaselineOffset = _loc20_;
         }
         _loc20_ = _loc3_.@multiline;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.multiline = _loc20_.toLowerCase() == "true";
         }
         _loc20_ = _loc3_.@antiAliasType;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.antiAliasType = _loc20_;
         }
         _loc20_ = _loc3_.@embedFonts;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.embedFonts = _loc20_.toLowerCase() == "true";
         }
         _loc20_ = _loc3_.@maxChars;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.maxChars = int(_loc20_);
         }
         _loc20_ = _loc3_.@displayAsPassword;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.displayAsPassword = _loc20_.toLowerCase() == "true";
         }
         _loc20_ = _loc3_.@text;
         if(_loc20_ != null && _loc20_.length > 0)
         {
            param1.text = _loc20_;
         }
         param1.alwaysShowSelection = false;
         param1.repaint();
      }
      
      override protected function getInstanceForInfo(param1:InstanceInfo, param2:DisplayObject = null) : DisplayObject
      {
         var ii:InstanceInfo = param1;
         var instance:DisplayObject = param2;
         try
         {
            if(getDefinitionByName("flashx.textLayout.elements.TextFlow") == null || getDefinitionByName("fl.text.container.TLFContainerController") == null)
            {
               return null;
            }
         }
         catch(re:ReferenceError)
         {
            return null;
         }
         var drawSprite:TLFTextField = instance == null?new TLFTextField():TLFTextField(instance);
         this.configureInstance(drawSprite,ii);
         return drawSprite;
      }
   }
}
