package
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   class SpeedGraph
   {
      
      public static var lineThickness = 4;
      
      public static const UPDATE_ALL = 3;
      
      public static const UPDATE_MASK = 2;
      
      public static const UPDATE_LINE = 1;
       
      
      private var _mask:MovieClip;
      
      private var _line:MovieClip;
      
      private var _maskHeight:MovieClip;
      
      private var _lineHeight:MovieClip;
      
      private var _maskContainer:MovieClip;
      
      private var _lineContainer:MovieClip;
      
      private var _graphArray:Array;
      
      private var _graphArray2:Array;
      
      private var _chunks:Number = 50;
      
      private var maxSpeed = 0;
      
      private var speedRatio = 5000;
      
      function SpeedGraph(param1:MovieClip, param2:MovieClip, param3:Number = 50)
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         super();
         if(param1 != null)
         {
            _loc4_ = this.prepareMaskContainer(param1);
            this._mask = _loc4_;
            this._maskContainer = param1;
            this._maskHeight = this.prepareHeight(param1);
         }
         if(param2 != null)
         {
            _loc5_ = this.prepareLineContainer(param2);
            this._line = _loc5_;
            this._lineContainer = param2;
            this._lineHeight = this.prepareHeight(param2);
         }
         this._chunks = param3;
         this._graphArray = new Array();
         this._graphArray2 = new Array();
      }
      
      function fadeMaskTo(param1:Number) : *
      {
         if(NetGaugeUI.ng.template == "classic")
         {
            TweenLite.to((this._maskContainer.parent as MovieClip).fillcolor,1,{"alpha":param1});
         }
         else
         {
            TweenLite.to(this._maskContainer,1,{"alpha":param1});
         }
      }
      
      function prepareHeight(param1:MovieClip) : *
      {
         var _loc2_:* = new MovieClip();
         _loc2_.graphics.lineStyle(0,0,0);
         _loc2_.graphics.moveTo(0,0);
         param1.addChild(_loc2_);
         return _loc2_;
      }
      
      function prepareLineContainer(param1:MovieClip) : *
      {
         var _loc2_:* = new MovieClip();
         _loc2_.graphics.lineStyle(lineThickness,153,1);
         _loc2_.graphics.moveTo(0,0);
         param1.addChild(_loc2_);
         return _loc2_;
      }
      
      function prepareMaskContainer(param1:MovieClip) : *
      {
         var _loc2_:* = new MovieClip();
         _loc2_.graphics.lineStyle();
         _loc2_.graphics.moveTo(0,0);
         param1.addChild(_loc2_);
         return _loc2_;
      }
      
      function updateGraph(param1:*, param2:* = 3) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1.graphResult != undefined)
         {
            _loc3_ = new Object();
            _loc3_.progress = param1.graphResult.progress;
            _loc3_.bytes = param1.graphResult.total;
            _loc3_.time = param1.graphResult.clienttime;
         }
         else
         {
            _loc3_ = param1;
         }
         _loc4_ = 0;
         if(this._graphArray.length > 0)
         {
            _loc4_ = this._graphArray[this._graphArray.length - 1].progress;
         }
         if(this._graphArray.length <= _loc3_.progress * this._chunks && _loc3_.progress != _loc4_)
         {
            this._graphArray.push({
               "time":_loc3_.time,
               "bytesLoaded":_loc3_.bytes,
               "progress":_loc3_.progress
            });
            if(this._mask != null && param2 & UPDATE_MASK)
            {
               this.updateGraphMask(this._graphArray,this._mask,this._maskContainer);
            }
            if(this._line != null && param2 & UPDATE_LINE)
            {
               this.updateGraphLine(this._graphArray,this._line,this._lineContainer);
            }
            this.equalGraphs(this._maskHeight,this._lineHeight);
            this.resetHeight(this._maskContainer,this._lineContainer);
         }
      }
      
      function updateGraph2(param1:*, param2:* = 3) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1.graphResult != undefined)
         {
            _loc3_ = new Object();
            _loc3_.progress = param1.graphResult.progress;
            _loc3_.bytes = param1.graphResult.total;
            _loc3_.time = param1.graphResult.clienttime;
         }
         else
         {
            _loc3_ = param1;
         }
         _loc4_ = 0;
         if(this._graphArray2.length > 0)
         {
            _loc4_ = this._graphArray2[this._graphArray2.length - 1].progress;
         }
         if(this._graphArray2.length <= _loc3_.progress * this._chunks && _loc3_.progress != _loc4_)
         {
            this._graphArray2.push({
               "time":_loc3_.time,
               "bytesLoaded":_loc3_.bytes,
               "progress":_loc3_.progress
            });
            if(this._mask != null && param2 & UPDATE_MASK)
            {
               this.updateGraphMask(this._graphArray2,this._mask,this._maskContainer);
            }
            if(this._line != null && param2 & UPDATE_LINE)
            {
               this.updateGraphLine(this._graphArray2,this._line,this._lineContainer);
            }
            this.equalGraphs(this._maskHeight,this._lineHeight);
            this.resetHeight(this._maskContainer,this._lineContainer);
         }
      }
      
      public function getMaxSpeed() : *
      {
         return this.maxSpeed;
      }
      
      function updateGraphMask(param1:Array, param2:MovieClip, param3:MovieClip) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         if(param1.length >= 2)
         {
            _loc4_ = param1[param1.length - 1];
            _loc5_ = param1[param1.length - 2];
            _loc6_ = 1000 * (_loc4_.bytesLoaded - _loc5_.bytesLoaded) / (_loc4_.time - _loc5_.time);
            this.maxSpeed = Math.max(this.maxSpeed,_loc6_);
            _loc7_ = _loc5_.progress * 200;
            _loc8_ = _loc4_.progress * 200;
            _loc9_ = -_loc6_ / this.speedRatio;
            if(param1.length > 2)
            {
               _loc11_ = param1[param1.length - 3];
               _loc12_ = 1000 * (_loc5_.bytesLoaded - _loc11_.bytesLoaded) / (_loc5_.time - _loc11_.time);
               _loc10_ = -_loc12_ / this.speedRatio;
            }
            else
            {
               _loc10_ = 0;
               _loc7_ = 0;
            }
            param2.graphics.beginFill(16711680);
            param2.graphics.moveTo(_loc7_,0);
            param2.graphics.lineTo(_loc8_,0);
            param2.graphics.lineTo(_loc8_,_loc9_);
            param2.graphics.lineTo(_loc7_,_loc10_);
            param2.graphics.lineTo(_loc7_,0);
            param2.graphics.endFill();
         }
      }
      
      function equalGraphs(param1:MovieClip, param2:MovieClip) : *
      {
         if(param1 != null)
         {
            param1.graphics.lineTo(0,-this.maxSpeed / this.speedRatio);
         }
         if(param2 != null)
         {
            param2.graphics.lineTo(0,-this.maxSpeed / this.speedRatio);
         }
      }
      
      function resetHeight(param1:MovieClip, param2:MovieClip) : *
      {
         if(param1 != null)
         {
            param1.height = 50;
         }
         if(param2 != null)
         {
            param2.height = 50;
         }
      }
      
      function updateGraphLine(param1:Array, param2:MovieClip, param3:MovieClip) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         if(param1.length >= 2)
         {
            _loc4_ = param1[param1.length - 1];
            _loc5_ = param1[param1.length - 2];
            _loc6_ = 1000 * (_loc4_.bytesLoaded - _loc5_.bytesLoaded) / (_loc4_.time - _loc5_.time);
            this.maxSpeed = Math.max(this.maxSpeed,_loc6_);
            _loc7_ = _loc4_.progress * 200;
            if(param1.length > 2)
            {
               _loc8_ = -_loc6_ / this.speedRatio;
            }
            else
            {
               _loc8_ = -_loc6_ / this.speedRatio;
            }
            param2.graphics.lineTo(_loc7_,_loc8_);
         }
      }
      
      function redrawGraph(param1:MovieClip, param2:MovieClip) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(param1 != null)
         {
            _loc5_ = this.prepareMaskContainer(param1);
         }
         if(param2 != null)
         {
            _loc6_ = this.prepareLineContainer(param2);
         }
         _loc3_ = new Array();
         _loc4_ = 0;
         while(_loc4_ < this._graphArray.length)
         {
            _loc3_.push(this._graphArray[_loc4_]);
            if(_loc5_ != null)
            {
               this.updateGraphMask(_loc3_,_loc5_,param1);
            }
            if(_loc6_ != null)
            {
               this.updateGraphLine(_loc3_,_loc6_,param2);
            }
            this.resetHeight(param1,param2);
            _loc4_++;
         }
      }
      
      function redrawGraph2(param1:MovieClip, param2:MovieClip) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(param1 != null)
         {
            _loc5_ = this.prepareMaskContainer(param1);
         }
         if(param2 != null)
         {
            _loc6_ = this.prepareLineContainer(param2);
         }
         _loc3_ = new Array();
         _loc4_ = 0;
         while(_loc4_ < this._graphArray2.length)
         {
            _loc3_.push(this._graphArray2[_loc4_]);
            if(_loc5_ != null)
            {
               this.updateGraphMask(_loc3_,_loc5_,param1);
            }
            if(_loc6_ != null)
            {
               this.updateGraphLine(_loc3_,_loc6_,param2);
            }
            this.resetHeight(param1,param2);
            _loc4_++;
         }
      }
   }
}
