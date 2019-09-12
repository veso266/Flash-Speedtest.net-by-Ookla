package org.as3commons.collections
{
   import org.as3commons.collections.framework.IIterator;
   import org.as3commons.collections.framework.IMap;
   import org.as3commons.collections.framework.core.MapIterator;
   import org.as3commons.collections.iterators.ArrayIterator;
   
   public class StringMap implements IMap
   {
       
      
      protected var _map:Object;
      
      protected var _size:uint = 0;
      
      public function StringMap()
      {
         super();
         this._map = new Object();
      }
      
      public function add(param1:*, param2:*) : Boolean
      {
         if(this._map[param1] !== undefined)
         {
            return false;
         }
         this._map[param1] = param2;
         this._size++;
         return true;
      }
      
      public function replaceFor(param1:*, param2:*) : Boolean
      {
         if(this._map[param1] === undefined)
         {
            return false;
         }
         if(this._map[param1] === param2)
         {
            return false;
         }
         this._map[param1] = param2;
         return true;
      }
      
      public function count(param1:*) : uint
      {
         var _loc3_:* = undefined;
         var _loc2_:uint = 0;
         for each(_loc3_ in this._map)
         {
            if(_loc3_ === param1)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      public function hasKey(param1:*) : Boolean
      {
         return this._map[param1] !== undefined;
      }
      
      public function itemFor(param1:*) : *
      {
         return this._map[param1];
      }
      
      public function keysToArray() : Array
      {
         var _loc2_:* = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in this._map)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function keyIterator() : IIterator
      {
         return new ArrayIterator(this.keysToArray());
      }
      
      public function removeKey(param1:*) : *
      {
         if(this._map[param1] === undefined)
         {
            return undefined;
         }
         var _loc2_:* = this._map[param1];
         delete this._map[param1];
         this._size--;
         return _loc2_;
      }
      
      public function removeAll(param1:*) : uint
      {
         var _loc3_:* = null;
         var _loc2_:uint = 0;
         for(_loc3_ in this._map)
         {
            if(this._map[_loc3_] === param1)
            {
               delete this._map[_loc3_];
               this._size--;
               this.itemRemoved(_loc3_,param1);
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      public function get size() : uint
      {
         return this._size;
      }
      
      public function has(param1:*) : Boolean
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in this._map)
         {
            if(_loc2_ === param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function toArray() : Array
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this._map)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function remove(param1:*) : Boolean
      {
         var _loc2_:* = null;
         for(_loc2_ in this._map)
         {
            if(this._map[_loc2_] === param1)
            {
               delete this._map[_loc2_];
               this._size--;
               this.itemRemoved(_loc2_,param1);
               return true;
            }
         }
         return false;
      }
      
      public function clear() : Boolean
      {
         if(!this._size)
         {
            return false;
         }
         this._map = new Object();
         this._size = 0;
         return true;
      }
      
      public function iterator(param1:* = undefined) : IIterator
      {
         return new MapIterator(this);
      }
      
      protected function itemRemoved(param1:*, param2:*) : void
      {
      }
   }
}
