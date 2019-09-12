package
{
   import flash.geom.Point;
   
   public class JSONServerConfigurationReader implements ServerConfigurationReader
   {
       
      
      protected var data:Object = null;
      
      protected var controller:SpeedTestController;
      
      public function JSONServerConfigurationReader(param1:CustomSpeedTestController)
      {
         super();
         this.controller = param1;
      }
      
      public function parse(param1:*) : *
      {
         this.data = param1;
      }
      
      public function getServerId(param1:Number) : *
      {
         var _loc2_:* = this.data[param1 - 1]["@id"];
         if(_loc2_ == undefined)
         {
            return param1;
         }
         return _loc2_;
      }
      
      public function getServerName(param1:Number) : *
      {
         return this.data[param1 - 1]["@name"];
      }
      
      public function getServerCount() : *
      {
         var _loc1_:* = this.data.length;
         trace("COUNT:" + _loc1_);
         if(isNaN(_loc1_) || _loc1_ == undefined)
         {
            return 0;
         }
         return _loc1_;
      }
      
      public function getServerPosition(param1:Number) : Point
      {
         var _loc2_:* = Number(this.data[param1 - 1]["@lon"]);
         var _loc3_:* = Number(this.data[param1 - 1]["@lat"]);
         return new Point(_loc2_,_loc3_);
      }
      
      public function getServer(param1:Number) : Object
      {
         var _loc2_:* = undefined;
         if(this.data[param1 - 1] != undefined)
         {
            _loc2_ = this.data[param1 - 1];
            return JSONEngineConfigurationReader.getArray(_loc2_);
         }
         return {};
      }
      
      public function getServerMethodCount(param1:Number, param2:* = false) : Number
      {
         var _loc3_:* = this.data[param1 - 1].method.length;
         if(isNaN(_loc3_) || _loc3_ == undefined)
         {
            return !!param2?Number(0):Number(1);
         }
         return _loc3_;
      }
      
      public function getServerMethod(param1:Number, param2:Number) : Object
      {
         var _loc4_:* = undefined;
         var _loc3_:* = this.getServerMethodCount(param1,true);
         Logger.info("Method: " + (param2 + 1) + "/" + _loc3_);
         if(this.data[param1 - 1].method[param2] != undefined)
         {
            _loc4_ = this.data[param1 - 1].method[param2];
            return JSONEngineConfigurationReader.getArray(_loc4_);
         }
         return {};
      }
   }
}
