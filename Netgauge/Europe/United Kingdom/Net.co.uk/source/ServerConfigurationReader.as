package
{
   import flash.geom.Point;
   
   public interface ServerConfigurationReader
   {
       
      
      function parse(param1:*) : *;
      
      function getServerId(param1:Number) : *;
      
      function getServerName(param1:Number) : *;
      
      function getServerCount() : *;
      
      function getServerPosition(param1:Number) : Point;
      
      function getServer(param1:Number) : Object;
      
      function getServerMethodCount(param1:Number, param2:* = false) : Number;
      
      function getServerMethod(param1:Number, param2:Number) : Object;
   }
}
