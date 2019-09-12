package
{
   import flash.display.DisplayObjectContainer;
   import org.as3commons.ui.layout.HLayout;
   
   class ButtonPlacement
   {
      
      static var smallScale = 0.6;
      
      static var standardScale = 1;
      
      static var forceMultiButton = false;
      
      static var hGap = 15;
      
      static var vGap = 10;
      
      static var offsetX = 0;
      
      static var offsetY = -20;
      
      static var hAlign = "center";
      
      static var vAlign = "middle";
      
      static var maxColumns = -1;
      
      static var restartOffsetX = -10;
      
      static var restartOffsetY = 45;
      
      static var restartHGap = 10;
      
      static var restartVGap = 20;
      
      static var restartHAlign = "right";
      
      static var restartVAlign = "top";
      
      static var restartMaxColumns = 2;
      
      static var progressOffsetX = 0;
      
      static var progressOffsetY = 14;
      
      static var progressHGap = 10;
      
      static var progressVGap = 20;
      
      static var progressHAlign = "center";
      
      static var progressVAlign = "top";
      
      static var progressMaxColumns = 5;
      
      static var parentLayoutWidth = 620;
      
      static var parentLayoutHeight = 420;
       
      
      function ButtonPlacement()
      {
         super();
      }
      
      static function multipleButtons() : *
      {
         var _loc1_:Array = new Array();
         var _loc2_:GenericStartButton = new StartButtonMulti();
         _loc2_.serverId = 0;
         _loc2_.display = Translation.getText("testagain");
         _loc2_.name = "server1";
         _loc2_.scaleX = smallScale;
         _loc2_.scaleY = smallScale;
         _loc1_.push(_loc2_);
         var _loc3_:GenericStartButton = new StartButtonMulti();
         _loc3_.serverId = -1;
         _loc3_.display = Translation.getText("newserver");
         _loc3_.name = "server2";
         _loc3_.scaleX = smallScale;
         _loc3_.scaleY = smallScale;
         _loc1_.push(_loc3_);
         return _loc1_;
      }
      
      static function dropButtons(param1:*, param2:*, param3:*, param4:*) : Array
      {
         var _loc6_:GenericStartButton = null;
         var _loc5_:Array = new Array();
         var _loc7_:* = 1;
         while(_loc7_ <= param2)
         {
            if(param2 == 1 && param1 != "restart" && forceMultiButton == false)
            {
               _loc6_ = new StartButton();
            }
            else
            {
               _loc6_ = new StartButtonMulti();
               _loc6_.alpha = 0;
            }
            _loc6_.name = "server" + _loc7_;
            _loc6_.serverId = _loc7_;
            if(param2 > 1)
            {
               _loc6_.display = param3.getServerName(_loc7_);
            }
            else if(param4.getTestCount() > 0)
            {
               _loc6_.display = Translation.getText("restarttest");
            }
            else
            {
               _loc6_.display = Translation.getText("starttest");
            }
            if(param1 != "normal" || param2 > 6)
            {
               _loc6_.scaleX = smallScale;
               _loc6_.scaleY = smallScale;
            }
            else if(standardScale != 1)
            {
               _loc6_.scaleX = standardScale;
               _loc6_.scaleY = standardScale;
            }
            _loc5_.push(_loc6_);
            _loc7_++;
         }
         return _loc5_;
      }
      
      static function placeItems(param1:Array, param2:String = "normal", param3:DisplayObjectContainer = null) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc14_:HLayout = null;
         var _loc12_:* = parentLayoutWidth;
         var _loc13_:* = parentLayoutHeight;
         switch(param2)
         {
            case "progress":
               _loc4_ = progressHGap;
               _loc5_ = progressVGap;
               _loc6_ = progressOffsetX;
               _loc7_ = progressOffsetY;
               _loc8_ = progressHAlign;
               _loc9_ = progressVAlign;
               _loc10_ = progressMaxColumns;
               _loc11_ = DocumentClass.document.getChildByName("progress");
               _loc13_ = 80;
               break;
            case "restart":
               _loc4_ = restartHGap;
               _loc5_ = restartVGap;
               _loc6_ = restartOffsetX;
               _loc7_ = restartOffsetY;
               _loc8_ = restartHAlign;
               _loc9_ = restartVAlign;
               _loc10_ = restartMaxColumns;
               _loc11_ = DocumentClass.document;
               break;
            case "normal":
            default:
               _loc4_ = hGap;
               _loc5_ = vGap;
               _loc6_ = offsetX;
               _loc7_ = offsetY;
               _loc8_ = hAlign;
               _loc9_ = vAlign;
               _loc10_ = maxColumns;
               _loc11_ = DocumentClass.document;
         }
         if(param3 != null)
         {
            _loc11_ = param3;
         }
         if(_loc10_ == -1)
         {
            if(param1.length > 15)
            {
               _loc10_ = 4;
            }
            else if(param1.length > 6)
            {
               _loc10_ = 3;
            }
            else if(param1.length > 2)
            {
               _loc10_ = 2;
            }
            else
            {
               _loc10_ = 1;
            }
         }
         _loc14_ = new HLayout();
         _loc14_.marginX = 0;
         _loc14_.marginY = 0;
         _loc14_.offsetX = _loc6_;
         _loc14_.offsetY = _loc7_;
         _loc14_.minWidth = _loc12_;
         _loc14_.minHeight = _loc13_;
         _loc14_.maxContentWidth = 0;
         _loc14_.maxItemsPerRow = _loc10_;
         _loc14_.hGap = _loc4_;
         _loc14_.vGap = _loc5_;
         _loc14_.hAlign = _loc8_;
         _loc14_.vAlign = _loc9_;
         _loc14_.add(param1);
         if(param1.length > 1 && param2 == "normal")
         {
         }
         _loc14_.layout(_loc11_);
      }
   }
}
