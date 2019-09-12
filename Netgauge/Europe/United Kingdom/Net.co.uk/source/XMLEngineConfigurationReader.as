package
{
   public class XMLEngineConfigurationReader implements EngineConfigurationReader
   {
       
      
      protected var data:XML = null;
      
      protected var controller:SpeedTestController;
      
      public function XMLEngineConfigurationReader(param1:CustomSpeedTestController)
      {
         super();
         this.controller = param1;
      }
      
      public static function getArray(param1:XMLList) : Object
      {
         var _loc2_:* = new Object();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length())
         {
            _loc2_[param1[_loc3_].name().toString()] = param1[_loc3_].toString();
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function parse(param1:String) : *
      {
         var file:String = param1;
         try
         {
            this.data = new XML(file);
            return;
         }
         catch(error:Error)
         {
            Logger.error("Configuration - XML Parse Error");
            data = new XML();
            throw error;
         }
      }
      
      public function getRaw() : *
      {
         return this.data;
      }
      
      public function getSetting(param1:String, param2:String) : String
      {
         var _loc3_:* = this.data[param1].attribute(param2);
         if(_loc3_.length() == 0)
         {
            return null;
         }
         return _loc3_.toString();
      }
      
      public function getSettingValue(param1:String) : String
      {
         return this.data[param1].toString();
      }
      
      public function getSettingArray(param1:String) : Object
      {
         var a:* = undefined;
         var name:String = param1;
         var r:* = new Object();
         if(name.indexOf(".") >= 0)
         {
            a = this.getSettingObjectAtPath(name);
         }
         else
         {
            a = this.data[name];
         }
         try
         {
            r = getArray(a.attributes());
         }
         catch(error:Error)
         {
            r = new Object();
         }
         return r;
      }
      
      protected function getSettingObjectAtPath(param1:String) : *
      {
         var _loc2_:* = this.data;
         var _loc3_:* = param1.split(".");
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_ = _loc2_[_loc3_[_loc4_]];
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function getSettingArrays(param1:String) : *
      {
         var _loc2_:* = this.getSettingObjectAtPath(param1);
         var _loc3_:* = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length())
         {
            _loc3_.push(getArray(_loc2_[_loc4_].attributes()));
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getServers() : *
      {
         return this.data.servers.server;
      }
      
      public function getTranslation() : *
      {
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc1_:* = this.data.translation;
         var _loc2_:* = [];
         if(_loc1_ == null)
         {
            return _loc2_;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length())
         {
            _loc4_ = this.getSingleTranslation(_loc1_[_loc3_]);
            if(_loc4_ != null)
            {
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      protected function getSingleTranslation(param1:XML) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc2_:* = {"data":[]};
         if(param1.attribute("lang"))
         {
            _loc2_.lang = param1.attribute("lang").toString();
            _loc3_ = param1.text;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = _loc3_[_loc4_];
               if(_loc5_.attribute("id"))
               {
                  _loc2_.data.push({
                     "id":_loc5_.attribute("id").toString(),
                     "value":_loc5_.toString()
                  });
               }
               _loc4_++;
            }
            return _loc2_;
         }
         return null;
      }
   }
}
