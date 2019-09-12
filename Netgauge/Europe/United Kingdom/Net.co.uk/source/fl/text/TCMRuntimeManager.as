package fl.text
{
   import fl.timeline.TimelineManager;
   import fl.timeline.timelineManager.InstanceInfo;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.text.AntiAliasType;
   import flash.text.engine.FontLookup;
   import flash.text.engine.RenderingMode;
   import flash.utils.getDefinitionByName;
   import flashx.textLayout.conversion.TextConverter;
   import flashx.textLayout.edit.EditingMode;
   import flashx.textLayout.edit.SelectionFormat;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.FlowLeafElement;
   import flashx.textLayout.elements.GlobalSettings;
   import flashx.textLayout.elements.IConfiguration;
   import flashx.textLayout.elements.InlineGraphicElement;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.TCYElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.BackgroundColor;
   import flashx.textLayout.formats.Direction;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   
   public class TCMRuntimeManager extends TimelineManager
   {
      
      private static var singleton:TCMRuntimeManager = new TCMRuntimeManager();
      
      private static var globalConfig:Object;
       
      
      public function TCMRuntimeManager()
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
      
      static function getGlobalConfig() : Object
      {
         if(globalConfig != null)
         {
            return globalConfig;
         }
         globalConfig = new Configuration(true);
         globalConfig.inlineGraphicResolverFunction = TCMRuntimeManager.resolveInlines;
         globalConfig.focusedSelectionFormat = new SelectionFormat(12047870,1,"normal",0,1,"normal",500);
         globalConfig.inactiveSelectionFormat = new SelectionFormat(12047870,0,"normal",0,0,"normal",0);
         globalConfig.unfocusedSelectionFormat = new SelectionFormat(12047870,0,"normal",0,0,"normal",0);
         return globalConfig;
      }
      
      public static function getSingleton() : TCMRuntimeManager
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
            }
         }
         return _loc4_ as DisplayObject;
      }
      
      public function configureInstance(param1:TCMText, param2:InstanceInfo) : void
      {
         var textFlow:TextFlow = null;
         var attr:String = null;
         var styles:Object = null;
         var customSource:Object = null;
         var computedFormat:ITextLayoutFormat = null;
         var fmt:TextLayoutFormat = null;
         var drawSprite:TCMText = param1;
         var ii:InstanceInfo = param2;
         TLFRuntimeTabManager.InitTabHandler(drawSprite);
         var xmlTree:XML = ii.data;
         var typeTextStr:String = xmlTree.@type;
         textFlow = TextConverter.importToFlow(ii.data,TextConverter.TEXT_LAYOUT_FORMAT,IConfiguration(getGlobalConfig()));
         GlobalSettings.fontMapperFunction = RuntimeFontMapper.fontMapper;
         var leaf:FlowLeafElement = textFlow.getFirstLeaf();
         var hasILG:Boolean = false;
         while(leaf)
         {
            if(leaf as InlineGraphicElement)
            {
               hasILG = true;
               styles = leaf.userStyles;
               customSource = styles["customSource"];
               if(ii.extraInfo != undefined && ii.extraInfo[customSource] != null)
               {
                  styles["extraInfo"] = ii.extraInfo;
                  leaf.userStyles = styles;
               }
            }
            leaf = leaf.getNextLeaf();
         }
         var hasTCY:Boolean = false;
         var hasAnchor:Boolean = false;
         var firstFormat:ITextLayoutFormat = textFlow.getFirstLeaf().computedFormat;
         var multipleFormats:Boolean = textFlow.direction == undefined?firstFormat.direction == Direction.RTL:textFlow.direction != firstFormat.direction;
         var curLeaf:FlowLeafElement = textFlow.getFirstLeaf();
         var p:ParagraphElement = textFlow.getChildAt(0) as ParagraphElement;
         var multipleParagraphs:Boolean = p.getNextParagraph() != null;
         if(!multipleFormats && !multipleParagraphs)
         {
            while(curLeaf)
            {
               computedFormat = curLeaf.computedFormat;
               multipleFormats = !TextLayoutFormat.isEqual(computedFormat,firstFormat) || computedFormat.backgroundColor != undefined && computedFormat.backgroundColor != BackgroundColor.TRANSPARENT;
               hasTCY = curLeaf.getParentByType(TCYElement) as TCYElement != null;
               hasAnchor = curLeaf.getParentByType(LinkElement) as LinkElement != null;
               if(multipleFormats || hasTCY || hasAnchor || hasILG)
               {
                  break;
               }
               curLeaf = curLeaf.getNextLeaf();
            }
         }
         var usingTextFlow:Boolean = multipleFormats || multipleParagraphs || hasTCY || hasAnchor || hasILG;
         attr = xmlTree.@columnCount;
         if(attr != null && attr.length > 0)
         {
            textFlow.columnCount = !!isNaN(Number(attr))?1:Number(attr);
         }
         attr = xmlTree.@columnGap;
         if(attr != null && attr.length > 0)
         {
            textFlow.columnGap = !!isNaN(Number(attr))?0:Number(attr);
         }
         attr = xmlTree.@verticalAlign;
         if(attr != null && attr.length > 0)
         {
            textFlow.verticalAlign = attr;
         }
         attr = xmlTree.@firstBaselineOffset;
         if(attr != null && attr.length > 0)
         {
            try
            {
               textFlow.firstBaselineOffset = attr;
            }
            catch(e:Error)
            {
               textFlow.firstBaselineOffset = !!isNaN(Number(attr))?"auto":Number(attr);
            }
         }
         attr = xmlTree.@paddingLeft;
         if(attr != null && attr.length > 0)
         {
            textFlow.paddingLeft = !!isNaN(Number(attr))?"auto":Number(attr);
         }
         attr = xmlTree.@paddingTop;
         if(attr != null && attr.length > 0)
         {
            textFlow.paddingTop = !!isNaN(Number(attr))?"auto":Number(attr);
         }
         attr = xmlTree.@paddingRight;
         if(attr != null && attr.length > 0)
         {
            textFlow.paddingRight = !!isNaN(Number(attr))?"auto":Number(attr);
         }
         attr = xmlTree.@paddingBottom;
         if(attr != null && attr.length > 0)
         {
            textFlow.paddingBottom = !!isNaN(Number(attr))?"auto":Number(attr);
         }
         attr = xmlTree.@antiAliasType;
         if(attr != null && attr.length > 0)
         {
            textFlow.renderingMode = attr == AntiAliasType.ADVANCED?RenderingMode.CFF:RenderingMode.NORMAL;
         }
         attr = xmlTree.@embedFonts;
         if(attr != null && attr.length > 0)
         {
            textFlow.fontLookup = attr.toLowerCase() == "true"?FontLookup.EMBEDDED_CFF:FontLookup.DEVICE;
         }
         if(usingTextFlow)
         {
            drawSprite.tcm.setTextFlow(textFlow);
            if(hasILG)
            {
               drawSprite.tcm.beginInteraction();
               drawSprite.tcm.endInteraction();
            }
         }
         else
         {
            drawSprite.tcm.setText(textFlow.getText());
            fmt = TextLayoutFormat(textFlow.getFirstLeaf().computedFormat);
            if(fmt.paddingTop == "auto" && !isNaN(textFlow.paddingTop))
            {
               fmt.paddingTop = textFlow.paddingTop;
            }
            if(fmt.paddingLeft == "auto" && !isNaN(textFlow.paddingLeft))
            {
               fmt.paddingLeft = textFlow.paddingLeft;
            }
            if(fmt.paddingRight == "auto" && !isNaN(textFlow.paddingRight))
            {
               fmt.paddingRight = textFlow.paddingRight;
            }
            if(fmt.paddingBottom == "auto" && !isNaN(textFlow.paddingBottom))
            {
               fmt.paddingBottom = textFlow.paddingBottom;
            }
            fmt.lineBreak = textFlow.lineBreak;
            fmt.verticalAlign = textFlow.verticalAlign;
            fmt.columnCount = textFlow.columnCount;
            fmt.columnGap = textFlow.columnGap;
            fmt.direction = textFlow.direction;
            drawSprite.tcm.hostFormat = fmt;
         }
         var editPolicy:String = xmlTree.@editPolicy;
         if(editPolicy == null || editPolicy.length == 0 || editPolicy == "selectable")
         {
            editPolicy = EditingMode.READ_SELECT;
         }
         drawSprite.tcm.editingMode = editPolicy;
         if(typeTextStr == "Paragraph")
         {
            drawSprite.tcm.compositionHeight = ii.bounds.height;
            drawSprite.tcm.compositionWidth = ii.bounds.width;
         }
         else
         {
            drawSprite.tcm.compositionHeight = drawSprite.tcm.compositionWidth = NaN;
         }
         attr = xmlTree.@background;
         if(attr != null && attr.length > 0)
         {
            drawSprite.background = attr.toLowerCase() == "true";
         }
         attr = xmlTree.@backgroundColor;
         if(attr != null && attr.length > 0)
         {
            drawSprite.backgroundColor = ColorStringToUint(attr);
         }
         attr = xmlTree.@backgroundAlpha;
         if(attr != null && attr.length > 0)
         {
            drawSprite.backgroundAlpha = Number(attr);
         }
         attr = xmlTree.@border;
         if(attr != null && attr.length > 0)
         {
            drawSprite.border = attr.toLowerCase() == "true";
         }
         attr = xmlTree.@borderColor;
         if(attr != null && attr.length > 0)
         {
            drawSprite.borderColor = ColorStringToUint(attr);
         }
         attr = xmlTree.@borderAlpha;
         if(attr != null && attr.length > 0)
         {
            drawSprite.borderAlpha = Number(attr);
         }
         attr = xmlTree.@borderWidth;
         if(attr != null && attr.length > 0)
         {
            drawSprite.borderWidth = Number(attr);
         }
         drawSprite.repaint(null);
      }
      
      override protected function getInstanceForInfo(param1:InstanceInfo, param2:DisplayObject = null) : DisplayObject
      {
         var ii:InstanceInfo = param1;
         var instance:DisplayObject = param2;
         try
         {
            if(getDefinitionByName("flashx.textLayout.container.TextContainerManager") == null || getDefinitionByName("fl.text.TLFTextContainerManager") == null)
            {
               return null;
            }
         }
         catch(re:ReferenceError)
         {
            return null;
         }
         var drawSprite:TCMText = instance == null?new TCMText():TCMText(instance);
         this.configureInstance(drawSprite,ii);
         return drawSprite;
      }
   }
}
