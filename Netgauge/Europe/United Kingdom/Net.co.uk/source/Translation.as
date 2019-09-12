package
{
   import com.adobe.utils.StringUtil;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   
   public class Translation
   {
      
      private static var currentLanguage:String = "en";
      
      private static var languages:Object = new Object();
      
      private static var fields:Dictionary = new Dictionary(true);
      
      private static var objects:Dictionary = new Dictionary(true);
       
      
      public function Translation()
      {
         super();
      }
      
      public static function setCurrentLanguage(param1:String) : *
      {
         currentLanguage = param1;
      }
      
      public static function getCurrentLanguage() : *
      {
         return currentLanguage;
      }
      
      public static function translateObject(param1:MovieClip, param2:String = "") : void
      {
         if(param2 == "")
         {
            param2 = param1.name;
         }
         objects[param1] = param2;
         param1.display = getText(param2);
      }
      
      public static function translate(param1:*, param2:String = "") : void
      {
         var _loc3_:* = undefined;
         if(param2 == "")
         {
            param2 = param1.name;
         }
         fields[param1] = param2;
         _loc3_ = getText(param2);
         if(StringUtil.beginsWith(_loc3_,"[html]"))
         {
            param1.htmlText = _loc3_.substr(6);
         }
         else
         {
            param1.text = _loc3_;
         }
      }
      
      public static function translateHTML(param1:*, param2:String = "") : void
      {
         if(param2 == "")
         {
            param2 = param1.name;
         }
         fields[param1] = param2;
         param1.htmlText = getText(param2);
      }
      
      public static function refreshTranslation() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:* = null;
         trace("refresh translation");
         for(_loc2_ in fields)
         {
            _loc1_ = getText(fields[_loc2_]);
            if(StringUtil.beginsWith(_loc1_,"[html]"))
            {
               _loc2_.htmlText = _loc1_.substr(6);
            }
            else
            {
               _loc2_.text = _loc1_;
            }
         }
         for(_loc3_ in objects)
         {
            _loc3_.display = getText(objects[_loc3_]);
         }
      }
      
      public static function testUnlocked(param1:Configuration) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:String = null;
         var _loc6_:Language = null;
         var _loc7_:* = undefined;
         var _loc8_:Object = null;
         var _loc2_:Array = param1.getTranslation();
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            _loc5_ = "xml";
            if(_loc4_.lang)
            {
               _loc5_ = _loc4_.lang;
            }
            if(languages[_loc5_] == undefined)
            {
               _loc7_ = new LanguageXML(_loc5_);
               Translation.load(_loc7_,false);
            }
            _loc6_ = languages[_loc5_];
            if(_loc4_.data)
            {
               for each(_loc8_ in _loc4_.data)
               {
                  _loc6_.setText(_loc8_.id,_loc8_.value);
               }
            }
            _loc3_++;
         }
         autoSelect();
      }
      
      public static function changeTranslation(param1:String) : *
      {
         if(languages[param1] == undefined)
         {
            return;
         }
         if(currentLanguage != param1)
         {
            setCurrentLanguage(param1);
            refreshTranslation();
         }
      }
      
      public static function load(param1:Language, param2:Boolean = true) : *
      {
         var _loc3_:* = param1.getLanguageString();
         languages[_loc3_] = param1;
         if(param2)
         {
            currentLanguage = _loc3_;
         }
      }
      
      public static function autoSelect() : *
      {
         var _loc1_:* = Configuration.getParameter("lang");
         var _loc2_:* = currentLanguage;
         if(!(_loc1_ == undefined || _loc1_ == null))
         {
            if(languages[_loc1_] != undefined)
            {
               currentLanguage = _loc1_;
            }
         }
         refreshTranslation();
      }
      
      public static function getExactText(param1:String) : String
      {
         var _loc2_:* = undefined;
         if(languages[currentLanguage] != undefined)
         {
            _loc2_ = languages[currentLanguage].getText(param1);
            if(_loc2_ != null)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getText(param1:String) : String
      {
         var _loc2_:* = getExactText(param1);
         if(_loc2_ == null)
         {
            return param1;
         }
         return _loc2_;
      }
   }
}
