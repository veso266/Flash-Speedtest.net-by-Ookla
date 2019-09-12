package org.as3commons.ui.layout.framework.core.config
{
   import org.as3commons.ui.layout.CellConfig;
   
   public class CellConfigCollection
   {
       
      
      private var _width:uint;
      
      private var _height:uint;
      
      private var _cellConfigs:Object;
      
      public function CellConfigCollection()
      {
         super();
         this._cellConfigs = new Object();
      }
      
      public function setConfig(param1:CellConfig, param2:int = -1, param3:int = -1) : void
      {
         var _loc4_:uint = param2 + 1;
         var _loc5_:uint = param3 + 1;
         if(_loc4_ >= this._width || _loc5_ >= this._height)
         {
            this.resize(_loc4_ + 1,_loc5_ + 1);
         }
         this._cellConfigs[_loc5_ * this._width + _loc4_] = param1;
      }
      
      public function getConfig(param1:int = -1, param2:int = -1) : CellConfig
      {
         var _loc5_:CellConfig = null;
         var _loc3_:uint = param1 + 1;
         var _loc4_:uint = param2 + 1;
         if(_loc3_ >= this._width)
         {
            _loc3_ = 0;
         }
         if(_loc4_ >= this._height)
         {
            _loc4_ = 0;
         }
         _loc5_ = CellConfigMerge.merge(_loc5_,this._cellConfigs[0]);
         if(_loc3_)
         {
            _loc5_ = CellConfigMerge.merge(_loc5_,this._cellConfigs[_loc3_]);
         }
         if(_loc4_)
         {
            _loc5_ = CellConfigMerge.merge(_loc5_,this._cellConfigs[_loc4_ * this._width]);
         }
         if(_loc3_ && _loc4_)
         {
            _loc5_ = CellConfigMerge.merge(_loc5_,this._cellConfigs[_loc4_ * this._width + _loc3_]);
         }
         return _loc5_;
      }
      
      private function resize(param1:uint, param2:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:* = null;
         param1 = Math.max(param1,this._width);
         param2 = Math.max(param2,this._height);
         var _loc3_:Object = new Object();
         for(_loc7_ in this._cellConfigs)
         {
            _loc6_ = parseInt(_loc7_);
            _loc4_ = _loc6_ % this._width;
            _loc5_ = Math.floor(_loc6_ / this._width);
            _loc3_[_loc5_ * param1 + _loc4_] = this._cellConfigs[_loc6_];
         }
         this._cellConfigs = _loc3_;
         this._width = param1;
         this._height = param2;
      }
   }
}
