package org.as3commons.collections
{
   import flash.utils.Dictionary;
   import org.as3commons.collections.framework.IIterator;
   import org.as3commons.collections.framework.IOrderedMap;
   import org.as3commons.collections.framework.core.AbstractLinkedDuplicatesCollection;
   import org.as3commons.collections.framework.core.LinkedMapIterator;
   import org.as3commons.collections.framework.core.LinkedMapNode;
   import org.as3commons.collections.framework.core.LinkedNode;
   
   public class LinkedMap extends AbstractLinkedDuplicatesCollection implements IOrderedMap
   {
       
      
      protected var _keys:Dictionary;
      
      protected var _items:Dictionary;
      
      protected var _stringMap:Object;
      
      public function LinkedMap()
      {
         super();
         this._items = new Dictionary();
         this._keys = new Dictionary();
         this._stringMap = new Object();
      }
      
      public function addFirst(param1:*, param2:*) : Boolean
      {
         var _loc3_:LinkedMapNode = this.add_private(param1,param2);
         if(_loc3_)
         {
            addNodeFirst(_loc3_);
            return true;
         }
         return false;
      }
      
      public function addLast(param1:*, param2:*) : Boolean
      {
         var _loc3_:LinkedMapNode = this.add_private(param1,param2);
         if(_loc3_)
         {
            addNodeLast(_loc3_);
            return true;
         }
         return false;
      }
      
      public function addBefore(param1:*, param2:*, param3:*) : Boolean
      {
         var _loc4_:LinkedMapNode = null;
         var _loc5_:LinkedMapNode = null;
         if(param1 is String)
         {
            _loc4_ = this._stringMap[param1];
         }
         else
         {
            _loc4_ = this._items[param1];
         }
         if(!_loc4_)
         {
            return false;
         }
         _loc5_ = this.add_private(param2,param3);
         if(!_loc5_)
         {
            return false;
         }
         addNodeBefore(_loc4_,_loc5_);
         return true;
      }
      
      public function addAfter(param1:*, param2:*, param3:*) : Boolean
      {
         var _loc4_:LinkedMapNode = null;
         var _loc5_:LinkedMapNode = null;
         if(param1 is String)
         {
            _loc4_ = this._stringMap[param1];
         }
         else
         {
            _loc4_ = this._items[param1];
         }
         if(!_loc4_)
         {
            return false;
         }
         _loc5_ = this.add_private(param2,param3);
         if(!_loc5_)
         {
            return false;
         }
         addNodeAfter(_loc4_,_loc5_);
         return true;
      }
      
      public function get firstKey() : *
      {
         if(_first)
         {
            return LinkedMapNode(_first).key;
         }
         return undefined;
      }
      
      public function get lastKey() : *
      {
         if(_last)
         {
            return LinkedMapNode(_last).key;
         }
         return undefined;
      }
      
      public function nextKey(param1:*) : *
      {
         var _loc2_:LinkedNode = this.getNode(param1);
         if(_loc2_ && _loc2_.right)
         {
            return LinkedMapNode(_loc2_.right).key;
         }
         return undefined;
      }
      
      public function previousKey(param1:*) : *
      {
         var _loc2_:LinkedNode = this.getNode(param1);
         if(_loc2_ && _loc2_.left)
         {
            return LinkedMapNode(_loc2_.left).key;
         }
         return undefined;
      }
      
      override public function removeFirst() : *
      {
         if(!_size)
         {
            return undefined;
         }
         this.removeKey_private(LinkedMapNode(_first).key);
         return super.removeFirst();
      }
      
      override public function removeLast() : *
      {
         if(!_size)
         {
            return undefined;
         }
         this.removeKey_private(LinkedMapNode(_last).key);
         return super.removeLast();
      }
      
      public function add(param1:*, param2:*) : Boolean
      {
         var _loc3_:LinkedMapNode = this.add_private(param1,param2);
         if(_loc3_)
         {
            addNodeLast(_loc3_);
            return true;
         }
         return false;
      }
      
      public function replaceFor(param1:*, param2:*) : Boolean
      {
         var _loc3_:LinkedMapNode = null;
         if(param1 is String)
         {
            _loc3_ = this._stringMap[param1];
         }
         else
         {
            _loc3_ = this._items[param1];
         }
         if(_loc3_ && _loc3_.item !== param2)
         {
            _loc3_.item = param2;
            return true;
         }
         return false;
      }
      
      public function hasKey(param1:*) : Boolean
      {
         return param1 is String?this._stringMap[param1] !== undefined:this._keys[param1] !== undefined;
      }
      
      public function itemFor(param1:*) : *
      {
         var _loc2_:LinkedMapNode = null;
         if(param1 is String)
         {
            _loc2_ = this._stringMap[param1];
         }
         else
         {
            _loc2_ = this._items[param1];
         }
         return !!_loc2_?_loc2_.item:undefined;
      }
      
      public function keysToArray() : Array
      {
         var _loc1_:LinkedNode = _first;
         var _loc2_:Array = new Array();
         while(_loc1_)
         {
            _loc2_.push(LinkedMapNode(_loc1_).key);
            _loc1_ = _loc1_.right;
         }
         return _loc2_;
      }
      
      public function keyIterator() : IIterator
      {
         return new KeyIterator(this);
      }
      
      public function removeKey(param1:*) : *
      {
         var _loc2_:LinkedNode = null;
         if(param1 is String)
         {
            if(this._stringMap[param1] === undefined)
            {
               return undefined;
            }
            _loc2_ = this._stringMap[param1];
         }
         else
         {
            if(this._keys[param1] === undefined)
            {
               return undefined;
            }
            _loc2_ = this._items[param1];
         }
         this.removeNode(_loc2_);
         return _loc2_.item;
      }
      
      override public function clear() : Boolean
      {
         if(!_size)
         {
            return false;
         }
         this._keys = new Dictionary();
         this._items = new Dictionary();
         this._stringMap = new Object();
         super.clear();
         return true;
      }
      
      override public function iterator(param1:* = undefined) : IIterator
      {
         var _loc2_:LinkedMapNode = null;
         if(param1 is String)
         {
            _loc2_ = this._stringMap[param1];
         }
         else
         {
            _loc2_ = this._items[param1];
         }
         return new LinkedMapIterator(this,_loc2_);
      }
      
      protected function getNode(param1:*) : LinkedMapNode
      {
         if(param1 is String)
         {
            return this._stringMap[param1];
         }
         return this._items[param1];
      }
      
      override protected function removeNode(param1:LinkedNode) : void
      {
         super.removeNode(param1);
         this.removeKey_private(LinkedMapNode(param1).key);
      }
      
      private function add_private(param1:*, param2:*) : LinkedMapNode
      {
         var _loc3_:LinkedMapNode = null;
         if(param1 is String)
         {
            if(this._stringMap[param1] !== undefined)
            {
               return null;
            }
            _loc3_ = new LinkedMapNode(param1,param2);
            this._stringMap[param1] = _loc3_;
         }
         else
         {
            if(this._keys[param1] !== undefined)
            {
               return null;
            }
            _loc3_ = new LinkedMapNode(param1,param2);
            this._keys[param1] = param1;
            this._items[param1] = _loc3_;
         }
         return _loc3_;
      }
      
      private function removeKey_private(param1:*) : void
      {
         if(param1 is String)
         {
            delete this._stringMap[param1];
         }
         else
         {
            delete this._keys[param1];
            delete this._items[param1];
         }
      }
   }
}

import org.as3commons.collections.LinkedMap;
import org.as3commons.collections.framework.IIterator;
import org.as3commons.collections.framework.core.LinkedMapNode;
import org.as3commons.collections.framework.core.LinkedNode;
import org.as3commons.collections.framework.core.as3commons_collections;

use namespace as3commons_collections;

class KeyIterator implements IIterator
{
    
   
   private var _next:LinkedNode;
   
   function KeyIterator(param1:LinkedMap)
   {
      super();
      this._next = param1.firstNode_internal;
   }
   
   public function hasNext() : Boolean
   {
      return this._next != null;
   }
   
   public function next() : *
   {
      if(!this._next)
      {
         return undefined;
      }
      var _loc1_:LinkedNode = this._next;
      this._next = this._next.right;
      return LinkedMapNode(_loc1_).key;
   }
}
