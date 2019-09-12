package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public dynamic class GenericTile extends MovieClip
   {
       
      
      protected var tileWidth:Number;
      
      protected var tileHeight:Number;
      
      protected var test:String;
      
      protected var results:Object;
      
      protected var configuration:CustomConfiguration;
      
      public function GenericTile(param1:Number, param2:Number, param3:String, param4:Object)
      {
         super();
         this.tileHeight = param2;
         this.tileWidth = param1;
         this.test = param3;
         this.results = param4;
         addEventListener(Event.ADDED_TO_STAGE,this.doStuff);
      }
      
      protected function doSkipped() : *
      {
         gotoAndStop("skipped");
         Translation.translate(this.skipped,"testskipped");
      }
      
      protected function doError(param1:String, param2:String) : *
      {
         gotoAndStop("skipped");
         Translation.translate(this.skipped,"testskipped");
         var _loc3_:* = ErrorMessages.getErrorMessage(param1);
         var _loc4_:* = ErrorMessages.getErrorTitle(param1);
         if(this.getChildByName("button") != null)
         {
            this.removeChild(this.getChildByName("button"));
         }
      }
      
      protected function doStuff(param1:Event) : *
      {
         trace("do stuff: " + this.test);
         Translation.translate(this.title,"label_" + this.test);
         switch(this.test)
         {
            case "download":
               gotoAndStop("download");
               break;
            case "speed":
               gotoAndStop("speed");
               break;
            case "latency":
               gotoAndStop("latency");
               break;
            case "jitter":
               gotoAndStop("jitter");
               break;
            case "firewall":
               gotoAndStop("firewall");
               break;
            case "packetloss":
               gotoAndStop("packetloss");
               break;
            case "skipped":
               gotoAndStop("skipped");
               break;
            case "shareimage":
               stop();
               break;
            default:
               stop();
         }
      }
   }
}
