package org.as3commons.collections
{
   import flash.utils.Dictionary;
   import org.as3commons.collections.framework.IIterator;
   import org.as3commons.collections.framework.IMap;
   import org.as3commons.collections.framework.core.MapIterator;
   import org.as3commons.collections.iterators.ArrayIterator;
   
   public class Map implements IMap
   {
       
      
      protected var _keys:Dictionary;
      
      protected var _items:Dictionary;
      
      protected var _stringMap:Object;
      
      protected var _size:uint = 0;
      
      public function Map()
      {
         super();
         this._items = new Dictionary();
         this._keys = new Dictionary();
         this._stringMap = new Object();
      }
      
      public function add(param1:*, param2:*) : Boolean
      {
         if(param1 is String)
         {
            if(this._stringMap[param1] !== undefined)
            {
               return false;
            }
            this._stringMap[param1] = param2;
         }
         else
         {
            if(this._keys[param1] !== undefined)
            {
               return false;
            }
            this._keys[param1] = param1;
            this._items[param1] = param2;
         }
         this._size++;
         return true;
      }
      
      public function replaceFor(param1:*, param2:*) : Boolean
      {
         if(param1 is String)
         {
            if(this._stringMap[param1] === undefined)
            {
               return false;
            }
            if(this._stringMap[param1] === param2)
            {
               return false;
            }
            this._stringMap[param1] = param2;
         }
         else
         {
            if(this._keys[param1] === undefined)
            {
               return false;
            }
            if(this._items[param1] === param2)
            {
               return false;
            }
            this._items[param1] = param2;
         }
         return true;
      }
      
      public function count(param1:*) : uint
      {
         var _loc3_:* = undefined;
         var _loc2_:uint = 0;
         for each(_loc3_ in this._stringMap)
         {
            if(_loc3_ === param1)
            {
               _loc2_++;
            }
         }
         for each(_loc3_ in this._items)
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
         return param1 is String?this._stringMap[param1] !== undefined:this._keys[param1] !== undefined;
      }
      
      public function itemFor(param1:*) : *
      {
         if(param1 is String)
         {
            return this._stringMap[param1];
         }
         return this._items[param1];
      }
      
      public function keysToArray() : Array
      {
         var _loc2_:* = null;
         var _loc3_:* = undefined;
         var _loc1_:Array = new Array();
         for(_loc2_ in this._stringMap)
         {
            _loc1_.push(_loc2_);
         }
         for each(_loc3_ in this._keys)
         {
            _loc1_.push(_loc3_);
         }
         return _loc1_;
      }
      
      public function keyIterator() : IIterator
      {
         return new ArrayIterator(this.keysToArray());
      }
      
      public function removeKey(param1:*) : *
      {
         var _loc2_:* = undefined;
         if(param1 is String)
         {
            if(this._stringMap[param1] === undefined)
            {
               return undefined;
            }
            _loc2_ = this._stringMap[param1];
            delete this._stringMap[param1];
         }
         else
         {
            if(this._keys[param1] === undefined)
            {
               return undefined;
            }
            _loc2_ = this._items[param1];
            delete this._keys[param1];
            delete this._items[param1];
         }
         this._size--;
         return _loc2_;
      }
      
      public function removeAll(param1:*) : uint
      {
         var _loc3_:* = null;
         var _loc4_:* = undefined;
         var _loc2_:uint = 0;
         for(_loc3_ in this._stringMap)
         {
            if(this._stringMap[_loc3_] === param1)
            {
               delete this._stringMap[_loc3_];
               this._size--;
               this.itemRemoved(_loc3_,param1);
               _loc2_++;
            }
         }
         for(_loc4_ in this._items)
         {
            if(this._items[_loc4_] === param1)
            {
               delete this._keys[_loc4_];
               delete this._items[_loc4_];
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
         for each(_loc2_ in this._stringMap)
         {
            if(_loc2_ === param1)
            {
               return true;
            }
         }
         for each(_loc2_ in this._items)
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
         for each(_loc2_ in this._stringMap)
         {
            _loc1_.push(_loc2_);
         }
         for each(_loc2_ in this._items)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function remove(param1:*) : Boolean
      {
         var _loc2_:* = null;
         var _loc3_:* = undefined;
         for(_loc2_ in this._stringMap)
         {
            if(this._stringMap[_loc2_] === param1)
            {
               delete this._stringMap[_loc2_];
               this._size--;
               this.itemRemoved(_loc2_,param1);
               return true;
            }
         }
         for(_loc3_ in this._items)
         {
            if(this._items[_loc3_] === param1)
            {
               delete this._keys[_loc3_];
               delete this._items[_loc3_];
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
         this._keys = new Dictionary();
         this._items = new Dictionary();
         this._stringMap = new Object();
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
