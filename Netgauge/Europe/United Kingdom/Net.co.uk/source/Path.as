package
{
   import flash.geom.Point;
   
   public class Path
   {
       
      
      private var _lengthValid:Boolean = true;
      
      protected var _length:Number = 0;
      
      protected var _moveToHasLength:Boolean = false;
      
      protected var _position:Point;
      
      protected var _segments:Array;
      
      public function Path()
      {
         super();
         this.init();
      }
      
      public function get length() : Number
      {
         var _loc1_:PathSegment = null;
         var _loc2_:int = 0;
         if(!this._lengthValid)
         {
            this._lengthValid = true;
            this._length = 0;
            _loc2_ = this._segments.length;
            while(_loc2_--)
            {
               _loc1_ = this._segments[_loc2_];
               if(this._moveToHasLength || !(_loc1_ is PathMoveSegment))
               {
                  this._length = this._length + _loc1_.length;
               }
            }
         }
         return this._length;
      }
      
      public function get moveToHasLength() : Boolean
      {
         return this._moveToHasLength;
      }
      
      public function set moveToHasLength(param1:Boolean) : void
      {
         this._lengthValid = false;
         this._moveToHasLength = param1;
      }
      
      public function get position() : Point
      {
         return this._position.clone();
      }
      
      public function set position(param1:Point) : void
      {
         this._position = param1.clone();
         this._segments.push(new PathSegment(this._position));
      }
      
      public function moveTo(param1:Number, param2:Number) : void
      {
         var _loc3_:Point = null;
         if(this._moveToHasLength)
         {
            this._lengthValid = false;
         }
         _loc3_ = new Point(param1,param2);
         this._segments.push(new PathMoveSegment(this._position,_loc3_));
         this._position = _loc3_;
      }
      
      public function lineTo(param1:Number, param2:Number) : void
      {
         this._lengthValid = false;
         var _loc3_:Point = new Point(param1,param2);
         this._segments.push(new PathLineSegment(this._position,_loc3_));
         this._position = _loc3_;
      }
      
      public function curveTo(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         this._lengthValid = false;
         var _loc5_:Point = new Point(param3,param4);
         this._segments.push(new PathCurveSegment(this._position,new Point(param1,param2),_loc5_));
         this._position = _loc5_;
      }
      
      public function circleTo(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         this._lengthValid = false;
         var _loc5_:Point = new Point(param3,param4);
         this._segments.push(new PathCircleSegment(this._position,new Point(param1,param2),_loc5_));
         this._position = _loc5_;
      }
      
      public function clear() : void
      {
         this.init();
      }
      
      public function draw(param1:*, param2:Number = 0, param3:Number = 1) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         param2 = this.cleant(param2,0);
         param3 = this.cleant(param3,1);
         if(param3 < param2)
         {
            this.draw(param1,param2,1);
            this.draw(param1,0,param3);
            return;
         }
         _loc4_ = this.getSegmentsToDraw(param2,param3);
         if(_loc4_.length)
         {
            param1.moveTo(_loc4_[0]._start.x,_loc4_[0]._start.y);
            _loc5_ = _loc4_.length;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc4_[_loc6_].draw(param1);
               _loc6_++;
            }
         }
      }
      
      public function pointAt(param1:Number) : Point
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:PathSegment = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         param1 = this.cleant(param1);
         if(param1 == 0)
         {
            return this._segments[0].pointAt(param1);
         }
         if(param1 == 1)
         {
            _loc8_ = this._segments.length - 1;
            return this._segments[_loc8_].pointAt(param1);
         }
         _loc2_ = param1 * this.length;
         _loc3_ = 0;
         _loc4_ = 0;
         _loc6_ = this._segments.length;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc5_ = this._segments[_loc7_];
            if((this._moveToHasLength || _loc5_._command != "moveTo") && _loc5_.length)
            {
               _loc3_ = _loc3_ + _loc5_.length;
               if(_loc2_ <= _loc3_)
               {
                  return _loc5_.pointAt((_loc2_ - _loc4_) / _loc5_.length);
               }
               _loc4_ = _loc3_;
            }
            _loc7_++;
         }
         return new Point(0,0);
      }
      
      public function angleAt(param1:Number) : Number
      {
         var _loc5_:PathSegment = null;
         var _loc7_:int = 0;
         param1 = this.cleant(param1);
         var _loc2_:Number = param1 * this.length;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc6_:int = this._segments.length;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc5_ = this._segments[_loc7_];
            if((this._moveToHasLength || _loc5_._command != "moveTo") && _loc5_.length)
            {
               _loc3_ = _loc3_ + _loc5_.length;
               if(_loc2_ <= _loc3_)
               {
                  return _loc5_.angleAt((_loc2_ - _loc4_) / _loc5_.length);
               }
               _loc4_ = _loc3_;
            }
            _loc7_++;
         }
         return 0;
      }
      
      private function init() : void
      {
         this._lengthValid = false;
         this._segments = new Array();
         this._position = new Point(0,0);
      }
      
      private function cleant(param1:Number, param2:Number = 0) : Number
      {
         if(isNaN(param1))
         {
            param1 = param2;
         }
         else if(param1 < 0 || param1 > 1)
         {
            param1 = param1 % 1;
            if(param1 == 0)
            {
               param1 = param2;
            }
            else if(param1 < 0)
            {
               param1 = param1 + 1;
            }
         }
         return param1;
      }
      
      private function getSegmentsToDraw(param1:Number, param2:Number) : Array
      {
         var _loc12_:PathSegment = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         if(param1 == 0 && param2 == 1)
         {
            return this._segments;
         }
         var _loc3_:Number = param1 * this.length;
         var _loc4_:Number = param2 * this.length;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:int = -1;
         var _loc8_:int = -1;
         var _loc9_:Number = 0;
         var _loc10_:Number = 1;
         var _loc11_:Array = new Array();
         var _loc13_:int = this._segments.length;
         _loc14_ = 0;
         while(_loc14_ < _loc13_)
         {
            _loc12_ = this._segments[_loc14_];
            if((this._moveToHasLength || _loc12_._command != "moveTo") && _loc12_.length)
            {
               _loc5_ = _loc5_ + _loc12_.length;
               if(_loc3_ < _loc5_ && _loc7_ == -1)
               {
                  _loc7_ = _loc14_;
                  _loc9_ = param1 == 0?Number(0):Number((_loc3_ - _loc6_) / _loc12_.length);
               }
               if(_loc4_ <= _loc5_)
               {
                  _loc8_ = _loc14_;
                  _loc10_ = param2 == 1?Number(1):Number((_loc4_ - _loc6_) / _loc12_.length);
                  break;
               }
               _loc6_ = _loc5_;
            }
            _loc14_++;
         }
         if(param2 == 1)
         {
            _loc8_ = _loc13_ - 1;
         }
         if(_loc7_ < 0 || _loc8_ < 0)
         {
            return _loc11_;
         }
         _loc11_ = this._segments.slice(_loc7_,_loc8_ + 1);
         if(_loc7_ == _loc8_)
         {
            if(_loc9_ != 0 || _loc10_ != 1)
            {
               _loc11_[0] = _loc11_[0].segment(_loc9_,_loc10_);
            }
         }
         else
         {
            if(_loc9_ != 0)
            {
               _loc11_[0] = _loc11_[0].segment(_loc9_,1);
            }
            if(_loc10_ != 1)
            {
               _loc15_ = _loc11_.length - 1;
               _loc11_[_loc15_] = _loc11_[_loc15_].segment(0,_loc10_);
            }
         }
         return _loc11_;
      }
   }
}

import flash.geom.Point;

class PathSegment
{
   
   private static var curveAccuracy:int = 5;
    
   
   private var _command:String = "moveTo";
   
   private var _start:Point;
   
   private var _end:Point;
   
   private var _constructor:Class;
   
   protected var _length:Number;
   
   function PathSegment(param1:Point)
   {
      super();
      this._start = param1.clone();
      this._end = this._start;
      this._constructor = prototype.constructor;
   }
   
   private function get command() : String
   {
      return this._command;
   }
   
   private function get start() : Point
   {
      return this._start.clone();
   }
   
   private function get end() : Point
   {
      return this._end.clone();
   }
   
   private function get length() : Number
   {
      return 0;
   }
   
   private function toString() : String
   {
      return "[" + this.command + "]";
   }
   
   private function draw(param1:*) : void
   {
      param1[this.command](this._end.x,this._end.y);
   }
   
   private function trim(param1:Number, param2:Boolean = false) : PathSegment
   {
      return this;
   }
   
   private function pointAt(param1:Number, param2:Point = null, param3:Point = null) : Point
   {
      return this._start.clone();
   }
   
   private function angleAt(param1:Number, param2:Point = null, param3:Point = null) : Number
   {
      return 0;
   }
}

import flash.geom.Point;

class PathLineSegment extends PathSegment
{
    
   
   function PathLineSegment(param1:Point, param2:Point)
   {
      super(param1);
      _end = param2.clone();
      _command = "lineTo";
      _constructor = prototype.constructor;
   }
   
   override private function get length() : Number
   {
      if(isNaN(_length))
      {
         _length = this.lineLength();
      }
      return _length;
   }
   
   private function segment(param1:Number, param2:Number) : PathSegment
   {
      if(param2 == 1)
      {
         if(param1 == 0)
         {
            return this;
         }
         return this.trim(param1,true);
      }
      var _loc3_:PathSegment = this.trim(param2);
      if(param1 != 0)
      {
         _loc3_ = _loc3_.trim(param1 / param2,true);
      }
      return _loc3_;
   }
   
   override private function trim(param1:Number, param2:Boolean = false) : PathSegment
   {
      var _loc3_:Point = null;
      var _loc4_:Point = null;
      var _loc5_:Point = null;
      var _loc6_:Point = null;
      var _loc7_:Number = NaN;
      var _loc8_:Number = NaN;
      if(param2)
      {
         _loc4_ = _start;
         _loc3_ = _end;
         param1 = 1 - param1;
      }
      else
      {
         _loc3_ = _start;
         _loc4_ = _end;
      }
      _loc5_ = _loc3_;
      _loc6_ = _loc3_;
      _loc7_ = _loc4_.x - _loc3_.x;
      _loc8_ = _loc4_.y - _loc3_.y;
      if(param2)
      {
         _loc5_ = new Point(_loc3_.x + _loc7_ * param1,_loc3_.y + _loc8_ * param1);
      }
      else
      {
         _loc6_ = new Point(_loc3_.x + _loc7_ * param1,_loc3_.y + _loc8_ * param1);
      }
      return new _constructor(_loc5_,_loc6_);
   }
   
   override private function pointAt(param1:Number, param2:Point = null, param3:Point = null) : Point
   {
      var _loc4_:Number = NaN;
      var _loc5_:Number = NaN;
      if(!param2)
      {
         param2 = _start;
      }
      if(!param3)
      {
         param3 = _end;
      }
      _loc4_ = param3.x - param2.x;
      _loc5_ = param3.y - param2.y;
      return new Point(param2.x + _loc4_ * param1,param2.y + _loc5_ * param1);
   }
   
   override private function angleAt(param1:Number, param2:Point = null, param3:Point = null) : Number
   {
      if(!param2)
      {
         param2 = _start;
      }
      if(!param3)
      {
         param3 = _end;
      }
      return Math.atan2(param3.y - param2.y,param3.x - param2.x);
   }
   
   protected function lineLength(param1:Point = null, param2:Point = null) : Number
   {
      var _loc3_:Number = NaN;
      var _loc4_:Number = NaN;
      if(!param1)
      {
         param1 = _start;
      }
      if(!param2)
      {
         param2 = _end;
      }
      _loc3_ = param2.x - param1.x;
      _loc4_ = param2.y - param1.y;
      return Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
   }
}

import flash.geom.Point;

class PathMoveSegment extends PathLineSegment
{
    
   
   function PathMoveSegment(param1:Point, param2:Point)
   {
      super(param1,param2);
      _command = "moveTo";
      _constructor = prototype.constructor;
   }
}

import flash.geom.Point;

class PathCurveSegment extends PathLineSegment
{
    
   
   private var _control:Point;
   
   function PathCurveSegment(param1:Point, param2:Point, param3:Point)
   {
      super(param1,param3);
      this._control = param2.clone();
      _command = "curveTo";
      _constructor = prototype.constructor;
   }
   
   override private function get length() : Number
   {
      if(isNaN(_length))
      {
         _length = this.curveLength();
      }
      return _length;
   }
   
   private function get control() : Point
   {
      return this._control.clone();
   }
   
   override private function draw(param1:*) : void
   {
      param1[command](this._control.x,this._control.y,_end.x,_end.y);
   }
   
   override private function pointAt(param1:Number, param2:Point = null, param3:Point = null) : Point
   {
      var _loc4_:Point = Point.interpolate(this._control,_start,param1);
      var _loc5_:Point = Point.interpolate(_end,this._control,param1);
      return Point.interpolate(_loc5_,_loc4_,param1);
   }
   
   override private function angleAt(param1:Number, param2:Point = null, param3:Point = null) : Number
   {
      param2 = super.pointAt(param1,_start,this._control);
      param3 = super.pointAt(param1,this._control,_end);
      return super.angleAt(param1,param2,param3);
   }
   
   override private function trim(param1:Number, param2:Boolean = false) : PathSegment
   {
      var _loc3_:Point = null;
      var _loc4_:Point = null;
      var _loc5_:Point = null;
      var _loc6_:Point = null;
      var _loc7_:Point = null;
      var _loc8_:Number = NaN;
      var _loc9_:Number = NaN;
      var _loc10_:Number = NaN;
      var _loc11_:Number = NaN;
      var _loc12_:Number = NaN;
      var _loc13_:Number = NaN;
      if(param2)
      {
         _loc4_ = _start;
         _loc3_ = _end;
         param1 = 1 - param1;
      }
      else
      {
         _loc3_ = _start;
         _loc4_ = _end;
      }
      _loc5_ = _loc3_;
      _loc7_ = _loc3_;
      _loc8_ = this._control.x - _loc3_.x;
      _loc9_ = this._control.y - _loc3_.y;
      _loc10_ = _loc4_.x - this._control.x;
      _loc11_ = _loc4_.y - this._control.y;
      _loc6_ = new Point(_loc3_.x + _loc8_ * param1,_loc3_.y + _loc9_ * param1);
      _loc12_ = this._control.x + _loc10_ * param1 - _loc6_.x;
      _loc13_ = this._control.y + _loc11_ * param1 - _loc6_.y;
      if(param2)
      {
         _loc5_ = new Point(_loc6_.x + _loc12_ * param1,_loc6_.y + _loc13_ * param1);
      }
      else
      {
         _loc7_ = new Point(_loc6_.x + _loc12_ * param1,_loc6_.y + _loc13_ * param1);
      }
      return new _constructor(_loc5_,_loc6_,_loc7_);
   }
   
   private function curveLength(param1:Point = null, param2:Point = null, param3:Point = null) : Number
   {
      var _loc4_:Number = NaN;
      var _loc5_:Number = NaN;
      var _loc8_:Number = NaN;
      var _loc9_:Number = NaN;
      var _loc10_:Number = NaN;
      var _loc11_:Number = NaN;
      var _loc12_:Point = null;
      var _loc13_:Point = null;
      var _loc14_:int = 0;
      if(!param1)
      {
         param1 = _start;
      }
      if(!param2)
      {
         param2 = this._control;
      }
      if(!param3)
      {
         param3 = _end;
      }
      _loc4_ = param3.x - param1.x;
      _loc5_ = param3.y - param1.y;
      var _loc6_:Number = _loc4_ == 0?Number(0):Number((param2.x - param1.x) / _loc4_);
      var _loc7_:Number = _loc5_ == 0?Number(0):Number((param2.y - param1.y) / _loc5_);
      _loc11_ = 0;
      _loc12_ = param1;
      _loc14_ = 1;
      while(_loc14_ < curveAccuracy)
      {
         _loc10_ = _loc14_ / curveAccuracy;
         _loc8_ = 2 * _loc10_ * (1 - _loc10_);
         _loc9_ = _loc10_ * _loc10_;
         _loc13_ = new Point(param1.x + _loc4_ * (_loc8_ * _loc6_ + _loc9_),param1.y + _loc5_ * (_loc8_ * _loc7_ + _loc9_));
         _loc11_ = _loc11_ + lineLength(_loc12_,_loc13_);
         _loc12_ = _loc13_;
         _loc14_++;
      }
      return _loc11_ + lineLength(_loc12_,param3);
   }
}

import flash.geom.Point;

class PathCircleSegment extends PathLineSegment
{
    
   
   private var _control:Point;
   
   private var _center:Point;
   
   private var radius:Number = 0;
   
   private var angleStart:Number = 0;
   
   private var angleEnd:Number = 0;
   
   private var arc:Number = 0;
   
   function PathCircleSegment(param1:Point, param2:Point, param3:Point)
   {
      super(param1,param3);
      this._control = param2.clone();
      _command = "circleTo";
      this._center = this.getCircleCenter(_start,this._control,_end);
      _constructor = prototype.constructor;
      if(this._center)
      {
         this.radius = lineLength(_start,this._center);
         this.angleStart = Math.atan2(_start.y - this._center.y,_start.x - this._center.x);
         this.angleEnd = Math.atan2(_end.y - this._center.y,_end.x - this._center.x);
         if(this.angleEnd < this.angleStart)
         {
            this.angleEnd = this.angleEnd + Math.PI * 2;
         }
         this.arc = this.angleEnd - this.angleStart;
      }
   }
   
   override private function get length() : Number
   {
      if(isNaN(_length))
      {
         _length = this.circleLength();
      }
      return _length;
   }
   
   private function get control() : Point
   {
      return this._control.clone();
   }
   
   override private function draw(param1:*) : void
   {
      var _loc3_:Number = NaN;
      var _loc8_:int = 0;
      if(!this._center)
      {
         return;
      }
      var _loc2_:Number = this.angleStart;
      var _loc4_:int = Math.floor(this.arc / (Math.PI / 4)) + 1;
      var _loc5_:Number = this.arc / (2 * _loc4_);
      var _loc6_:Number = Math.cos(_loc5_);
      var _loc7_:Number = !!_loc6_?Number(this.radius / _loc6_):Number(0);
      _loc8_ = 0;
      while(_loc8_ < _loc4_)
      {
         _loc3_ = _loc2_ + _loc5_;
         _loc2_ = _loc3_ + _loc5_;
         param1.curveTo(this._center.x + Math.cos(_loc3_) * _loc7_,this._center.y + Math.sin(_loc3_) * _loc7_,this._center.x + Math.cos(_loc2_) * this.radius,this._center.y + Math.sin(_loc2_) * this.radius);
         _loc8_++;
      }
   }
   
   override private function pointAt(param1:Number, param2:Point = null, param3:Point = null) : Point
   {
      if(!this._center)
      {
         return _start.clone();
      }
      var _loc4_:Number = this.angleStart + param1 * this.arc;
      return new Point(this._center.x + Math.cos(_loc4_) * this.radius,this._center.y + Math.sin(_loc4_) * this.radius);
   }
   
   override private function angleAt(param1:Number, param2:Point = null, param3:Point = null) : Number
   {
      var _loc4_:Number = (this.angleStart + param1 * this.arc + Math.PI / 2) % (Math.PI * 2);
      if(_loc4_ > Math.PI)
      {
         _loc4_ = _loc4_ - Math.PI * 2;
      }
      else if(_loc4_ < -Math.PI)
      {
         _loc4_ = _loc4_ + Math.PI * 2;
      }
      return _loc4_;
   }
   
   override private function trim(param1:Number, param2:Boolean = false) : PathSegment
   {
      var _loc3_:Point = null;
      var _loc4_:Point = null;
      var _loc5_:Point = null;
      var _loc6_:Point = null;
      var _loc7_:Point = null;
      var _loc8_:Number = NaN;
      if(param2)
      {
         _loc4_ = _start;
         _loc3_ = _end;
      }
      else
      {
         _loc3_ = _start;
         _loc4_ = _end;
      }
      _loc5_ = _loc3_;
      _loc7_ = _loc3_;
      _loc8_ = this.angleStart + param1 * this.arc;
      if(param2)
      {
         _loc5_ = new Point(this._center.x + Math.cos(_loc8_) * this.radius,this._center.y + Math.sin(_loc8_) * this.radius);
         _loc8_ = (this.angleEnd + _loc8_) / 2;
      }
      else
      {
         _loc7_ = new Point(this._center.x + Math.cos(_loc8_) * this.radius,this._center.y + Math.sin(_loc8_) * this.radius);
         _loc8_ = (this.angleStart + _loc8_) / 2;
      }
      _loc6_ = new Point(this._center.x + Math.cos(_loc8_) * this.radius,this._center.y + Math.sin(_loc8_) * this.radius);
      return new _constructor(_loc5_,_loc6_,_loc7_);
   }
   
   private function circleLength() : Number
   {
      return this.radius * this.arc;
   }
   
   private function getCircleCenter(param1:Point, param2:Point, param3:Point) : Point
   {
      var _loc4_:Point = null;
      var _loc5_:Number = NaN;
      var _loc6_:Number = NaN;
      var _loc7_:Number = NaN;
      var _loc8_:Number = NaN;
      var _loc9_:Number = NaN;
      if(param1.x == param2.x || param1.y == param2.y)
      {
         _loc4_ = param1;
         param1 = param3;
         param3 = _loc4_;
      }
      if(param2.x == param3.x)
      {
         _loc4_ = param1;
         param1 = param2;
         param2 = _loc4_;
      }
      if(param1.x == param2.x || param2.x == param3.x)
      {
         return null;
      }
      _loc5_ = (param2.y - param1.y) / (param2.x - param1.x);
      _loc6_ = (param3.y - param2.y) / (param3.x - param2.x);
      if(_loc5_ == _loc6_)
      {
         return null;
      }
      _loc7_ = param1.x + param2.x;
      _loc8_ = param2.x + param3.x;
      _loc9_ = (_loc5_ * _loc6_ * (param1.y - param3.y) + _loc6_ * _loc7_ - _loc5_ * _loc8_) / (2 * (_loc6_ - _loc5_));
      var _loc10_:Number = !!_loc5_?Number((param1.y + param2.y) / 2 - (_loc9_ - _loc7_ / 2) / _loc5_):Number((param2.y + param3.y) / 2 - (_loc9_ - _loc8_ / 2) / _loc6_);
      return new Point(_loc9_,_loc10_);
   }
}
