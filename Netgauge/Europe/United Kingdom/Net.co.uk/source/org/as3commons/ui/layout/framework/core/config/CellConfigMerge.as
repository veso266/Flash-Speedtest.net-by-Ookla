package org.as3commons.ui.layout.framework.core.config
{
   import org.as3commons.ui.layout.CellConfig;
   
   public class CellConfigMerge
   {
       
      
      public function CellConfigMerge()
      {
         super();
      }
      
      public static function merge(param1:CellConfig, param2:CellConfig) : CellConfig
      {
         if(!param2)
         {
            return param1;
         }
         if(!param1)
         {
            param1 = new CellConfig();
         }
         if(param2.propertyExplicitlySet("width"))
         {
            param1.width = param2.width;
         }
         if(param2.propertyExplicitlySet("height"))
         {
            param1.height = param2.height;
         }
         if(param2.propertyExplicitlySet("marginX"))
         {
            param1.marginX = param2.marginX;
         }
         if(param2.propertyExplicitlySet("marginY"))
         {
            param1.marginY = param2.marginY;
         }
         if(param2.propertyExplicitlySet("offsetX"))
         {
            param1.offsetX = param2.offsetX;
         }
         if(param2.propertyExplicitlySet("offsetY"))
         {
            param1.offsetY = param2.offsetY;
         }
         if(param2.propertyExplicitlySet("hAlign"))
         {
            param1.hAlign = param2.hAlign;
         }
         if(param2.propertyExplicitlySet("vAlign"))
         {
            param1.vAlign = param2.vAlign;
         }
         return param1;
      }
   }
}
