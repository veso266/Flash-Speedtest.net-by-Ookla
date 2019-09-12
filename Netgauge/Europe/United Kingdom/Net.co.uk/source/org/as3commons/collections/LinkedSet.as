package org.as3commons.collections
{
   import flash.utils.Dictionary;
   import org.as3commons.collections.framework.IIterator;
   import org.as3commons.collections.framework.IOrderedSet;
   import org.as3commons.collections.framework.core.AbstractLinkedCollection;
   import org.as3commons.collections.framework.core.LinkedNode;
   import org.as3commons.collections.framework.core.LinkedSetIterator;
   
   public class LinkedSet extends AbstractLinkedCollection implements IOrderedSet
   {
       
      
      private var _items:Dictionary;
      
      private var _stringItems:Object;
      
      public function LinkedSet()
      {
         super();
         this._items = new Dictionary();
         this._stringItems = new Object();
      }
      
      public function addFirst(param1:*) : Boolean
      {
         var _loc2_:LinkedNode = this.add_private(param1);
         if(_loc2_)
         {
            addNodeFirst(_loc2_);
            return true;
         }
         return false;
      }
      
      public function addLast(param1:*) : Boolean
      {
         var _loc2_:LinkedNode = this.add_private(param1);
         if(_loc2_)
         {
            addNodeLast(_loc2_);
            return true;
         }
         return false;
      }
      
      public function addBefore(param1:*, param2:*) : Boolean
      {
         var _loc3_:LinkedNode = null;
         var _loc4_:LinkedNode = null;
         if(param1 is String)
         {
            _loc3_ = this._stringItems[param1];
         }
         else
         {
            _loc3_ = this._items[param1];
         }
         if(!_loc3_)
         {
            return false;
         }
         _loc4_ = this.add_private(param2);
         if(!_loc4_)
         {
            return false;
         }
         addNodeBefore(_loc3_,_loc4_);
         return true;
      }
      
      public function addAfter(param1:*, param2:*) : Boolean
      {
         var _loc3_:LinkedNode = null;
         var _loc4_:LinkedNode = null;
         if(param1 is String)
         {
            _loc3_ = this._stringItems[param1];
         }
         else
         {
            _loc3_ = this._items[param1];
         }
         if(!_loc3_)
         {
            return false;
         }
         _loc4_ = this.add_private(param2);
         if(!_loc4_)
         {
            return false;
         }
         addNodeAfter(_loc3_,_loc4_);
         return true;
      }
      
      public function replace(param1:*, param2:*) : Boolean
      {
         var _loc3_:LinkedNode = null;
         if(param2 is String && this._stringItems[param2] !== undefined)
         {
            return false;
         }
         if(this._items[param2] !== undefined)
         {
            return false;
         }
         if(param1 is String)
         {
            if(this._stringItems[param1] !== undefined)
            {
               _loc3_ = this._stringItems[param1];
               _loc3_.item = param2;
               this._stringItems[param2] = _loc3_;
               delete this._stringItems[param1];
               return true;
            }
         }
         else if(this._items[param1] !== undefined)
         {
            _loc3_ = this._items[param1];
            _loc3_.item = param2;
            this._items[param2] = _loc3_;
            delete this._items[param1];
            return true;
         }
         return false;
      }
      
      public function next(param1:*) : *
      {
         var _loc2_:LinkedNode = this.getNode(param1);
         if(_loc2_ && _loc2_.right)
         {
            return _loc2_.right.item;
         }
         return undefined;
      }
      
      public function previous(param1:*) : *
      {
         var _loc2_:LinkedNode = this.getNode(param1);
         if(_loc2_ && _loc2_.left)
         {
            return _loc2_.left.item;
         }
         return undefined;
      }
      
      override public function removeFirst() : *
      {
         if(!_size)
         {
            return undefined;
         }
         this.remove_private(_first.item);
         return super.removeFirst();
      }
      
      override public function removeLast() : *
      {
         if(!_size)
         {
            return undefined;
         }
         this.remove_private(_last.item);
         return super.removeLast();
      }
      
      public function add(param1:*) : Boolean
      {
         var _loc2_:LinkedNode = this.add_private(param1);
         if(_loc2_)
         {
            addNodeLast(_loc2_);
            return true;
         }
         return false;
      }
      
      override public function has(param1:*) : Boolean
      {
         return param1 is String?this._stringItems[param1] !== undefined:this._items[param1] !== undefined;
      }
      
      override public function remove(param1:*) : Boolean
      {
         var _loc2_:LinkedNode = null;
         if(param1 is String)
         {
            if(this._stringItems[param1] === undefined)
            {
               return false;
            }
            _loc2_ = this._stringItems[param1];
         }
         else
         {
            if(this._items[param1] === undefined)
            {
               return false;
            }
            _loc2_ = this._items[param1];
         }
         this.removeNode(_loc2_);
         return true;
      }
      
      override public function clear() : Boolean
      {
         if(!_size)
         {
            return false;
         }
         this._items = new Dictionary();
         this._stringItems = new Object();
         super.clear();
         return true;
      }
      
      override public function iterator(param1:* = undefined) : IIterator
      {
         var _loc2_:LinkedNode = null;
         if(param1 is String)
         {
            _loc2_ = this._stringItems[param1];
         }
         else
         {
            _loc2_ = this._items[param1];
         }
         return new LinkedSetIterator(this,_loc2_);
      }
      
      override protected function removeNode(param1:LinkedNode) : void
      {
         this.remove_private(param1.item);
         super.removeNode(param1);
      }
      
      protected function getNode(param1:*) : LinkedNode
      {
         if(param1 is String)
         {
            return this._stringItems[param1];
         }
         return this._items[param1];
      }
      
      private function add_private(param1:*) : LinkedNode
      {
         var _loc2_:LinkedNode = null;
         if(param1 is String)
         {
            if(this._stringItems[param1] !== undefined)
            {
               return null;
            }
            _loc2_ = new LinkedNode(param1);
            this._stringItems[param1] = _loc2_;
         }
         else
         {
            if(this._items[param1] !== undefined)
            {
               return null;
            }
            _loc2_ = new LinkedNode(param1);
            this._items[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      private function remove_private(param1:*) : void
      {
         if(param1 is String)
         {
            delete this._stringItems[param1];
         }
         else
         {
            delete this._items[param1];
         }
      }
   }
}
