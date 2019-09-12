package fl.text
{
   import flash.text.StyleSheet;
   import flash.text.engine.Kerning;
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.IFormatResolver;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   
   class CSSFormatResolver implements IFormatResolver
   {
      
      private static const textFieldToTLFStyleMap:Object = {
         "leading":"lineHeight",
         "letterSpacing":"trackingRight",
         "marginLeft":"paragraphStartIndent",
         "marginRight":"paragraphEndIndent"
      };
      
      private static const tlfToTextFieldStyleMap:Object = {
         "lineHeight":"leading",
         "trackingRight":"letterSpacing",
         "paragraphStartIndent":"marginLeft",
         "paragraphEndIndent":"marginRight"
      };
       
      
      private var _styleSheet:StyleSheet;
      
      function CSSFormatResolver(param1:StyleSheet)
      {
         super();
         this._styleSheet = param1;
      }
      
      public function getResolverForNewFlow(param1:TextFlow, param2:TextFlow) : IFormatResolver
      {
         return this;
      }
      
      public function invalidate(param1:Object) : void
      {
      }
      
      public function resolveFormat(param1:Object) : ITextLayoutFormat
      {
         var attr:TextLayoutFormat = null;
         var attrName:String = null;
         var elem:Object = param1;
         if(elem is FlowElement)
         {
            try
            {
               if(elem.typeName)
               {
                  switch(elem.typeName)
                  {
                     case "TextFlow":
                        attr = this.addStyleAttributes(attr,"body");
                        break;
                     default:
                        attr = this.addStyleAttributes(attr,String(elem.typeName));
                  }
               }
               if(elem.styleName != null)
               {
                  attr = this.addStyleAttributes(attr,"." + elem.styleName);
               }
            }
            catch(e:Error)
            {
               for(attrName in tlfToTextFieldStyleMap)
               {
                  e.message = String(e.message).replace(attrName,tlfToTextFieldStyleMap[attrName]);
               }
               trace("Error (CSS Style Name - " + elem.styleName + "): " + e.message);
               return null;
            }
         }
         return attr;
      }
      
      public function invalidateAll(param1:TextFlow) : void
      {
      }
      
      private function addStyleAttributes(param1:TextLayoutFormat, param2:String) : TextLayoutFormat
      {
         var _loc4_:* = undefined;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc3_:Object = this._styleSheet.getStyle(param2);
         if(_loc3_ != null)
         {
            for(_loc4_ in _loc3_)
            {
               _loc5_ = _loc3_[_loc4_];
               if(param1 == null)
               {
                  param1 = new TextLayoutFormat();
               }
               if(textFieldToTLFStyleMap[_loc4_])
               {
                  _loc6_ = textFieldToTLFStyleMap[_loc4_];
                  param1[_loc6_] = _loc5_;
               }
               else if(_loc4_ == "color" || _loc4_ == "backgroundColor")
               {
                  _loc7_ = String(_loc5_);
                  if(_loc7_ && _loc7_.charAt(0) == "#")
                  {
                     param1[_loc4_] = "0x" + _loc7_.substring(1);
                  }
               }
               else if(_loc4_ != "display")
               {
                  if(_loc4_ == "kerning")
                  {
                     if(String(_loc5_).toLowerCase() == "true")
                     {
                        param1.kerning = Kerning.ON;
                     }
                     else
                     {
                        param1.kerning = Kerning.OFF;
                     }
                  }
                  else if(String(_loc4_).toLowerCase() == "textdecoration")
                  {
                     if(String(_loc5_).toLowerCase() == "line-through")
                     {
                        param1.lineThrough = true;
                     }
                     else
                     {
                        param1[_loc4_] = _loc5_;
                     }
                  }
                  else
                  {
                     param1[_loc4_] = _loc5_;
                  }
               }
            }
         }
         return param1;
      }
      
      public function resolveUserFormat(param1:Object, param2:String) : *
      {
         var attr:TextLayoutFormat = null;
         var attrName:String = null;
         var elem:Object = param1;
         var userStyle:String = param2;
         var flowElem:FlowElement = elem as FlowElement;
         if(flowElem)
         {
            try
            {
               if(flowElem.styleName)
               {
                  attr = this.addStyleAttributes(null,"." + flowElem.styleName);
               }
               else if(flowElem is LinkElement)
               {
                  if(userStyle == "linkNormalFormat")
                  {
                     attr = this.addStyleAttributes(null,"a:link");
                  }
                  else if(userStyle == "linkHoverFormat")
                  {
                     attr = this.addStyleAttributes(null,"a:hover");
                  }
                  else if(userStyle == "linkActiveFormat")
                  {
                     attr = this.addStyleAttributes(null,"a:active");
                  }
               }
               else
               {
                  attr = this.addStyleAttributes(null,userStyle);
               }
            }
            catch(e:Error)
            {
               for(attrName in tlfToTextFieldStyleMap)
               {
                  e.message = String(e.message).replace(attrName,tlfToTextFieldStyleMap[attrName]);
               }
               trace("Error (CSS Style Name - " + elem.styleName + "): " + e.message);
               return null;
            }
         }
         return attr != null?attr:undefined;
      }
      
      public function get styleSheet() : StyleSheet
      {
         return this._styleSheet;
      }
   }
}
