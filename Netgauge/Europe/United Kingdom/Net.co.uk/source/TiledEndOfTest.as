package
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class TiledEndOfTest extends MovieClip
   {
      
      public static var tileWidth:Number = 112;
      
      public static var tileHeight:Number = 120;
      
      public static var xOffset:Number = 0;
      
      public static var yOffset:Number = 0;
      
      public static var hGap:Number = 10;
      
      public static var vGap:Number = 10;
      
      public static var tileColumns = 5;
      
      public static var tileRows = 2;
       
      
      public function TiledEndOfTest()
      {
         super();
      }
      
      public static function setColumn(param1:Number) : *
      {
         tileColumns = param1;
      }
      
      static function addEndOfTest(param1:Object, param2:String = "", param3:String = "") : *
      {
         var _loc4_:Point = DocumentClass.document.getSize();
         var _loc5_:* = new TiledEndOfTest();
         var _loc6_:Point = getEndOfTestSize();
         var _loc7_:* = (_loc4_.x - _loc6_.x) / 2;
         var _loc8_:* = (_loc4_.y - _loc6_.y) / 2;
         _loc5_.x = _loc7_ + xOffset;
         _loc5_.y = _loc8_ + yOffset;
         _loc5_.name = "endoftest";
         _loc5_.addTiles(param1,param2,param3);
         var _loc9_:* = DocumentClass.document.getChildByName("slice");
         if(_loc9_ != null)
         {
            DocumentClass.document.addChildAt(_loc5_,DocumentClass.document.getChildIndex(_loc9_));
         }
         else
         {
            DocumentClass.document.addChild(_loc5_);
         }
      }
      
      static function getStartPoint() : Point
      {
         var _loc1_:Point = DocumentClass.document.getSize();
         var _loc2_:Point = getEndOfTestSize();
         var _loc3_:* = (_loc1_.x - _loc2_.x) / 2;
         var _loc4_:* = (_loc1_.y - _loc2_.y) / 2;
         var _loc5_:* = new Point();
         _loc5_.x = _loc3_ + xOffset;
         _loc5_.y = _loc4_ + yOffset;
         return _loc5_;
      }
      
      static function getEndPoint() : Point
      {
         var _loc1_:Point = getStartPoint();
         var _loc2_:Point = getEndOfTestSize();
         var _loc3_:* = new Point();
         _loc3_.x = _loc1_.x + _loc2_.x;
         _loc3_.y = _loc1_.y + _loc2_.y;
         return _loc3_;
      }
      
      static function removeEndOfTest() : *
      {
         if(NetGaugeUI.ng.getChild("endoftest") != null)
         {
            Tools.fadeOutAndDelete(NetGaugeUI.ng.getChild("endoftest"));
         }
      }
      
      static function getTile(param1:Number, param2:Number, param3:String, param4:Object) : GenericTile
      {
         var _loc5_:GenericTile = null;
         switch(param1 + "," + param2)
         {
            case "4,2":
               _loc5_ = new Tile4x2(param3,param4);
               break;
            case "2,2":
               _loc5_ = new Tile2x2(param3,param4);
               break;
            case "2,1":
               _loc5_ = new Tile2x1(param3,param4);
               break;
            case "1,2":
               _loc5_ = new Tile1x2(param3,param4);
               break;
            case "1,1":
               _loc5_ = new Tile1x1(param3,param4);
         }
         return _loc5_;
      }
      
      static function isSize(param1:Array, param2:int, param3:int, param4:int, param5:int) : *
      {
         var _loc8_:* = undefined;
         if(param2 + param5 > param1.length)
         {
            return false;
         }
         if(param3 + param4 > param1[param2].length)
         {
            return false;
         }
         var _loc6_:* = param1[param2][param3];
         var _loc7_:* = 0;
         while(_loc7_ < param5)
         {
            _loc8_ = 0;
            while(_loc8_ < param4)
            {
               if(_loc6_ != param1[param2 + _loc7_][param3 + _loc8_])
               {
                  return false;
               }
               _loc8_++;
            }
            _loc7_++;
         }
         return true;
      }
      
      static function clearLayout(param1:Array, param2:int, param3:int, param4:int, param5:int) : *
      {
         var _loc7_:* = undefined;
         var _loc6_:* = 0;
         while(_loc6_ < param5)
         {
            _loc7_ = 0;
            while(_loc7_ < param4)
            {
               param1[param2 + _loc6_][param3 + _loc7_] = " ";
               _loc7_++;
            }
            _loc6_++;
         }
      }
      
      static function getSize(param1:Array, param2:int, param3:int) : *
      {
         if(isSize(param1,param2,param3,4,2))
         {
            return {
               "width":4,
               "height":2
            };
         }
         if(isSize(param1,param2,param3,2,2))
         {
            return {
               "width":2,
               "height":2
            };
         }
         if(isSize(param1,param2,param3,1,2))
         {
            return {
               "width":1,
               "height":2
            };
         }
         if(isSize(param1,param2,param3,2,1))
         {
            return {
               "width":2,
               "height":1
            };
         }
         return {
            "width":1,
            "height":1
         };
      }
      
      public static function getEndOfTestSize() : Point
      {
         var _loc1_:* = tileColumns * (tileWidth + hGap) - hGap;
         var _loc2_:* = tileRows * (tileHeight + vGap) - vGap;
         return new Point(_loc1_,_loc2_);
      }
      
      protected function getTileCoordinates(param1:Number, param2:Number) : Point
      {
         var _loc3_:Point = new Point();
         _loc3_.x = param2 * (tileWidth + hGap);
         _loc3_.y = param1 * (tileHeight + vGap);
         return _loc3_;
      }
      
      protected function parseLayoutSettings(param1:String, param2:String) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         if(param1.length != tileColumns || param2.length != tileColumns)
         {
            param1 = "FPLSS";
            param2 = "FPLSS";
            tileColumns = 5;
         }
         _loc3_[0] = param1.split("");
         _loc3_[1] = param2.split("");
         trace(_loc3_);
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc3_[_loc5_].length)
            {
               _loc7_ = _loc3_[_loc5_][_loc6_];
               _loc8_ = "";
               switch(_loc7_)
               {
                  case "S":
                     _loc8_ = "speed";
                     break;
                  case "F":
                     _loc8_ = "firewall";
                     break;
                  case "P":
                     _loc8_ = "packetloss";
                     break;
                  case "L":
                     _loc8_ = "latency";
                     break;
                  case "J":
                     _loc8_ = "jitter";
                     break;
                  case "I":
                     _loc8_ = "shareimage";
                     break;
                  case " ":
                  default:
                     _loc8_ = "";
               }
               if(_loc8_ != "")
               {
                  _loc9_ = getSize(_loc3_,_loc5_,_loc6_);
                  _loc9_.row = _loc5_;
                  _loc9_.column = _loc6_;
                  _loc9_.cellType = _loc8_;
                  _loc4_.push(_loc9_);
                  clearLayout(_loc3_,_loc5_,_loc6_,_loc9_.width,_loc9_.height);
               }
               _loc6_++;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function addTiles(param1:Object, param2:String = "", param3:String = "") : *
      {
         var _loc6_:* = undefined;
         var _loc7_:GenericTile = null;
         var _loc8_:* = undefined;
         var _loc4_:* = this.parseLayoutSettings(param2,param3);
         var _loc5_:* = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            _loc7_ = getTile(_loc6_.width,_loc6_.height,_loc6_.cellType,param1);
            _loc8_ = this.getTileCoordinates(_loc6_.row,_loc6_.column);
            _loc7_.x = _loc8_.x;
            _loc7_.y = _loc8_.y;
            _loc7_.name = "tile" + _loc6_.row + "_" + _loc6_.column;
            this.addChild(_loc7_);
            _loc5_++;
         }
      }
   }
}
